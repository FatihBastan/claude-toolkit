#!/usr/bin/env bash
set -e
mkdir -p runtime/src requirements .claude
cat > runtime/src/watchdog.h <<'C'
#ifndef WATCHDOG_H
#define WATCHDOG_H
#include <stdint.h>
#include <stdbool.h>

void wd_init(uint32_t now_ms);
void wd_on_frame(uint32_t now_ms, bool crc_ok);
bool wd_poll(uint32_t now_ms);   /* true = show the data-invalid flag */

#endif
C
cat > runtime/src/watchdog.c <<'C'
/* Display-data watchdog: decides when the HMI shows the data-invalid flag. */
#include "watchdog.h"

#define WD_TIMEOUT_MS   150U
#define WD_RECOVER_CNT  3U

static uint32_t s_last_rx_ms;
static uint8_t  s_good_cnt;
static bool     s_invalid;

void wd_init(uint32_t now_ms)
{
    s_last_rx_ms = now_ms;
    s_good_cnt   = 0U;
    s_invalid    = true;   /* invalid until valid data has been seen */
}

void wd_on_frame(uint32_t now_ms, bool crc_ok)
{
    if (crc_ok) {
        s_last_rx_ms = now_ms;
        if (s_good_cnt < WD_RECOVER_CNT) {
            s_good_cnt++;
        }
        if (s_good_cnt >= WD_RECOVER_CNT) {
            s_invalid = false;
        }
    } else {
        s_good_cnt = 0U;
    }
}

bool wd_poll(uint32_t now_ms)
{
    /* unsigned subtraction keeps this correct when the 32-bit ms counter wraps */
    uint32_t elapsed = now_ms - s_last_rx_ms;

    if (elapsed > WD_TIMEOUT_MS) {
        s_invalid  = true;
        s_good_cnt = 0U;
    }
    return s_invalid;
}
C
cat > requirements/hlr.csv <<'CSV'
ID,Text,Parent,Verification Method
HMI-HLR-010,"When no valid display-data frame has been received for more than 150 ms, the HMI software shall show the data-invalid flag.",SYS-REQ-104,Test
HMI-HLR-011,"When valid display-data frames are received again after a data-invalid condition, the HMI software shall remove the data-invalid flag after 3 consecutive valid frames.",SYS-REQ-105,Test
CSV
: > .claude/no-toolkit   # simulate a set-up repo: silence the init offer

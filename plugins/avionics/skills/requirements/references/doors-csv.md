# CSV for DOORS

Use when the project imports requirements as a spreadsheet (DOORS Classic "Import > Spreadsheet", or DOORS Next CSV import).

## Columns
One header row. Header names must match the DOORS module's attribute names exactly — create the attributes in the module first, or map them in the import dialog.

| Column | Content |
|---|---|
| `ID` | the requirement ID (a custom attribute — DOORS assigns its own Absolute Number on import) |
| `Object Heading` | only on section rows; empty on requirement rows |
| `Object Text` | the requirement text, one "shall" |
| `Parent` | parent ID(s), `;`-separated |
| `Verification Method` | Test / Analysis / Review / Inspection |
| `Derived` | Y / N |
| `Derivation Rationale` | required when Derived = Y |
| `Safety Related` | Y / N |
| `Change Ref` | change request / problem report reference |
| `Status` | Draft / Reviewed / Released / Deleted |

Use the project's own column set instead when it has one.

## Format
- UTF-8. If the importer garbles non-ASCII characters (e.g. Turkish letters), re-save as UTF-8 with BOM or the module's code page.
- Comma-separated; quote every field that contains a comma, quote or newline, and double any inner quote (`""`). Let a CSV library do it — don't build lines by hand.
- One row per requirement, sorted by ID; section headings as their own rows.
- No empty trailing columns or rows.

## Links
A spreadsheet import creates objects and attributes, not links. Keep the parent IDs in the `Parent` attribute and create the trace links afterwards in DOORS (a link-by-attribute script, or the team's usual procedure) — or use ReqIF, which carries the relations itself.

## Writing it
```python
import csv
FIELDS = ["ID", "Object Heading", "Object Text", "Parent", "Verification Method",
          "Derived", "Derivation Rationale", "Safety Related", "Change Ref", "Status"]
with open("requirements/export/llr_doors.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=FIELDS, quoting=csv.QUOTE_MINIMAL)
    w.writeheader()
    for req in sorted(reqs, key=lambda r: r["ID"]):
        w.writerow({k: req.get(k, "") for k in FIELDS})
```

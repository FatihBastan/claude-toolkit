# Credits and licenses

This toolkit is Fatih Baştan's personal Claude Code setup. Parts are adapted from, or point to, the open-source projects below. Adapted files carry a one-line attribution at the bottom.

## Adapted (rewritten and condensed)

| Source | License | Used for | Upstream commit reviewed |
|---|---|---|---|
| [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | MIT, © 2025 Addy Osmani | `core` skills `spec`, `build`, `interview`, `source-driven` | `aeac41d4d005` |
| [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | MIT, © 2026 Affaan Mustafa | agents `build-error-resolver`, `silent-failure-hunter`, `pytorch-build-resolver`; `ml-reviewer` (inspired by `mle-reviewer`); ideas for the path-scoped rules | `90606c8315ee` |

Both are distributed under the MIT License:

```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Referenced, not copied

| Project | License | How it's used |
|---|---|---|
| [gamedev-skills/awesome-gamedev-agent-skills](https://github.com/gamedev-skills/awesome-gamedev-agent-skills) | Apache-2.0 | `/gamedev:setup` enables its marketplace bundles, or copies selected skills into a repo together with its LICENSE/NOTICE (reviewed at `184b72be0288`) |
| [CoderGamester/mcp-unity](https://github.com/CoderGamester/mcp-unity) | MIT | Optional Unity Editor MCP server |
| [Coding-Solo/godot-mcp](https://github.com/Coding-Solo/godot-mcp) | MIT | Optional Godot MCP server |
| three.js, React Three Fiber, drei, @react-three/rapier, @react-three/postprocessing, three.quarks, Yuka, Colyseus | MIT | Recommended in the `web3d-stack` skill; nothing vendored |

## Ideas
- Boris Cherny, *Mastering Claude Code in 30 minutes* (Anthropic, May 2025) — short CLAUDE.md, plan before coding, give Claude a way to verify its work, shared project config.
- The selective-install advice from the ECC community thread: start small instead of installing hundreds of skills.

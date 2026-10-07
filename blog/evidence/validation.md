# Local validation — 2026-10-06

This is engineering validation, not a benchmark or native browser-agent experiment.

| Check | Outcome |
| --- | --- |
| TypeScript: `node_modules/.bin/tsc --noEmit` | Passed |
| Full Vitest suite: `npm test` | 218 tests passed across 13 suites; six new WebMCP tests |
| Static export: `NEXT_PUBLIC_BASE_PATH=/AI-Engineering-Visual-Guide npm run build` | Passed |
| Article JavaScript syntax | Passed |
| Integration patch applies to pinned base | Passed; see reproduction setup |
| Native WebMCP/browser-agent comparison | Not run |
| Ordinary-browser/rendered UI smoke checks | Blocked: local server socket denied; Chromium launch denied socket operation |
| Root-path production export | Not run; project-subpath export was tested |
| GitHub Pages deployment | Publication authorized; deployment initiated 2026-10-06 |
| Clean network dependency installation | Not run; local dependencies copied into writable isolated checkout |

Test correction: one initial contract assumed all source entries contained technical points. Some legitimate source records have an empty points array. The final contract requires real summaries and preserves source content instead of inventing points.

An initial dependency symlink pointed to a read-only source checkout and prevented Vitest cache writes. Dependencies were copied into the writable isolated checkout before the successful tests/build.

No timings or agent-step counts have been manufactured. The interactive article diagram is illustrative. Original code/package licensing is MIT; upstream rights are separate. Conclusions remain limited unless end-to-end agent runs are collected.

Raw successful test/build logs are included alongside this report. They describe local execution, not remote deployment.

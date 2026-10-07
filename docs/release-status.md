# Release status — 2026-10-06

The user authorized publication and chose MIT for original code/package material. Existing local commits were preserved; the newer blog upstream was merged, retaining both timeline cards.

Published:
- Encyclopedia integration commit `1bf88d7b366475d46a41ccb8bc8bfec51f7bdeb7` on upstream main. GitHub Actions run 37563836162 passed tests, build, and Pages deployment. PR #1 was created before the authorized main push.
- Canonical article: https://mailtotanvir.github.io/webmcp-edge/
- Public research package: https://github.com/mailtotanvir/WebMCP-Edge
- Encyclopedia: https://mailtotanvir.github.io/AI-Engineering-Visual-Guide/
- Blog upstream was reconciled through merge commit fbb0f94; publication/evidence commits c7e5a0f and e49a081 are on remote main.

Verified:
- GitHub DNS, authentication, SSH fetch/push, and anonymous HTTP access work.
- Anonymous homepage listing, article, article JavaScript, validation report, design document, and public repository return HTTP 200.
- Ordinary Playwright Chromium smoke checks passed against both the local production export and live encyclopedia: CUDA initial selection/local execution and Inference KV-cache search/selection; no page errors. document.modelContext was absent.
- Reproduction script successfully cloned the upstream, checked out the pinned base, and applied the integration patch.
- Original code/package is MIT licensed. LICENSING.md excludes upstream materials and third-party rights; no license was found for the upstream encyclopedia.

Remaining research limitations:
- Native WebMCP interoperability, experimental browser matrix, and browser-agent performance comparison remain unmeasured.
- Do not describe mock registration or ordinary Chromium harness results as native interoperability or agent performance evidence.

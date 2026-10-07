# WebMCP-Edge

A frontend-only research prototype that exposes existing website content as structured browser tools. Built on the [AI Engineering Visual Encyclopedia](https://github.com/mailtotanvir/AI-Engineering-Visual-Guide), it lets a caller search, retrieve, and cite real CUDA and Inference Atlas records through the same application logic used by an optional local research panel.

**Status: private review candidate.** The blog article was withdrawn and remains an unapproved draft. Native WebMCP interoperability and browser-agent performance have not been established. The API target is the WebMCP Draft Community Group Report dated 2 October 2026, which is not a W3C Standard and is not on the Standards Track.

## What this project explores

Websites already encode relationships between titles, explanations, categories, and destinations. This experiment asks how a website can expose those relationships as explicit operations alongside its visual interface, and what evidence would be needed to compare that interface with ordinary browser interaction.

The prototype derives records from existing source exports. It uses deterministic lexical search and preserves the original summaries, technical points, and scene relationships. It does not introduce a separate article dataset, model endpoint, chatbot, database, or MCP server.

## Tools

| Tool | Example input | Result |
| --- | --- | --- |
| `search_articles` | `{"query":"KV cache","limit":3}` | Ranked source-backed records with IDs, summaries, and canonical links |
| `get_article` | `{"id":"cuda:atlas:sms"}` | The canonical Streaming Multiprocessors record and available technical details |
| `cite_article` | `{"id":"cuda:atlas:sms","format":"APA"}` | A title-first citation using the actual title and URL |

Search supports a default limit of 5 and a maximum of 10. Citation formats are APA, MLA, and Chicago; missing author and date fields are not invented. Search and retrieval may highlight an entry in the currently mounted Atlas. They do not change source content or navigate between worlds.

## Architecture

```text
Existing CUDA / Inference exports
                │
      Derived records and lexical search
                │
       Validated application functions
                │
     ┌──────────┴───────────┐
Local research harness    Native WebMCP adapter
     │                     │
     └──── Research panel ─┘
             │
      Atlas selection + optional in-memory log
```

The local harness invokes application functions directly. Native mode requires the actual `document.modelContext` interface, discovers registered tool objects, and executes through the browser. Native support is never polyfilled. Passing a harness check does not establish native discovery or agent access.

## Reproduce the integration

You need Git, Node.js 20 or later, npm, and network access to GitHub and npm. No API key is needed by the application.

From a checkout of this research repository, create a new sibling encyclopedia checkout:

```bash
bash scripts/reproduce.sh ../webmcp-review
cd ../webmcp-review
npm ci
npm test
npx tsc --noEmit
NEXT_PUBLIC_BASE_PATH=/AI-Engineering-Visual-Guide npm run build
npm run dev
```

Open `http://localhost:3000/atlas/?entry=sms`, expand **Agent-native web · research mode**, and run a local search. Native mode is available only in a verified browser exposing the matching draft API.

The reproduction script fetches the upstream repository, checks out the pinned base, and applies the patch. It refuses to overwrite an existing target directory.

| Revision | Commit |
| --- | --- |
| Upstream base | `c8c5e2b6195e8f725f0ccba86b2b3d29c16514df` |
| Original integration | `1bf88d7b366475d46a41ccb8bc8bfec51f7bdeb7` |

See [the manifest](integration/manifest.json) and [integration design](docs/webmcp-design.md) for the implementation boundary.

## Validation and evidence

| Check | Recorded outcome |
| --- | --- |
| TypeScript | Passed |
| Full inherited Vitest suite | 218 tests across 13 suites passed, including six WebMCP tests |
| Production static export | GitHub Pages project-subpath build passed |
| Patch reproduction | Upstream clone, pinned checkout, and patch application passed |
| Ordinary Chromium smoke check | Local and live checks passed; no page errors; `document.modelContext` absent |
| Native browser interoperability | Not measured |
| Browser-agent performance comparison | Not measured |

These are recorded engineering checks, not a benchmark. A clean dependency installation was not part of the original local validation; the upstream deployment workflow subsequently completed its `npm ci`, test, and build steps. Local checkout paths in evidence logs have been redacted without changing results.

Read the [validation report](evaluation/validation.md), [test log](evaluation/tests.log), [build log](evaluation/build.log), and [browser smoke record](evaluation/browser-smoke.log). The [evaluation protocol](evaluation/protocol.md) defines the tasks and conditions for future agent runs. No latency, action savings, or relevance advantage is claimed.

To run the existing browser smoke script, install Playwright and its Chromium browser in an evaluation environment, serve the production export under its configured project path, and set `BASE_URL` accordingly. The script checks ordinary application behavior and reports native-context presence; it does not evaluate an agent.

## Repository guide

| Path | Purpose |
| --- | --- |
| `integration/` | Patch, pinned revisions, and draft homepage snippet |
| `scripts/reproduce.sh` | Fetch and prepare a reproducible integration checkout |
| `scripts/browser-smoke.cjs` | Chromium harness smoke check |
| `evaluation/` | Protocol, validation report, and recorded evidence |
| `docs/` | Design, historical implementation plan, and current review status |
| `blog/` | Withdrawn article draft and preview assets; editorial review required |
| `CITATION.cff` | Citation metadata for this research package |

Preview the article draft locally with `python3 -m http.server 4174 -d blog`, then open `http://localhost:4174/`. It is not an approved publication.

## Trust, privacy, and limitations

Runtime validation constrains inputs, but does not authenticate an agent or make page content trustworthy. The tools expose only CUDA and Inference Atlas records. Search is lexical, and citation metadata is incomplete where the original source provides no author or date.

Optional research logs are held in memory, bounded to 100 invocations, and recorded while the research panel is open. Export is explicit; review inputs before sharing. There is no remote telemetry. Tools can change temporary UI selection, so the adapter does not assert the draft's `readOnlyHint` annotation.

Before public release, review source files, history, metadata, and exported evidence for personal information and secrets. The current repository remains private until the owner approves publication. See [review status](docs/release-status.md).

## License

Original WebMCP code and research-package material are licensed under [MIT](LICENSE). The license does not grant rights to upstream encyclopedia content, existing source code, patch context, dependencies, or referenced specifications. Reproduction fetches upstream separately. Read [LICENSING.md](LICENSING.md) before redistributing upstream materials.

## References

- [WebMCP draft specification](https://webmachinelearning.github.io/webmcp/)
- [Chrome agent documentation](https://developer.chrome.com/docs/ai/agents)
- [AI Engineering Visual Encyclopedia source](https://github.com/mailtotanvir/AI-Engineering-Visual-Guide)

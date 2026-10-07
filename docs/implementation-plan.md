# WebMCP-Edge: implementation and research publication plan

Status: proposed implementation plan; no prototype or experimental results yet.
Prepared: 2026-10-06.

## 1. Intended outcome

Publish an evidence-backed, interactive research article on Tanvir's blog and release a public GitHub repository that lets readers reproduce the experiment. The article should demonstrate how a real website exposes declared capabilities to a browser agent, using the AI Engineering Visual Encyclopedia as the application under study.

Working title: **WebMCP: Turning a Website into an Agent-Native Interface**.

The encyclopedia remains frontend-only. The MVP exposes exactly `search_articles`, `get_article`, and `cite_article`, using real CUDA and Inference content. No chatbot, model endpoint, backend, MCP server, keys, or remotely collected telemetry.

The publication is part of the deliverable, not a documentation task deferred until after development. Methodology and evidence capture begin before implementation.

## 2. Inspection findings and uncertainties

The current workspace contains the project spec and no application source or usable Git repository. Two relevant local checkouts were found and inspected read-only:

| Surface | Local source | Findings |
| --- | --- | --- |
| Encyclopedia | `<encyclopedia-checkout>` | Remote: `mailtotanvir/AI-Engineering-Visual-Guide`; Next.js 14, React 18, TypeScript, Vitest; static export and GitHub Pages |
| Blog | `<blog-checkout>` | Static HTML homepage and project articles; remote: `mailtotanvir/mailtotanvir.github.io` |

Encyclopedia source inspected at commit `c8c5e2b6195e8f725f0ccba86b2b3d29c16514df`. This is a local snapshot, not verification of the current deployed site or remote HEAD.

Actual integration seams:

- `content/cuda/atlas.ts`: topic IDs, domains, titles, summaries, technical points, and journey links.
- `content/cuda/journey.ts` and `content/cuda/scenes.ts`: scene metadata and routes.
- `content/inference/atlas.ts`, `journey.ts`, and `notes.ts`: concepts, scene relationships, explanations, and technical details.
- `components/atlas/AtlasBrowser.tsx` and `components/inference/InfAtlasBrowser.tsx`: existing domain filters and expanded-entry state; inspected components do not expose a shared text-search service.
- `components/shell/AppShell.tsx`: shared client shell and current settings modal.
- `app/layout.tsx`: root shell mounting; `app/globals.css`: existing visual tokens.
- `next.config.mjs`: static export, configurable base path, trailing slashes.
- `.github/workflows/deploy.yml`: existing deployment workflow.
- `npm test` and `npm run build`: existing validation commands. README test-count badges are not fresh test results.

The application has grown beyond the spec's description of two live worlds. Keep research coverage restricted to CUDA and Inference for the MVP and clearly report that restriction.

The rendered WebMCP specification was successfully retrieved on 2026-10-06 after the user supplied its canonical URL. It identifies itself as a Draft Community Group Report dated 2 October 2026. The draft API findings below are verified against that document; browser implementation support, live blog rendering, repository visibility, and content licenses remain unverified.

## 3. Repository and publication layout

Recommended arrangement:

1. Integrate the thin adapter into the encyclopedia, using an isolated writable checkout and a focused branch.
2. Use **WebMCP-Edge** as the public research package: spec, implementation plan, evaluation protocol, scripts, traces, results, integration patch or pinned adapter source, and blog source.
3. Publish the canonical article at `https://mailtotanvir.github.io/webmcp-edge/` and add an article card to the blog homepage. This is a proposed URL; confirm route availability before release.
4. Link the article to the live encyclopedia experiment, the public research repository, and the exact encyclopedia implementation commit.

Reproduction must specify the encyclopedia base commit and implementation commit. If distributing a patch, CI must verify it applies to the pinned base and the resulting site builds. Avoid an independently maintained copy of the encyclopedia dataset. Check source redistribution rights before packaging code or content; if unclear, prefer a documented upstream checkout plus patch.

Suggested research-package layout:

```text
README.md
LICENSE                         # after license compatibility review
CITATION.cff
webmcp_ai_engineering_visual_encyclopedia_project_spec.md
docs/implementation-plan.md
docs/api-compatibility.md
docs/webmcp-experiment.md
evaluation/protocol.md
evaluation/tasks.json
evaluation/runs/                 # reviewed, sanitized raw artifacts
evaluation/results/             # derived tables and analysis
scripts/                        # setup, verification, result aggregation
integration/                    # patch + upstream commit manifest
blog/index.html
blog/assets/
.github/workflows/              # reproduction and article checks
```

Do not create a second full application framework for the research package.

## 4. Phase 0 — freeze the research protocol and API target

Before writing the adapter:

- Refresh the encyclopedia and blog baselines, inspect applicable repository instructions, check clean working state, and record source commits.
- Read the current WebMCP specification, Chrome documentation, and current type definitions. Save links, retrieval date, spec revision, browser build, flags or enrollment requirements, and relevant signatures in `docs/api-compatibility.md`.
- Recheck the verified draft contract below against current Chrome documentation and type definitions, then test the actual browser implementation. Draft specification support is distinct from shipping browser support.
- Record differences between draft APIs and the actual experimental browser implementation. Adapt to the supported interface with explicit documentation; do not silently emulate native support.
- Add a legacy fallback only if a tested browser requires it. Report it separately.
- Define task success, ground truth, step-counting rules, failure categories, run order, and conditions before collecting comparison runs.

**Exit gate:** versioned API contract and predeclared evaluation protocol; a viable native browser configuration, or a documented native-testing limitation.

### Verified draft API contract

Source: https://webmachinelearning.github.io/webmcp/ (retrieved 2026-10-06; document date 2026-10-02).

- `document.modelContext` is a secure-context, same-object Document attribute. Use HTTPS or a browser-recognized trustworthy local origin for testing.
- `registerTool(tool, options)` returns `Promise<undefined>`.
- `getTools(options)` returns `Promise<RegisteredTool[]>`.
- `executeTool(registeredTool, inputObject, options)` returns `Promise<DOMString>`. Its first argument is the discovered **RegisteredTool object**, not a tool-name string.
- A tool definition requires `name`, `description`, and `execute`; it can include `title`, `inputSchema`, and `annotations`.
- The execution callback receives `(inputObject, { signal })` and returns a promise. Its fulfilled JavaScript value is JSON-serialized by the browser. Return a JSON-serializable object from the callback; the panel should parse the serialized string returned by `executeTool` for structured display, retaining raw output for diagnostics.
- Registration lifetime is controlled by `registerTool(tool, { signal })`; aborting that signal unregisters the tool. This is separate from execution cancellation, supplied through the callback options and `executeTool` options.
- The draft provides `toolchange`, `toolactivated`, and `toolcancel` event-handler attributes. Do not infer agent discovery from registration or from `toolchange`.
- Cross-document exposure uses `exposedTo` registration options and `fromOrigins` discovery options. The MVP needs no additional cross-origin exposure.
- `annotations.readOnlyHint` describes a tool that does not modify any state. Because optional UI synchronization changes temporary selection/highlights, do not automatically set this hint solely because content is immutable. Verify the annotation policy against the actual behavior and document that distinction.
- The document explicitly says it is **not a W3C Standard and is not on the W3C Standards Track**. Keep that precise caveat in the article and README.

These findings support the supplied project spec's main API direction. They refine the execution result shape, discovered-tool argument, separate abort signals, secure-context requirement, and annotation semantics. They do not establish Chrome interoperability.

## 5. Phase 1 — derive a semantic view from real content

Add a small pure TypeScript module in the encyclopedia's existing `lib/` structure that projects existing source exports into a common record. This is a derived view, not an authored parallel dataset.

Record fields: namespaced ID, record kind, title, world, domain, optional related scene, summary, explanation, technical points, existing source metadata, and canonical URL. Distinguish an Atlas concept from its linked journey scene; do not merge different entries merely because they share a scene.

Use IDs such as `cuda:atlas:<source-id>` and `inference:scene:<source-id>`. Preserve source IDs separately. Missing metadata remains missing. CUDA `get_article` may return summary and technical points when no longer explanation exists.

Implement deterministic lexical search across title, domain, summary, and existing technical text, with documented weighting and a stable ID tie-break. Normalize case and whitespace. Any limited synonym mapping must be documented and evaluated; do not tune ranking to benchmark answers after seeing results. Search limits control output size, not relevance guarantees.

Define citations from verified page metadata. For undated, unauthored entries, use the appropriate title-first and undated convention for each requested style. Do not infer an author from the GitHub username. Preserve verified site title and URL; explain that these cite encyclopedia entries, not the external technical sources mentioned by entries.

Create durable entry anchors or query-based selection where missing. Verify that a citation link loads and reveals the intended record, including on a direct load under the GitHub Pages base path.

**Exit gate:** pure search/retrieval/citation functions, unique IDs, real content coverage, deterministic outputs, valid deep links, and focused contract tests.

## 6. Phase 2 — thin native WebMCP adapter

Suggested encyclopedia additions, adjusted if source refresh reveals a better seam:

```text
lib/webmcp/content.ts
lib/webmcp/tools.ts
lib/webmcp/citations.ts
lib/webmcp/register.ts
lib/webmcp/activity.ts
components/webmcp/WebMCPProvider.tsx
components/webmcp/ResearchPanel.tsx
```

Mount a browser-only provider through the shared client shell. Keep registration separate from the pure application functions, so testing the latter does not require WebMCP.

- Register exactly the three spec tools with explicit JSON Schemas and concise descriptions.
- Validate runtime arguments as well as schemas: types, empty queries, unknown properties, query bounds, integer limits, valid IDs, and citation formats. Use the current API's documented error/result envelope.
- Feature-detect before use, await registration, handle rejection and partial registration, and clean up using the verified lifecycle mechanism.
- Prevent duplicates during React development remounts and navigation. Exercise reload, unmount, aborted registration, and retry paths.
- Distinguish unsupported, initializing, registered, and failed states. A failed integration must not crash the encyclopedia.
- Keep tools read-only with respect to content and external systems. Explicitly disclose that synchronization may change temporary UI selection/highlights.
- Treat arguments and returned text as untrusted; render as text, preserve known local URLs, and bound result sizes.

**Exit gate:** native registration verified where available; unavailable and failure paths leave navigation and visualizations working.

## 7. Phase 3 — shared UI state and research observability

Use existing Atlas state and settings affordances. Add minimal shared selection/activity state rather than another navigation system. Search highlights matching records in the active relevant view; retrieval selects or reveals the intended record without unexpectedly changing worlds. When results span worlds, show compact links to the other world. Citation calls need not navigate.

The optional research panel shows actual availability, successful registrations, schemas, inputs, results, durations, and errors. Native discovery/execution controls appear only where those APIs exist. A direct call to the pure functions must be labeled **local harness**, with no claim that native discovery or an agent was tested.

Keep bounded logs in memory, off by default outside research mode, with clear/reset and explicit export. Record only test inputs and minimal outputs needed for inspection. No network logging or automatic persistent storage. Do not log a discovery event unless it was actually observed; registration is a different event.

Reuse the encyclopedia's dark tokens, typography, settings vocabulary, reduced-motion support, and keyboard interactions. No standalone dashboard treatment.

**Exit gate:** human and tool interactions reflect consistent selections, research mode is inspectable, and the normal experience remains uncluttered.

## 8. Phase 4 — evaluation and evidence

Tasks from the spec:

| Task | Completion criteria |
| --- | --- |
| A: CUDA memory hierarchy | Relevant real entries retrieved; coverage and irrelevant results assessed against a predeclared answer set |
| B: three inference KV-cache/memory concepts | Three distinct relevant entries with valid links; ranking assessed, not assumed correct |
| C: retrieve an entry and produce APA citation | Correct source entry, faithful content, deterministic citation, valid bibliographic metadata and destination |

Establish accepted IDs and relevance judgments by reviewing real source content before running the experiment. Permit multiple valid answers where the task is broad. Keep setup/smoke queries separate from measured tasks.

Comparison conditions:

- **DOM/UI baseline:** an actual browser agent uses ordinary rendered interactions, with declared WebMCP tools disabled.
- **Native WebMCP:** the same agent/model and content snapshot use browser-exposed tools.
- **Local harness:** direct function checks and scripted calls, reported separately as engineering validation.

For an end-to-end comparison, run at least five independent attempts per task per supported condition, reset state, alternate condition order, and record exact model/version, prompt, browser, viewport, allowed tools, cache policy, timeout, and content commit. This small sample supports descriptive observations, not broad statistical claims.

Record success/failure, source relevance, citation correctness, agent-visible action count, navigation count, end-to-end time, and ambiguity categories. Define what counts as an action, including discovery and calls, before measurement. Separate adapter execution duration from agent/model latency. Preserve all failures and timeouts, not only clean demonstrations. Publish per-run data and median/range where appropriate.

No external model service is part of the site. If an independently available browser agent is used for evaluation, document its requirements and any external evaluation dependency separately.

If comparable browser-agent access is unavailable, publish a qualitative architecture comparison and measured local function behavior. State prominently that neither agent efficiency nor native interoperability was established by a mock or harness.

Evidence bundle: environment manifest, frozen tasks, source commits, sanitized traces, raw run table, screenshots or short recordings, aggregation script, results table, and a claim-to-evidence map. Each published numeric claim must link to its source artifact. Exported logs must exclude unrelated user browsing or personal queries.

**Exit gate:** honest observations with reproducible provenance; no invented measurements and no hidden failed runs.

## 9. Phase 5 — validation and release candidate

Run existing `npm test` and `npm run build`, plus the appropriate TypeScript check. Add focused tests for data projection, ranking/limits, metadata, citation styles, validation, registration cleanup/failures, and synchronization. Mocks verify lifecycle logic; they do not establish browser support.

Browser matrix:

- Ordinary browser with no WebMCP: navigation, settings, visualizations, and Atlas entries still work.
- Verified experimental browser: native availability, registration, discovery/call/result where supported, and structured errors.
- Reload and repeated registration; navigation/unmount and direct CUDA/Inference loads.
- Empty/malformed arguments, no results, many results, valid/invalid IDs and citation formats.
- Root and project-subpath static exports; entry anchors and asset paths.
- Desktop/mobile, keyboard access, reduced motion, readable JSON/log output, and clean console behavior.

Verify from a clean checkout with the documented toolchain and lockfile. Record checks actually performed and leave blocked native checks explicitly marked. Audit tracked files and relevant Git history for secrets/private artifacts, verify dependency and asset licenses, and publish only reviewed evidence.

**Exit gate:** reproducible build, regression checks, accurate compatibility table, and a concrete release candidate.

## 10. Phase 6 — write and design the blog article

Local reference articles: `/noesis/`, `/evalshield/`, and `/gridos/`. Their styles differ; there is no single universal article template. Useful shared characteristics are a strong thesis, architecture diagrams, interactive explanations, technical detail, and visible limits. Noesis connects narrative to a real checkout experiment; gridOS explicitly labels illustrative films and separates proposed architecture from demonstrated results.

Recommended visual direction: use EvalShield's dark research-article vocabulary and the encyclopedia's Space Grotesk/IBM Plex Mono pairing. Borrow gridOS's reading navigation and inspectable diagrams. Integrate the new article card with the blog homepage's existing light glass layout. Review the actual rendered references before final styling.

Article outline:

1. Open with one real request and the two observed interaction traces.
2. Explain the presentation-layer versus declared-capability distinction.
3. Show the real content model and the three-tool boundary.
4. Walk through discovery, search, retrieval, citation, and shared human state.
5. Explain the API revision and browser setup tested.
6. Present the protocol, results, failures, and linked evidence.
7. Discuss input validation, page/tool trust, origin mediation, and future consent boundaries.
8. State limitations and what this experiment permits us to conclude.
9. Offer concise reproduction steps, live demo, repository, and authoritative references.

Build one interactive SVG/HTML comparison: step through the two paths, inspect schema/input/output, and see the matching encyclopedia entry. Use recorded traces with visible provenance. Any staged explanatory animation must be labeled illustrative; no simulated timings presented as measurements. Add a static readable fallback and reduced-motion support.

Provide a narrow readable prose column, optional sticky contents navigation, expandable technical detail, responsive figures/tables, accessible controls, canonical URL, description, Open Graph image, and working source/evidence links. Let the final title and conclusion reflect the results, including incomplete native testing if that is the outcome.

**Exit gate:** complete article with every claim sourced, reviewed visual behavior, and no draft metrics or unsupported superiority claims.

## 11. Phase 7 — public GitHub and blog release

Prepare the public repository with README, compatible license, citation metadata, installation instructions, exact browser caveats, schemas, research protocol, evidence index, reproduction scripts, and limitations. `private: true` in an npm package prevents accidental package publication; it does not indicate GitHub visibility.

Create a tagged release that pins the exact integration and evidence revisions. Use GitHub Pages for any research-package preview only if useful; keep one canonical article URL. Validate repository permissions and Pages source before publishing.

Release order:

1. Finish code, validation, evidence, article, and a reviewable release diff.
2. Publish the reviewed research package publicly and deploy the encyclopedia integration.
3. Publish the canonical blog article and homepage entry with final working URLs.
4. Verify anonymous access to code, downloads, article, evidence, and demo; test reproduction from a fresh checkout.

The user's requested end state authorizes public publication work. This planning task does not itself execute a repository visibility change, deployment, or publication. Any platform-required approval at execution time should be requested only after the concrete release candidate is ready.

**Exit gate:** public code, working blog listing/article/demo links, and reproducible release artifacts.

## 12. Milestones and effort

| Milestone | Output | Estimated focused effort |
| --- | --- | --- |
| M0 | Source/API verification and frozen protocol | 0.5–1 day |
| M1 | Real-content projection and pure tools | 1–2 days |
| M2 | Native adapter, synchronization, debug panel | 1–2 days |
| M3 | Browser checks, evaluation, evidence bundle | 1–3 days |
| M4 | Interactive article and publication assets | 1–2 days |
| M5 | Public repository, deployments, final checks | 0.5–1 day |

Total planning estimate: **5–11 focused working days**, dependent on experimental-browser and agent access. This is an effort estimate, not a deadline or measured result. Native API incompatibility, missing licenses, or unavailable comparison infrastructure may change scope and timing.

## 13. Final acceptance checklist

- [ ] Three read-only tools operate on real CUDA/Inference source content.
- [ ] API target and tested browser configuration are recorded accurately.
- [ ] Unsupported browsers retain the ordinary encyclopedia experience.
- [ ] Durable citation URLs, deterministic output, and input validation work.
- [ ] Native, local-harness, and illustrative paths are labeled separately.
- [ ] Shared UI state and local research observability work.
- [ ] Existing tests/build and relevant browser checks are recorded.
- [ ] Protocol, raw evidence, failures, and limitations are published.
- [ ] Article matches the blog's visual/editorial quality and supports every claim.
- [ ] Public GitHub release reproduces the integration without a fake dataset.
- [ ] Blog homepage, canonical article, live demo, and evidence links resolve anonymously.

## References

- Project spec: `../webmcp_ai_engineering_visual_encyclopedia_project_spec.md`
- Encyclopedia: https://mailtotanvir.github.io/AI-Engineering-Visual-Guide/
- Blog: https://mailtotanvir.github.io/
- Rendered WebMCP specification (primary API reference): https://webmachinelearning.github.io/webmcp/
- WebMCP specification repository: https://github.com/webmachinelearning/webmcp
- Specification source: https://github.com/webmachinelearning/webmcp/blob/main/index.bs
- Chrome agent documentation: https://developer.chrome.com/docs/ai/agents
- Type definitions: https://github.com/WebMCP-org/npm-packages/tree/main/packages/webmcp-types

The rendered specification was retrieved and reviewed; Chrome documentation, current package types, and native browser behavior still require verification during Phase 0.

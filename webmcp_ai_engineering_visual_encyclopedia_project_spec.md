# Project Spec: WebMCP on the AI Engineering Visual Encyclopedia

## 0. Mission

Add a **small, rigorous WebMCP research prototype** to the existing:

**AI Engineering Visual Encyclopedia**  
https://mailtotanvir.github.io/AI-Engineering-Visual-Guide/

The goal is NOT to turn the site into an AI chatbot.

The goal is to experimentally demonstrate a more interesting architectural idea:

> **A website can expose explicit, structured capabilities to browser-native AI agents, without a backend, by registering WebMCP tools in the page.**

This should become a polished, reproducible mini research/demo project that can be published alongside the site.

The site is currently a visual, interactive AI-engineering encyclopedia with CUDA and Inference worlds live, and additional disciplines planned. Preserve its visual identity and existing interactions.

---

# 1. Core Research Question

Investigate:

> **What changes when a website moves from being merely an interface that an AI agent must scrape/manipulate to being an explicit agent-native interface with declared tools?**

Compare two conceptual interaction models:

### Conventional web-agent interaction

```text
Agent
  ↓
DOM / rendered UI
  ↓
infer structure
  ↓
click / search / scrape
  ↓
extract content
```

### WebMCP interaction

```text
Agent
  ↓
discover declared tools
  ↓
structured tool call
  ↓
browser-mediated execution
  ↓
structured result
```

The experiment should make this difference tangible rather than merely explaining it.

---

# 2. Important Current-WebMCP Constraint

Do NOT copy older WebMCP examples blindly.

The current API is centered on:

```js
document.modelContext
```

The current WebMCP draft exposes APIs including:

```js
document.modelContext.registerTool(...)
document.modelContext.getTools()
document.modelContext.executeTool(...)
```

Tool registration is asynchronous.

Tool lifetime/unregistration should use an `AbortController`/`AbortSignal` where supported by the current API rather than assuming an old `unregisterTool()` API.

`navigator.modelContext` appears in older/deprecated material. Treat it only as a compatibility fallback if the implementation genuinely needs it.

Authoritative references:

- WebMCP specification:
  https://github.com/webmachinelearning/webmcp
- WebMCP spec source:
  https://github.com/webmachinelearning/webmcp/blob/main/index.bs
- Chrome WebMCP documentation:
  https://developer.chrome.com/docs/ai/agents
- Current WebMCP type definitions:
  https://github.com/WebMCP-org/npm-packages/tree/main/packages/webmcp-types

The WebMCP API is experimental and the draft can change. Clearly label the project as an experiment, not a production integration or standards-compliant guarantee.

---

# 3. Desired Demo

Use the existing AI Engineering Visual Encyclopedia content.

The best first demonstration is an agent asking something like:

> "Find the articles/scenes about GPU memory movement and give me the three most relevant concepts."

or:

> "Find the CUDA material about memory hierarchy and give me citations for the relevant entries."

The site should expose its own semantic content instead of requiring an agent to reverse-engineer the DOM.

---

# 4. Tool Surface

Implement a deliberately SMALL tool surface.

Target three tools:

```text
search_articles
get_article
cite_article
```

Do not expose dozens of tools.

The point is to demonstrate that a few carefully designed capabilities can make a rich website agent-readable and agent-actionable.

## 4.1 search_articles

Purpose:

Search the site's local structured content.

Suggested schema:

```json
{
  "type": "object",
  "properties": {
    "query": {
      "type": "string",
      "description": "Topic, concept, keyword, or author to search for."
    },
    "limit": {
      "type": "integer",
      "minimum": 1,
      "maximum": 10,
      "description": "Maximum number of results to return."
    }
  },
  "required": ["query"],
  "additionalProperties": false
}
```

Return concise structured results containing useful semantic metadata, for example:

```json
{
  "results": [
    {
      "id": "...",
      "title": "...",
      "world": "CUDA",
      "scene": "...",
      "summary": "...",
      "path": "...",
      "url": "..."
    }
  ]
}
```

Use the site's REAL content/index.

Do not leave dummy article data in production.

---

# 5. get_article

Purpose:

Retrieve the canonical structured representation of one encyclopedia entry.

Suggested input:

```json
{
  "type": "object",
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique identifier for the encyclopedia entry."
    }
  },
  "required": ["id"],
  "additionalProperties": false
}
```

Return:

- title
- world
- scene
- conceptual explanation
- relevant technical details
- URL
- any useful metadata already present in the site's source data

Do NOT scrape the rendered DOM to implement this.

Use the underlying content model/index.

---

# 6. cite_article

Purpose:

Produce a deterministic citation for an existing encyclopedia entry.

Suggested schema:

```json
{
  "type": "object",
  "properties": {
    "id": {
      "type": "string",
      "description": "Unique identifier for the encyclopedia entry."
    },
    "format": {
      "type": "string",
      "enum": ["APA", "MLA", "Chicago"],
      "description": "Citation format."
    }
  },
  "required": ["id", "format"],
  "additionalProperties": false
}
```

Return structured citation data:

```json
{
  "id": "...",
  "title": "...",
  "format": "APA",
  "citation": "..."
}
```

Citation generation should be deterministic and based on actual page metadata.

Do not invent authors, dates, publishers, or other bibliographic facts.

If the site does not currently have an author/date field, use a clearly defined site-level convention rather than fabricated metadata.

---

# 7. Feature Detection

The implementation must fail gracefully on browsers without WebMCP.

Conceptually:

```js
const modelContext =
  document.modelContext ??
  navigator.modelContext;
```

But use the current canonical API first and document any fallback as compatibility-only.

If unavailable:

```text
WebMCP unavailable
→ normal encyclopedia continues working exactly as before
```

There must be:

- no JavaScript crash
- no broken navigation
- no broken visualization
- no visible WebMCP UI required for normal users

WebMCP is an enhancement, not a dependency.

---

# 8. Architecture

Keep this frontend-only.

```text
GitHub Pages
│
├── Existing Visual Encyclopedia
│   ├── CUDA
│   ├── Inference
│   └── future worlds
│
├── Existing content/index
│
└── WebMCP adapter
    ├── search_articles
    ├── get_article
    └── cite_article
```

No backend.

No database.

No external AI API.

No API key.

No server-side MCP implementation.

The experiment is specifically about **browser-side capability exposure**.

---

# 9. Critical Implementation Principle

The WebMCP tools must call the site's REAL application/content logic.

Do NOT create a fake parallel demo dataset.

Bad:

```js
const dummyArticles = [...]
```

Good:

```text
WebMCP tool
    ↓
existing content/index
    ↓
existing semantic data
```

The agent-facing interface should be a thin adapter over the site's real data model.

This makes the experiment meaningful.

---

# 10. Human UI Synchronization

Where useful, tool calls should synchronize the visual interface.

For example:

```text
Agent calls search_articles("GPU memory")
        ↓
site highlights / reveals matching entries
        ↓
human can see what the agent found
```

This is important conceptually.

The human and agent should not become two completely separate interfaces.

The experiment should demonstrate:

> **One application state, two interaction modalities.**

However, do not add distracting UI solely for the demo.

A subtle "Agent activity" indicator or result highlight is enough if it fits the existing design.

---

# 11. Build a Small WebMCP Debug Panel

Create an optional developer/research mode, preferably hidden behind an existing settings/debug affordance.

It should show:

```text
WEBMCP
──────────────
Status: AVAILABLE / UNAVAILABLE

Registered tools:
  ✓ search_articles
  ✓ get_article
  ✓ cite_article

Schema
Execution
Result
```

If practical, allow local execution of the tools through the page itself so the developer can verify:

```text
discover → call → result
```

This is NOT the agent UI.

It is an observability surface for the experiment.

Keep it lightweight.

---

# 12. Research Instrumentation

Add lightweight instrumentation so the experiment can measure:

### Tool path

- tool name
- invocation timestamp
- input
- result count
- execution duration
- success/failure

Do NOT collect personal data.

Do NOT send telemetry to a server.

Keep instrumentation local to the browser.

If useful, expose an in-page event log:

```text
21:04:12  TOOL DISCOVERED  search_articles
21:04:19  TOOL CALL       search_articles
21:04:19  RESULT           4 entries
21:04:20  TOOL CALL       cite_article
21:04:20  RESULT           APA citation
```

This makes screenshots and demonstrations much stronger.

---

# 13. Before/After Demonstration

Create a small section/page or expandable research panel titled:

## Agent-Native Web

Explain:

### Before

```text
DOM → agent infers meaning
```

### After

```text
WebMCP → site declares meaning + capabilities
```

Keep the explanation visual.

Do not turn the encyclopedia into a long essay.

A simple diagram is preferred.

---

# 14. Evaluation

Run a tiny qualitative/quantitative experiment.

At minimum test:

### Task A

> Find the CUDA content about memory hierarchy.

### Task B

> Find the three most relevant inference concepts about KV cache / memory.

### Task C

> Retrieve an entry and produce an APA citation.

Record for each:

| Metric | Conventional web interaction | WebMCP |
|---|---:|---:|
| Interaction steps | measure | measure |
| Tool/DOM ambiguity | qualitative | qualitative |
| Structured input | no/implicit | yes |
| Structured result | no/implicit | yes |
| Backend required | no | no |
| Site-specific semantics | inferred | declared |

Do NOT manufacture numbers.

If we cannot perform a meaningful conventional-agent comparison, say so explicitly and keep the table qualitative.

The research goal is not to "prove WebMCP is better."

The goal is to characterize the architectural difference.

---

# 15. Security / Trust Section

Include a short section explaining that:

> WebMCP does not magically make a webpage trustworthy.

Discuss briefly:

- tool descriptions become part of the agent interaction surface
- tool schemas constrain inputs but are not a complete security boundary
- read-only tools are a good first experiment
- future mutating tools require much stronger user-consent and authorization considerations
- origin/browser mediation matters
- never expose secrets through tools
- never treat agent-supplied input as trusted

For this MVP, keep every tool read-only.

That is deliberate.

---

# 16. Standards Caveat

Clearly label:

> **Experimental — WebMCP is an evolving Web Machine Learning Community Group draft, not a finished web standard.**

Avoid claims such as:

- "WebMCP is standardized"
- "WebMCP works everywhere"
- "WebMCP is production-ready"
- "first WebMCP website"
- "first implementation"

The project is a reproducible experiment against the current API.

---

# 17. Browser Test Matrix

Test at least:

1. normal browser without WebMCP
2. supported experimental Chrome configuration
3. page reload
4. direct navigation into CUDA
5. direct navigation into Inference
6. WebMCP unavailable
7. malformed tool arguments
8. search with zero results
9. search with many results
10. citation for valid ID
11. citation for invalid ID
12. repeated registration / page lifecycle

The normal site must continue functioning if WebMCP is unavailable.

---

# 18. Files / Code Organization

First inspect the repository.

Do NOT assume filenames.

Find:

- main JS/TS entry point
- content/index data
- routing
- existing search logic
- existing article/scene representation
- existing settings/debug UI
- build/deployment process

Then implement the smallest clean architecture.

Prefer something conceptually like:

```text
src/
  webmcp/
    register-tools.*
    search-tool.*
    article-tool.*
    citation-tool.*
```

But adapt to the actual repository structure.

Do not force a new architecture if the existing codebase has a better natural seam.

---

# 19. Documentation Deliverables

Add:

## README / project documentation

Explain:

1. What WebMCP is
2. Why this experiment exists
3. Architecture
4. Tools exposed
5. Browser requirements
6. How to run locally
7. How to test
8. Limitations
9. Security considerations
10. Current standards status

## Research note

Create something like:

```text
docs/webmcp-experiment.md
```

It should capture:

- hypothesis
- implementation
- tool schemas
- test methodology
- observations
- limitations
- conclusion
- links to authoritative WebMCP sources

Do not overstate results.

---

# 20. Visual Design

The existing site has a strong visual language.

Preserve:

- typography
- dark visual system
- spatial navigation
- motion
- existing interaction vocabulary
- existing token system

Do NOT introduce a generic "MCP dashboard" aesthetic.

WebMCP should feel like a native capability of the encyclopedia.

The site currently emphasizes:

> "Don't explain what can be demonstrated."

Apply the same principle here.

Show the agent interacting with the site.

---

# 21. Ideal Demo Flow

The finished demo should be able to show:

```text
1. Open AI Engineering Visual Encyclopedia

2. Open WebMCP experiment/debug panel

3. Browser reports:
   WebMCP AVAILABLE

4. Tools appear:
   search_articles
   get_article
   cite_article

5. Agent asks:
   "Find the CUDA concepts related to GPU memory."

6. Agent discovers:
   search_articles

7. Browser executes:
   search_articles({
     query: "GPU memory"
   })

8. Site highlights matching concepts.

9. Agent asks:
   "Give me an APA citation for the most relevant one."

10. Agent calls:
    cite_article(...)

11. Browser returns structured citation.

12. Human sees:
    same encyclopedia,
    same content,
    new agent-native interaction layer.
```

That is the core story.

---

# 22. Publication Story

The eventual article should NOT be a generic API tutorial.

Suggested title:

# WebMCP: Turning a Website into an Agent-Native Interface

Subtitle:

> A zero-backend experiment with browser-native AI tools on the AI Engineering Visual Encyclopedia.

Core thesis:

> Traditional web agents interact with the presentation layer and infer the site's capabilities. WebMCP lets the site explicitly declare capabilities to an agent.

Then show the experiment.

Potential conclusion:

> **WebMCP doesn't make the website intelligent. It makes the website legible as an action surface to an agent.**

Treat this as the central conceptual observation, not as a claim that the experiment has proven broad superiority.

---

# 23. What NOT To Build

Do NOT:

- add a backend
- add a database
- add an MCP server
- add an LLM API
- add API keys
- build a chatbot
- replace the site's search
- duplicate the content model
- create fake demo articles
- introduce a huge framework
- build dozens of tools
- make WebMCP required for site functionality
- collect telemetry
- expose write/mutation tools in MVP

The experiment should remain small.

---

# 24. Definition of Done

The MVP is DONE when:

- [ ] Existing site still works normally.
- [ ] WebMCP is feature-detected.
- [ ] Current canonical `document.modelContext` API is used.
- [ ] `search_articles` is registered.
- [ ] `get_article` is registered.
- [ ] `cite_article` is registered.
- [ ] Tools operate on real site content.
- [ ] No backend is required.
- [ ] Tool schemas are valid and explicit.
- [ ] Read-only execution works.
- [ ] Agent-facing results are structured.
- [ ] Search/call activity can be observed locally.
- [ ] Relevant UI can synchronize with tool calls.
- [ ] Browser without WebMCP remains fully functional.
- [ ] Experimental/debug panel works.
- [ ] Documentation explains setup and limitations.
- [ ] Research note records the hypothesis and observations.
- [ ] No fabricated benchmark results.
- [ ] No secrets or telemetry are introduced.
- [ ] GitHub Pages deployment works.
- [ ] Demo can be reproduced from a clean checkout.

---

# 25. Codex Working Instructions

Before changing code:

1. Inspect the entire repository structure.
2. Identify the real content model.
3. Identify existing search/navigation logic.
4. Identify existing settings/debug surfaces.
5. Identify build/deploy mechanism.
6. Determine the smallest natural integration point.
7. Read the current WebMCP API references linked above.
8. Check whether the existing Chrome/WebMCP API has changed since this spec was written.
9. Implement against the current API rather than stale examples.

Then:

1. Make the smallest coherent implementation.
2. Run existing tests/build/lint.
3. Add focused tests where practical.
4. Test WebMCP-enabled and WebMCP-disabled paths.
5. Verify GitHub Pages output.
6. Review the final diff for unnecessary complexity.
7. Update documentation.
8. Report exactly what was implemented, what was tested, and what remains experimental.

If the current WebMCP API has changed materially, STOP and adapt the implementation to the current authoritative API rather than blindly following this document.

---

# 26. Final Architectural Principle

The project should demonstrate this distinction:

```text
                    HUMAN
                      │
                      ▼
              ┌───────────────┐
              │ Visual Web UI │
              └───────┬───────┘
                      │
                      ▼
              ┌───────────────┐
              │ Content Model │
              └───────┬───────┘
                      │
          ┌───────────┴───────────┐
          │                       │
          ▼                       ▼
   Human interaction       Agent interaction
                                  │
                                  ▼
                           ┌──────────────┐
                           │   WebMCP     │
                           │    Tools     │
                           └──────┬───────┘
                                  │
                                  ▼
                           Browser-mediated
                              execution
```

The website remains one application.

It simply gains a second explicit interaction vocabulary:

**human UI + agent tools.**

That is the experiment.


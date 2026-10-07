# Protocol v1 — frozen before browser-agent evaluation

Status: no native or DOM-agent runs collected.

Content baseline: c8c5e2b6195e8f725f0ccba86b2b3d29c16514df. Scope: CUDA and Inference Atlas records.

Tasks:
A. Find the CUDA content about memory hierarchy.
B. Find the three most relevant inference concepts about KV cache / memory.
C. Retrieve the Streaming Multiprocessors entry and produce an APA citation.

Before measured runs, independently review source records and save accepted IDs/relevance judgments for A and B. Broad queries admit multiple valid answer sets. Do not optimize lexical weights using measured outcomes. C succeeds only with cuda:atlas:sms, faithful source content, its canonical entry link, and title-first undated APA rendering.

Conditions: ordinary rendered DOM with WebMCP disabled; native browser-exposed tools with the same browser agent/model; local function harness reported separately. Use five independent attempts per task/available agent condition, alternate order, reset page state/cache according to a recorded policy, same content/model/prompt/viewport, and record a preselected timeout. An action is one agent-visible tool invocation or UI interaction; discovery counts as an action; internal callback dispatch does not count again. Record navigation separately.

Save per-run environment, allowed tools, exact prompts, action trace, outcome, relevance judgments, citation correctness, timeout/failure, and elapsed wall-clock time. Native callback duration is not agent latency. Publish all failures, raw rows, median/range, and claim-to-evidence links. If native access or a comparable DOM agent is unavailable, leave quantitative comparison unmeasured.

No site backend/model dependency. Any independently supplied evaluation agent is an evaluation dependency and must be disclosed. Screenshots demonstrate only what they visibly record. Illustrations and mocked calls cannot establish native support.

# WebMCP-Edge

A frontend-only research prototype exposing real AI Engineering Visual Encyclopedia content through three browser-side tools: search_articles, get_article, cite_article.

**Implementation findings release. Native interoperability and browser-agent comparison remain unmeasured.** The current draft is not a W3C Standard or on the Standards Track.

- [Review article](blog/index.html)
- [Implementation plan](docs/implementation-plan.md)
- [Evaluation protocol](evaluation/protocol.md)
- [Validation report](evaluation/validation.md)
- [Integration manifest](integration/manifest.json)

The integration is a patch over a pinned upstream checkout, not a copied dataset. Run `bash scripts/reproduce.sh /tmp/webmcp-review` to create a clean implementation checkout; then follow the printed commands. Node.js 20+ and network access to GitHub/npm are required. No API key, MCP server, database, or LLM endpoint is required by the site.

The article is static HTML. Preview with `python3 -m http.server 4174 -d blog` and open localhost:4174. The canonical article is https://mailtotanvir.github.io/webmcp-edge/.

Licensing: original WebMCP code and research-package material are MIT licensed. Upstream materials retain their existing rights; see [licensing scope](LICENSING.md).

Security: arguments are validated; outputs derive from known content; logs are local, bounded, opt-in, and exportable. Tools change no content but may highlight UI selection. Page tools do not make a page trustworthy. Future write tools require a separate authorization design.

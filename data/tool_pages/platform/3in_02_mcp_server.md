---
id: "docs-mcp"
short_title: "Docs MCP Server"
title: "ocaml.org MCP Server: Package Data for AI Assistants"
description: "A hosted Model Context Protocol endpoint that lets AI assistants query opam package dependency and documentation information."
category: "OCaml Infrastructure"
---

> Experimental / beta. The ocaml.org MCP server is a new, experimental
> service. It may change, be rate-limited more tightly, or be taken down without
> notice while it stabilises, and it is not guaranteed to be available on every
> deployment. A deployment where the server is not enabled answers plain `404`
> at the endpoint.

ocaml.org hosts a public [Model Context Protocol](https://modelcontextprotocol.io)
(MCP) server that lets AI assistants query OCaml package data directly. It
works with Claude, ChatGPT, Gemini, and Mistral, in their web apps or in local
clients. The assistant reaches the server over public HTTPS, so wiring it in
takes only a URL: no local install, and no OCaml environment.

The endpoint is:

```text
https://ocaml.org/mcp
```

## Available Tools

### API and Module Documentation

These reuse ocaml.org's existing documentation backend, which serves the same
odoc content shown on package pages.

- `ocaml_package_documentation`: a documentation overview of a package,
  covering its synopsis, description, licence, homepage, tags, documentation
  build status, and the libraries and top-level modules it exposes. Each
  library and module comes with a `path` you can hand to
  `ocaml_module_documentation`. Takes a `package` name and an optional
  `version` (defaulting to the latest *documented* version, falling back to the
  latest release).
- `ocaml_module_documentation`: the documentation of a single module page,
  giving its preamble and signatures as plain text (HTML special characters
  arrive entity-encoded), the page's table of contents and breadcrumbs, and a
  `references` list of the page's links. Internal
  cross-references carry the target `package`, `version`, and `path`, so an
  assistant can follow them across dependencies by calling the tool again;
  external links are returned as inert data, not as fetchable markup. Takes a
  `package`, an optional `version`, and a `path` (for example
  `lwt/Lwt/index.html`, as returned by `ocaml_package_documentation`).

### Package Dependencies

ocaml.org can answer dependency queries because it already computes
dependency information in memory for every package in the opam repository.

- `ocaml_package_dependencies`: the direct dependencies (with their version
  constraints), optional dependencies, and conflicts of a package. Takes a
  `package` name and an optional `version` (defaulting to the latest release).
- `ocaml_package_reverse_dependencies`: the packages that depend on a given
  package ("used by"), each with its version constraint and latest release, plus
  a total count. Takes the same arguments.

Each tool returns a JSON document. For example, asking
`ocaml_package_documentation` about `lwt` returns its synopsis and the list of
modules to drill into with `ocaml_module_documentation`; asking
`ocaml_package_dependencies` about `dream` returns that package's resolved
version alongside its `dependencies`, `optional`, and `conflicts` lists.

## Connecting Your Assistant

Whether you can add a remote MCP server, and where, depends on your assistant
and plan. Two things hold across all of them: the server speaks Streamable
HTTP, and it is public and unauthenticated. You add it with just the URL,
with no API key and no OAuth step. For some clients that is an advantage in
itself: a few (the GitHub Copilot cloud agent among them) accept *only*
unauthenticated remote servers.

Each vendor section covers its command-line (coding) tool and closes, where
applicable, with a paragraph on its web or desktop app; the two often differ in
how (and whether) a custom server can be added. GitHub Copilot, which spans
several editors rather than a single model, comes last and follows its own
shape.

The vendor details were last verified in October 2026. Web access in particular
comes with vendor-dependent limits (plan, role, region) that are likely to
change, so the sections below do not track them: check the linked vendor page
for the current conditions. If a step no longer matches what you see, ask your
assistant how to add a custom MCP server to itself; it tends to know its own
product best.

Once the server is added, confirm that the client lists the four `ocaml_*`
tools, then try a prompt such as "Which packages directly depend on dream, and
what are its own dependencies?"

### Anthropic &mdash; Claude

In Claude Code, add the endpoint with:

```bash
claude mcp add --transport http --scope user ocaml-org https://ocaml.org/mcp
```

The `--scope user` flag makes the connector available across all your projects;
without it, `claude mcp add` registers the server only for you in the current
project. See the [Claude Code MCP documentation](https://code.claude.com/docs/en/mcp).

On the web and desktop apps (Claude.ai), custom connectors are added from the
connector settings by pasting `https://ocaml.org/mcp`. See
[Get started with custom connectors](https://support.claude.com/en/articles/11175166-get-started-with-custom-connectors-using-remote-mcp).

### OpenAI &mdash; Codex and ChatGPT

In Codex, add the endpoint with:

```bash
codex mcp add ocaml-org --url https://ocaml.org/mcp
```

This writes to the global `~/.codex/config.toml`, so it applies to all your
sessions; a project-local `.codex/config.toml` scopes it to one directory
(trusted projects only). The same configuration is shared by the ChatGPT
desktop app and the Codex IDE extension. See the
[Codex MCP documentation](https://learn.chatgpt.com/docs/extend/mcp).

On the web, ChatGPT adds custom MCP servers as apps in Developer Mode. See
[Developer mode and MCP apps in ChatGPT](https://help.openai.com/en/articles/12584461-developer-mode-and-mcp-apps-in-chatgpt).

### Google &mdash; Gemini

In the Gemini CLI, add a server under `mcpServers` in `~/.gemini/settings.json`,
using `httpUrl` for a Streamable HTTP server:

```json
{
  "mcpServers": {
    "ocaml-org": { "httpUrl": "https://ocaml.org/mcp" }
  }
}
```

The user-level file applies across all your projects; a project-local
`.gemini/settings.json` scopes it to one directory. See
[MCP servers with the Gemini CLI](https://geminicli.com/docs/tools/mcp-server/).
Google's newer agentic client, [Antigravity](https://antigravity.google/docs/mcp/),
uses a different file and key. Its servers go in `mcp_config.json` (global
`~/.gemini/config/mcp_config.json`, or `.agents/mcp_config.json` per workspace),
and remote servers take a `serverUrl` field. Antigravity does not accept
`httpUrl`, so the snippet above does not transfer as-is.

The consumer Gemini app accepts custom MCP servers from its connected-apps
settings; credentials are only requested when a server demands them, which this
one does not. If the feature is not available to your account, use the Gemini
CLI above, or a
[Gemini Enterprise (Vertex AI) setup](https://docs.cloud.google.com/gemini/enterprise/docs/connectors/custom-mcp-server/set-up-custom-mcp-server),
which likewise supports unauthenticated servers.

### Mistral &mdash; Vibe

In Vibe Code, Mistral's coding mode, add a `[[mcp_servers]]` entry in its
`config.toml` with the URL `https://ocaml.org/mcp`; the exact transport keys
are still settling, so copy the current form from the linked page. It supports
`http`, `streamable-http`, and `stdio` transports. Browse configured servers
from within Vibe with `/mcp` or `/connectors`. See
[MCP servers in Vibe Code](https://docs.mistral.ai/vibe/code/cli/mcp-servers).

On the web, Vibe Work accepts custom MCP connectors on its connectors page:
give it a name and the server URL `https://ocaml.org/mcp`; a no-auth server
like this one is detected automatically. See
[MCP connectors in Vibe Work](https://docs.mistral.ai/vibe/work/connectors/mcp-connectors).

### GitHub &mdash; Copilot

Copilot connects to remote MCP servers across all its surfaces. Because this
endpoint needs no authentication, you can skip the OAuth step its documentation
describes for authenticated servers.

In VS Code, add a workspace `.vscode/mcp.json` and the server's tools become
available to the agent in Copilot Chat:

```json
{
  "servers": {
    "ocaml-org": { "type": "http", "url": "https://ocaml.org/mcp" }
  }
}
```

Note the root key is `servers`, not `mcpServers`; that key belongs to Copilot's
portable `.mcp.json` format and the repository settings below.

In the Copilot CLI, run `/mcp add` and give the name `ocaml-org`, type
`http`, and URL `https://ocaml.org/mcp`. The Copilot cloud agent, the one
that runs on github.com and opens pull requests, also supports remote MCP
servers, configured by a repository admin under the repository's Copilot
settings (root key `mcpServers` there). It does not support OAuth-protected
remote servers at all, so an unauthenticated endpoint like this one is exactly
what it can use.

See [Use MCP servers in VS Code](https://code.visualstudio.com/docs/agent-customization/mcp-servers),
[Adding MCP servers for the Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers),
and [Extending Copilot with MCP](https://docs.github.com/en/copilot/how-tos/copilot-in-your-ide/customize-copilot/extend-copilot-with-tools-and-context/extend-copilot-chat-with-mcp).

## Local Models and Software Freedom

MCP is a client-side protocol and it is model-agnostic: the server never knows
which model is calling it. The endpoint therefore works just as well behind a
locally run model as behind a hosted one. What matters is that the client
speaks Streamable HTTP MCP. A runner such as llama.cpp or Ollama serves the
model. In front of it, an MCP-capable harness makes the tool calls and holds
the connector: Goose, Cline, Continue, LibreChat, or Mistral Vibe pointed at a
local provider.

Every link of that chain can be free software. The runners (llama.cpp, Ollama)
are MIT-licensed, as is LibreChat; Goose, Cline, and Continue are Apache-2.0.
Model weights deserve a closer look, because "open-weight" is not "free". OLMo
is Apache-2.0 with open training data, DeepSeek-R1 is MIT, and many Qwen and
Mistral releases are Apache-2.0, while Llama's community licence carries use
restrictions. On the
server side, this endpoint is ISC-licensed OCaml
([`src/ocamlorg_mcp`](https://github.com/ocaml/ocaml.org/tree/main/src/ocamlorg_mcp)
in the ocaml.org repository), so you can read it, audit it, and run your own
instance against your own opam-repository clone.

Privacy follows from the architecture. The client orchestrates everything; the
tool calls the server receives carry package names and documentation paths,
plus the ordinary metadata of any HTTP request (client address, user agent, and
the client application's name from the MCP handshake). Your conversation,
prompts, and code never reach it. With local inference, those tool-call HTTPS
requests are the only thing that leaves your machine.

One caveat remains: tool use is demanding. Smaller local models are often less
reliable at deciding when to call a tool and at chaining several calls (for
example, following a module's cross-references across dependencies). Results
vary with the model.

## Protocol Details

All traffic is `POST`. The server speaks Streamable HTTP, the transport remote
MCP clients use, in which every JSON-RPC 2.0 message is an HTTP `POST` to the
endpoint. The protocol reserves `GET` for one optional extra: a server-to-client
stream of server-initiated messages. This server never initiates messages, so a
`GET` receives `405 Method Not Allowed`; no client following the spec will
notice.

The server is read-only and stateless: it exposes data ocaml.org already
computes and holds no per-session state.

## Limits, Privacy, and Trust

The endpoint is public and rate-limited, currently at 300 requests per minute
per client address. The budget is shared: web connectors reach the server from
a pool of vendor egress addresses rather than from your machine, so all clients
connecting through the same vendor draw on the same allowance. The server only
ever reads ocaml.org's own package data, so it cannot be used to fetch
arbitrary URLs. When the assistant connects from its vendor's cloud, the server
cannot see your local machine; a local coding agent, by contrast, connects
directly from it, so the server sees your address. In either case, the server
is not a substitute for local tooling that inspects your current opam switch,
pins, or installed packages.

The MCP code adds no logging of its own; requests appear only in the standard
web-server logs that every ocaml.org page generates. There are no accounts, no
cookies, and no trackers.

## Untrusted Content

Package documentation, synopses and doc comments are community-authored and
not vetted by ocaml.org. Anyone can publish an opam package, so this text should
be treated as untrusted data, never as instructions. The risk is indirect
prompt injection, where retrieved text tries to steer the assistant. The server
reduces the attack surface where it can:

- Documentation is returned as plain text, with active markup removed (no
  images, scripts or fetchable links).
- Links are handed back as inert structured data.
- Responses are size-bounded.
- The tools are annotated read-only (`readOnlyHint`) over a fixed backend
  (`openWorldHint: false`).

These are hints and mitigations, not guarantees: the decision to act on
retrieved text happens in the client, so keep this connector isolated from
tools that execute actions without review.

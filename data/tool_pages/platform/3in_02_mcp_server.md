---
id: "docs-mcp"
short_title: "MCP Server"
title: "The ocaml.org MCP Server: OCaml Package Data for AI Assistants"
description: "A hosted Model Context Protocol endpoint that lets AI assistants query opam package dependency and documentation information."
category: "OCaml Infrastructure"
---

This page was written with AI assistance and reviewed by the OCaml.org team.

ocaml.org hosts a public [Model Context Protocol](https://modelcontextprotocol.io)
(MCP) server that lets AI assistants — such as Claude, ChatGPT, Gemini or
Mistral, in both their web apps and local clients — query OCaml package data
directly. The server is reached over public HTTPS from the assistant's side, so
wiring it in takes only a URL: there is no local install and no OCaml
environment required.

The endpoint is:

```text
https://ocaml.org/mcp
```

It speaks Streamable HTTP (JSON-RPC 2.0 over an HTTP `POST`, with a companion
`GET` for the server-to-client stream), which is the transport remote MCP
clients use. The server is public, read-only and stateless: it exposes data
ocaml.org already computes and holds no per-session state.

## Available tools

### Package dependencies

ocaml.org can answer these because it already computes
dependency information in memory for every package in the opam repository.

- **`ocaml_package_dependencies`** — the direct dependencies (with their version
  constraints), optional dependencies and conflicts of a package. Takes a
  `package` name and an optional `version` (defaulting to the latest release).
- **`ocaml_package_reverse_dependencies`** — the packages that depend on a given
  package ("used by"), each with its version constraint and latest release, plus
  a total count. Takes the same arguments.

### API and module documentation

These reuse ocaml.org's existing documentation backend, which serves the same
odoc content shown on package pages.

- **`ocaml_package_documentation`** — a documentation overview of a package: its
  synopsis, description, license, homepage, tags, documentation build status,
  and the libraries and top-level modules it exposes. Each library and module
  comes with a `path` you can hand to the next tool. Takes a `package` name and
  an optional `version` (defaulting to the latest *documented* version).
- **`ocaml_module_documentation`** — the documentation of a single module page:
  its preamble and signatures as plain text, the page's table of contents and
  breadcrumbs, and a `references` list of the page's links. Internal
  cross-references carry the target `package`, `version` and `path`, so an
  assistant can follow them **across dependencies** by calling the tool again;
  external links are returned as inert data, not as fetchable markup. Takes a
  `package`, an optional `version`, and a `path` (for example
  `lwt/Lwt/index.html`, as returned by `ocaml_package_documentation`).

Each tool returns a JSON document. For example, asking
`ocaml_package_dependencies` about `dream` returns that package's resolved
version alongside its `dependencies`, `optional` and `conflicts` lists; asking
`ocaml_package_documentation` about `lwt` returns its synopsis and the list of
modules to drill into with `ocaml_module_documentation`.

## Connecting your assistant

Whether you can add a remote MCP server, and where, depends on your assistant
and plan. Two things hold across all of them: the server speaks Streamable
HTTP, and it is public and **unauthenticated** — you add it with just the URL,
with no API key and no OAuth step. That last point matters in one place: a
client that *requires* OAuth for custom servers (currently the consumer Gemini
app) cannot attach a no-auth endpoint like this one, so there you fall back to
the command-line tool.

Each vendor is covered twice below: once for its command-line (coding) tool, and
once for its web or desktop app, since the two often differ in how — and whether
— a custom server can be added. GitHub Copilot, which spans several editors
rather than a single model, has its own section at the end.

### Anthropic (Claude)

#### Claude Code (command line)

Claude Code speaks Streamable HTTP to remote servers. Add the endpoint with:

```bash
claude mcp add --transport http --scope user ocaml-org https://ocaml.org/mcp
```

The `--scope user` flag makes the connector available across all your projects;
without it, `claude mcp add` registers the server for the current project only.
See the [Claude Code MCP documentation](https://code.claude.com/docs/en/mcp).

#### Claude.ai (web and desktop)

Open **Settings → Connectors → Add custom connector**, give it a name (for
example "ocaml.org") and paste `https://ocaml.org/mcp`. Custom connectors are
available on every plan, with two limits worth knowing: the Free plan is capped
at a single custom connector, and on Team and Enterprise only an Owner can add
one, and only if the organisation has enabled custom connectors. See
[Get started with custom connectors](https://support.claude.com/en/articles/11175166-get-started-with-custom-connectors-using-remote-mcp).

### OpenAI (ChatGPT and Codex)

#### Codex (command line)

Codex supports remote Streamable HTTP servers. Add the endpoint with:

```bash
codex mcp add ocaml-org --url https://ocaml.org/mcp
```

This writes to the global `~/.codex/config.toml`, so it applies to all your
sessions; a project-local `.codex/config.toml` scopes it to one directory. See
the [Codex MCP documentation](https://developers.openai.com/codex/mcp).

#### ChatGPT (web)

Custom MCP servers require **Developer Mode**: enable it under **Settings → Apps
& Connectors → Advanced → Developer mode**, then add a connector pointing at
`https://ocaml.org/mcp`. Developer Mode is available on the Plus, Pro, Business,
Enterprise and Edu plans — **not** the free tier — and accepts only remote
HTTPS servers (there is no local/stdio option). Note that Developer Mode grants
full read/write MCP access, so review anything you connect. See
[Developer mode and MCP apps in ChatGPT](https://help.openai.com/en/articles/12584461-developer-mode-and-mcp-apps-in-chatgpt).

### Google (Gemini)

#### Gemini CLI (command line)

Add a server under `mcpServers` in the user-level `~/.gemini/settings.json`
(global, across all projects; a project-local `.gemini/settings.json` scopes it
to one directory), using `httpUrl` for a Streamable HTTP server:

```json
{
  "mcpServers": {
    "ocaml-org": { "httpUrl": "https://ocaml.org/mcp" }
  }
}
```

See [MCP servers with the Gemini CLI](https://github.com/google-gemini/gemini-cli/blob/main/docs/tools/mcp-server.md).
Google's newer agentic client, [Antigravity](https://antigravity.google/docs/mcp/),
manages MCP servers in much the same way.

#### Gemini app (web)

The consumer Gemini app requires **OAuth** for custom MCP servers, so the
public, unauthenticated ocaml.org endpoint cannot be added there. Use the Gemini
CLI above, or a
[Gemini Enterprise (Vertex AI) setup](https://docs.cloud.google.com/gemini/enterprise/docs/connectors/custom-mcp-server/set-up-custom-mcp-server),
instead.

### Mistral (Le Chat and Vibe)

#### Mistral Vibe (command line)

Mistral's command-line coding agent,
[Mistral Vibe](https://docs.mistral.ai/vibe/code/cli/mcp-servers), supports MCP
servers over `http`/`streamable-http`/`stdio`. Add a server under `mcp_servers`
in its global `config.toml` with the URL `https://ocaml.org/mcp` (see the docs
for the exact transport keys), then browse configured servers from within Vibe
with `/mcp` or `/connectors`.

#### Le Chat (web)

Open **Intelligence → Connectors → Add connector → Add custom connector** and
enter `https://ocaml.org/mcp`. Custom remote connectors are available on all Le
Chat plans; on organisation plans an admin controls which connectors members may
use. See [Using MCP connectors with Le Chat](https://help.mistral.ai/en/articles/393511-using-my-mcp-connectors-with-le-chat).

### GitHub Copilot (VS Code, CLI and coding agent)

Copilot connects to remote Streamable HTTP servers across all its surfaces, and
because this endpoint needs no authentication you can skip the OAuth step its
documentation describes for authenticated servers.

In **VS Code** (agent mode, VS Code 1.101 or later), add a workspace
`.vscode/mcp.json` — note the root key is `servers`, not `mcpServers` — then turn
on **Agent mode** in the Copilot Chat input:

```json
{
  "servers": {
    "ocaml-org": { "type": "http", "url": "https://ocaml.org/mcp" }
  }
}
```

In the **Copilot CLI**, run `/mcp add` and give the name `ocaml-org`, type
`http`, and URL `https://ocaml.org/mcp`. The **Copilot coding agent** — the one
that runs on github.com and opens pull requests — also supports remote MCP
servers, configured in the repository or organisation Copilot settings.

See [Use MCP servers in VS Code](https://code.visualstudio.com/docs/agent-customization/mcp-servers),
[Adding MCP servers for the Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers),
and [Extending Copilot with MCP](https://docs.github.com/copilot/customizing-copilot/using-model-context-protocol/extending-copilot-chat-with-mcp).

## Local and open-weight models

MCP is a client-side protocol and it is model-agnostic: the server never knows
which model is calling it. The endpoint therefore works just as well behind a
locally-run, open-weight model (Llama, Mistral, Qwen, and so on) as behind a
hosted one — what matters is that the *client* speaks Streamable HTTP MCP. A
runner such as Ollama, LM Studio or llama.cpp serves the model, and an
MCP-capable harness in front of it — LM Studio itself, Cline, Continue, Goose,
LibreChat, or Mistral Vibe pointed at a local provider — makes the tool calls
and holds the connector.

Two caveats. First, running the model locally does not make the connection
local: the request to `https://ocaml.org/mcp` still leaves your machine over
HTTPS; only the model inference is local. Second, tool use is demanding —
smaller local models are often less reliable at deciding when to call a tool and
at chaining several calls (for example, following a module's cross-references
across dependencies), so results vary with the model.

## Notes

The endpoint is public and rate-limited per client. It only ever reads from
ocaml.org's own package data, so it cannot be used to fetch arbitrary URLs.
When the assistant connects from its vendor's cloud, the server cannot see
your local machine. This is not the case when using a local coding agent. In all
cases, it is not a substitute for local tooling that inspects your current opam
switch, pins or installed packages.

### Untrusted content

Package documentation, synopses and doc comments are **community-authored** and
not vetted by ocaml.org. Anyone can publish an opam package, so this text should
be treated as untrusted **data**, never as instructions — the risk is indirect
prompt injection, where retrieved text tries to steer the assistant. The server
reduces the surface it can: documentation is returned as plain text with active
markup removed (no images, scripts or fetchable links), links are handed back as
inert structured data, responses are size-bounded, and the tools are annotated
read-only (`readOnlyHint`) over a fixed backend (`openWorldHint: false`). These
are hints and mitigations, not guarantees: the decision to act on retrieved text
happens in the client, so keep this connector isolated from tools that execute
actions without review.

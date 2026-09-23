---
id: "mcp-server"
short_title: "MCP Server"
title: "The ocaml.org MCP Server: OCaml Package Data for AI Assistants"
description: "A hosted Model Context Protocol endpoint that lets AI assistants query opam package dependency and documentation information."
category: "OCaml Infrastructure"
---

ocaml.org hosts a public [Model Context Protocol](https://modelcontextprotocol.io)
(MCP) server that lets AI assistants — such as Claude, ChatGPT and Gemini, in
both their web apps and local clients — query OCaml package data directly. The
server is reached over public HTTPS from the assistant's side, so wiring it in
takes only a URL: there is no local install and no OCaml environment required.

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

ocaml.org can answer these authoritatively because it already computes
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

Further tools — documentation search by name and by type signature — are
planned; see the [tracking issue](https://github.com/ocaml/ocaml.org/issues/3775)
for the roadmap.

## Connecting your assistant

Whether you can add a remote MCP server, and where, depends on your assistant
and plan. The steps below cover the three most common clients.

### Claude

Remote MCP connectors are available to Claude users on all plans, in both
[Claude.ai](https://claude.ai) and Claude Code. In the web or desktop app, open
**Settings → Connectors → Add custom connector**, give it a name (for example
"ocaml.org") and paste the URL `https://ocaml.org/mcp`. In Claude Code, run:

```bash
claude mcp add --transport http ocaml-org https://ocaml.org/mcp
```

### ChatGPT

ChatGPT reaches custom MCP servers through **Developer Mode**. Enable it under
**Settings → Connectors → Advanced → Developer mode**, then add a new connector
pointing at `https://ocaml.org/mcp`. Custom connector availability depends on
your ChatGPT plan.

### Gemini

Gemini's support for custom MCP servers is oriented towards its enterprise and
developer tooling (for example the Gemini CLI and Vertex AI Agent Engine) rather
than the consumer app. Point your MCP-capable Gemini client at
`https://ocaml.org/mcp` following its connector configuration.

## Notes

The endpoint is public and rate-limited per client. It only ever reads from
ocaml.org's own package data, so it cannot be used to fetch arbitrary URLs.
Because the assistant connects from its vendor's cloud, the server cannot see
your local machine: it is not a substitute for local tooling that inspects your
current opam switch, pins or installed packages.

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

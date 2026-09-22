---
id: "mcp-server"
short_title: "MCP Server"
title: "The ocaml.org MCP Server: OCaml Package Data for AI Assistants"
description: "A hosted Model Context Protocol endpoint that lets AI assistants query opam package dependency information."
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

The first capability shipped is package **dependency** information, which
ocaml.org can answer authoritatively because it already computes it in memory
for every package in the opam repository.

- **`ocaml_package_dependencies`** — the direct dependencies (with their version
  constraints), optional dependencies and conflicts of a package. Takes a
  `package` name and an optional `version` (defaulting to the latest release).
- **`ocaml_package_reverse_dependencies`** — the packages that depend on a given
  package ("used by"), each with its version constraint and latest release, plus
  a total count. Takes the same arguments.

Each tool returns a JSON document. For example, asking
`ocaml_package_dependencies` about `dream` returns that package's resolved
version alongside its `dependencies`, `optional` and `conflicts` lists.

More tools — API and module documentation, and documentation search — are
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

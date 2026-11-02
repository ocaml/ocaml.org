# `tool/attribution`

Generates per-document **"Authors and history"** records for ocaml.org, from
git history, into `data/attribution.jsonl`. Phase 1 of
[#3902](https://github.com/ocaml/ocaml.org/issues/3902): the generator and the
committed records only — no frontend and no `data.bin`/packer change yet.

Attribution is a pure function of the repository at the build commit, so the
records are precomputed and committed rather than derived at runtime (the
deployed container has no `.git` of this repo).

## The one rule: never hand-edit `data/attribution.jsonl`

It is a **derived artifact**. `sync` folds forward from what is committed, so a
hand-edit would linger until the next re-seed, and `check` (see below) flags it
as differing from a fresh recompute. Express every correction as an **input**
instead; the next `seed` applies it, so it is reproducible and reviewable in the
PR diff.

| To fix… | Edit this input (read-only to the tool) |
| --- | --- |
| a wrong or duplicated contributor name | `.mailmap` |
| a mechanical commit being credited as authorship | `.git-blame-ignore-revs` |
| credit someone git misses, or drop a mis-attributed commit | `attribution/overrides/<path>.yml` (`add` / `exclude_commits` / `notes`) |
| mark a document as derived from an external source (no git trailer) | `attribution/overrides/<path>.yml` (`derived_from: [source:<key>]`) + the source in `attribution/sources.yml` |
| external-source authors / licence | `attribution/sources.yml` (keyed; resolved via `Derived-from: source:<key>` or the override above) |
| recover authorship lost when a document was imported from an earlier site | `attribution/imports.yml` (maps the doc to its path in a local clone of the source repo) |

The tool writes **only** `data/attribution.jsonl`; all four inputs above are
read-only to it. Hand-edit them freely — a reseed never clobbers them.

### `.mailmap` note

Identities are collapsed by git's `.mailmap`. When unifying a person's emails,
verify same-person by the **stable GitHub numeric ID** (`gh api user/<id>`,
where `<id>` is the number in an `<id>+login@users.noreply.github.com` address),
not the login: a login can be **recycled** to a different person. If a *bare*
`login@users.noreply.github.com` (no numeric prefix) is involved, map it with
the name+email form (`Canon <canon-email> Commit-Name <commit-email>`) rather
than by email alone, so a later owner of that login is not mis-credited.

## How the store is kept up to date

Pull requests **never** touch `data/attribution.jsonl`. After a pull request
that edits a tutorial or tool page merges, `.github/workflows/sync-attribution.yml`
runs `sync` on `main` and proposes the result as a single rolling pull request
(branch `bot/attribution`), the same way the scrape
workflows propose new content. A maintainer merges it whenever convenient.

The result:

- **No conflicts.** Only that bot pull request edits the store, and each run
  regenerates it from `main`, so an open one is overwritten rather than merged.
- **Nothing to do for contributors.** No command to run, and no check to fail.
- **One commit per merged pull request.** The project squash-merges, so the
  history `sync` folds over has one commit per pull request: a contributor's
  `commits` count is the number of their merged pull requests touching the
  document. Trailers (`Co-authored-by`, `Assisted-by`, `Derived-from`, …) count
  when they survive into the squash commit message.

## Commands

```sh
dune exec -- data-attribution sync     # fold every record forward to HEAD (CI, post-merge)
dune exec -- data-attribution seed     # full history; a maintainer runs it on main, then opens a PR
dune exec -- data-attribution check    # local: fail if the committed store is stale
```

- **`sync`** — brings the whole store up to date with HEAD, which must be a
  commit of `main`. Each record is folded **forward from its own watermark**
  (`generated_at_commit`): only the commits since then are added, and the record
  is re-stamped at HEAD. It also:
  - drops the records of deleted documents;
  - carries a renamed document's record to its new path (rename detection at
    `-M90%`, the threshold `git log --follow` uses) and folds it forward;
  - creates records for new documents.

  This is additions-only, so shallow history is enough, and it needs neither the
  full clone nor the imported-repo clone: everything already summed is carried
  in the record. It refuses to run when a watermark is not an ancestor of HEAD
  locally (unreachable, or a clone too shallow), rather than silently
  under-counting.
- **`seed`** — rewrites the whole store from full history. This is the one step
  that needs the complete clone (and the imported-repo clones), so the full
  history never enters CI. Re-seeding also re-bases any drift the incremental
  path accumulated, and is the way to apply a change to `.mailmap`,
  `.git-blame-ignore-revs`, or `attribution/overrides/` to commits already
  counted. Run it **on a checkout of `main`** (`make attribution-seed` checks
  this): it stamps every record at HEAD, and a branch commit would be discarded
  by the squash merge.
- **`check`** — full recompute, compared **ignoring the generation-time
  provenance stamp** (`generated_at_commit` / `generator`) so an advancing HEAD
  does not flag an otherwise-fresh store.

### The `generated_at_commit` watermark

Each record's `generated_at_commit` is **load-bearing**: it is the commit of
`main` the record was last folded up to, and the next `sync` resumes from it
(`watermark..HEAD`). Because `sync` and `seed` only ever run on `main`, the
watermark is always reachable, even though the project squash-merges. After a
sync every record shares one watermark, so the workflow only deepens its shallow
clone back to the last merged sync.

The workflow proposes a pull request only when some record's **content**
changed. A sync that would only move watermarks is dropped, so merging the bot's
pull request does not trigger another one.

By default the seed covers the documents the frontend surfaces
(`data/tutorials` + `data/tool_pages`); `--docs-root DIR` (repeatable) widens it.

### When `sync` asks for a re-seed

If a document disappears and another appears since the last sync, and rename
detection cannot pair them (a rename combined with heavy edits, say), `sync`
cannot tell a rename from an unrelated deletion and addition. Guessing wrong
would silently drop the old document's history, so it fails and asks for a
maintainer re-seed: on an up-to-date `main` checkout, run
`make attribution-seed`, commit the store on a branch, and open a pull request.
The next sync then starts from the re-seeded records.

## Record schema

One record per document, one compact JSON object per line, keys in the order
below, lists deterministically sorted. The authoritative definition is the type
`Record.t` in `lib/record.ml`; the data-packer deserializes it with `yojson`
into `Data_intf.Attribution.t`.

| Field | Type | Meaning |
| --- | --- | --- |
| `path` | string | Document path under `data/` (the sort key) |
| `contributors` | contributor[] | Human authors, sorted by first-commit date then name |
| `derived_from` | string[] | Internal provenance `"path@commit"` (from `Derived-from` trailers) |
| `external_authors` | string[] | External authors, resolved from `attribution/sources.yml` via `Derived-from: source:<key>` |
| `provenance_unknown_before` | string \| null | Date before which authorship is unknown (`Imported-from` / `Provenance: unknown`); **the only nullable field** |
| `ai_assisted` | ai_section[] | AI-assistance facet (one entry per AI-assisted commit) |
| `overrides_applied` | string[] | Audit trail: `exclude:<hash>`, `add:<name>`, `note:<…>` |
| `generated_at_commit` | string | The record's **watermark** — commit it was last folded up to; **excluded from `check` content comparison** but drives incremental maintenance |
| `generator` | string | `git` version + options, for reproducibility |

`contributor`:

| Field | Type | Meaning |
| --- | --- | --- |
| `name` | string | Mailmap-canonicalised display name (**never an email**) |
| `commits` | int | Count of non-trivial commits on this document (a count, not a list) |
| `first_commit` | string | Full hash of their earliest commit on it |
| `first_date` | string | `YYYY-MM-DD`, UTC |

`ai_section` (kept per-commit, since AI disclosure is inherently per-commit):

| Field | Type | Meaning |
| --- | --- | --- |
| `commit` | string | The AI-assisted commit's hash |
| `assisted_by` | string[] | AI tool(s) credited (e.g. `Claude Opus 4.8 (1M context)`) |
| `sections` | string[] | From `AI-sections` trailers (empty until the vocabulary is adopted) |
| `context` | string[] | From `AI-context` trailers (empty until adopted) |

## Imported documents (v2 and earlier)

Many tutorials were imported from the earlier site (v2.ocaml.org) in 2023, which
dropped their pre-import git authorship — so the real authors (e.g. John
Whitington, Xavier Leroy, Simon Cruanes) were missing while their adapters were
credited. `attribution/imports.yml` maps each such document to its path in a
local clone of that repo; the generator mines that history and folds the
contributors in, aggregating commit counts across the whole lineage. A mapping
may add `derived_from` for provenance older than that repo (the ocaml-tutorial.org
wiki it was copied from, Pierre Weis's Inria guidelines, …), resolved through
`sources.yml` into `external_authors`.

Two consequences:

- **Seeding and `check` of an imported document require the source clone** to be
  present at the configured `repo` path. The recovered authorship is baked into
  `data/attribution.jsonl` (the committed source of truth); the clone is only
  needed when regenerating those records.
- A contributor recovered from an imported repo has a **`first_commit` hash that
  belongs to that repo**, not this one — the date is the portable signal.

A related caveat: because contributor ordering and `first_date` are keyed on the
**author date** (which a rebase preserves even as commits are reordered), a
periodic full `seed` can occasionally reshuffle contributors whose first dates
are close, relative to an incrementally-folded store. This is harmless — both paths use
day-granularity author dates — but it is why a re-seed sometimes produces a diff beyond the documents that changed.

## How it works

Standalone binary, synchronous `git` via `bos` (the `git log` idiom is ported
from `src/ocamlorg_package/lib/opam_repository.ml`; no Lwt, no OCaml git
library). Per document: `git log --follow -M90%` collects commits; trivial ones
are dropped (`.git-blame-ignore-revs`, whitespace-only under `-w`); contributors
are aggregated and the trailer vocabulary folded in
(`Co-authored-by`, `Derived-from`, `Imported-from`, `Provenance`, `Assisted-by`,
`AI-sections`, `AI-context`). Output is one compact JSON object per line, sorted
by path, so a document's update rewrites exactly its own line.

Identities are handled so attribution stays honest: commit authors are mailmapped
by git, co-authors are mailmapped explicitly (git does not rewrite trailer text),
AI tools are routed to the `ai_assisted` facet rather than listed as human
authors, bots are dropped, and **no email addresses are published** (records
carry only name, commit count, first commit, first date).

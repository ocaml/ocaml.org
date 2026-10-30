# Per-document attribution overrides

Manual corrections applied **last** by the attribution generator
(`tool/attribution`), one file per document, named after the document's path
under `data/` with a `.yml` suffix — e.g. overrides for
`data/tutorials/guides/functions.md` live in
`attribution/overrides/data/tutorials/guides/functions.md.yml`.

Overrides are additive by policy: dropping a credit requires an explicit
`exclude_commits` entry (with a reason in `notes`) rather than silent removal.

```yaml
# attribution/overrides/data/tutorials/guides/functions.md.yml
add:
  - name: Ada Lovelace        # credit a contributor git history misses
exclude_commits:
  - 0000000000000000000000000000000000000000   # a mis-attributed commit
derived_from:
  - source:some-book          # key in attribution/sources.yml → external authors
notes: why these corrections were made
```

Use `derived_from` for imported/adapted documents whose commits predate any
`Derived-from:` trailer convention — e.g. a tutorial reproduced from an external
book. The generator resolves each `source:<key>` through `attribution/sources.yml`
into the record's `external_authors`, crediting the original authors that git
history alone would miss.

The six `.yml` files alongside this note are the current overrides: each
declares an external `derived_from` source for a tutorial excerpted/adapted from
a book (cs3110's "OCaml Programming", Real World OCaml), crediting authors git
history alone would miss.

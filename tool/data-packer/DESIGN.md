# Data Packer Design

## Problem

The current `ood-gen` tool converts 67 MiB of YAML/Markdown data into 119 MiB of
OCaml source code. The OCaml compiler then has to parse, type-check, and compile
all that generated code. This is slow.

## Solution

Replace code generation with binary serialization:

```text
Current:  data/*.yaml,md  →  [ood-gen]  →  *.ml (119 MiB)  →  [ocamlc]  →  binary
Proposed: data/*.yaml,md  →  [packer]   →  data.bin       →  [as]      →  binary
```

The packer:
1. Parses YAML/Markdown (same as ood-gen)
2. Serializes with `Marshal` (fast)
3. Outputs a single binary blob

The blob is embedded via `.incbin` assembly directive and deserialized at runtime.

## Architecture

```text
┌─────────────────────────────────────────────────────────────────────┐
│  tool/data-packer/                                                  │
│                                                                     │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────────────────┐ │
│  │ data/*.yaml  │ → │ parse        │ → │ Marshal.to_bytes         │ │
│  │ data/*.md    │   │ (reuse ood-  │   │ → _build/data.bin        │ │
│  │              │   │  gen logic)  │   │                          │ │
│  └──────────────┘   └──────────────┘   └──────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
                                                    │
                                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│  src/ocamlorg_data/                                                 │
│                                                                     │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────────────────┐ │
│  │ data_blob.S  │ → │ data_blob.o  │ → │ linked into ocamlorg     │ │
│  │ (.incbin)    │   │              │   │ binary                   │ │
│  └──────────────┘   └──────────────┘   └──────────────────────────┘ │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ data.ml                                                      │   │
│  │   get_blob_raw () : Bigarray (zero-copy view of the blob)    │   │
│  │   let data = Marshal.from_bytes … : All_data.t (at load)     │   │
│  │   ...                                                        │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## Binary Format

`data.bin` is the output of `Marshal.to_bytes` on a single
`Types.All_data.t` value (`lib/packer.ml`). It has no header and no
per-section index: `src/ocamlorg_data/data.ml` unmarshals the whole value
once, when the module loads, as a `Data_intf.All_data.t`.

Marshal output is untyped and tied to the compiler that wrote it. That is
acceptable here because the packer and the server are built by the same
compiler in the same build, and `data.bin` is regenerated on every build.

## Types and Decoders

The types themselves live in `src/ocamlorg_data/data_intf.ml`, with no
derivers attached. The packer refers to them in two ways:

- **Plain alias** (`type t = Data_intf.News.t`) by default, including
  everywhere in `lib/types.ml`.
- **`[%import]`** (`type link = [%import: Data_intf.Book.link]
  [@@deriving of_yaml]`) only where a deriver (`of_yaml`, `of_yojson`) is
  attached, because the deriver needs the type's structure at the definition
  site. These live in the `*_parser.ml` that decodes the type.

An alias does not bring constructors or record fields into scope, so a parser
that builds or matches values of these types opens the matching module
(`open Data_intf.Event`). Warning 40 (name-out-of-scope) is an error in
`tool/data-packer` (see its `dune` file), so relying on type-directed
disambiguation alone fails to build.

The packed blob is a Marshal of `Types.All_data.t`, so no type needs a
serialisation deriver.

## Assembly Wrapper and C Stubs

`stubs/data_blob.S` embeds `data.bin` in a read-only section with
`.incbin`, between the symbols `ocamlorg_data_blob` and
`ocamlorg_data_blob_end`, and stores the difference in
`ocamlorg_data_blob_size`. It supports Linux and macOS on amd64 and arm64.

`stubs/data_blob_stubs.c` exposes the blob to OCaml.
`caml_ocamlorg_data_blob` returns a zero-copy `CAML_BA_EXTERNAL` bigarray
over it, and `caml_ocamlorg_data_blob_check` rejects an implausible size.

## OCaml Interface

`src/ocamlorg_data/data.ml` copies the blob into bytes, unmarshals it once
when the module is loaded, and builds the accessor modules on top:

```ocaml
external get_blob_raw :
  unit ->
  (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
  = "caml_ocamlorg_data_blob"

let data : Data_intf.All_data.t =
  let ba = get_blob_raw () in
  let b = Bytes.create (Bigarray.Array1.dim ba) in
  (* copy ba into b *)
  Marshal.from_bytes b 0

module Testimonial = struct
  include Data_intf.Testimonial

  let all = data.testimonials
end
```

## Build Integration (dune)

`src/ocamlorg_data/dune` runs `pack.exe` to produce `data.bin`, copies
`data_blob.S` and `data_blob_stubs.c` from `stubs/`, assembles
`data_blob.o`, and links it into the `data` library through
`extra_objects`:

```lisp
(rule
 (target data.bin)
 (deps
  (source_tree %{workspace_root}/data)
  (:packer %{workspace_root}/_build/default/tool/data-packer/bin/pack.exe))
 (action
  (chdir
   %{workspace_root}
   (run %{packer} -o %{target}))))

(rule
 (target data_blob.o)
 (deps data_blob.S data.bin)
 (action
  (run %{cc} -c %{dep:data_blob.S} -o %{target})))
```

## Expected Benefits

| Metric | Current | Packer |
|--------|---------|--------|
| Data processing | ~seconds | ~seconds |
| Code compilation | minutes | milliseconds |
| Total build time | minutes | seconds |
| Incremental rebuild | full recompile | re-serialize only |

## Benchmark Results (Full Implementation)

With the complete data set (all types from ood-gen), measured with the
original bin_prot encoding; the current Marshal blob is about 18 MB:

```text
=== Data Sizes ===
Source data (YAML/Markdown):  67 MB
Generated OCaml (ood-gen):   119 MB
Packed binary (bin_prot):     17 MB  (75% smaller than source!)

=== Data Counts ===
testimonials:              7
academic_testimonials:     2
jobs:                     21
opam_users:               12
resources:                11
featured_resources:        6
videos:                  406
academic_institutions:    38
books:                    20
code_examples:             1
papers:                   74
tools:                    17
releases:                 35
success_stories:          11
industrial_users:         50
news:                     82
events:                   20
recurring_events:         12
exercises:                87
pages:                     5
conferences:              20
tutorials:                58
tutorial_search_documents: 758
changelog entries:       560
backstage entries:        99
planet entries:         2454
blog_sources:             77
blog_posts:             2048
cookbook_recipes:         59
cookbook_tasks:           86
cookbook_top_categories:  19
is_ocaml_yet:              2
outreachy rounds:         13
governance_teams:          5
governance_working_groups: 1
tool_pages:               10

=== Timing ===
Pack (parse YAML/MD + serialize): ~6.35 seconds
Unpack (deserialize from binary):  ~0.30 seconds
```

The unpacking is very fast - only 0.3 seconds to load all 6000+ records from binary.
Compare this to compiling 119 MiB of OCaml code, which takes minutes.

## Migration Path

1. **Phase 1**: Prototype with one type (Testimonial)
2. **Phase 2**: Serialize all types (planned as bin_io on every type in
   data_intf.ml; replaced by a single Marshal of `All_data.t`)
3. **Phase 3**: Create full packer (reusing ood-gen parsing)
4. **Phase 4**: Replace ood-gen rules in dune
5. **Phase 5**: Remove ood-gen (optional, can keep for debugging)

## Open Questions

1. Should we compress the blob? (gzip can reduce size significantly)
2. Should each type be a separate blob for faster incremental builds?
3. Do we need versioning/migration support for the binary format?

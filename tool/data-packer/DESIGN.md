# Data Packer Design

## Problem

The current `ood-gen` tool converts 67 MiB of YAML/Markdown data into 119 MiB of
OCaml source code. The OCaml compiler then has to parse, type-check, and compile
all that generated code. This is slow.

## Solution

Replace code generation with binary serialization:

```
Current:  data/*.yaml,md  →  [ood-gen]  →  *.ml (119 MiB)  →  [ocamlc]  →  binary
Proposed: data/*.yaml,md  →  [packer]   →  data.bin       →  [as]      →  binary
```

The packer:
1. Parses YAML/Markdown (same as ood-gen)
2. Serializes to bin_prot format (fast)
3. Outputs a single binary blob

The blob is embedded via `.incbin` assembly directive and deserialized at runtime.

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│  tool/data-packer/                                                  │
│                                                                     │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────────────────┐ │
│  │ data/*.yaml  │ → │ parse        │ → │ Bin_prot.Writer          │ │
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
│  │ data_blob.s  │ → │ data_blob.o  │ → │ linked into ocamlorg     │ │
│  │ (.incbin)    │   │              │   │ binary                   │ │
│  └──────────────┘   └──────────────┘   └──────────────────────────┘ │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ data.ml                                                      │   │
│  │   external get_blob : unit -> Bigstringaf.t                  │   │
│  │   let all_testimonials = lazy (deserialize blob)             │   │
│  │   ...                                                        │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
```

## Binary Format

Single blob containing all data types, with a header for fast lookup:

```
┌────────────────────────────────────────┐
│ Header                                 │
│   magic: "OODP" (4 bytes)              │
│   version: uint32                      │
│   num_sections: uint32                 │
│   section_offsets: (name, offset, len) │
└────────────────────────────────────────┘
┌────────────────────────────────────────┐
│ Section: testimonials                  │
│   bin_prot encoded list                │
└────────────────────────────────────────┘
┌────────────────────────────────────────┐
│ Section: books                         │
│   bin_prot encoded list                │
└────────────────────────────────────────┘
│ ...                                    │
```

## Type Modifications

Add `[@@deriving bin_io]` to types in `data_intf.ml`:

```ocaml
(* Before *)
type t = { name : string; ... } [@@deriving show]

(* After *)
type t = { name : string; ... } [@@deriving show, bin_io]
```

Special handling needed for:
- `Ptime.t` → custom bin_io (serialize as RFC3339 string or float)
- Polymorphic variants → bin_io handles these

## Assembly Wrapper

```asm
    .section .rodata
    .global ocamlorg_data_blob
    .global ocamlorg_data_blob_size

ocamlorg_data_blob:
    .incbin "data.bin"
ocamlorg_data_blob_end:

ocamlorg_data_blob_size:
    .quad ocamlorg_data_blob_end - ocamlorg_data_blob
```

## C Stubs

```c
#include <caml/mlvalues.h>
#include <caml/bigarray.h>

extern char ocamlorg_data_blob[];
extern size_t ocamlorg_data_blob_size;

CAMLprim value caml_ocamlorg_data_blob(value unit) {
    return caml_ba_alloc_dims(
        CAML_BA_UINT8 | CAML_BA_C_LAYOUT | CAML_BA_EXTERNAL,
        1, ocamlorg_data_blob, (long)ocamlorg_data_blob_size
    );
}
```

## OCaml Interface

```ocaml
(* In src/ocamlorg_data/data.ml *)

external get_blob : unit -> Bigstringaf.t = "caml_ocamlorg_data_blob"

let blob = lazy (get_blob ())

module Testimonial = struct
  include Data_intf.Testimonial

  let all = lazy (
    let buf = Lazy.force blob in
    let pos_ref = ref (Header.find_section "testimonials") in
    bin_read_t_list buf ~pos_ref
  )

  let all () = Lazy.force all
end
```

## Build Integration (dune)

```lisp
; Generate data.bin from sources
(rule
 (target data.bin)
 (deps (source_tree %{workspace_root}/data)
       (:packer %{workspace_root}/tool/data-packer/bin/pack.exe))
 (action (run %{packer} -o %{target})))

; Generate assembly wrapper
(rule
 (target data_blob.s)
 (deps data.bin)
 (action (write-file %{target}
   "    .section .rodata\n    .global ocamlorg_data_blob\nocamlorg_data_blob:\n    .incbin \"data.bin\"\n...")))

; Compile assembly
(rule
 (target data_blob.o)
 (deps data_blob.s data.bin)
 (action (run %{cc} -c %{deps} -o %{target})))
```

## Expected Benefits

| Metric | Current | Packer |
|--------|---------|--------|
| Data processing | ~seconds | ~seconds |
| Code compilation | minutes | milliseconds |
| Total build time | minutes | seconds |
| Incremental rebuild | full recompile | re-serialize only |

## Benchmark Results (Full Implementation)

With the complete data set (all types from ood-gen):

```
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
2. **Phase 2**: Add bin_io to all types in data_intf.ml
3. **Phase 3**: Create full packer (reusing ood-gen parsing)
4. **Phase 4**: Replace ood-gen rules in dune
5. **Phase 5**: Remove ood-gen (optional, can keep for debugging)

## Open Questions

1. Should we compress the blob? (gzip can reduce size significantly)
2. Should each type be a separate blob for faster incremental builds?
3. Do we need versioning/migration support for the binary format?

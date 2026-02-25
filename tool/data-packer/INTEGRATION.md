# Data Packer

The data-packer replaces ood-gen for processing site content. It serializes YAML/Markdown data into a binary blob that's embedded directly into the executable.

## Build Flow

```
data/*.yaml,md  →  [pack.exe]  →  data.bin (17 MB)
                                      ↓
                              [assembler + .incbin]
                                      ↓
                                 data_blob.o  →  binary
```

## Performance

| Metric | Value |
|--------|-------|
| Source data | 67 MB (YAML/Markdown) |
| Packed binary | 17 MB |
| Pack time | ~6 seconds |
| Deserialize time | ~0.3 seconds |

## Platform Support

The assembly wrapper (`stubs/data_blob.S`) supports:
- Linux amd64 (x86_64, ELF)
- Linux arm64 (aarch64, ELF)
- macOS amd64 (x86_64, Mach-O)
- macOS arm64 (Apple Silicon, Mach-O)

## Directory Structure

```
tool/data-packer/
├── lib/           # Parsers and types with bin_prot serialization
├── bin/           # pack.exe, verify.exe, benchmark.exe
└── stubs/         # Assembly and C source files (copied to src/ocamlorg_data/)
    ├── data_blob.S         # Assembly with .incbin directive
    ├── data_blob_stubs.c   # C functions for OCaml access
    ├── data_blob.ml        # OCaml interface (reference only)
    └── data_blob.mli       # Type signatures (reference only)
```

## How It Works

1. `pack.exe` parses all YAML/Markdown in `data/` and serializes to `data.bin` using bin_prot
2. The assembly file embeds `data.bin` via `.incbin` directive
3. C stubs provide OCaml access to the embedded blob as a Bigarray
4. `src/ocamlorg_data/data.ml` deserializes lazily on first access

## Type Safety

- Types are defined in `Data_intf` (shared with the rest of the codebase)
- Packer uses `ppx_import` to ensure type compatibility
- bin_prot provides deterministic serialization
- Type mismatches are caught at deserialize time

# Benchmark: data-packer vs ood-gen

## How to Run the Comparison

### Prerequisites

You need two copies of the repository:
1. One on `main` branch with an opam switch compatible with ood-gen
2. One on `data-packer` branch with current dependencies

### ood-gen (code generation approach)

```bash
# In the main branch copy with old switch
dune build  # warm up, build ood-gen executable
rm -rf _build/default/src/ocamlorg_data
time dune build src/ocamlorg_data
```

This will:
1. Run `tool/ood-gen/bin/gen.exe` to generate .ml files
2. Compile those generated .ml files into the `data` library

### data-packer (binary serialization approach)

```bash
# In the data-packer branch
dune build  # warm up, build pack executable
rm -rf _build/default/src/ocamlorg_data
time dune build src/ocamlorg_data
```

This will:
1. Run `tool/data-packer/bin/pack.exe` to parse data and serialize to `data.bin`
2. Compile a small wrapper that loads the binary at runtime

## Results (January 2026)

| Metric | ood-gen | data-packer | Improvement |
|--------|---------|-------------|-------------|
| Wall clock | 7.6s | 6.5s | **15% faster** |
| User time | 16.25s | 6.37s | **2.5x less CPU** |
| CPU usage | 237% | 106% | Less parallel work needed |
| Output | ~119MB .ml files | 17MB binary | **7x smaller** |

### Analysis

The wall clock times are close because ood-gen parallelizes compilation across cores (237% CPU). But data-packer uses **2.5x less total CPU time** - it's doing less work overall.

### Key Wins

1. **Less CPU burn** - better for CI runners and laptops
2. **Smaller output** - 17MB binary vs ~119MB of generated OCaml source
3. **Simpler build** - no generated .ml files to compile
4. **Incremental rebuilds** - changing one data file only re-packs, doesn't trigger OCaml recompilation

## Dedicated Benchmark Tool

For micro-benchmarking the packing/unpacking operations in isolation:

```bash
dune exec tool/data-packer/bin/benchmark.exe
```

This runs 10 iterations and reports average times for:
- Pack (parse YAML/Markdown + serialize to binary)
- Unpack (deserialize binary at runtime)

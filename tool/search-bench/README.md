# search-bench — measuring ocaml.org package-search ranking

This tool benchmarks the **ranking** of ocaml.org's package search
(`Ocamlorg_package.search`, the engine behind the top-right search box). It
compares ranking *arms* over a query set and reports both **effectiveness**
(relevance) and **efficiency** (latency), so a ranking change can be shown to be
an improvement rather than asserted to be one.

It ships one candidate change alongside the harness: a **BM25F** ranking arm
(`Ocamlorg_package.Bm25f`) that replaces the historical binary-presence scorer
with term-frequency saturation, per-field length normalisation and IDF, keeping
the popularity prior as a multiplicative factor. BM25F is **not** the default —
it stays behind the `?ranking` flag until the numbers justify flipping it.

## What it measures

Two things that a single change can win one of and lose the other, so they are
reported separately:

- **Effectiveness** — does it return *better-ordered* results?
  - **Known-item tier** (free, no network): navigational queries whose correct
    answer is unambiguous (`yojson` → the `yojson` package must rank first).
    Metrics: precision@1, MRR. Frozen as a dune regression test
    (`src/ocamlorg_package/test/search_ranking_test.ml`).
  - **Graded tier** (LLM judge): topic/need queries scored 0–3 for relevance,
    reported **per surface** — **nDCG@5** for autocomplete (the handler shows the
    top 5) and **nDCG@10** for the results page. Runs only when
    `ANTHROPIC_API_KEY` is set.
- **Efficiency** — p-latency of the search call (warmed, so BM25F's one-time
  corpus-stats build is excluded).

Both arms rank the **same matched set** — BM25F only re-orders — so each
(query, package) pair is judged once per pass and the grade is reused across all
arms.

## Running

```sh
# known-item + latency only (no API key needed)
dune exec tool/search-bench/bench.exe -- tool/search-bench/queries.csv > runs/bench.csv

# with the LLM graded tier (5 judge passes, averaged)
ANTHROPIC_API_KEY=sk-ant-... \
  dune exec tool/search-bench/bench.exe -- tool/search-bench/queries.csv > runs/bench.csv
```

Flags:

| Flag | Effect |
| --- | --- |
| `--ablate` | Run the full component-ablation + parameter-sweep arm set (`no-idf`, `no-lennorm`, `no-exact`, `flat-boost`, `k1-2.0`, `b-0.0/0.4/1.0`) instead of just `current` vs `bm25f`. |
| `--passes N` | Judge each query N times and average the grades (default 5). Also reports the mean per-query grade stddev as a judge-noise readout. |
| `--split train\|holdout` | Keep only queries tagged with that split (untagged queries always run). Tune params on `train`, report the headline on the untouched `holdout`. |
| `--validate-judge` | Judge a sample with the configured model **and** `claude-opus-4-8`, report agreement (mean \|Δgrade\|, Pearson r), then exit. |
| `--show` | Dump each arm's top-10 per query (judge grade in parens) to stderr. |

Env: `SEARCH_BENCH_JUDGE_MODEL` (default `claude-haiku-4-5`), `ANTHROPIC_API_KEY`.

Per-(query,arm) CSV goes to stdout; progress, per-arm means, and the paired
statistics go to stderr:

```text
query,arm,split,p1,mrr,ndcg5,ndcg10,latency_ms
```

The tool reads the on-disk package-state cache
(`OCAMLORG_PKG_STATE_PATH`, default `~/.cache/ocamlorg/package.state`) via
`Ocamlorg_package.load_cached` — no opam-repository clone, no background
polling. Populate it by running the site once if it is missing. **For
realistic corpus statistics (IDF, average field lengths) run against a full
~14k-package cache**, not a partial snapshot — point `OCAMLORG_PKG_STATE_PATH`
at a fresh `package.state` (e.g. produced by running `make watch` once).

## The query set

`queries.csv` is a small, stratified **starter** set (navigational + topic,
tagged `train`/`holdout`). It is not evidence on its own. The ground truth of
what users want is what they type: mine `q=` values from the server access logs
and replace this file (see the `--split` discipline below). If search queries
are not logged yet, adding that logging is the cheapest high-value first step.

Columns: `query[,expected-package[,split]]`. An `expected-package` makes it a
known-item query; `split ∈ {train,holdout}` separates tuning from reporting
(untagged queries run in every split).

## Judge prompt

The LLM judge grades relevance pointwise, 0–3, from the query and each
candidate's **name, synopsis, tags and a description excerpt** (no popularity
signal). This is the system prompt (kept in sync with `judge_system_prompt` in
`bench.ml`):

> You are a strict relevance judge for an OCaml package search engine. Given a
> user's search query and a numbered list of candidate packages (name,
> synopsis, tags and a description excerpt), grade how well each candidate
> answers the query on this scale:
> 3 = perfect: the package is exactly what the query asks for.
> 2 = highly relevant: a strong, directly useful match.
> 1 = marginally relevant: related but not a good answer.
> 0 = irrelevant.
> Judge only from the query and the candidate text. Do not reward popularity or
> name familiarity. Reply with ONLY a JSON array of objects, one per candidate,
> each {"index": <int>, "grade": <0-3>}. No prose.

Model: `claude-haiku-4-5` by default (via the Messages API over raw HTTP — there
is no official Anthropic OCaml SDK), overridable with `SEARCH_BENCH_JUDGE_MODEL`.
The pool handed to the judge for each query is the **union of the top-10 across
arms, shuffled (seeded)** with arm labels removed — so the judgment set is not
biased toward either arm.

**Validate the cheap judge.** `--validate-judge` compares the configured model
against `claude-opus-4-8` on a sample and reports mean |Δgrade| and Pearson r.
Run it once before trusting Haiku grades at scale; record the result.

**The judge is a proxy, not an oracle.** LLM grades validate the *LLM's* notion
of relevance. A self-built query/judge set can only support "better for how we
search / non-regressing", not "better for OCaml users in general" (that needs
judgments from other people).

## Statistics

The tool prints, to stderr, per BM25F arm vs `current` on nDCG@10 (graded
queries only):

- the **mean per-query delta**,
- a **paired bootstrap 95% CI** (10 000 resamples, seeded) — if it **crosses
  zero the improvement is not established**,
- a **sign test** (wins/losses/ties),
- and, with `--passes > 1`, the **mean per-query grade stddev** (judge noise).

Always `--show` and read the actual ranked lists for a sample — aggregate metrics
can rise while the visible top results get worse.

### Aggregating from the CSV (awk / gnuplot — no Python)

Per-arm means for a metric column (nDCG@10 = column 7):

```sh
awk -F, 'NR>1 && $7!="" {s[$2]+=$7; n[$2]++}
         END{for(a in s) printf "%-10s %.4f\n", a, s[a]/n[a]}' runs/bench.csv
```

Latency percentiles per arm (column 8):

```sh
for arm in current bm25f; do
  awk -F, -v a=$arm 'NR>1 && $2==a{print $8}' runs/bench.csv | sort -n | \
    awk -v a=$arm '{v[NR]=$0} END{
      printf "%-10s p50=%.1f p90=%.1f p99=%.1f ms\n", a,
        v[int(NR*0.5)+0], v[int(NR*0.9)+0], v[int(NR*0.99)+0]}'
done
```

## Arms and next steps

Current arms: `current` (production binary-presence + popularity) and `bm25f`
(BM25F + popularity); `--ablate` adds the component/parameter arms. Tuning
workflow: `--ablate --split train` to find params that fix the losses, then
confirm on `--split holdout`. Freeze the known-item guard as the dune regression
test (already done) before shipping any default change.

**Known limitation:** `is_author_match` here is a substring stub, not the
handler's opam-user-table resolution (`ocamlorg_data`); fine while the set has no
`author:` queries, but wire the real table before benchmarking author search.

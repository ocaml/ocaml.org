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
it stays behind the `?ranking` flag until the numbers below justify flipping it.

## What it measures

Two things that a single change can win one of and lose the other, so they are
reported separately:

- **Effectiveness** — does it return *better-ordered* results?
  - **Known-item tier** (free, no network): navigational queries whose correct
    answer is unambiguous (`yojson` → the `yojson` package must rank first).
    Metrics: precision@1, MRR. This is the natural CI regression guard.
  - **Graded tier** (LLM judge): topic/need queries scored 0–3 for relevance,
    reported as nDCG@5 / nDCG@10. Runs only when `ANTHROPIC_API_KEY` is set.
- **Efficiency** — p-latency of the search call (warmed, so BM25F's one-time
  corpus-stats build is excluded).

Both arms rank the **same matched set** — BM25F only re-orders — so each
(query, package) pair is judged once and the grade is reused across arms.

## Running

```sh
# known-item + latency only (no API key needed)
dune exec tool/search-bench/bench.exe -- tool/search-bench/queries.csv > runs/bench.csv

# with the LLM graded tier
ANTHROPIC_API_KEY=sk-ant-... \
  dune exec tool/search-bench/bench.exe -- tool/search-bench/queries.csv > runs/bench.csv
```

Progress and per-arm means go to stderr; the per-(query,arm) CSV goes to stdout:

```text
query,arm,p1,mrr,ndcg5,ndcg10,latency_ms
```

The tool reads the on-disk package-state cache
(`OCAMLORG_PKG_STATE_PATH`, default `~/.cache/ocamlorg/package.state`) via
`Ocamlorg_package.load_cached` — no opam-repository clone, no background
polling. Populate it by running the site once if it is missing.

## The query set

`queries.csv` is a small, stratified **starter** set (navigational + topic).
It is not evidence on its own. The ground truth of what users want is what they
type: mine `q=` values from the server access logs and replace this file. If
search queries are not logged yet, adding that logging is the cheapest
high-value first step. Stratify into navigational, topic/need, and (once
cross-package type search exists) type queries.

## Judge prompt

The LLM judge grades relevance pointwise, 0–3, from the query and each
candidate's name + synopsis only (no popularity signal). This is the system
prompt (kept in sync with `judge_system_prompt` in `bench.ml`):

> You are a strict relevance judge for an OCaml package search engine. Given a
> user's search query and a numbered list of candidate packages (name and
> one-line synopsis), grade how well each candidate answers the query on this
> scale:
> 3 = perfect: the package is exactly what the query asks for.
> 2 = highly relevant: a strong, directly useful match.
> 1 = marginally relevant: related but not a good answer.
> 0 = irrelevant.
> Judge only from the query and the candidate text. Do not reward popularity or
> name familiarity. Reply with ONLY a JSON array of objects, one per candidate,
> each {"index": <int>, "grade": <0-3>}. No prose.

Model: `claude-opus-4-8` via the Messages API (raw HTTP — there is no official
Anthropic OCaml SDK). The pool handed to the judge for each query is the
**union of the top-10 across arms**, shuffled by name order, with arm labels
removed — so the judgment set is not biased toward either arm.

**The judge is a proxy, not an oracle.** LLM grades validate the *LLM's* notion
of relevance. Before trusting them at scale, hand-label a sample and check
agreement; and a self-built query/judge set can only support "better for how we
search / non-regressing", not "better for OCaml users in general" (that needs
judgments from other people).

## Aggregating (awk / gnuplot — no Python)

Per-arm means for a metric column (e.g. nDCG@10 = column 6):

```sh
awk -F, 'NR>1 && $6!="" {s[$2]+=$6; n[$2]++}
         END{for(a in s) printf "%-8s %.4f\n", a, s[a]/n[a]}' runs/bench.csv
```

Per-query delta (bm25f − current) for nDCG@10, the input to a paired test:

```sh
awk -F, 'NR>1 && $6!=""{v[$1"|"$2]=$6; q[$1]=1}
         END{for(k in q){d=v[k"|bm25f"]-v[k"|current"];
                         if(v[k"|bm25f"]!=""&&v[k"|current"]!="")
                           printf "%s\t%+.4f\n", k, d}}' runs/bench.csv
```

Latency percentiles per arm (column 7):

```sh
for arm in current bm25f; do
  awk -F, -v a=$arm 'NR>1 && $2==a{print $7}' runs/bench.csv | sort -n | \
    awk -v a=$arm '{v[NR]=$0} END{
      printf "%-8s p50=%.1f p90=%.1f p99=%.1f ms\n", a,
        v[int(NR*0.5)+0], v[int(NR*0.9)+0], v[int(NR*0.99)+0]}'
done
```

A mean nDCG gain over ~25 queries proves nothing without a **paired bootstrap
confidence interval** over the per-query deltas: resample the deltas with
replacement, recompute the mean each time, take the 2.5th/97.5th percentiles; if
that interval crosses zero the improvement is not established. And always eyeball
the actual ranked lists for a sample — aggregate metrics can rise while the
visible top results get worse.

## Arms and next steps

Current arms: `current` (production binary-presence + popularity) and `bm25f`
(BM25F + popularity). To isolate *which* part of BM25F earns a gain, add
intermediate arms (`+idf`, `+length-norm`, `+field-weight`) as further
`ranking` variants and compare them the same way. Freeze the known-item tier as
a dune regression test before shipping any default change.

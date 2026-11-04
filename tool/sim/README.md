# Server Simulation

`sim` runs the production server image under conditions close to production,
but faster. It replays real opam-repository history into the server so that it
goes through its package-state update cycle (pull, rebuild, save) every few
seconds instead of every hour. While that happens, it sends the server
realistic traffic and records memory, CPU, GC pauses, and response latency on
a single timeline.

Use it to see how a change to the server behaves over many update cycles: for
example, whether memory keeps growing, or whether requests stall while the
package state is rebuilt or saved.

The load tests in [`test/load-test/`](../../test/load-test/) answer a
different question: how much request throughput the server sustains. They use
closed-loop virtual users against a server that stays idle otherwise.

## How It Works

The server needs no change, and the image is the one built from the
repository's `Dockerfile`:

- **Accelerated polling.** The server reads its polling interval from
  `OCAMLORG_OPAM_POLLING`. By default, `sim` sets it to the production 3600
  seconds divided by `--speedup`.
- **Replayed upstream.** The image contains a full clone of opam-repository.
  [`entrypoint.sh`](entrypoint.sh) makes a bare upstream that shares the
  clone's objects. It points the clone's `origin` at that upstream and rewinds
  both to the `master` commit from `--history-days` before the image's tip.
  `sim` then moves the upstream's `master` forward along the real
  first-parent history, `--speedup` times faster than it happened. The
  server's own `git pull` picks up each change as it would in production.
- **Traffic.** An open-loop generator sends requests at Poisson-distributed
  times. A slow server does not slow it down, and each latency is measured
  from the time the request was scheduled, so time spent waiting behind a
  stalled server counts. There are two streams:
  - `human`: the page mix and daily curve of a [traffic profile](#traffic-profiles).
    By default, the hour of day follows the replayed history's clock
    (`--diurnal compressed`).
  - `bot`: a crawler that requests every package and package-version page in
    random order, at `--bot-rps` requests per second. Plausible does not count
    crawlers, which can make up a large share of the server's load. Package
    documentation pages are left out unless `--include-docs` is given.
- **Documentation server.** Package pages make the server fetch documentation
  status from an external server. By default (`--docs stub`), `sim` points the
  server at a stub on the host instead. The stub is reached by IP address and
  answers every request with 404, which the server treats as "no
  documentation built". This keeps the network, and name resolution inside
  the container, out of the measurements. In our runs, intermittent DNS
  failures towards the real docs server caused most of the 2–5 s stalls.
  `--docs real` uses the production docs server; the stub's request counts
  are written to `docs-stub.json`.
- **Instrumentation.** Everything is read from the host:
  - memory and CPU from the container's cgroup (v2);
  - the server's resident set size from `/proc`;
  - GC activity from the server's OCaml runtime-events ring
    (`OCAML_RUNTIME_EVENTS_START`), shared with the host through a volume;
  - the update cycle from the server's log.

## Running

You need Docker with Compose, a cgroup v2 host (any recent Linux), and
gnuplot for the plots. Run everything from the repository root:

```bash
docker build -t ocamlorg:sim .
opam exec -- dune exec tool/sim/bin/main.exe -- run --image ocamlorg:sim --duration 15m
```

This replays the last 7 days of opam-repository at 120× speed, which means a
poll every 30 seconds, with each poll seeing an hour of real merges. At the
end, `sim` prints a summary and writes `timeline.svg`.

The options most likely to matter:

| Option | Default | Meaning |
| ------ | ------- | ------- |
| `--speedup X` | `120` | History replay speed |
| `--poll S` | `3600 / X` | Server polling interval |
| `--history-days D` | `7` | How much history to replay; the run runs out of history after `D × 86400 / X` seconds |
| `--duration T` | `15m` | Run length (`90s`, `15m`, `2h`) |
| `--profile FILE` | `profiles/sample.json` | Human traffic profile |
| `--traffic-scale X` | `1` | Multiplier on the profile's rate |
| `--no-human` | | No human traffic |
| `--bot-rps R` | `2` | Crawler rate; `0` turns it off |
| `--mem M`, `--cpus N` | `7g`, unlimited | Container limits. In production, two servers share a 15.5 GB host |
| `--keep` | | Leave the container running at the end |
| `--docs M` | `stub` | Documentation server: `stub` or `real`; see above |

See `run --help` for the others. To compare two builds, run the same command
against each image. The traffic schedule, meaning every send time and path,
is drawn up front from `--seed`. It is counted from the moment the server
first answers, so two runs with the same seed and options send the same
requests at the same offsets, whatever each server does. The one exception
is at the end: a server that took longer to start gets fewer seconds of
traffic before the run stops. Requests with the same `id` in `traffic.csv`
can be compared one to one.

The first update cycle rebuilds the package state from scratch: the image's
state was built at its tip, and the run starts days before that. The summary
labels it as warm-up.

## Output

Each run writes a directory under `tool/sim/out/` (ignored by git):

| File | Content |
| ---- | ------- |
| `meta.json` | Run parameters, image id, start and tip commits |
| `summary.txt` | The summary described [below](#reading-the-summary) |
| `summary.json` | The same summary, structured, for programs and language models ([below](#for-programs-and-language-models)) |
| `timeline.csv` | Per 10 s, one row: update share, memory, CPU, GC, latency per stream, upstream commits |
| `events.csv` | Updates, upstream advances, the 10 longest GC pauses, and latency bursts |
| `timeline.svg` | Everything on one time axis; update windows shaded |
| `resources.csv` | Per second: cgroup memory, anon/file, RSS, CPU |
| `gc.csv` | Per second: minor GCs and major slices (count, total, longest), major heap size |
| `gc-events.csv` | One row per GC pause (minor collection or major slice): start, kind, duration |
| `traffic.csv` | One row per request; `id` is its position in its stream |
| `latency-<stream>.csv` | Per 5 s: count, errors, drops, p50/p90/p95/p99/p99.9/max |
| `sync.csv` | Update cycle events and phase durations, from the server log |
| `windows.csv` | Update windows: from "Update server state" to "Package state saved", plus 1 s, because the largest GC pauses of an update fall within 0.2 s of that log line |
| `cycles.csv` | Per update: duration, CPU-seconds, peak memory, memory floor after it, longest GC pause |
| `feed.csv` | When upstream moved, and by how many commits |
| `server.log` | The server's full log |

`sim summary DIR` and `sim plot DIR` regenerate the summary and the plot.
`sim compare A B` compares two runs (see [below](#comparing-runs)).

### Reading the Summary

Each kind of data is summarised in the way that suits it.

- **Latency and GC pauses** are many separate events, so they get
  percentiles (p50, p90, p95, p99, p99.9, max), during updates and outside
  them. A percentile is only as good as the number of samples above it. It
  shows as `-` when no sample lies above it, since it would just be the
  maximum, and is marked `*` when fewer than 10 do. In a 5-minute run with
  the sample profile, the human p99 rests on about 5 requests: run longer, or
  with more traffic, for stable tails.
- **Minimum mutator utilisation** (MMU) is the worst share of any 1 ms,
  10 ms, 100 ms or 1 s window left to the program rather than the GC. Many
  short pauses close together hurt a request more than one longer pause.
  Percentiles of single pauses miss that; MMU does not.
- **Memory and CPU** are time series with a trend and a sawtooth, not
  independent samples, so they are summarised per update cycle instead:
  - CPU-seconds spent;
  - peak memory during the update;
  - the floor, meaning the lowest memory between an update and the next.

  A floor that keeps rising points to memory retained across updates; the
  summary gives its least-squares trend in MB per update. CPU is also split
  between updates and the baseline outside them.
- **Update phases** happen a handful of times per run, so they get min,
  median and max, without the warm-up rebuild.

### For Programs and Language Models

The plot is for people. A program, or a language model, reads the same data
better as text with the aggregation already done:

- `summary.json` holds everything in `summary.txt`, with units in field
  names (`p99_ms`, `rss_floor_trend_mb_per_update`). Each percentile carries
  the number of samples above it and a `reliable` flag. The run parameters
  and the definitions used (update window, floor, MMU, burst) are included.
- `timeline.csv` replaces the picture: 10-second rows, one column per
  metric, about 60 rows for a 10-minute run.
- `events.csv`, also in `summary.json`, lists what happened and when:
  - each update and when upstream moved;
  - the longest GC pauses;
  - latency bursts, meaning at least 3 requests slower than 2 s, each
    scheduled within 5 s of the previous one.

All three are computed by `sim` from the raw files: the same run directory
always gives the same output. The raw CSVs stay available for detail, for
example to query with `awk`.

### Comparing Runs

```bash
opam exec -- dune exec tool/sim/bin/main.exe -- compare DIR_A DIR_B -o report.json
```

This prints:

- the run parameters that differ, apart from the image. If any do, the runs
  are not comparable one to one.
- every number of the two `summary.json` files, with B − A and B / A. A
  percentile resting on fewer than 10 samples on either side is marked.
- paired latency: each request is matched with the same request (stream and
  `id`) in the other run, and the differences B − A are summarised per
  stream, then by update timing (during an update in either run, or outside)
  and by page class. Groups of fewer than 20 pairs are marked as small. This
  needs runs made since request ids were added. A path mismatch means the two
  schedules differ.
- slow requests: of the requests slower than 2 s in either run, how many are
  slow in both. A low overlap means slowness depends on when a request
  arrived, not on what it asked for.

With `-o`, it also writes `report.json`, a single entry point for a program
or a language model. It contains:

- reading instructions and the definitions used;
- both runs' parameters;
- the key metrics, each saying which direction is better;
- every metric;
- the paired breakdowns;
- both runs' events;
- the path of each run's files, for detail.

For the 10-minute comparison it is about 40 KB.

## Traffic Profiles

A profile is a JSON file with the following fields:

- a mean page-request rate (`base_rps`);
- 24 hourly weights;
- a weighted list of paths.

In a path, `{pkg}` and `{ver}` are replaced by a random package and version
from the replayed repository. They stand for the long tail of package pages.

- [`profiles/sample.json`](profiles/sample.json) is a hand-written
  placeholder. Its rates and mix are guesses.
- `sim profile plausible -o FILE` builds a profile from ocaml.org's Plausible
  statistics. It needs a Stats API key in `OCAMLORG_PLAUSIBLE_KEY`. It runs
  three queries over `--period` (default `30d`): total pageviews, pageviews
  per hour, and the top `--limit` pages. The pageviews of the pages below the
  limit go to the package-page placeholders. Plausible counts page views by
  browsers, not requests to the server: assets and pages served from the CDN
  cache never reach the server, so use `--traffic-scale` to explore around
  the measured rate.
- `sim profile access-log -o FILE LOG...` builds a profile from access logs
  in the Common or Combined Log Format. Logs include crawlers, so run with
  `--bot-rps 0` when using such a profile.

Profiles built from real data are not committed.

## Caveats

- With the default `--docs stub`, package pages follow the server's
  no-documentation path. Pages whose documentation exists in production do
  more work there, which the stub does not reproduce.
- The GC reader must be built with the same OCaml version as the server
  image, because the ring format is version-specific.
- Runtime events stay on in processes the server forks, such as `git`, so
  each of them leaves a sparse ring file in the run's `rte/` directory
  (about 16 KB of real disk each). `sim` removes them at the end of the run.
- Requests go straight to the server, not through the CDN in front of it in
  production.

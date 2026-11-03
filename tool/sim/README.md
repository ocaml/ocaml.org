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
    crawlers, which can make up a large share of the server's load. Documentation
    pages come from the external docs server, so they are left out unless
    `--include-docs` is given.
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

See `run --help` for the others. To compare two builds, run the same command
against each image. With the same `--seed`, both runs request the same URLs
on the same schedule.

The first update cycle rebuilds the package state from scratch: the image's
state was built at its tip, and the run starts days before that. The summary
labels it as warm-up.

## Output

Each run writes a directory under `tool/sim/out/` (ignored by git):

| File | Content |
| ---- | ------- |
| `meta.json` | Run parameters, image id, start and tip commits |
| `summary.txt` | Latency during and outside updates, peaks |
| `timeline.svg` | Everything on one time axis; update windows shaded |
| `resources.csv` | Per second: cgroup memory, anon/file, RSS, CPU |
| `gc.csv` | Per second: minor GCs and major slices (count, total, longest), major heap size |
| `traffic.csv` | One row per request |
| `latency-<stream>.csv` | Per 5 s: count, errors, drops, p50/p90/p99/max |
| `sync.csv` | Update cycle events and phase durations, from the server log |
| `windows.csv` | Update windows (update → saved) |
| `feed.csv` | When upstream moved, and by how many commits |
| `server.log` | The server's full log |

`sim summary DIR` and `sim plot DIR` regenerate the summary and the plot.

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

- Without `--include-docs`, no request reaches the external docs server.
  Package overview pages may still query its status endpoint.
- The GC reader must be built with the same OCaml version as the server
  image, because the ring format is version-specific.
- Runtime events stay on in processes the server forks, such as `git`, so
  each of them leaves a sparse ring file in the run's `rte/` directory
  (about 16 KB of real disk each). `sim` removes them at the end of the run.
- Requests go straight to the server, not through the CDN in front of it in
  production.

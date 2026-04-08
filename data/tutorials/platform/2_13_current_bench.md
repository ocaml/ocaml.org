---
id: "continuous-benchmarking"
title: "Continuous Benchmarking with current-bench"
short_title: "current-bench"
description: |
  Track performance regressions automatically using current-bench, a continuous benchmarking service for OCaml projects
category: "Additional Tooling"
prerequisite_tutorials:
  - "bootstrapping-a-dune-project"
---

## What Is current-bench?

[current-bench](https://github.com/ocurrent/current-bench) is a continuous benchmarking service for OCaml projects, hosted at [bench.ci.dev](https://bench.ci.dev). Built on the [OCurrent](https://github.com/ocurrent/ocurrent) pipeline framework (like [OCaml-CI](/docs/ocaml-ci)), it runs benchmarks on every PR and push, tracks results over time, and surfaces performance regressions in a web dashboard.

Notable projects using current-bench include the OCaml compiler itself, Dune, Merlin, Irmin, Eio, and Saturn.

## How It Works

When a PR is opened or a branch is pushed, current-bench:

1. Builds the project in a Docker container on a dedicated benchmarking worker
2. Runs `make bench`
3. Captures JSON output from **stdout**
4. Stores the results and displays time-series charts

The key contract is simple: your `make bench` target must print valid JSON to stdout. All other output (logs, progress messages) must go to **stderr**.

Results are visible at `https://bench.ci.dev/<org>/<repo>`.

## Writing Benchmarks

### JSON Output Format

current-bench expects JSON on stdout with this structure:

```json
{
  "results": [
    {
      "name": "my-benchmark",
      "metrics": [
        {
          "name": "duration",
          "value": 1.42,
          "units": "s",
          "trend": "lower-is-better"
        }
      ]
    }
  ]
}
```

| Field | Required | Notes |
|-------|----------|-------|
| `results[].name` | yes | Test identifier (shown in the dashboard) |
| `metric.name` | yes | Unique within the test |
| `metric.value` | yes | A number, array of numbers, or `{"min":_, "avg":_, "max":_}` |
| `metric.units` | yes | e.g. `"s"`, `"MB"`, `"ops/sec"` |
| `metric.trend` | no | `"lower-is-better"` or `"higher-is-better"` |
| `metric.description` | no | Explanation of the metric |

To plot multiple metrics in the same graph, give them a common prefix separated by a slash (e.g. `"compile/parsing"`, `"compile/typing"`).

For the complete specification, see the [JSON format reference](https://github.com/ocurrent/current-bench/blob/main/doc/json_spec.md).

Here is a minimal benchmark that times a workload and prints the result as current-bench JSON:

```ocaml
let time f =
  let t = Unix.gettimeofday () in
  let _ = f () in
  Unix.gettimeofday () -. t

let () =
  let duration = time (fun () ->
    (* replace with your workload *)
    for _ = 1 to 1_000_000 do ignore (Sys.opaque_identity 42) done)
  in
  Printf.printf
    {|{"results": [{"name": "my-bench", "metrics": [
        {"name": "duration", "value": %f, "units": "s", "trend": "lower-is-better"}
      ]}]}|}
    duration
```

### Using the cobench Library

The [cobench](https://github.com/ocurrent/current-bench/tree/main/cobench) library handles timing (via [Bechamel](https://github.com/mirage/bechamel)) and JSON formatting for you. Add it to your dune file:

```
(executable
 (name my_bench)
 (libraries cobench))
```

Then write your benchmarks:

```ocaml
open Cobench

let test_fibo () =
  let rec fibonacci n =
    match n with 0 -> 0 | 1 -> 1 | n -> fibonacci (n - 1) + fibonacci (n - 2)
  in
  fibonacci 20

let () = bench ~quota:1.0 "my-suite" "fibonacci" test_fibo
```

`Cobench.bench` runs the function repeatedly for the given time quota, measures throughput, and prints the JSON to stdout. For more control, the library also provides `metric`, `of_metrics`, `of_results`, and `to_json` functions &mdash; see the [cobench interface](https://github.com/ocurrent/current-bench/blob/main/cobench/cobench.mli).

### Validating Output

Use `cb-check` to verify your JSON output before enrolling:

```
opam pin -n cb-check git+https://github.com/ocurrent/current-bench.git
opam install cb-check
```

Then pipe your benchmark output to it:

```
opam exec -- dune exec -- ./bench/main.exe | cb-check
```

## Setting Up current-bench

### Step 1: Create the Makefile Target

Your project needs a valid `.opam` file at the root and a `Makefile` with a `bench` target:

```makefile
bench:
	dune exec -- ./bench/main.exe
```

Make sure JSON goes to **stdout** and all logs go to **stderr** (redirect with `1>&2` if needed).

### Step 2: Install the GitHub App

Install [ocaml-benchmarks](https://github.com/marketplace/ocaml-benchmarks) from the GitHub Marketplace. Select **"Only select repositories"** and choose the repository you want to benchmark.

### Step 3: Get Approved

Enrollment is currently manual. Contact the current-bench maintainers (Tarides) to request approval. They will notify you once your repository is activated.

### Step 4: View Results

Once approved, benchmarks run automatically on PRs and pushes. Access your dashboard at `https://bench.ci.dev/<org>/<repo>`.

### Step 5: Custom Dockerfile (Optional)

If your project needs a specific OCaml version or system dependencies, create a `bench.Dockerfile` at the project root:

```dockerfile
FROM ocaml/opam:debian-ocaml-5.2
RUN sudo apt-get update && sudo apt-get install -y libev-dev
COPY --chown=opam . .
RUN opam install . --deps-only
```

When present, current-bench builds and runs benchmarks inside this container instead of using the default image. See [Using OCaml in Docker](/docs/ocaml-docker) for more on the `ocaml/opam` base images.

## Dashboard and PR Workflow

The dashboard at [bench.ci.dev](https://bench.ci.dev) shows time-series graphs for the main branch by default. Select a PR from the sidebar to see a comparison view: a table showing each metric's value on the PR branch versus the main branch, with percentage deltas to highlight regressions and improvements. The comparison is performed against the last commit of the PR.

By default, benchmarks run on every PR. Repositories can be configured to require a specific label (e.g. `run-benchmarks`) before triggering &mdash; contact the maintainers to set this up. When benchmarks are running, an `ocaml-benchmarks` check appears in the PR's check list on GitHub.

## Self-Hosting

The hosted instance at bench.ci.dev requires manual approval for each repository. If you need full control over configuration and enrollment, you can run your own current-bench instance.

A self-hosted deployment consists of six services managed by Docker Compose: the OCurrent pipeline, a PostgreSQL database, a Hasura GraphQL engine, the web frontend, an OCluster scheduler, and a worker that executes benchmarks in Docker containers.

### Quick Start

```sh
git clone https://github.com/ocurrent/current-bench.git
cd current-bench
cp environments/production.env.template environments/production.env
```

Edit `environments/production.env` to set your GitHub App credentials, database password, and public URLs. Then create `environments/production.conf` to declare the repositories you want to benchmark:

```json
{
  "repositories": [
    {
      "name": "your-org/your-repo",
      "worker": "autumn",
      "image": "ocaml/opam:debian-11-ocaml-4.14",
      "notify_github": true
    }
  ]
}
```

Start everything with:

```sh
make start-production
```

You will also need to [create a GitHub App](https://github.com/settings/apps/new) with read access to contents, write access to pull requests and statuses, and push/pull_request webhook events. The `OCAML_BENCH_GITHUB_ACCOUNT_ALLOW_LIST` environment variable controls which GitHub accounts can use your instance.

### Submitting Results via API

Instead of using the built-in worker, you can run benchmarks on your own infrastructure (e.g. GitHub Actions runners) and POST the results to your instance:

```sh
curl -X POST \
  -H 'Authorization: Bearer <token>' \
  https://your-server:8081/benchmarks/metrics \
  --data-raw '{
    "repo_owner": "your-org",
    "repo_name": "your-repo",
    "commit": "abc123...",
    "branch": "main",
    "run_at": "2024-01-15T12:00:00Z",
    "duration": "42.5",
    "benchmarks": [...]
  }'
```

API tokens are configured per-repository in `production.conf`. The `run_at` field must be RFC 3339, and either `branch` or `pull_number` must be provided.

For the complete self-hosting guide including GitHub App setup, worker configuration, and database migrations, see the [self-hosting documentation](https://github.com/ocurrent/current-bench/blob/main/doc/self_hosting.md).

## References

- [current-bench repository](https://github.com/ocurrent/current-bench)
- [JSON format specification](https://github.com/ocurrent/current-bench/blob/main/doc/json_spec.md)
- [User manual](https://github.com/ocurrent/current-bench/blob/main/doc/user_manual.md)
- [cobench library interface](https://github.com/ocurrent/current-bench/blob/main/cobench/cobench.mli)
- [Hardware tuning guide](https://github.com/ocurrent/current-bench/blob/main/doc/hardware_tuning.md)

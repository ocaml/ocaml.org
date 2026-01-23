---
id: "ocaml-ci"
title: "OCaml-CI"
short_title: "OCaml-CI"
description: |
   OCaml-CI is a continuous integration service specifically designed for OCaml projects hosted on GitHub (and GitLab).
category: "Additional Tooling"
---

## What is OCaml-CI?

OCaml-CI is a continuous integration service specifically designed for OCaml projects hosted on GitHub (and GitLab). It's built on the [OCurrent](https://github.com/ocurrent/ocurrent) pipeline framework and is hosted at [ocaml.ci.dev](https://ocaml.ci.dev).

## How It Works

OCaml-CI uses metadata from the project's `opam` and `dune` files to work out what to build, and it also uses caching to make builds fast. It takes the information in the project's `.opam` files to automatically test against multiple OCaml versions and OS platforms. This is the beauty of OCaml-CI &mdash; it leverages the existing OCaml ecosystem metadata rather than requiring yet another configuration format.

The pipeline operates as follows:

1. **Discovers installations** of the GitHub app
2. **Lists repositories** to check for each installation
3. **Identifies branches and PRs** to monitor
4. For each target, it fetches the head commit, generates a Dockerfile and builds it. The generated Dockerfile first adds all the `*.opam` files found in the project, then uses opam to install all the dependencies, then adds the rest of the source files.

This approach makes rebuilds fast because Docker reuses cached steps when opam files haven't changed.

## Setting Up OCaml-CI on a Project

### Step 1: Install the GitHub App

Add the app to your account by selecting **Configure** at [https://github.com/apps/ocaml-ci](https://github.com/apps/ocaml-ci), then select the GitHub account or organisation and click **Configure**.

### Step 2: Select Repositories

Select only the repositories you want tested (starting with no more than three please). If you select **All Repositories**, we won't be able to build anything!

### Step 3: Get Approved

You will need to be approved before it will start building anything. This is done by adding yourself to a list by submitting a PR to the [ocaml-ci](https://github.com/ocurrent/ocaml-ci) repository, specifically adding yourself to [`deploy-data/github-organisations.txt`](https://github.com/ocurrent/ocaml-ci/blob/master/deploy-data/github-organisations.txt).

### Step 4: Add a Status Badge (Optional)

Add this to your README:
```markdown
[![OCaml-CI Build Status](https://img.shields.io/endpoint?url=https://ocaml.ci.dev/badge/<user>/<repo>/<branch>&logo=ocaml)](https://ocaml.ci.dev/github/<user>/<repo>)
```

## Project Requirements

For OCaml-CI to work properly, your project needs:

- Valid `.opam` files describing your package dependencies
- A `dune-project` or `dune` files (recommended for proper metadata)

OCaml-CI will automatically determine which OCaml versions and platforms to test based on your opam file constraints.

## Testing Locally

You can test how OCaml-CI would build your project locally:

```bash
git clone --recursive https://github.com/ocurrent/ocaml-ci.git
cd ocaml-ci
opam install . --deps-only --with-test --yes
dune exec -- ocaml-ci-local /path/to/your/project
```

This runs a local web interface at `http://localhost:8080` showing how your project would be built.

## Key Features

- **Automatic multi-version testing**: Tests against multiple OCaml compiler versions
- **Multi-platform support**: Tests on different operating systems
- **Smart caching**: Docker layer caching makes rebuilds fast
- **Webhook integration**: Automatically rebuilds when opam-repository is updated
- **Remote API**: Cap'n Proto API for programmatic access and a CLI client

## The OCaml-CI CLI

The CLI allows you to interact with OCaml-CI programmatically &mdash; checking build status, viewing logs, cancelling or rebuilding jobs.

### Requirements

You need a **capability file** (`ocaml-ci.cap`) which grants access to the API. This file must be provided to you by the OCaml-CI administrators.

### Installation & Usage

You can run it via dune:
```bash
dune exec -- ocaml-ci --ci-cap=ocaml-ci.cap ...
```

Or install it as `ocaml-ci`.

### Example Commands

**List branches and PRs for a repository:**
```bash
$ ocaml-ci mirage/irmin
615364620f4233cb82a96144824eb6ad5d1104f0 refs/heads/1.4 (passed)
e0fcf0d336544650ca5237b356cfce4a48378245 refs/heads/master (passed)
6c46d1de5e67a3f504fc55af1d644d852c946533 refs/heads/mirage-dev (passed)
28421a152e8e19b3fb5048670629e7e01d0fbea6 refs/pull/523/head (passed)
...
b2d4b06f94d13384ae08eb06439ce9c6066419cd refs/pull/815/head (failed)
```

**List build variants for a specific ref:**
```bash
$ ocaml-ci mirage/irmin refs/heads/main
alpine-3.10-ocaml-4.08
```

**View the build log (follows if still running):**
```bash
$ ocaml-ci mirage/irmin refs/heads/master alpine-3.10-ocaml-4.08 log
[...]
- Test Successful in 17.643s. 99 tests run.
-> compiled  irmin-unix.dev
-> installed irmin-unix.dev
Done.
2019-09-25 14:55.57: Job succeeded
```

**Other actions:**
- `cancel` - Cancel a running build
- `rebuild` - Trigger a rebuild
- `status` - Check build status

### Shorthand Syntax

For convenience:
- You can omit `refs/` from references (e.g., `heads/master` instead of `refs/heads/master`)
- For PRs, you can omit `/head` (e.g., `pull/867` instead of `refs/pull/867/head`)
- For commits, provide at least 6 characters

Example:
```bash
$ ocaml-ci mirage/irmin pull/867 alpine-3.10-ocaml-4.08 cancel
```

## Main Sources of OCaml-CI Documentation

1. **Getting Started page**: [https://ocaml.ci.dev/getting-started](https://ocaml.ci.dev/getting-started)
   - Very brief, covers only the basic setup steps

2. **GitHub README**: [https://github.com/ocurrent/ocaml-ci](https://github.com/ocurrent/ocaml-ci)
   - The most comprehensive source
   - Covers how the pipeline works, installation, setup, CLI usage, and deployment
   - This is where most of the technical details in my first answer came from

3. **Tarides Blog Post**: [https://tarides.com/blog/2023-07-12-ocaml-ci-renovated/](https://tarides.com/blog/2023-07-12-ocaml-ci-renovated/)
   - Covers the value proposition, experimental builds, lower-bounds testing, and the 2022 UI renovation
   - Good overview of features but not a step-by-step guide

4. **OCaml Discuss thread**: [Best practices for CI in 2023](https://discuss.ocaml.org/t/best-practices-for-continuous-integration-ci-in-2023/12380)
   - Community discussion with practical tips

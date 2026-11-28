# Deployment and Infrastructure

This page describes everything a page on ocaml.org depends on: the repositories, the CI jobs, the build and deploy services, the hosts, and the backends the running server and the visitor's browser call. It also lists where other documentation disagrees with what runs, and where a change tends to get stuck on its way to production.

Facts here drift. Each statement names the file or service that settles it; when they disagree, trust that source, not this page. The deploy and hosting details were checked against live DNS, [`ocurrent/ocurrent-deployer`](https://github.com/ocurrent/ocurrent-deployer) (branch `live-ocaml-org`), [`mtelvers/ansible`](https://github.com/mtelvers/ansible), and [`ocaml/infrastructure`](https://github.com/ocaml/infrastructure) in November 2026.

## Three Loops

Everything below belongs to one of three loops, which run at different speeds. Telling them apart answers most "why isn't my change live?" questions.

* **Deploy loop** (per merge, minutes). A push to `main` or `staging` reaches the deployer by webhook. OCluster builds the [`Dockerfile`](../Dockerfile), with `data/`, the playground, and the compiler manuals inside, and pushes the image to Docker Hub as `:live` or `:staging`. The deployer then updates the swarm services over SSH, and production bans its Varnish cache. This loop carries code, `data/` content, the playground pin, and the manuals (as of the build).
* **Content loop** (daily, hours to days). Scheduled GitHub Actions scrape blog feeds, videos, platform tool releases, and check.ci.ocaml.org. Each opens a bot pull request (`bot/planet`, `bot/platform`, `bot/opam-health`). Nothing scraped reaches the site until a maintainer merges that pull request, after which the deploy loop takes over. The doc-modules scraper is the exception: it publishes the module paths of package documentation as assets of the `doc-modules-latest` release, with no pull request and no file in git.
* **Runtime loop** (continuous, at most an hour). Each server container pulls opam-repository every hour (`OCAMLORG_OPAM_POLLING`) and rebuilds the package state; a failed run keeps the old state. Package documentation is fetched from dill on a cache miss, and browsers load the analytics script from plausible.ci.dev. Package pages and documentation therefore change with no commit to this repository.

## Repositories

Several repositories control what is served, each one a different layer. Before proposing a change, find the layer it belongs to: a pull request in the wrong repository will build fine and change nothing.

| Repository | Controls | Takes effect when |
| ---------- | -------- | ----------------- |
| [`ocaml/ocaml.org`](https://github.com/ocaml/ocaml.org) | Server code, `data/`, the `Dockerfile` and the `ENV` defaults baked into the image, all GitHub Actions, and the `playground-*`, `scraper-latest`, and `doc-modules-latest` releases | Merged to `main` (or pushed to `staging`) |
| [`ocaml/opam-repository`](https://github.com/ocaml/opam-repository) | The build dependencies, at the [pinned commit](../HACKING.md#managing-dependencies), and every package page, from `master` (every package, every version) | Within the hour, with no deploy |
| [`ocaml-web/html-compiler-manuals`](https://github.com/ocaml-web/html-compiler-manuals) | The `/manual` pages, all versions | The next image build of ocaml.org |
| [`ocurrent/ocaml-docs-ci`](https://github.com/ocurrent/ocaml-docs-ci) | Package documentation on dill | When docs-ci rebuilds; no deploy |
| [`ocurrent/opam-health-check`](https://github.com/ocurrent/opam-health-check) | Build-health data shown on package pages | After the next scrape pull request is merged |
| [`ocurrent/ocurrent-deployer`](https://github.com/ocurrent/ocurrent-deployer) | Which branch builds which image and deploys to which host and service (`src/pipeline.ml`, module `Ocaml_org`) | Once the change reaches the `live-ocaml-org` branch |
| [`mtelvers/ansible`](https://github.com/mtelvers/ansible) | The swarm stacks on each host: Hitch, Varnish and its VCL, Caddy for staging, per-service `environment:` overrides, and the deployer's own stack (`www.ocaml.org.yml`, `staging.ocaml.org.yml`, `deploy.ci.ocaml.org.yml`) | When the playbook is re-run |
| [`ocaml/infrastructure`](https://github.com/ocaml/infrastructure) | The [infra.ocaml.org](https://infra.ocaml.org/) wiki: machine inventory and how-to pages | Never: it is documentation only, nothing reads it, and it can drift (see [Where Other Documentation Is Wrong](#where-other-documentation-is-wrong)) |

## Build and Deploy

The deployer behind [deploy.ci.ocaml.org](https://deploy.ci.ocaml.org/?repo=ocaml/ocaml.org) is an OCurrent pipeline, [`ocurrent-deployer`](https://github.com/ocurrent/ocurrent-deployer). It runs on `ci5.ocamllabs.io`, a Scaleway VM, and redeploys itself from the `live-ocaml-org` branch of its repository, not from its default branch. It builds pushes to `main` and `staging` and the heads of pull requests, and deploys `main` and `staging`:

| Branch | Image | Host | Services | Serves |
| ------ | ----- | ---- | -------- | ------ |
| `main` | `ocurrent/v3.ocaml.org-server:live` | `v3b.ocaml.org` | `infra_www1`, `infra_www2` | <https://ocaml.org/> |
| `staging` | `ocurrent/v3.ocaml.org-server:staging` | `v3c.ocaml.org` | `infra_www` | <https://staging.ocaml.org/> |
| Pull request heads | none | none | none | nothing: build only |

A push goes through these steps:

1. The push reaches the deployer through its GitHub App, `deploy-ci-ocaml-org`. The `Ocaml_org` module of [`src/pipeline.ml`](https://github.com/ocurrent/ocurrent-deployer/blob/master/src/pipeline.ml) maps the branch to an image tag and target services.
2. The deployer submits the root `Dockerfile` to a worker of the OCluster `linux-x86_64` pool; the build doesn't run on `ci5`. The image is built on Alpine 3.24 with OCaml 5.5, in this order:
   1. the opam dependencies, at the pinned opam-repository commit, with `opam.ocaml.org/cache` as archive mirror;
   2. the playground assets, downloaded from the release pinned in `playground/release`;
   3. the server, with `data/` compiled in;
   4. the package state, from opam-repository `master`: the build runs the package-state builder, and if it exits non-zero, the image build fails and nothing deploys;
   5. a clone of `html-compiler-manuals`, served as the manuals.
3. For a pull request, the deployer stops here and reports the result to GitHub as the `deployability` check run. Nothing is pushed or deployed.
4. For `main` or `staging`, the worker pushes to `ocurrentbuilder/staging`, and the deployer then publishes the manifest as `ocurrent/v3.ocaml.org-server:live` or `:staging` on [Docker Hub](https://hub.docker.com/r/ocurrent/v3.ocaml.org-server).
5. Over an SSH Docker context, the deployer makes the target host pull the image and runs a swarm service update (`docker service update --image`) on `infra_www1` and `infra_www2` (v3b) or `infra_www` (v3c). Both hosts run Docker in swarm mode, and an Ansible playbook creates the `infra` stack, hence the `infra_` prefix. There is no approval step: the deployer's confirmation level is released automatically 120 seconds after it starts.
6. The deployer posts the deploy's status to Slack, in the ocamllabs workspace, as `Deploy <commit> as <service>: <state>`. The webhook URL is a private Ansible secret (`deployer-slack`).
7. On v3b, a host-side `monitor` timer notices the new containers, reloads the Varnish VCL, and bans the cache, so the new version shows at once.

Once running, each container runs the package-state builder again every hour (`OCAMLORG_OPAM_POLLING`, 3600 seconds): it pulls opam-repository into the container and swaps in the new `package.state`. If that run fails, the server keeps the previous state. See [Package Metadata and State](../HACKING.md#package-metadata-and-state).

## Serving

Production and staging have different front ends.

### Production: `v3b.ocaml.org`

The swarm stack `infra` is defined in [`www.ocaml.org.yml`](https://github.com/mtelvers/ansible/blob/master/www.ocaml.org.yml). Its services are `hitch`, `varnish`, `nginx`, `www1`, and `www2`:

* **Hitch** terminates TLS, on port 443 only, with certificates from certbot. It forwards to Varnish over the PROXY protocol.
* **Varnish** has a 2 GB cache and a VCL defined in the Ansible file. It takes the real client IP from the PROXY header and appends it to `X-Forwarded-For`. Plain HTTP on port 80 goes straight to Varnish, which answers with a 301 to HTTPS. Varnish also answers every host other than `ocaml.org` (`www`, `v3`, `v3b`) with a 301 to `https://ocaml.org`.
* **`www1` and `www2`** are two Dream replicas, listening on port 8080, between which Varnish balances requests round-robin, with health probes. They share no caches and no rate-limit tables. The `/mcp` endpoint is enabled in the image (`OCAMLORG_MCP_ENABLED=true`).
* **`nginx`** serves only ACME challenges.
* The host's **`monitor` timer** reloads the VCL and bans the cache after each deploy, and reloads Hitch when the certificates are renewed.

### Staging: `v3c.ocaml.org`

The stack is defined in [`staging.ocaml.org.yml`](https://github.com/mtelvers/ansible/blob/master/staging.ocaml.org.yml). Caddy terminates TLS and caches responses for 240 seconds (with the `shonfeder/caddy-cache-handler` module), then proxies to a single Dream container, `www`, on port 8080. There is no Hitch and no Varnish.

Because of these differences, anything that depends on edge caching (Varnish grace, weak ETags, cookies, POST pass-through) or on header handling can't be checked on staging, and a single replica hides problems that only show with two.

### Calls Made by the Server and the Browser

On a cache miss, every Dream container fetches package documentation over HTTPS from `dill.caelum.ci.dev` ([External Services](../HACKING.md#external-services)); the documentation is never baked into the image. Visitors' browsers load the analytics script from `plausible.ci.dev` (see `src/ocamlorg_frontend/layouts/layout.eml`). MCP clients, such as AI coding agents, reach `/mcp` over the same HTTPS front end as browsers.

## GitHub Actions

All workflows live in [`.github/workflows/`](../.github/workflows/). None of them deploys: the only deploy trigger is a push to `main` or `staging`, seen by the deployer, and the deployer's `deployability` check is the only one that builds the production image.

| Workflow | Runs on | What it does | Produces |
| -------- | ------- | ------------ | -------- |
| `ci.yml` | Pull requests to `main`, pushes to `main`, Mondays 01:00 UTC, manual | `make`, `make test`, and `make fmt` on Ubuntu and macOS, with OCaml 5.5.2 and opam-repository at the pin | Check status |
| `markdown-lint.yml` | Every push and pull request | `markdownlint-cli2`, excluding `data/planet/` and `data/changelog/` | Check status |
| `playground.yml` | Pull requests and pushes that touch `playground/` | Builds the playground from source (with the `merlin-js` submodule) and runs its smoke test | Check status |
| `devcontainer.yml` | Changes to `.devcontainer/` or `ocamlorg.opam` | Builds the development image, tagged by a hash of its inputs | `ghcr.io/ocaml/ocaml.org-dev`, and `:main` from `main` |
| `debug-ci.yml` | Manual only | The CI steps, run with `dune` directly | Nothing |
| `release-playground.yml` | Pushes to `main` that touch `playground/` | Builds and smoke-tests the assets, publishes them, and tests the server with them | Release `playground-<compiler>-<commit>`, and a pull request "playground: assets \<tag\>" updating `playground/release` |
| `release-scraper.yml` | Pushes to `main` that touch `tool/`, `src/`, or opam files | Builds `tool/data-scrape` and `tool/doc-modules`, then deletes and recreates the release | Release `scraper-latest`, holding `scrape.exe` and `doc_modules.exe` |
| `sync-attribution.yml` | Pushes to `main` that touch tutorials or tool pages | Folds the "Authors and history" records forward to the new commit | Rolling pull request on `bot/attribution` updating `data/attribution.jsonl` (other pull requests never edit it) |
| `scrape-planet.yml` | Daily, 05:36 UTC | Fetches the feeds listed in `data/planet-sources.yml`, the YouTube channel feeds, and watch.ocaml.org (PeerTube API) | Pull request on `bot/planet`: `data/planet/`, `data/video-watch.yml`, `data/video-youtube.yml` |
| `scrape-platform-releases.yml` | Daily, 05:36 UTC | Reads the GitHub releases of the platform tools (dune, opam, Merlin, odoc, OCamlFormat, ppxlib, …) | Pull request on `bot/platform`: `data/platform_releases/` |
| `scrape-opam-health.yml` | Daily, 12:00 UTC | Reads the latest check.ci.ocaml.org run; stops after about 10 KB if that run is already committed | Pull request on `bot/opam-health`: `data/opam_health.yml` |
| `scrape-doc-modules.yml` | Hourly at :17, scraping only when its polling policy says so (every 1 to 24 hours, learned from how often dill regenerates docs); manual, with an optional `reset` | Reads every package's `sidebar.json` from dill, with ETag revalidation, at most 8 requests per second; keeps its state in an Actions cache | Release `doc-modules-latest`: `doc-modules.jsonl.gz`, the index `doc-modules-v1.idx` (replaced only when it changes), and `stats.jsonl` |

The scrapers download their binary (`scrape.exe`, or `doc_modules.exe` for doc-modules) from the `scraper-latest` release instead of compiling it, so a change to a scraper takes effect only once `release-scraper.yml` has run on `main`. The three content scrapers open a pull request only when something changed. They never write to `main`: once a maintainer merges their pull request, the change takes the same path to production as any other commit. The doc-modules scraper writes only to its release, replacing assets without ever deleting the only copy (`tool/doc-modules/release-assets.sh`).

Known limitation: `scraper-latest` can't be downloaded while `release-scraper.yml` republishes it, between deleting the old release and publishing the new one. That took 5 to 9 seconds on recent runs. If the publish fails after the delete, the release stays missing, and every scraper fails, until the next successful run. The content scrapers try once; the doc-modules scraper retries for about five minutes. [#4065](https://github.com/ocaml/ocaml.org/issues/4065) proposes publishing to two alternating releases instead (blue/green).

## External Services

| Service | Run by | Used for | If it is down |
| ------- | ------ | -------- | ------------- |
| deploy.ci.ocaml.org | `ocurrent-deployer` on `ci5` | Builds every push to `main` and `staging` and the heads of pull requests; deploys `main` and `staging` | No deploys; the site keeps running the last image |
| OCluster | OCurrent build cluster | The Docker build itself | Builds queue; no deploys |
| Docker Hub | `ocurrent/v3.ocaml.org-server` | Carries the image from the builder to the host | No deploys |
| dill.caelum.ci.dev | `ocurrent/ocaml-docs-ci` | Package documentation under `/p/<package>/<version>/doc/` and its build status (`OCAMLORG_DOC_URL`, `OCAMLORG_DOC_STATUS_URL`); every package's `sidebar.json`, for the doc-modules scraper | Documentation pages that aren't cached fail; the rest of the site works. A doc-modules scrape aborts, recording its stats, and the published index stays as it was |
| github.com/ocaml/opam-repository | opam-repository maintainers | Package state, at image build and every hour in each container | Image builds fail; running servers keep their last package state |
| check.ci.ocaml.org | `ocurrent/opam-health-check` | Build results per compiler, about weekly (Mondays), shown on package pages through `data/opam_health.yml`; read by the scraper, not at runtime | No new pull request; the site shows the last merged results |
| watch.ocaml.org | PeerTube, a separate service deployed by the same deployer | Video listings, scraped daily | The video list goes stale |
| Blog and YouTube feeds | Their authors | OCaml Planet, scraped daily | That source goes stale; the scraper reports it |
| plausible.ci.dev | ci.dev infrastructure | Page analytics, loaded by the browser | No analytics; pages are unaffected |
| opam.ocaml.org/cache | opam infrastructure | Archive mirror for the image's `opam install` | Matters only if a package's own source is also down |
| GitHub releases | `ocaml/ocaml.org` Actions | The playground tarball (pinned by SHA-256), the scraper binaries, and the doc-modules assets | Image and CI builds can't fetch the playground; scrapers don't run |
| ghcr.io | `ocaml/ocaml.org` Actions | The development image, `ocaml/ocaml.org-dev` ([Devcontainer and Cloud Sessions](../HACKING.md#devcontainer-and-cloud-sessions)) | Devcontainers and cloud sessions can't pull the image |
| Slack (ocamllabs workspace) | The deployer's webhook | Deploy notices | Deploys happen silently |

## Where Other Documentation Is Wrong

These rows were checked against live DNS, the deployer's `pipeline.ml`, and the Ansible stack definitions.

| Where | What it says | What is true | Evidence |
| ----- | ------------ | ------------ | -------- |
| Infra wiki, [`_machines/v3b.md`](https://github.com/ocaml/infrastructure/blob/master/_machines/v3b.md) | Notes: `staging.ocaml.org` | v3b serves `ocaml.org` and redirects `www.ocaml.org` to it | DNS A records; `infra_www1` and `infra_www2` on v3b in `pipeline.ml` |
| Infra wiki, [`_machines/v3c.md`](https://github.com/ocaml/infrastructure/blob/master/_machines/v3c.md) | Notes: `www.ocaml.org` | v3c serves `staging.ocaml.org` | DNS A record; `infra_www` on v3c in `pipeline.ml` |
| Infra wiki, [OCaml.org Deployment](https://infra.ocaml.org/www-ocaml-org.html) | Production is fronted by Caddy, from a sample `Caddyfile` and playbook | Production has no Caddy: Hitch terminates TLS, and Varnish caches and routes | `www.ocaml.org.yml` services: `hitch`, `varnish`, `nginx`, `www1`, `www2` |
| Infra wiki, [OCaml.org Deployment](https://infra.ocaml.org/www-ocaml-org.html) | One `www` service | Two replicas, `www1` and `www2`, with no shared caches or rate-limit tables | `pipeline.ml`; the Ansible stack |
| Infra wiki, IPv6 paragraph | Describes IPv6 handling for the swarm | `ocaml.org` and `www.ocaml.org` have no AAAA record, though `v3b` itself has one; `staging.ocaml.org` has one, but it differs from `v3c`'s | `dig AAAA` |

Two similar names are also worth keeping apart: deploy.ci.dev and deploy.ci.ocaml.org are different deployers. deploy.ci.dev moved to Cambridge in April 2026, while deploy.ci.ocaml.org is still on `ci5`, at Scaleway.

## Staging Outage

As of November 2026, `staging.ocaml.org` has been down since June 2025, while production on v3b is unaffected. The last successful staging deploy was on 2025-06-11 at 15:16 UTC, and the Wayback Machine last captured `staging.ocaml.org` on 2025-06-19 at 03:58 UTC. The next deploy, on 2025-06-20 at 09:47 UTC, failed at the SSH step:

```text
ssh: connect to host v3c.ocaml.org port 22: Cannot assign requested address
```

Every staging deploy since has failed the same way (2025-06-20, 2025-07-04, 2025-10-22, and 2026-11-02), `staging.ocaml.org` times out, and the deployer's front page shows red. Since the `staging` branch is pushed rarely, this went unnoticed. Fixing it is a host-side job for the infrastructure maintainers. See [`FOR_MAINTAINERS.md`](FOR_MAINTAINERS.md#how-we-maintain-the-staging-branch) for how the branch itself is maintained.

## Where a Change Gets Stuck

| Symptom | Cause | What to do |
| ------- | ----- | ---------- |
| A pull request shows a red `deployability` check with no code at fault | The image build pulls opam-repository `master` and runs the package-state builder, so an upstream package change can fail it | Read the build log on [deploy.ci.ocaml.org](https://deploy.ci.ocaml.org/?repo=ocaml/ocaml.org-builds) |
| A pull request was merged while checks were pending | No check is required on `main`: neither `deployability` nor the GitHub Actions builds | Wait for `deployability` before merging changes other than documentation |
| New opam packages don't appear on ocaml.org | The hourly in-container builder failed, timed out, or was killed; the server keeps serving the previous package state | Check the `www1` and `www2` container logs on v3b; a redeploy restarts from the state baked into the image |
| Staging deploys fail, and the deployer's front page is red | v3c is unreachable (see [Staging Outage](#staging-outage)). Red can also come from other services in the same pipeline, such as the weekly PeerTube pull for watch.ocaml.org | Look at which job failed on deploy.ci.ocaml.org; host problems go to the infrastructure maintainers |
| A merged deployer change has no effect | The deployer runs from `live-ocaml-org`, not `master` | Make sure the change reaches `live-ocaml-org` |
| A new `OCAMLORG_*` setting is ignored in production | It is neither in the image's `ENV` nor in the Ansible `environment:` block, or the playbook hasn't been re-run | Bake it into the `Dockerfile`, or open a pull request on `mtelvers/ansible` and ask for a playbook run |
| Behaviour differs between staging and production | Caddy cache (staging) versus Varnish (production); one replica versus two | Test edge-cache behaviour against production headers, not staging |
| A VCL change is merged but not live | The VCL is part of the Ansible stack, not the image | It needs a playbook re-run on v3b |
| A scraper workflow fails at its download step | `scraper-latest` was being republished, or a failed `release-scraper.yml` run left it missing ([#4065](https://github.com/ocaml/ocaml.org/issues/4065)) | Rerun the scraper; if the release is missing, run `release-scraper.yml` manually |
| A merged change to a scraper has no effect | The scrapers run the binary from `scraper-latest`, rebuilt by `release-scraper.yml` after the merge | Check that `release-scraper.yml` succeeded for that commit |
| The doc-modules scraper keeps aborting after opam-repository removed many packages | Packages that lose their docs or disappear count as losses, and above 10% the scrape aborts, as for a backend failure. Without a scrape state (cache evicted, `STATE_KEY` bumped), losses count against the published index | If the removal is genuine, run `scrape-doc-modules.yml` manually with `reset`, which also drops the published index as the reference |
| The doc-modules scraper aborts with "packages failed in a row" | The documentation backend failed 20 packages in a row (5xx, 429, timeouts), so the scrape stopped asking | Nothing to do if the backend recovers: the next due run retries. Check the backend otherwise |
| `doc-modules-v1.idx` or another doc-modules asset answers 404 | A replacement was interrupted after deleting the old asset, and its rename failed even after retries | Every hourly run of `scrape-doc-modules.yml` finishes interrupted replacements first; run it manually to do so at once |

## Planned Changes

These would change the picture above once merged:

* [#3981](https://github.com/ocaml/ocaml.org/pull/3981) (doc-modules search): the servers fetch the index published by `scrape-doc-modules.yml` and use it for package search.
* [#4065](https://github.com/ocaml/ocaml.org/issues/4065): `scraper-latest` becomes two alternating releases, so that a rebuild never leaves the scrapers without a binary.
* [#3984](https://github.com/ocaml/ocaml.org/pull/3984): the image moves from Alpine 3.24 to Debian 13.
* [#3909](https://github.com/ocaml/ocaml.org/issues/3909) (RFC): the compiler manuals gain a CI-built odoc and sherlodoc artefact.

## Sources

* [`ocurrent-deployer`](https://github.com/ocurrent/ocurrent-deployer): `src/pipeline.ml` (`Ocaml_org`), `src/build.ml` (the `deployability` check), `src/cluster.ml` (build, push, service update), `README.md` (the `live-ocaml-org` branch), `doc/services.md`
* [`mtelvers/ansible`](https://github.com/mtelvers/ansible): `www.ocaml.org.yml`, `staging.ocaml.org.yml`, `deploy.ci.ocaml.org.yml`
* [infra.ocaml.org: OCaml.org Deployment](https://infra.ocaml.org/www-ocaml-org.html) and the [machine pages](https://github.com/ocaml/infrastructure/tree/master/_machines)
* [deploy.ci.ocaml.org](https://deploy.ci.ocaml.org/?repo=ocaml/ocaml.org), for the live pipeline state
* This repository: `.github/workflows/*.yml`, `Dockerfile`, [`HACKING.md`](../HACKING.md), `src/ocamlorg_web/lib/config.ml`, `src/ocamlorg_package/lib/config.ml`, `src/ocamlorg_frontend/layouts/layout.eml`, `tool/data-scrape/`, `tool/doc-modules/`

.DEFAULT_GOAL := all

.PHONY: help
help: ## Show this help message (list common targets)
	@awk 'BEGIN {FS = ":.*## "; printf "Run a target with: make <target>\n\nCommon targets:\n"} /^[a-zA-Z_-]+:.*## / {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: all
all: ## Build the project (default target)
	opam exec -- dune build --root .

.PHONY: deps
deps: create_switch ## Install development dependencies
	opam install -y ocamlformat=0.29.0 ocaml-lsp-server
	opam install -y --deps-only --with-test --with-doc .

# Package(s) defining the switch invariant (the compiler). Override to add a
# compiler variant — e.g. frame pointers, so `perf`/flame graphs can unwind the
# OCaml stack when profiling the server:
#   make switch SWITCH_PACKAGES="ocaml.5.5.1,ocaml-option-fp"
# (or just `make switch_fp`). Frame pointers cost a register (~1-3%), so they
# are opt-in and deliberately not the default — CI and the Dockerfile build
# without them.
SWITCH_PACKAGES ?= ocaml.5.5.1

.PHONY: create_switch
create_switch: ## Create switch and pinned opam repo
	opam switch create . --no-install --packages=$(SWITCH_PACKAGES) --repos pin=git+https://github.com/ocaml/opam-repository#8cdfa3296d9bc7d93273f46eb2438757e4fd5cf0

.PHONY: switch
switch: deps ## Create an opam switch and install development dependencies

.PHONY: switch_fp
switch_fp: ## Like `switch`, but with frame pointers (for profiling)
	$(MAKE) switch SWITCH_PACKAGES="ocaml.5.5.1,ocaml-option-fp"

.PHONY: lock
lock: ## Generate a lock file
	opam lock -y .

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	opam exec -- dune build --root .

.PHONY: playground
playground: ## Build the OCaml Playground
	make build -C playground

.PHONY: install
install: all ## Install the packages on the system
	opam exec -- dune install --root .

.PHONY: start
start: all ## Run the produced executable
	opam exec -- dune exec src/ocamlorg_web/bin/main.exe

.PHONY: test
test: ## Run the unit tests
	opam exec -- dune build --root . @runtest

.PHONY: test_code_examples
test_code_examples: ## Checks exercices and tutorials code blocks
	opam exec -- dune runtest data

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	opam exec -- dune clean --root .

.PHONY: doc
doc: ## Generate odoc documentation
	opam exec -- dune build --root . @doc

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	opam exec -- dune build --root . --auto-promote @fmt

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	opam exec -- dune build @run -w --force --no-buffer

.PHONY: utop
utop: ## Run a REPL and link with the project's libraries
	opam exec -- dune utop --root . . -- -implicit-bindings

SCRAPE ?= opam exec -- dune exec --root . tool/data-scrape/bin/scrape.exe --

.PHONY: scrape_ocaml_planet
scrape_ocaml_planet:
	$(SCRAPE) planet $(if $(COMMIT_FILE),--commit-file $(COMMIT_FILE)) \
	                 $(if $(REPORT_FILE),--report-file $(REPORT_FILE))
	$(SCRAPE) video $(if $(COMMIT_FILE),--commit-file $(COMMIT_FILE)) \
	                $(if $(REPORT_FILE),--report-file $(REPORT_FILE))

.PHONY: scrape_platform_releases
scrape_platform_releases:
	$(SCRAPE) platform_releases

.PHONY: docker
docker: ## Generate docker container
	docker build -f Dockerfile . -t ocamlorg:latest

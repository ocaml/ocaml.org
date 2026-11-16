# The OCaml version the playground runs. This is the only place it is set:
# the CI workflow reads it from here, and the opam solver checks that the
# playground's dependencies (js_of_ocaml-toplevel, merlin-lib) support it.
COMPILER=5.5.2

# Same opam-repository commit as the server (see the root Makefile).
OPAM_REPO=git+https://github.com/ocaml/opam-repository\#ca403de684b07caee6f246b36a2f3a1787d780ac

# The playground has its own local switch, separate from the server's. Name it
# explicitly: an OPAMSWITCH or OPAM_SWITCH_PREFIX inherited from the
# environment would otherwise take precedence over the local switch.
SWITCH ?= --switch=$(CURDIR)

.PHONY: create_switch
create_switch: ## Create switch
	opam switch create . $(COMPILER) --no-install --repos pin=$(OPAM_REPO)

.PHONY: deps
deps: create_switch ## Install development dependencies
	opam install $(SWITCH) . --deps-only -y
	$(MAKE) toplevel-client

# js_of_ocaml-toplevel builds its worker_lwt_client library only if lwt and
# js_of_ocaml-ppx are installed first, but it does not depend on js_of_ocaml-ppx,
# so opam may build the two in parallel and silently skip the library.
# Reinstall js_of_ocaml-toplevel when that happened. CI, which uses the
# setup-ocaml switch, runs this with SWITCH= (the current switch).
.PHONY: toplevel-client
toplevel-client:
	opam exec $(SWITCH) -- ocamlfind query js_of_ocaml-toplevel.worker_lwt_client >/dev/null 2>&1 \
	  || opam reinstall $(SWITCH) -y js_of_ocaml-toplevel

.PHONY: switch
switch: deps ## Create an opam switch and install development dependencies

.PHONY: build
build:
	opam exec $(SWITCH) -- dune build --root . --profile=release

.PHONY: smoke
smoke: ## Run the headless-browser smoke test against asset/
	cd test && npm ci --no-audit --no-fund && node smoke.mjs

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	opam exec $(SWITCH) -- dune build --root . --auto-promote @fmt

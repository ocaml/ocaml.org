.DEFAULT_GOAL := all

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

# Dependencies used in development, for ood-gen in particular
DEV_DEPS := \
"yaml>=3.0" \
ppx_deriving_yaml \
ezjsonm \
ptime \
fmt \
fpath \
piaf \
lambdasoup \
cmdliner \
crunch \
ppx_deriving_yaml \
"omd>=2.0.0~alpha2" \
xmlm \
uri

.PHONY: all
all:
	opam exec -- dune build --root .

.PHONY: deps
deps: ## Install development dependencies
	opam install -y dune-release ocamlformat utop ocaml-lsp-server $(DEV_DEPS)
	npm install
	opam install --deps-only --with-test --with-doc -y .

.PHONY: create_switch
create_switch:
	opam switch create . 4.12.0 --no-install

.PHONY: switch
switch: create_switch deps ## Create an opam switch and install development dependencies

.PHONY: lock
lock: ## Generate a lock file
	opam lock -y .

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	opam exec -- dune build --root .

.PHONY: install
install: all ## Install the packages on the system
	opam exec -- dune install --root .

.PHONY: start
start: all ## Run the produced executable
	opam exec -- dune exec --root . src/ocamlorg_web/bin/main.exe -- -vv $(ARGS)

.PHONY: test
test: ## Run the unit tests
	opam exec -- dune build --root . @test/runtest -f

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
	opam exec -- script/watch.sh

.PHONY: utop
utop: ## Run a REPL and link with the project's libraries
	opam exec -- dune utop --root . . -- -implicit-bindings

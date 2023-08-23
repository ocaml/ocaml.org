COMPILER=5.0.0

.PHONY: create_switch
create_switch: ## Create switch
	opam switch create . $(COMPILER) --no-install

.PHONY: deps
deps: create_switch ## Install development dependencies
	opam install . --deps-only -y

.PHONY: switch
switch: deps ## Create an opam switch and install development dependencies

.PHONY: build
build:
	opam exec -- dune build --root .

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	opam exec -- dune build --root . --auto-promote @fmt

COMPILER=5.0.0

dune.lock: ## Generate dune.lock directory
	dune pkg lock --workspace dune-workspace --root .

.PHONY: build
build: dune.lock
	dune build --root .

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	dune build --root . --auto-promote @fmt

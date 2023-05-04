.PHONY: create_switch
create_switch: ## Create switch and pinned opam repo
	opam switch create 5.0.0 5.0.0 --no-install

.PHONY: deps
deps: create_switch ## Install development dependencies
	opam install . --deps-only --switch=5.0.0

.PHONY: build
build:
	opam exec --switch=5.0.0 -- dune build --root .

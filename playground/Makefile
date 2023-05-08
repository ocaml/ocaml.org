COMPILER=5.0.0
SWITCH=playground

.PHONY: create_switch
create_switch: ## Create switch and pinned opam repo
	opam switch create $(SWITCH) $(COMPILER) --no-install

.PHONY: deps
deps: create_switch ## Install development dependencies
	opam install . --deps-only --switch=$(SWITCH)

.PHONY: build
build:
	opam exec --switch=$(SWITCH) -- dune build --root .

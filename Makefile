.DEFAULT_GOAL := all

.PHONY: all
all: dune.lock
	dune build --root .

dune.lock: ## Generate a lock file
	dune pkg lock

.PHONY: build
build: dune.lock ## Build the project, including non installable libraries and executables
	dune build --root .

.PHONY: playground
playground:
	make build -C playground

.PHONY: install
install: all ## Install the packages on the system
	dune install --root .

.PHONY: start
start: all ## Run the produced executable
	dune exec src/ocamlorg_web/bin/main.exe

.PHONY: test
test: ## Run the unit tests
	dune build --root . @runtest

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	dune clean --root .

.PHONY: doc
doc: ## Generate odoc documentation
	dune build --root . @doc

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	dune build --root . --auto-promote @fmt

.PHONY: watch
watch: dune.lock ## Watch for the filesystem and rebuild on every change
	dune build @run -w --force --no-buffer

.PHONY: utop
utop: ## Run a REPL and link with the project's libraries
	dune utop --root . . -- -implicit-bindings

.PHONY: scrape_ocaml_planet
scrape_ocaml_planet: dune.lock ## Generate the po files
	dune build --root . tool/ood-gen/bin/scrape.exe
	dune exec --root . tool/ood-gen/bin/scrape.exe planet
	dune exec --root . tool/ood-gen/bin/scrape.exe video

.PHONY: scrape_changelog
scrape_changelog:
	opam exec -- dune exec --root . tool/ood-gen/bin/scrape.exe platform_releases

.PHONY: docker
docker: ## Generate docker container
	docker build -f Dockerfile . -t ocamlorg:latest

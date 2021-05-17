SHELL=/bin/bash
NVM=source $$NVM_DIR/nvm.sh && nvm
YARN=$(NVM) use && npx yarn@1.22
ESY=$(NVM) use && npx esy@0.6.8
BSB=$(NVM) use && npx bsb

.PHONY: dev
dev: install-deps watch-and-serve

.PHONY: install-deps
install-deps:
	$(NVM) install
	$(YARN) install
	make vendor/ood && $(YARN) link ood
	$(ESY)

vendor/ood:
	mkdir -p vendor && cd vendor && \
	git clone https://github.com/ocaml/ood.git && cd ood && \
	$(YARN) link

.PHONY: ci
ci:
	# NOTE: No NVM in CI
	# NOTE: No vendor/ood in CI, use dependency as specified in package.json
	npx yarn@1.22 install
	npx yarn@1.22 run build

.PHONY: watch
watch:
	$(YARN) watch

.PHONY: watch-and-serve
watch-and-serve:
	$(YARN) watch-and-serve

.PHONY: build
build:
	$(YARN) build

.PHONY: serve
serve: build
	$(YARN) start-test-server

.PHONY: clean
clean:
	$(BSB) -clean

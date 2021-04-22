SHELL=/bin/bash

.PHONY: ci-install-deps
ci-install-deps:
	# installing (or using) esy encounters permission error
	# npm install -g esy@0.6.7 # for eventual dune install
	yarn install

.PHONY: ci-build
ci-build:
	yarn build

.PHONY: clean
clean:
	npx bsb -clean

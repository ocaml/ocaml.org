SHELL = /bin/bash

ifeq ($(VERCEL), 1)
  # The yarn version is picked from .engines in package.json
  YARN=yarn
  ESY=npx esy
  BSB=npx bsb
else
  # Yarn version specified here because it can't bootstrap itself as a devDependency with npx.
  YARN=npx yarn@1.22
  ESY=npx esy
  BSB=npx bsb
endif

.PHONY: dev
dev: install-deps watch-and-serve

.PHONY: install-deps
install-deps:
ifeq ($(VERCEL), 1)
	npm config set user root
	yum install perl-Digest-SHA
	# Vercel doesn't correctly handle caching of esy
	rm -rf _esy node_modules/esy node_modules/.bin/esy ~/.esy
endif
	$(YARN) install
	make vendor/ood && $(YARN) link ood
	$(ESY) install

vendor/ood:
	mkdir -p vendor && cd vendor && \
	git clone https://github.com/ocaml/ood.git && cd ood && \
	$(YARN) link

.PHONY: watch
watch:
	$(YARN) watch

.PHONY: watch-and-serve
watch-and-serve:
	$(YARN) watch-and-serve

.PHONY: build
build:
	$(ESY) build
	$(YARN) build

.PHONY: serve
serve: build
	$(YARN) start-test-server

.PHONY: clean
clean:
	-$(BSB) -clean
	-$(ESY) dune clean
	-rm -f .merlin
	-rm -rf .next
	-rm -rf out

.PHONY: distclean
distclean: clean
	-($(YARN) unlink ood && cd vendor/ood && $(YARN) unlink)
	-rm -rf vendor
	-rm -rf node_modules
	-rm -rf _esy
	-rm -f yarn-error.log

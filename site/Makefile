SHELL=/bin/bash

.PHONY: install-vendored-deps
install-vendored-deps:
	mkdir -p node_modules/ood
	rsync \
	  --verbose \
	  --archive \
	  --delete \
	  --exclude '*.js' \
	  --exclude 'lib/**/*' \
	  --exclude .merlin \
	  vendor/ood/lib/ \
	  node_modules/ood

.PHONY: ci-install-deps
ci-install-deps:
	mkdir vendor
	cd vendor && git clone https://github.com/ocaml/ood.git
	make install-vendored-deps
	# installing (or using) esy encounters permission error
	# npm install -g esy@0.6.7 # for eventual dune install
	yarn install

.PHONY: ci-build
ci-build:
	yarn build

.PHONY: clean
clean:
	npx bsb -clean

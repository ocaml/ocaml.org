SHELL=/bin/bash
NVM=source $$NVM_DIR/nvm.sh && nvm

# NOTE: currently, yarn@VERSION is used throughout because
# the first invokation of npx yarn installs yarn itself.
# since we can't control which order users run the commands
# below, we guard all usages of yarn with a version.

.PHONY: install-deps
install-deps:
	# install node version, if not already present
	$(NVM) install
	# install js library dependencies and build tools for ocaml
	$(NVM) use && npx yarn@1.22 install && npx esy@0.6.8

.PHONY: rescript-watch
rescript-watch:
	$(NVM) use && npx yarn@1.22 rescript:start

.PHONY: next-dev
next-dev:
	$(NVM) use && npx yarn@1.22 next:dev

.PHONY: ci-install-deps
ci-install-deps:
	# installing (or using) esy encounters permission error
	# npm install -g esy@0.6.7 # for eventual dune install
	npx yarn@1.22 install

.PHONY: ci-build
ci-build:
	npx yarn@1.22 build

.PHONY: rescript-format
rescript-format:
	# this command requires that you install `moreutils` which provides `sponge`
	$(NVM) use && npx yarn@1.22 rescript:format

.PHONY: clean
clean:
	$(NVM) use && npx bsb -clean

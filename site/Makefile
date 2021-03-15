SHELL=/bin/bash

.PHONY: install-deps
install-deps:
	# install node version, if not already present
	source $$NVM_DIR/nvm.sh && nvm install
	# install js library dependencies and build tools
	source $$NVM_DIR/nvm.sh && nvm use && npx yarn@1.22 install

.PHONY: rescript-watch
rescript-watch:
	source $$NVM_DIR/nvm.sh && nvm use && npx yarn@1.22 rescript:start

.PHONY: next-dev
next-dev:
	source $$NVM_DIR/nvm.sh && nvm use && npx yarn@1.22 next:dev

.PHONY: ci-install-deps
ci-install-deps:
	# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash
	# need to setup NVM_DIR and source nvm.sh here
	# nvm install
	# nvm use
	# installing (or using) esy encounters permission error
	# npm install -g esy@0.6.7 # for eventually dune install
	npx yarn@1.22 install

.PHONY: ci-build
ci-build:
	# nvm use
	npx yarn@1.22 build
	# perform export once to ensure no server side functionality has been used
	npx yarn@1.22 next:export

.PHONY: rescript-format
rescript-format:
	# this command requires that you install `moreutils` which provides `sponge`
	source $$NVM_DIR/nvm.sh && nvm use && npx yarn@1.22 rescript:format

.PHONY: clean
clean:
	source $$NVM_DIR/nvm.sh && nvm use && npx bsb -clean

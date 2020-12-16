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
	npx yarn build

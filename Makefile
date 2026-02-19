.PHONY: prerequisites lint clean all build-image ansible test collection-build collection-test help

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

prerequisites: ## Check prerequisites and setup
	@docker --version || (echo "Docker is required but not installed." && exit 1)
	@echo "Prerequisites check passed"

build-image: prerequisites ## Build the development Docker image
	docker build -t ansible-toolbox .

lint: build-image ## Run ansible-lint on the collection
	docker run --rm -v $(PWD):/workdir -w /workdir ansible-toolbox ansible-lint

test: build-image ## Run collection tests
	docker run --rm -v $(PWD):/workdir -w /workdir ansible-toolbox ansible-playbook tests/test.yml --syntax-check

collection-build: build-image ## Build the collection artifact
	docker run --rm -v $(PWD):/workdir -w /workdir ansible-toolbox ansible-galaxy collection build

collection-test: collection-build ## Build and test install collection locally
	docker run --rm -v $(PWD):/workdir -w /workdir ansible-toolbox sh -c \
		"ansible-galaxy collection build && \
		 ansible-galaxy collection install *.tar.gz --force && \
		 ansible-playbook tests/test.yml --syntax-check"

ansible: build-image ## Run arbitrary ansible commands (usage: make ansible -- --version)
	docker run --rm -v $(PWD):/workdir -w /workdir ansible-toolbox ansible $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

shell: build-image ## Open interactive shell in development container
	docker run --rm -it -v $(PWD):/workdir -w /workdir ansible-toolbox bash

all: lint test collection-test ## Run all checks and tests

clean: ## Clean up generated files
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	find . -name "*.tar.gz" -delete 2>/dev/null || true
	docker rmi ansible-toolbox 2>/dev/null || true

# Handle ansible command arguments
%:
	@:
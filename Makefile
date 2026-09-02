.DEFAULT_GOAL := help

.PHONY: help polaris-console-clone up up-bootstrap bootstrap-only build down clean

DOCKER_COMPOSE ?= docker-compose

help: ## List all available make commands
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-22s\033[0m %s\n", $$1, $$2}'

polaris-console-clone: ## Clone the Polaris console tools repository if it doesn't exist
	mkdir -p tools
	if [ ! -d "tools/polaris-tools" ]; then git clone --depth 1 https://github.com/apache/polaris-tools.git tools/polaris-tools; fi

build: polaris-console-clone ## Build the Docker images
	$(DOCKER_COMPOSE) build

up: build ## Start the Docker containers
	$(DOCKER_COMPOSE) up -d --remove-orphans

up-bootstrap: build ## Start the Docker containers and run the bootstrap process
	$(DOCKER_COMPOSE) up -d --remove-orphans
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml rm -sf minio-bootstrap polaris-bootstrap || true
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml up --force-recreate --abort-on-container-exit minio-bootstrap polaris-bootstrap

bootstrap-only: polaris-console-clone ## Run only the bootstrap process
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml rm -sf minio-bootstrap polaris-bootstrap || true
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml up --force-recreate --abort-on-container-exit minio-bootstrap polaris-bootstrap

down: ## Stop the Docker containers
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml rm -sf minio-bootstrap polaris-bootstrap || true

clean: ## Stop and remove all Docker containers, volumes, and bootstrap containers
	$(DOCKER_COMPOSE) down -v
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml down -v || true
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml rm -sf minio-bootstrap polaris-bootstrap || true

.PHONY: polaris-console-clone up up-bootstrap bootstrap-only build down clean

DOCKER_COMPOSE ?= docker-compose

polaris-console-clone:
	mkdir -p tools
	if [ ! -d "tools/polaris-tools" ]; then git clone --depth 1 https://github.com/apache/polaris-tools.git tools/polaris-tools; fi

build: polaris-console-clone
	$(DOCKER_COMPOSE) build

up: build
	$(DOCKER_COMPOSE) up -d --remove-orphans

up-bootstrap: build
	$(DOCKER_COMPOSE) up -d --remove-orphans
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml rm -sf minio-bootstrap polaris-bootstrap || true
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml up --force-recreate --abort-on-container-exit minio-bootstrap polaris-bootstrap

bootstrap-only: polaris-console-clone
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml rm -sf minio-bootstrap polaris-bootstrap || true
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml up --force-recreate --abort-on-container-exit minio-bootstrap polaris-bootstrap

down:
	$(DOCKER_COMPOSE) down
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml rm -sf minio-bootstrap polaris-bootstrap || true

clean:
	$(DOCKER_COMPOSE) down -v
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml down -v || true
	$(DOCKER_COMPOSE) -f docker-compose.yml -f docker/compose/bootstrap.yml rm -sf minio-bootstrap polaris-bootstrap || true

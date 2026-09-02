# Local Data Platform Development Stack

Local Apache Iceberg + Polaris development stack for running a catalog-first Iceberg setup with MinIO object storage, Spark compute, and the official Polaris Console.

## Components

- MinIO: object storage for the warehouse
- Polaris: Iceberg REST catalog
- Spark + Jupyter: local compute and notebook access
- Polaris Console: official web UI for the catalog

## Prerequisites

Before running the stack, install and start Docker Engine-compatible tooling such as:

- Docker Desktop
- OrbStack (recommended for macOS)

The project uses Docker Compose, so a running Docker daemon is required before executing any `make` target.

## Local environment setup

This repo expects a local `.env` file in the project root. A checked-in template is provided at [.env.example](.env.example). To create your local config:

```bash
cp .env.example .env
```

Then edit `.env` with your local values. The real `.env` file is gitignored and should not be committed.

## Available commands

Running `make` by itself shows the list of project targets.

```bash
make
```

Common commands:

```bash
make build
make up
make up-bootstrap
make bootstrap-only
make down
make clean
```

## Run the stack

Start the runtime services only:

```bash
make up
```

This rebuilds images and starts the stack in the background.

If you also want the initial MinIO bucket and Polaris catalog created once, run:

```bash
make up-bootstrap
```

If the stack is already running and you only want to bootstrap the bucket and catalog again, use:

```bash
make bootstrap-only
```

## URLs

- MinIO console: http://localhost:9001
- Spark UI: http://localhost:8080
- Jupyter: http://localhost:8888
- Polaris API: http://localhost:8281
- Polaris health: http://localhost:8282/q/health
- Polaris Console: http://localhost:8081

## Polaris login

Use the default bootstrap client:

- Realm: `<POLARIS_REALM>` from `.env`
- Client ID: `<POLARIS_ROOT_CLIENT_ID>` from `.env`
- Client Secret: `<POLARIS_ROOT_CLIENT_SECRET>` from `.env`
- Scope: `PRINCIPAL_ROLE:ALL`

> Note: the values in `.env` are for local development only. Do not use these credentials or environment values directly in production environments.

## Stop / clean up

Stop the running stack:

```bash
make down
```

Fully remove the stack and bootstrap-related containers/volumes:

```bash
make clean
```

## Notes

- `.env` is intentionally local-only and should stay out of version control.
- `.env.example` is the safe file to commit to the repository.
- The workspace includes a `tools` directory for the Polaris Console source; it is created automatically when needed by the `polaris-console-clone` target.


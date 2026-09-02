# iceberg-to-gcp

Local Apache Iceberg + Polaris development stack for running a catalog-first Iceberg setup with MinIO object storage, Spark compute, and the official Polaris Console.

## Components

- MinIO: object storage for the warehouse
- Polaris: Iceberg REST catalog
- Spark + Jupyter: local compute and notebook access
- Polaris Console: official web UI for the catalog

## One-time setup

The console source is cloned into the repo automatically via Task:

```bash
task polaris-console-clone
```

This creates a local checkout under `tools/polaris-tools`.

## Run the stack

Start the runtime services only:

```bash
task up
```

This rebuilds images and starts the stack in the background.

If you also want the initial MinIO bucket and Polaris catalog created once, run:

```bash
task up-bootstrap
```

This starts the runtime stack and then runs the one-time bootstrap setup.

If the stack is already running and you only want to bootstrap the bucket and catalog again, use:

```bash
task bootstrap-only
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

- Realm: `POLARIS`
- Client ID: `root`
- Client Secret: `s3cr3t`
- Scope: `PRINCIPAL_ROLE:ALL`

> Note: the values in `.env` are for local development and education only. Do not use these credentials or environment values directly in production environments.

## Stop / clean up

Stop the running stack:

```bash
task down
```

Fully remove the stack and Bootstrap-related containers/volumes:

```bash
task clean
```


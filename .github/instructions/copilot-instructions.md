# Project Description
This project is created to demonstrate the use of Apache Iceberg with a local development stack that includes MinIO for object storage, Polaris for catalog management, and Spark for data processing. The stack is designed to be easily deployable using Docker Compose.

# Project Components:
- **MinIO**: Provides object storage for the Iceberg warehouse.
- **Polaris**: Acts as the Iceberg REST catalog, managing metadata and schema information.
- **Spark + Jupyter**: Offers local compute capabilities and notebook access for data analysis.
- **Polaris Console**: The official web UI for managing the Polaris catalog.

# Project Structure:
- `docker/compose/`: Contains Docker Compose files for setting up the local development environment.
    - `minio.yml`: Configuration for the MinIO service.
    - `catalogs.yml`: Configuration for the Polaris catalog service.
    - `spark.yml`: Configuration for the Spark service.
    - `ui.yml`: Configuration for the Polaris Console service.
    - `bootstrap.yml`: Configuration for the MinIO and Polaris bootstrap setup.
- `docker/spark/`: Contains Dockerfile and related configurations for the Spark service.
- `docker-compose.yml`: The main Docker Compose file that orchestrates all services.
- `.env`: Environment variables for configuring the services.
- `.env.example`: Example environment variables for configuring the services.
- `notebooks/`: Contains Jupyter notebooks for data analysis and experimentation.
- `conf/`: Contains configuration files for the Spark services.
- `tools/polaris-tools/console/`: Contains the local checkout of the Polaris Console source code.
- `README.md`: Provides an overview of the project, setup instructions, and usage guidelines.
- `Makefile`: Defines tasks for automating setup and management of the local development environment.
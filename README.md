# Blitz Docker

An example application with various configurations and setups to run Blitz with Docker. Work in progress use at your own risk.

## Dockerfiles

### Overview

| Type      |      Base image      |                     Size |
| --------- | :------------------: | -----------------------: |
| complete  | node:14-stretch-slim | see below for each stage |
| prod-only | node:14-stretch-slim |                    584MB |
| dev-only  | node:14-stretch-slim |                          |
| complete  |    node:14-alpine    |                          |
| prod-only |    node:14-alpine    |                    833MB |

### Build image

Place the `Dockerfile` that you want to use at the root of your application and run:

```bash
docker build . -t "IMAGE_NAME:TAG" --build-arg DATABASE_URL="postgresql://user:password@host:port/db?sslmode=require&pgbouncer=true"
```

## Local Environments

Place the `docker-compose` config that you want to use at the root of your application.

- with MySQL
- with PostgreSQL

## Best Practices

- [x] Explicit image reference, avoid `latest` tag
- [x] Use official images
- [x] Multistage builds
- [x] Non-root `node` user
- [x] Always combine `apt-get update` with `apt-get install` in the same `RUN` statement
- [x] No dev dependencies in production image
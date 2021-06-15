# Blitz Docker

An example application with various configurations and setups to run Blitz with Docker.

## Dockerfiles

### Overview

The 'complete' `Dockerfile` is one large file that contains all the environments. There are also `Dockerfiles` available for specific environment if you only need those.  
You can also mix and match the content of the `Dockerfiles` to create a custom one. The image sizes are based on a fresh Blitz app (0.35.0) like the one used in this repo.
Sizes can vary depending on the Blitz version.

| Type                                                                                   |      Base image      |                     Size | 
|----------------------------------------------------------------------------------------|:--------------------:|-------------------------:|
| [complete](docker/dockerfiles/complete/stretch-slim/Dockerfile)                        | node:14-stretch-slim | see below for each stage |                  |              |
| [prod-only](docker/dockerfiles/prod-only/Dockerfile.stretch)                      | node:14-stretch-slim |                    797MB | 
| [prod-only w/ BuildKit](docker/dockerfiles/prod-only/Dockerfile.buildkit) | node:14-stretch-slim |                    612MB |     
| [dev-only]                                                                             | node:14-stretch-slim |                          |                  |              |
| [complete](docker/dockerfiles/complete/alpine/Dockerfile)                              |    node:14-alpine    | See below for each stage |                  |              |
| [prod-only](docker/dockerfiles/prod-only/Dockerfile.alpine)                            |    node:14-alpine    |                    1.06GB |                  |              |

### Build image

Place the `Dockerfile` that you want to use at the root of your application and run:

```bash
docker build . -t "IMAGE_NAME:TAG" \ 
  --build-arg DATABASE_URL="postgresql://user:password@host:port/db?sslmode=require&pgbouncer=true" \
	--build-arg SESSION_SECRET_KEY="yoursupersecretsessionkey"
```

If are using one of the 'complete' `Dockerfiles` and you want to stop at a specific stage you can do:

```bash
docker build . --target testing -t "IMAGE_NAME:TAG" \
	--build-arg DATABASE_URL="postgresql://user:password@host:port/db?sslmode=require&pgbouncer=true"
	--build-arg SESSION_SECRET_KEY="yoursupersecretsessionkey"
```

You can speed up the image build process and performance if you are using Docker v18.09 or later by using BuildKit. This is especially useful in combination with CI/CD. 
You can enable it by setting:

```bash
export DOCKER_BUILDKIT=1
```

Now you can build your image with one of the BuildKit Dockerfiles.

This is just a very basic way to build your image. You'll probably want to use CI/CD to automate this.
An easy way to get started is this [GitHub Action](https://github.com/marketplace/actions/build-and-push-docker-images) to build and push Docker images.

## Docker Compose

### Development

Place the `docker-compose` config file with the database that you want to use at the root of your application.  
Currently you can choose between [PostgreSQL](docker/docker-compose/dev/postgres/docker-compose.yml) and [MySQL](docker/docker-compose/dev/mysql/docker-compose.yml).

### Production

- [ ] Production<sup>\*</sup> with remote database (managed on DO, AWS, Heroku etc.)
- [ ] Production<sup>\*</sup> with local database

<sup>\*</sup> Docker Compose provides an easy way to deploy apps to production. This works fine for small and/or low-traffic apps on a single server.  
If you need constant uptime, high-availability, load-balancing or anything like that you can check out some of the popular solutions. The easiest way to get started is by using [Docker Swarm Mode](https://docs.docker.com/engine/swarm/) (this is not Docker Classic Swarm which is deprecated). Other options are [Kubernetes](https://kubernetes.io), which is offered as a managed service by most cloud providers, [AWS ECS](https://aws.amazon.com/ecs), [Google Cloud Run](https://cloud.google.com/run) or [HashiCorp Nomad](https://www.nomadproject.io/).

## Best Practices

- [x] Use official images
- [x] Explicit image reference, avoid `latest` tag or generic aliases like `node`
- [x] Multistage builds
- [x] Non-root `node` user
- [x] Reduce the number of layers by merging `RUN`, `FROM`, and `CMD` commands.  
       Using multiple `COPY` lines though to avoid that a change to a file invalidates the whole layer
- [x] No dev dependencies in production image
- [x] Delete caches
- [x] Use `.dockerignore`
- [x] Split long or complex RUN statements on multiple lines separated with backslashes to make the Dockerfile more readable,   
  		understandable, and more maintainable.

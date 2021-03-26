# create a standard base image that has all the defaults
FROM node:14-stretch-slim AS base
ARG DATABASE_URL
ENV NODE_ENV=production
ENV PATH /home/node/app/node_modules/.bin:$PATH
ENV TINI_VERSION v0.19.0
EXPOSE 3000
RUN apt-get update && apt-get install -y openssl --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/* \
	&& mkdir /home/node/app && chown -R node:node /home/node/app
WORKDIR /home/node/app
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
USER node
COPY --chown=node:node package*.json yarn.lock* ./
RUN yarn config list && yarn install --frozen-lockfile && yarn cache clean --force

# create a development image
FROM base AS dev
ENV NODE_ENV=development
USER node
RUN yarn config list && yarn install && yarn cache clean --force
USER node

# create a testing image
FROM dev AS test
ENV NODE_ENV=development
COPY --chown=node:node . .
CMD blitz lint; blitz test
USER node

# create a build image
FROM test as build
ENV NODE_ENV=production
ENV DATABASE_URL=$DATABASE_URL
RUN blitz prisma migrate deploy --preview-feature && blitz prisma generate && blitz build
USER node

# create a production image
FROM base as prod
ENV NODE_ENV=production
COPY --chown=node:node --from=build /home/node/app/public /home/node/app/public
COPY --chown=node:node --from=build /home/node/app/.blitz /home/node/app/.blitz
COPY --chown=node:node --from=build /home/node/app/db /home/node/app/db
ENTRYPOINT ["/tini", "--"]
EXPOSE 3000
CMD blitz prisma generate && blitz start
USER node
# create a standard base image that has all the defaults
FROM node:14-alpine as base
ARG DATABASE_URL
ARG SESSION_SECRET_KEY
ENV NODE_ENV=production
ENV PATH /home/node/app/node_modules/.bin:$PATH
ENV TINI_VERSION v0.19.0
EXPOSE 3000
WORKDIR /home/node/app
RUN apk add --no-cache make g++ python libsodium-dev openssl libtool autoconf automake \ 
	&& rm -rf /var/cache/apk/* \
	&& chown -R node:node /home/node/app
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
USER node
COPY --chown=node:node package*.json yarn.lock* ./
RUN yarn install --frozen-lockfile --prefer-offline && yarn cache clean --force

# create a build image
FROM base as build
ENV NODE_ENV=development
ENV DATABASE_URL=$DATABASE_URL
COPY --chown=node:node . .
RUN yarn install --prefer-offline && yarn cache clean --force \ 
	&&blitz prisma migrate deploy --preview-feature \
	&& blitz prisma generate && blitz build
USER node

# create a production image
FROM base as prod
ENV NODE_ENV=production
ENV SESSION_SECRET_KEY=$SESSION_SECRET_KEY
COPY --chown=node:node --from=build /home/node/app/public /home/node/app/public
COPY --chown=node:node --from=build /home/node/app/.blitz /home/node/app/.blitz
COPY --chown=node:node --from=build /home/node/app/db /home/node/app/db
COPY --chown=node:node --from=build /home/node/app/blitz.config.js /home/node/app/blitz.config.js
ENTRYPOINT ["/tini", "--"]
EXPOSE 3000
CMD blitz prisma generate && blitz start
USER node
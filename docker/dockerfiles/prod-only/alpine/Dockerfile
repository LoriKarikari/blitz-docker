# create a standard base image that has all the defaults
FROM node:14-alpine as base
ARG DATABASE_URL
ENV NODE_ENV=production
ENV PATH /home/node/app/node_modules/.bin:$PATH
EXPOSE 3000
RUN mkdir /app
WORKDIR /app
RUN apk upgrade --update-cache --available && \
	apk add openssl && \
	rm -rf /var/cache/apk/*
COPY package*.json ./


# create a build image
FROM base as pre-prod
COPY . .
RUN yarn install --frozen-lockfile
RUN npx next telemetry disable && npx blitz prisma generate && npx blitz build

# create a production image
FROM node:14-alpine as prod
RUN mkdir /app
WORKDIR /app
RUN apk upgrade --update-cache --available && \
	apk add openssl && \
	rm -rf /var/cache/apk/*
COPY --from=pre-prod /app/public ./public
COPY --from=pre-prod /app/.next ./.next
COPY --from=pre-prod /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]
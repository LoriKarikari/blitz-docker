FROM node:14-alpine as base
RUN mkdir /app
WORKDIR /app
RUN apk upgrade --update-cache --available && \
	apk add openssl && \
	rm -rf /var/cache/apk/*
COPY package*.json ./

FROM base as pre-prod
COPY . .
RUN yarn install --frozen-lockfile
RUN npx next telemetry disable && npx blitz prisma generate && npx blitz build

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
FROM node:14-stretch-slim as base
RUN mkdir /app
WORKDIR /app
RUN apt-get update && apt-get install openssl -y && rm -rf /var/lib/apt/lists/* 
COPY package*.json ./

FROM base as pre-prod
COPY . .
RUN yarn install --frozen-lockfile
RUN npx next telemetry disable && npx blitz prisma generate && npx blitz build

FROM node:14-stretch-slim as prod
RUN mkdir /app
WORKDIR /app
RUN apt-get update && apt-get install openssl -y && rm -rf /var/lib/apt/lists/* 
COPY --from=pre-prod /app/public ./public
COPY --from=pre-prod /app/.next ./.next
COPY --from=pre-prod /app/node_modules ./node_modules
EXPOSE 3000
CMD ["node_modules/.bin/next", "start"]
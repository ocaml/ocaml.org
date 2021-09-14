# Install dependencies only when needed
# Seems ReScript is broken on alpine https://github.com/rescript-lang/rescript-compiler/issues/3666 ? 
FROM node:14-buster-slim AS deps

RUN apt-get update && apt-get install -y python g++ make

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install --frozen-lockfile

# Rebuild the source code only when needed
FROM node:14-buster-slim AS builder

WORKDIR /app

COPY . .
COPY --from=deps /app/node_modules ./node_modules

RUN yarn build

# Production image containing only the static files
FROM alpine:latest AS data

WORKDIR /data

COPY --from=builder /app/out .

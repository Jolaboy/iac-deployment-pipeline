# syntax=docker/dockerfile:1

# ---- Stage 1: dependencies (cached layer) ----
# Installs ALL deps (incl. dev) against a lockfile-friendly layer so that
# unchanged package manifests reuse the cached node_modules across builds.
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci

# ---- Stage 2: test ----
# Runs the Jest suite as part of the image build so a broken test fails the build.
FROM deps AS test
WORKDIR /app
COPY . .
RUN npm test

# ---- Stage 3: production dependencies only ----
FROM node:20-alpine AS prod-deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

# ---- Stage 4: runtime (minimal final image) ----
FROM node:20-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app
# Only production node_modules and source are copied into the final layer,
# keeping the shipped image small and free of test tooling.
COPY --from=prod-deps /app/node_modules ./node_modules
COPY package*.json ./
COPY src ./src
USER node
EXPOSE 3000
CMD ["node", "src/server.js"]

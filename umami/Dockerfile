# Install dependencies only when needed
FROM node:22-alpine AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN npm install -g pnpm
RUN pnpm install --frozen-lockfile

# Rebuild the source code only when needed
FROM node:22-alpine AS builder
WORKDIR /app
# Install pnpm in builder stage
RUN npm install -g pnpm
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build arguments with default values for build-time
ARG DATABASE_TYPE=postgresql
ARG DATABASE_URL=postgresql://umami:umami@localhost:5432/umami
ARG BASE_PATH=""

# Environment variables for build time
ENV DATABASE_TYPE=$DATABASE_TYPE
ENV DATABASE_URL=$DATABASE_URL
ENV BASE_PATH=$BASE_PATH
ENV NEXT_TELEMETRY_DISABLED=1

RUN pnpm run build-docker

# Production image, copy all the files and run next
FROM node:22-alpine AS runner
WORKDIR /app

ARG NODE_OPTIONS
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV NODE_OPTIONS=$NODE_OPTIONS

# Install system dependencies first
RUN apk add --no-cache curl

# Install pnpm globally FIRST (before creating users)
RUN npm install -g pnpm

# Create user and group
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Install script dependencies
RUN pnpm add npm-run-all dotenv prisma@6.7.0

# Create necessary directories with correct ownership
RUN mkdir -p /app/.next && chown -R nextjs:nodejs /app

# Copy files with correct ownership
COPY --from=builder --chown=nextjs:nodejs /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/prisma ./prisma
COPY --from=builder --chown=nextjs:nodejs /app/scripts ./scripts
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Custom routes manipulation
RUN mv ./.next/routes-manifest.json ./.next/routes-manifest-orig.json 2>/dev/null || true

# Fix permissions for pnpm store - do this BEFORE switching users
RUN chown -R nextjs:nodejs /app/node_modules/.pnpm/ 2>/dev/null || true

USER nextjs

EXPOSE 3000
ENV HOSTNAME=0.0.0.0
ENV PORT=3000

CMD ["pnpm", "start-docker"]
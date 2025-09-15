# Multi-stage build for Nuxt.js app
FROM node:22-alpine AS builder

WORKDIR /app

# # Build arguments
# ARG API_BASE_URL=http://localhost:8080

# # Set environment variable for build
# ENV API_BASE_URL=$API_BASE_URL

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Production stage
FROM node:22-alpine AS production

WORKDIR /app

# Install curl for healthcheck
RUN apk add --no-cache curl

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production && npm cache clean --force

# Copy built application
COPY --from=builder /app/.output ./

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nuxtjs -u 1001

# Change ownership of app directory  
RUN chown -R nuxtjs:nodejs /app

USER nuxtjs

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/ || exit 1

# Start the application
CMD ["node", "server/index.mjs"] 


FROM node:20-alpine

# Create app directory
WORKDIR /app

# Install curl (useful for healthchecks/debugging if needed)
RUN apk add --no-cache curl

# Copy package definition if the image supports overrides (safe even if unused)
COPY package*.json ./

# Install production dependencies if package.json exists
RUN if [ -f package.json ]; then npm ci --omit=dev || true; fi

# Copy application files
COPY . .

# Expose OpenClaw default port
EXPOSE 18789

# Ensure container runs as non-root user
RUN addgroup -S openclaw && adduser -S openclaw -G openclaw
USER openclaw

# Default command (can be overridden by compose)
CMD ["node", "server.js"]
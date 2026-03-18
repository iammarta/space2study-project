FROM node:18-alpine AS builder

WORKDIR /app

# Install system dependencies required for compiling native modules
RUN apk add --no-cache make gcc g++ python3

COPY package*.json ./

# Install only production dependencies
RUN npm ci --legacy-peer-deps

# Rebuild bcrypt from source inside the container to ensure binary compatibility with Alpine Linux
RUN npm rebuild bcrypt --build-from-source

COPY . .

RUN npm prune --omit=dev

FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./

# Set permissions for the node user for better security
RUN chown -R node:node /app
USER node

EXPOSE 5001

CMD ["node", "src/app.js"]
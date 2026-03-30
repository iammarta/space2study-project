FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --legacy-peer-deps

COPY . .

RUN npm prune --omit=dev

FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app ./

# Set permissions for the node user for better security
RUN chown -R node:node /app
USER node

EXPOSE 5001

CMD ["node", "src/app.js"]
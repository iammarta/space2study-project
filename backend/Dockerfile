FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN apk add --no-cache make gcc g++ python3 && \
    npm ci --legacy-peer-deps && \
    npm rebuild bcrypt --build-from-source && \
    apk del make gcc g++ python3 && \
    npm cache clean --force

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
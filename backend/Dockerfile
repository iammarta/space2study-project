FROM node:18.19.0-alpine3.19 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --legacy-peer-deps
COPY . .
RUN npm prune --omit=dev
FROM node:18.19.0-alpine3.19
WORKDIR /app
COPY --from=build --chown=node:node /app ./
USER node
EXPOSE 5001
CMD ["node", "src/app.js"]
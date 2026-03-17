FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

# Install system dependencies required for compiling native modules
RUN apk add --no-cache make gcc g++ python3

# Install only production dependencies and skip scripts to avoid build errors
RUN npm ci --only=production --legacy-peer-deps --ignore-scripts

# Rebuild bcrypt from source inside the container to ensure binary compatibility with Alpine Linux
RUN npm rebuild bcrypt --build-from-source

COPY . .

# Set permissions for the node user for better security
RUN chown -R node:node /app
USER node

EXPOSE 5001

CMD ["node", "src/app.js"]
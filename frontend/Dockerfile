# Stage 1: Build the application
FROM node:18.19.0-alpine3.19 AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci --legacy-peer-deps
COPY . .

# Set the backend URL as an environment variable
ARG VITE_API_BASE_PATH
ENV VITE_API_BASE_PATH=$VITE_API_BASE_PATH
RUN npm run build

# Stage 2: Serve the application using Nginx
FROM nginx:1.27-alpine
# Copy custom Nginx configuration to handle SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy only the compiled build artifacts from the build stage
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
# -------------------------------------------------------
# STAGE 1: Build the Vite app
# -------------------------------------------------------
FROM node:18-alpine AS builder

# Create app directory
WORKDIR /app

# Copy package files separately for better caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the project files
COPY . .

# Run Vite build
RUN npm run build



# -------------------------------------------------------
# STAGE 2: Serve static build using nginx
# -------------------------------------------------------
FROM nginx:alpine AS production

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy the Vite build output to nginx html directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 5173

# Run nginx
CMD ["nginx", "-g", "daemon off;"]

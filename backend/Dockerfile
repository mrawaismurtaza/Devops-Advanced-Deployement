# Use an official Node.js image as base
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy backend code
COPY . .

# Expose backend port
EXPOSE 5000

# Install nodemon for hot reloading
RUN npm install -g nodemon

# Start server with nodemon (for live changes)
CMD ["nodemon", "server.js"]

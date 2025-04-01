# Use Node.js image to build the React app
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy frontend code
COPY . .

# Set environment to development for hot reloading
ENV WDS_SOCKET_PORT=0

# Start frontend with development server
CMD ["npm", "start"]

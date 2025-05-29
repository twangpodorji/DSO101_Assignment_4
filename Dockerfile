FROM --platform=linux/amd64 node:18-alpine

# Create a non-root user
RUN adduser -D appuser

# Set working directory
WORKDIR /app

# Copy package files and install dependencies securely
COPY package*.json ./
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm install --no-cache --production

# Copy application files
COPY . .

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 3000

# Set environment variable for production
ENV NODE_ENV=production

# Start the application
CMD ["npm", "start"]
FROM --platform=linux/amd64 node:18-alpine
RUN adduser -D appuser
WORKDIR /app
COPY package*.json ./

# Install dependencies using secrets (SECURITY BEST PRACTICE #2)
# This ensures sensitive info like registry tokens aren't in build history
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm install

# Copy application code
COPY . .

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user (SECURITY BEST PRACTICE #1)
USER appuser

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
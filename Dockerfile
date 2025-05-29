FROM --platform=linux/amd64 node:18-alpine
RUN adduser -D appuser
WORKDIR /app
COPY package*.json ./
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm install
COPY . .
RUN chown -R appuser:appuser /app
USER appuser
EXPOSE 3000
CMD ["npm", "start"]
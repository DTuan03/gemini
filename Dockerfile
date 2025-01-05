# Stage 1: Build ứng dụng
FROM node:22-alpine3.19 AS builder

WORKDIR /app

# Copy file package.json và package-lock.json
COPY package*.json ./

# Cài đặt dependencies
RUN npm install

# Copy toàn bộ mã nguồn vào container
COPY . .

# Build ứng dụng
RUN npm run build

# Stage 2: Caddy server
FROM caddy:2.8.4-alpine

# Copy file cấu hình Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# Copy nội dung build từ stage 1
COPY --from=builder /app/dist /usr/share/caddy/

# Expose port cho ứng dụng
EXPOSE 80

# Chạy Caddy
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]

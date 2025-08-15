#!/bin/bash

# Docker Setup Script untuk VPS
set -e

echo "=== Installing Docker on VPS ==="

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Start and enable Docker
systemctl enable docker
systemctl start docker

# Add user to docker group (optional)
usermod -aG docker root

echo "=== Docker installed successfully ==="

echo "=== Cloning repository ==="

# Create app directory
mkdir -p /var/www
cd /var/www

# Clone repository
git clone https://github.com/muhammad-seman/surehomecare.git
cd surehomecare

echo "=== Setting up environment ==="

# Create required directories
mkdir -p server/images
mkdir -p deployment/ssl
mkdir -p logs

echo "=== Building and running with Docker ==="

# Build and run containers
docker-compose up -d --build

echo "=== Checking container status ==="
docker-compose ps

echo "=== Deployment completed! ==="
echo ""
echo "🌐 Your application should be available at:"
echo "   Backend API: http://148.230.99.217:3002"
echo "   Frontend:    http://148.230.99.217:3000"
echo "   Database:    http://148.230.99.217:3306"
echo ""
echo "📝 Next steps:"
echo "1. Setup Nginx reverse proxy"
echo "2. Configure SSL certificates"
echo "3. Test the application"
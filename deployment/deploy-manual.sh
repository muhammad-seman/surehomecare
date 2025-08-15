#!/bin/bash

# Manual Deployment Script untuk Bidan Care
# Jalankan script ini di VPS setelah setup awal

set -e

APP_DIR="/var/www/surehomecare"
BACKEND_DIR="$APP_DIR/backend"
FRONTEND_DIR="$APP_DIR/frontend"
REPO_URL="https://github.com/YOUR_USERNAME/YOUR_REPO.git"  # Ganti dengan URL repo Anda

echo "=== Starting Manual Deployment ==="

# Create backup
BACKUP_DIR="/var/backups/surehomecare/$(date +%Y%m%d_%H%M%S)"
echo "Creating backup at $BACKUP_DIR..."
mkdir -p $BACKUP_DIR
if [ -d "$BACKEND_DIR" ]; then
    cp -r $BACKEND_DIR $BACKUP_DIR/
fi
if [ -d "$FRONTEND_DIR" ]; then
    cp -r $FRONTEND_DIR $BACKUP_DIR/
fi

# Stop services
echo "Stopping services..."
pm2 stop bidan-care-backend || true

# Clone repository
echo "Cloning repository..."
cd /tmp
rm -rf bidan-care-deploy
git clone $REPO_URL bidan-care-deploy
cd bidan-care-deploy

# Deploy backend
echo "Deploying backend..."
cd $BACKEND_DIR
# Keep important files
cp .env /tmp/.env.backup 2>/dev/null || true
cp -r images /tmp/images.backup 2>/dev/null || true

# Remove old files but keep node_modules
find . -maxdepth 1 -not -name 'node_modules' -not -name '.' -not -name '..' -exec rm -rf {} +

# Copy new files
cp -r /tmp/bidan-care-deploy/server/* .

# Restore important files
cp /tmp/.env.backup .env 2>/dev/null || true
cp -r /tmp/images.backup images 2>/dev/null || true

# Install dependencies
npm ci --only=production

# Install uuid for seeder
npm install uuid

# Run database setup (idempotent)
node setup-database.js

# Deploy frontend
echo "Deploying frontend..."
cd /tmp/bidan-care-deploy/bidan_care_admin

# Install dependencies and build
npm ci
npm run build

# Copy built files
rm -rf $FRONTEND_DIR/*
cp -r .next/standalone/* $FRONTEND_DIR/
cp -r .next/static $FRONTEND_DIR/.next/static
cp -r public $FRONTEND_DIR/public

# Set permissions
chown -R nginx:nginx $APP_DIR

# Start services
echo "Starting services..."
cd $BACKEND_DIR
pm2 start ecosystem.config.js --env production
pm2 save

# Restart Nginx
systemctl reload nginx

# Cleanup
rm -rf /tmp/bidan-care-deploy
rm -f /tmp/.env.backup
rm -rf /tmp/images.backup

echo "=== Deployment completed successfully! ==="
echo "Backend: https://api.surehomecare.id"
echo "Frontend: https://surehomecare.id"
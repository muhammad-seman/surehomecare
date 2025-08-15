#!/bin/bash

# SSL Setup Script untuk Docker deployment
set -e

echo "=== Setting up SSL certificates ==="

# Install Nginx and Certbot
dnf install -y nginx certbot python3-certbot-nginx

# Setup Nginx configuration
cp nginx-docker.conf /etc/nginx/sites-available/surehomecare.id
ln -sf /etc/nginx/sites-available/surehomecare.id /etc/nginx/sites-enabled/

# Remove default config
rm -f /etc/nginx/sites-enabled/default

# Test nginx config
nginx -t

# Start nginx
systemctl enable nginx
systemctl start nginx

# Wait for nginx to start
sleep 5

# Setup SSL certificates
echo "Setting up SSL for main domain..."
certbot --nginx -d surehomecare.id -d www.surehomecare.id --non-interactive --agree-tos --email admin@surehomecare.id

echo "Setting up SSL for API domain..."
certbot --nginx -d api.surehomecare.id --non-interactive --agree-tos --email admin@surehomecare.id

# Setup auto renewal
systemctl enable certbot.timer
systemctl start certbot.timer

# Test renewal
certbot renew --dry-run

echo "✅ SSL certificates configured successfully!"

# Restart nginx with SSL
systemctl restart nginx

echo ""
echo "🔒 HTTPS enabled:"
echo "   https://surehomecare.id"
echo "   https://api.surehomecare.id"
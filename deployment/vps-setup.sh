#!/bin/bash

# VPS Setup Script untuk Bidan Care
# AlmaLinux 10 - surehomecare.id

set -e

echo "=== Starting VPS Setup for Bidan Care ==="

# Update system
echo "Updating system packages..."
dnf update -y

# Install basic tools
echo "Installing basic tools..."
dnf install -y curl wget git unzip nano htop

# Install Node.js 20 LTS
echo "Installing Node.js 20 LTS..."
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
dnf install -y nodejs

# Install PM2 globally
echo "Installing PM2..."
npm install -g pm2

# Install Nginx
echo "Installing Nginx..."
dnf install -y nginx
systemctl enable nginx

# Install MySQL 8.0
echo "Installing MySQL..."
dnf install -y mysql-server
systemctl enable mysqld
systemctl start mysqld

# Secure MySQL installation
echo "Starting MySQL secure installation..."
mysql_secure_installation

# Install Certbot for SSL
echo "Installing Certbot..."
dnf install -y epel-release
dnf install -y certbot python3-certbot-nginx

# Create application directory
echo "Creating application directories..."
mkdir -p /var/www/surehomecare
mkdir -p /var/www/surehomecare/backend
mkdir -p /var/www/surehomecare/frontend
mkdir -p /var/www/surehomecare/uploads

# Set proper permissions
chown -R nginx:nginx /var/www/surehomecare

# Create PM2 ecosystem file template
cat > /var/www/surehomecare/ecosystem.config.js << 'EOF'
module.exports = {
  apps: [
    {
      name: 'bidan-care-backend',
      script: './backend/app.js',
      cwd: '/var/www/surehomecare/backend',
      instances: 1,
      exec_mode: 'cluster',
      env: {
        NODE_ENV: 'production',
        PORT: 3002
      },
      error_file: '/var/log/pm2/backend-error.log',
      out_file: '/var/log/pm2/backend-out.log',
      log_file: '/var/log/pm2/backend.log'
    }
  ]
};
EOF

# Create log directory for PM2
mkdir -p /var/log/pm2

# Setup firewall
echo "Configuring firewall..."
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-port=3002/tcp
firewall-cmd --reload

# Enable services
systemctl start nginx
systemctl enable nginx

echo "=== VPS Setup Complete ==="
echo "Next steps:"
echo "1. Configure DNS: surehomecare.id -> 148.230.99.217"
echo "2. Configure DNS: api.surehomecare.id -> 148.230.99.217"
echo "3. Create MySQL database and user"
echo "4. Deploy application code"
echo "5. Configure SSL certificates"
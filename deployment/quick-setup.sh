#!/bin/bash

# Quick Setup Script - Jalankan setelah VPS setup selesai
# Script ini akan melakukan konfigurasi domain dan SSL

set -e

DOMAIN="surehomecare.id"
API_DOMAIN="api.surehomecare.id"
VPS_IP="148.230.99.217"

echo "=== Quick Setup untuk $DOMAIN ==="

# Verifikasi DNS propagation
echo "Checking DNS propagation..."
while true; do
    MAIN_IP=$(dig +short $DOMAIN @8.8.8.8 | tail -n1)
    API_IP=$(dig +short $API_DOMAIN @8.8.8.8 | tail -n1)
    
    if [ "$MAIN_IP" = "$VPS_IP" ] && [ "$API_IP" = "$VPS_IP" ]; then
        echo "✅ DNS propagation completed!"
        break
    else
        echo "⏳ Waiting for DNS propagation... (Current: $MAIN_IP, $API_IP)"
        echo "Expected: $VPS_IP"
        echo "Configure your DNS records first:"
        echo "A    @      $VPS_IP"
        echo "A    www    $VPS_IP" 
        echo "A    api    $VPS_IP"
        sleep 30
    fi
done

# Setup Nginx configuration
echo "Setting up Nginx configuration..."
cp /root/nginx-config.conf /etc/nginx/sites-available/$DOMAIN
ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/

# Remove default nginx config
rm -f /etc/nginx/sites-enabled/default

# Test nginx config
nginx -t

# Restart nginx
systemctl restart nginx

# Wait for nginx to start
sleep 5

# Setup SSL certificates
echo "Setting up SSL certificates..."

# Main domain
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN

# API domain
certbot --nginx -d $API_DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN

# Setup auto renewal
systemctl enable certbot.timer
systemctl start certbot.timer

# Test certificate renewal
certbot renew --dry-run

echo "✅ SSL certificates configured successfully!"

# Final nginx restart
systemctl restart nginx

# Setup PM2 startup
pm2 startup
echo "Run the command above to enable PM2 startup"

echo "=== Quick Setup Completed! ==="
echo ""
echo "🌐 Your domains:"
echo "   Main site: https://$DOMAIN"
echo "   API:       https://$API_DOMAIN"
echo ""
echo "📝 Next steps:"
echo "1. Upload your code to /var/www/surehomecare/"
echo "2. Configure environment variables"
echo "3. Run database setup"
echo "4. Start your application with PM2"
echo "5. Access admin panel at https://$DOMAIN/login"
echo ""
echo "🔑 Default admin login:"
echo "   Username: admin@surehomecare.id"
echo "   Password: Admin123!@#"
echo ""
# Panduan Deployment Bidan Care ke VPS Hostinger

## Informasi VPS
- **Domain**: surehomecare.id
- **VPS IP**: 148.230.99.217
- **OS**: AlmaLinux 10
- **Spek**: 2 CPU, 8GB RAM, 100GB Storage

## Arsitektur Deployment
```
Domain Structure:
├── surehomecare.id → Frontend Admin (Next.js)
├── api.surehomecare.id → Backend API (Node.js/Express)
└── Backend running on port 3002 (internal)
```

## Tahap 1: Setup DNS Domain

### 1. Konfigurasi DNS di Hostinger/Domain Provider
Tambahkan record DNS berikut:

```
Type    Name    Value               TTL
A       @       148.230.99.217      14400
A       www     148.230.99.217      14400
A       api     148.230.99.217      14400
CNAME   *       surehomecare.id     14400
```

### 2. Verifikasi DNS
```bash
# Test domain propagation
nslookup surehomecare.id
nslookup api.surehomecare.id
```

## Tahap 2: Setup VPS Environment

### 1. Login ke VPS
```bash
ssh root@148.230.99.217
```

### 2. Upload dan jalankan setup script
```bash
# Upload file setup dari local
scp deployment/vps-setup.sh root@148.230.99.217:/root/

# Jalankan setup
chmod +x /root/vps-setup.sh
./vps-setup.sh
```

### 3. Setup MySQL Database
```bash
# Login ke MySQL sebagai root
mysql -u root -p

# Jalankan database setup
source /root/database-setup.sql

# Verifikasi
SHOW DATABASES;
SELECT User, Host FROM mysql.user WHERE User='bidan_care_user';
```

## Tahap 3: Konfigurasi Nginx

### 1. Setup Nginx configuration
```bash
# Copy nginx config
cp deployment/nginx-config.conf /etc/nginx/sites-available/surehomecare.id

# Enable site
ln -s /etc/nginx/sites-available/surehomecare.id /etc/nginx/sites-enabled/

# Test configuration
nginx -t

# Restart Nginx
systemctl restart nginx
```

## Tahap 4: Setup SSL Certificates

### 1. Obtain SSL certificates
```bash
# Untuk domain utama
certbot --nginx -d surehomecare.id -d www.surehomecare.id

# Untuk API subdomain
certbot --nginx -d api.surehomecare.id

# Setup auto renewal
systemctl enable certbot.timer
systemctl start certbot.timer
```

### 2. Verifikasi SSL
```bash
# Test renewal
certbot renew --dry-run

# Check certificates
certbot certificates
```

## Tahap 5: Deploy Aplikasi

### 1. Setup Environment Variables
```bash
# Copy environment files
cp deployment/.env.production.server /var/www/surehomecare/backend/.env
cp deployment/.env.production.admin /var/www/surehomecare/frontend/.env.production

# Edit dengan informasi yang benar
nano /var/www/surehomecare/backend/.env
```

### 2. Deploy Manual (Pertama kali)
```bash
# Jalankan script deployment manual
chmod +x deployment/deploy-manual.sh
./deployment/deploy-manual.sh
```

### 3. Setup Database
```bash
cd /var/www/surehomecare/backend
node setup-database.js
```

## Tahap 6: Setup CI/CD (GitHub Actions)

### 1. Setup GitHub Repository
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/USERNAME/surehomecare.git
git push -u origin main
```

### 2. Setup GitHub Secrets
Di GitHub repository settings → Secrets and variables → Actions, tambahkan:

```
VPS_HOST = 148.230.99.217
VPS_USERNAME = root
VPS_SSH_KEY = (SSH private key content)
```

### 3. Generate SSH Key untuk GitHub Actions
```bash
# Generate key pair di local
ssh-keygen -t rsa -b 4096 -C "github-actions" -f ~/.ssh/github_actions

# Copy public key ke VPS
ssh-copy-id -i ~/.ssh/github_actions.pub root@148.230.99.217

# Ambil private key untuk GitHub Secret
cat ~/.ssh/github_actions
```

## Tahap 7: Setup Email Service

### 1. Konfigurasi Email di Hostinger
- Login ke hPanel Hostinger
- Buat email account: noreply@surehomecare.id
- Catat SMTP settings

### 2. Update Environment Variables
```bash
nano /var/www/surehomecare/backend/.env

# Update with actual email settings:
NODEMAILER_SENDER_EMAIL="noreply@surehomecare.id"
NODEMAILER_SENDER_PASSWORD="your_email_password"
NODEMAILER_SENDER_HOST="mail.surehomecare.id"
```

## Verifikasi Deployment

### 1. Test Backend API
```bash
curl https://api.surehomecare.id/api/admin
```

### 2. Test Frontend
```bash
curl https://surehomecare.id
```

### 3. Test Database Connection
```bash
cd /var/www/surehomecare/backend
node -e "const db = require('./config/database'); db.authenticate().then(() => console.log('DB Connected')).catch(console.error)"
```

### 4. Check PM2 Status
```bash
pm2 status
pm2 logs bidan-care-backend
```

## Login Admin Default

Setelah deployment berhasil:
- **URL**: https://surehomecare.id/login
- **Username**: admin@surehomecare.id
- **Password**: Admin123!@#

**PENTING**: Ganti password default setelah login pertama!

## Troubleshooting

### 1. Service tidak jalan
```bash
# Restart semua services
systemctl restart nginx
pm2 restart all

# Check logs
journalctl -u nginx
pm2 logs bidan-care-backend
```

### 2. Database connection error
```bash
# Check MySQL status
systemctl status mysqld

# Test connection
mysql -u bidan_care_user -p bidan_care
```

### 3. SSL issues
```bash
# Renew certificates
certbot renew

# Check certificate status
openssl s_client -connect surehomecare.id:443 -servername surehomecare.id
```

### 4. Deployment rollback
```bash
# List available backups
ls -la /var/backups/surehomecare/

# Restore from backup
cp -r /var/backups/surehomecare/BACKUP_TIMESTAMP/backend/* /var/www/surehomecare/backend/
cp -r /var/backups/surehomecare/BACKUP_TIMESTAMP/frontend/* /var/www/surehomecare/frontend/
pm2 restart bidan-care-backend
```

## Monitoring & Maintenance

### 1. Setup log rotation
```bash
# Create logrotate config
cat > /etc/logrotate.d/surehomecare << EOF
/var/log/pm2/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    copytruncate
}
EOF
```

### 2. Setup database backup
```bash
# Create backup script
cat > /root/backup-db.sh << EOF
#!/bin/bash
mysqldump -u bidan_care_user -p'BiDaN_CaRe_2025!@#' bidan_care > /var/backups/db/bidan_care_\$(date +%Y%m%d_%H%M%S).sql
find /var/backups/db/ -name "*.sql" -mtime +7 -delete
EOF

chmod +x /root/backup-db.sh

# Add to crontab (daily backup at 2 AM)
echo "0 2 * * * /root/backup-db.sh" | crontab -
```

### 3. Monitor disk usage
```bash
# Check disk usage
df -h

# Check large files
du -h --max-depth=1 /var/www/surehomecare/
```

## Next Steps untuk Production Ready

1. **Security Hardening**:
   - Setup fail2ban
   - Configure proper firewall rules
   - Regular security updates

2. **Monitoring**:
   - Setup Prometheus + Grafana
   - Configure alerts
   - Application performance monitoring

3. **Backup Strategy**:
   - Automated database backups
   - Code backup to external storage
   - Disaster recovery plan

4. **Load Balancing** (jika traffic tinggi):
   - Multiple backend instances
   - Redis session storage
   - CDN untuk static assets
# 🚀 Deploy Faldy Portfolio ke Railway

## Link Repository
GitHub: https://github.com/faldysanger12/portofolio

## Prerequisites
1. Akun Railway (https://railway.app)
2. Git repository sudah ter-push ke GitHub

## Steps untuk Deploy:

### 1. Build aplikasi
```bash
chmod +x build.sh
./build.sh
```

### 2. Push ke Git Repository
```bash
git add .
git commit -m "🚀 Ready for Railway deployment"
git push origin main
```

### 3. Deploy di Railway
1. Login ke https://railway.app
2. Click "New Project"
3. Choose "Deploy from GitHub repo"
4. Select repository: portofolio
5. Railway akan otomatis detect Dockerfile
6. Click "Deploy"

### 4. Custom Domain (Optional)
1. Di Railway dashboard, click project
2. Go to "Settings" > "Domains"
3. Add custom domain atau gunakan railway.app subdomain

## File Structure untuk Railway
```
├── Dockerfile          # Container configuration
├── nginx.conf          # Web server configuration
├── build.sh            # Build script
├── build/web/          # Flutter web build (generated)
├── lib/                # Flutter source code
└── pubspec.yaml        # Dependencies
```

## Environment Variables
Tidak ada environment variables khusus diperlukan untuk project ini.

## Monitoring
- Railway akan provide URL untuk mengakses aplikasi
- Check logs di Railway dashboard untuk troubleshooting
- URL akan seperti: https://portofolio-production-xxxx.up.railway.app

## Troubleshooting
1. Jika build gagal, check Flutter version compatibility
2. Jika assets tidak load, check nginx.conf configuration
3. Jika routing tidak work, pastikan nginx fallback ke index.html

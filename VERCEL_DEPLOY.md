# 🚀 Deploy Faldy Portfolio ke Vercel (100% GRATIS)

## Link Repository
GitHub: https://github.com/faldysanger12/portofolio

## Steps untuk Deploy di Vercel:

### 1. Buka Vercel
- Kunjungi: https://vercel.com
- Login dengan GitHub account

### 2. Import Project
- Click "New Project"
- Import dari GitHub: "faldysanger12/portofolio"
- Vercel akan auto-detect sebagai static site

### 3. Build Settings
- Framework: Other
- Build Command: `flutter build web --release`
- Output Directory: `build/web`
- Install Command: (kosongkan)

### 4. Deploy
- Click "Deploy"
- Vercel akan otomatis build dan deploy
- Dapat URL seperti: https://portofolio-xxx.vercel.app

### 5. Custom Domain (Optional)
- Di dashboard Vercel > Settings > Domains
- Add custom domain gratis

## Kelebihan Vercel:
✅ 100% Gratis selamanya
✅ Unlimited bandwidth
✅ Global CDN super cepat
✅ Auto deployment setiap git push
✅ SSL certificate otomatis
✅ Custom domains gratis

## Troubleshooting:
- Jika build gagal, pastikan `build/web` folder ada
- Vercel akan auto-detect Flutter web project

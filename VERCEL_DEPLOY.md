# 🚀 Deploy Faldy Portfolio ke Vercel (100% GRATIS) - STATIC FILES

## Link Repository
GitHub: https://github.com/faldysanger12/portofolio

## ⚠️ PENTING: Deploy Static Files (Bukan Build di Vercel)

Karena Vercel tidak support Flutter build secara native, kita deploy file static yang sudah di-build.

## Steps untuk Deploy di Vercel:

### Method 1: Vercel CLI (RECOMMENDED)

1. **Install Vercel CLI:**
   ```bash
   npm install -g vercel
   ```

2. **Login ke Vercel:**
   ```bash
   vercel login
   ```

3. **Deploy dari root project:**
   ```bash
   cd /path/to/your/flutter-project
   vercel --prod
   ```

4. **Follow prompts:**
   - Set up and deploy? **Y**
   - Which scope? Pilih account kamu
   - Link to existing project? **N** (untuk deploy pertama)
   - Project name: `faldy-portfolio`
   - Directory to deploy: **. (current directory)**

5. **Selesai! Dapat URL:**
   ```
   https://faldy-portfolio.vercel.app
   ```

### Method 2: Vercel Dashboard

1. **Buka Vercel:**
   - Kunjungi: https://vercel.com
   - Login dengan GitHub account

2. **Import Project:**
   - Click "New Project"
   - Import dari GitHub: "faldysanger12/portofolio"

3. **Build Settings (PENTING):**
   - Framework Preset: **Other**
   - Root Directory: **. (root)**
   - Build Command: **Leave empty** (kosongkan)
   - Output Directory: **. (root)**

4. **Deploy:**
   - Click "Deploy"
   - Vercel akan deploy file static langsung

## File yang Di-Deploy:

```
/ (root)
├── index.html          # Main Flutter web app
├── main.dart.js        # Compiled Dart code
├── flutter.js          # Flutter web framework
├── assets/             # App assets
├── canvaskit/          # Flutter renderer
├── vercel.json         # Config untuk SPA routing
└── .vercelignore       # Exclude development files
```

## Kelebihan Vercel:
✅ 100% Gratis selamanya
✅ Unlimited bandwidth
✅ Global CDN super cepat
✅ Auto deployment setiap git push
✅ SSL certificate otomatis
✅ Custom domains gratis

## Configuration Files:

**vercel.json** (SPA routing):
```json
{
    "routes": [
        {
            "src": "/(.*)",
            "dest": "/index.html"
        }
    ]
}
```

## Troubleshooting:
- ❌ Jika error "flutter: command not found" → Normal, kita deploy static files
- ✅ File `index.html` harus ada di root
- ✅ File dari `build/web/` sudah di-copy ke root
- ✅ `.vercelignore` exclude file development yang tidak perlu

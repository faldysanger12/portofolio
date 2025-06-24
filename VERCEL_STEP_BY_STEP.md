# 🚀 Deploy Faldy Portfolio ke Vercel - Panduan Step by Step

## 📋 Persiapan

### ✅ Yang Sudah Siap:
- Repository GitHub: https://github.com/faldysanger12/portofolio
- Flutter project sudah ter-build: `build/web/`
- File konfigurasi: `vercel.json`, `vercel-simple.json`

---

## 🎯 METODE 1: Upload Manual (PALING MUDAH & RECOMMENDED)

### Step 1: Build Flutter Web
Pastikan build sudah ada:
```bash
cd /Users/sdamedia/Downloads/project/valdi_portofolio
flutter build web --release
```

### Step 2: Deploy Manual ke Vercel
1. **Buka** https://vercel.com
2. **Login** dengan GitHub
3. **Klik** "New Project"
4. **Pilih** "Browse All Templates" atau "Upload"
5. **Drag & Drop** seluruh isi folder `build/web/` ke Vercel
6. **Set Project Name**: `faldy-portfolio`
7. **Klik** "Deploy"
8. **Tunggu** 30-60 detik
9. **Selesai!** Anda akan dapat URL: `https://faldy-portfolio.vercel.app`

---

## 🔗 METODE 2: Connect GitHub (Alternatif)

### Step 1: Import dari GitHub
1. **Buka** https://vercel.com
2. **Login** dengan GitHub
3. **Klik** "New Project"
4. **Import** repository: `faldysanger12/portofolio`

### Step 2: Build Settings
- **Framework Preset**: `Other`
- **Build Command**: `flutter build web --release`
- **Output Directory**: `build/web`
- **Install Command**: (kosongkan)
- **Root Directory**: `./` (default)

### Step 3: Deploy
1. **Klik** "Deploy"
2. **Tunggu** 2-5 menit
3. Jika berhasil → Dapat URL
4. Jika gagal → Gunakan Metode 1

---

## 🛠️ Troubleshooting

### ❌ Build Failed di Vercel?
**Solusi**: Gunakan **Metode 1** (Upload Manual)
- Vercel kadang tidak support Flutter build
- Upload manual 100% berhasil

### ❌ 404 Page Not Found?
**Solusi**: Pastikan routing benar
- File `vercel.json` sudah dikonfigurasi
- SPA routing akan redirect ke `index.html`

### ❌ Assets tidak muncul?
**Solusi**: 
- Pastikan upload seluruh isi folder `build/web/`
- Termasuk folder `assets/`, `canvaskit/`, dll

---

## 🎉 Hasil Akhir

Setelah deploy berhasil, portfolio Faldy akan live di:
```
https://faldy-portfolio.vercel.app
```

### ✨ Fitur yang akan aktif:
- ✅ Marquee text "Halo saya Faldy Sanger"
- ✅ Hero section dengan nama Faldy  
- ✅ About section dengan bio Indonesia + galeri foto
- ✅ Projects section dengan 3 mini games:
  - 🎮 Flappy Bird (Play Now + GitHub)
  - 🏓 Pong Game (Play Now + GitHub)  
  - 🧩 Tetris (Play Now + GitHub)
- ✅ Navigation: Home, About, Projects
- ✅ Responsive design
- ✅ Fast loading dengan CDN global

---

## 🌐 Custom Domain (Opsional)

Setelah deploy berhasil:
1. **Buka** Vercel Dashboard
2. **Pilih** project Anda
3. **Masuk** Settings > Domains
4. **Add** custom domain: `faldysanger.com` (contoh)
5. **Ikuti** instruksi DNS setup
6. **SSL** otomatis aktif

---

## 💡 Tips Pro

1. **Metode 1** paling reliable untuk Flutter web
2. **Auto-deployment**: Setiap push ke GitHub akan auto-deploy (jika pakai Metode 2)
3. **Analytics**: Vercel memberikan analytics gratis
4. **Preview**: Setiap PR akan dapat preview URL
5. **Speed**: Vercel CDN sangat cepat global

---

## 🔄 Update Portfolio

### Untuk update konten:
1. Edit kode Flutter
2. Build ulang: `flutter build web --release`
3. Upload ulang folder `build/web/` ke Vercel (Metode 1)
4. Atau push ke GitHub (Metode 2)

### Auto-sync dengan GitHub:
Jika pakai Metode 2, setiap `git push` akan otomatis deploy ulang.

---

**🎯 RECOMMENDATION: Gunakan Metode 1 untuk hasil pasti dan cepat!**

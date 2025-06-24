#!/bin/bash

echo "🔥 Building Faldy's Portfolio for Railway..."

# Clean previous builds
flutter clean

# Get dependencies
flutter pub get

# Build for web with optimizations
flutter build web --release --web-renderer html --dart-define=FLUTTER_WEB_USE_SKIA=false

echo "✅ Build completed! Ready for Railway deployment."
echo "📁 Build files are in: build/web/"
echo "🚀 Next steps:"
echo "   1. git add ."
echo "   2. git commit -m 'Deploy to Railway'"
echo "   3. git push origin main"
echo "   4. Deploy on Railway: https://railway.app"

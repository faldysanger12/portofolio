#!/bin/bash

echo "🚀 Building optimized Flutter web app..."

# Clean previous build
flutter clean

# Get dependencies
flutter pub get

# Build with optimization flags
flutter build web \
  --release \
  --web-renderer canvaskit \
  --tree-shake-icons \
  --dart-define=FLUTTER_WEB_AUTO_DETECT=true

echo "✅ Optimized build completed!"
echo "📁 Output: build/web/"

# Show build size
echo "📊 Build size:"
if [ -d "build/web" ]; then
    du -sh build/web/
else
    echo "Build directory not found!"
    exit 1
fi

# Copy optimized files to root for deployment
echo "📋 Preparing files for deployment..."
if [ -f "./prepare-static.sh" ]; then
    ./prepare-static.sh
else
    echo "Manual copy of build files..."
    cp -r build/web/* .
fi

echo "🎉 Ready for deployment!"

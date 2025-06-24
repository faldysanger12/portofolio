#!/bin/bash

echo "🚀 Deploying Flutter Web Portfolio with Fixed White Screen Issue"
echo "================================================================"

# Clean and rebuild
echo "📦 Cleaning previous build..."
flutter clean

echo "📥 Getting dependencies..."
flutter pub get

echo "🔨 Building optimized web app..."
flutter build web --release --web-renderer canvaskit --tree-shake-icons

echo "📋 Build completed! Deploy the build/web folder to your hosting platform."
echo ""
echo "💡 For Vercel:"
echo "   1. Copy contents of build/web/ to a new folder"
echo "   2. Deploy that folder (not the Flutter source code)"
echo "   3. Make sure vercel.json is in the root of the deployed folder"
echo ""
echo "🎯 Key fixes applied:"
echo "   ✅ Modern Flutter loader API (no deprecated warnings)"
echo "   ✅ Proper loading screen with container element"
echo "   ✅ Multiple fallback mechanisms to hide loading"
echo "   ✅ Fixed favicon reference"
echo "   ✅ Updated manifest.json"
echo "   ✅ Optimized with tree-shaking and CanvasKit renderer"
echo ""
echo "🌐 Your site should now load properly without white screen!"

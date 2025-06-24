#!/bin/bash

# Vercel Build Script for Flutter Web
echo "🚀 Starting Flutter Web Build for Vercel..."

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "📦 Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable
    export PATH="$PATH:`pwd`/flutter/bin"
fi

# Get Flutter version
flutter --version

# Enable web support
flutter config --enable-web

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Build for web with optimization
echo "🏗️ Building Flutter web app..."
flutter build web --release --web-renderer canvaskit --source-maps

# Copy build files to Vercel output directory
echo "📋 Copying build files..."
mkdir -p public
cp -r build/web/* public/

echo "✅ Build completed successfully!"
echo "📁 Files are ready in the public directory"

# List the contents to verify
ls -la public/

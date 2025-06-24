#!/bin/bash

# Simple static deployment script for Vercel
# This script copies the pre-built files to the output directory

echo "🚀 Deploying pre-built Flutter web files..."

# Create output directory
mkdir -p public

# Copy pre-built web files
if [ -d "build/web" ]; then
    echo "📋 Copying Flutter web build files..."
    cp -r build/web/* public/
    
    echo "✅ Flutter web files copied successfully!"
    echo "📁 Output directory contents:"
    ls -la public/
else
    echo "❌ build/web directory not found!"
    echo "🔨 Building Flutter web app..."
    
    # Try to build if flutter is available
    if command -v flutter &> /dev/null; then
        flutter config --enable-web
        flutter pub get
        flutter build web --release --web-renderer canvaskit
        cp -r build/web/* public/
        echo "✅ Flutter build and deployment completed!"
    else
        echo "❌ Flutter not found. Please ensure Flutter is installed."
        exit 1
    fi
fi

echo "🎉 Deployment completed successfully!"

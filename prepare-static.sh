#!/bin/bash

# Copy Flutter web build files to root for static deployment
echo "Copying Flutter web build files to root..."

# Copy all files from build/web to root (excluding some that might conflict)
cp -r build/web/* .

# Ensure index.html is in root
if [ ! -f "index.html" ]; then
    echo "Error: index.html not found after copy"
    exit 1
fi

echo "Files copied successfully for static deployment"
echo "Ready for Vercel deployment!"

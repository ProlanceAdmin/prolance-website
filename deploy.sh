#!/bin/bash

# Safe Deployment Script for Prolance Website
# This script ONLY copies new files, never deletes existing ones

echo "🚀 Prolance Website Deployment Script"
echo "====================================="

# Safety check: Ensure we're in the right directory
if [ ! -f "CNAME" ] || [ ! -d ".git" ]; then
    echo "❌ Error: Run this from the prolance-website directory"
    exit 1
fi

# Check if prolance-website-dev exists
if [ ! -d "../prolance-website-dev" ]; then
    echo "❌ Error: prolance-website-dev not found in parent directory"
    exit 1
fi

echo "⚠️  CRITICAL: Before proceeding, ensure vite.config.ts in prolance-website-dev has:"
echo "   base: '/'"
echo "   NOT base: '/prolance-website/'"
echo ""
read -p "Has vite.config.ts been fixed? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "📝 Please fix vite.config.ts first!"
    echo "   Edit: ../prolance-website-dev/vite.config.ts"
    echo "   Change: base: mode === 'production' ? '/prolance-website/' : '/'"
    echo "   To: base: '/'"
    exit 1
fi

# Build the project
echo "📦 Building project..."
cd ../prolance-website-dev
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Copy files (SAFE - only overwrites, doesn't delete)
echo "📂 Copying build files..."
cd ../prolance-website

# Copy all files from dist, preserving structure
cp -r ../prolance-website-dev/dist/* .

# Ensure CNAME still exists
if [ ! -f "CNAME" ]; then
    echo "www.prolance.com.au" > CNAME
fi

# Show what changed
echo "📝 Changes to be deployed:"
git status --short

# Commit and deploy
read -p "Deploy these changes? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    git add .
    git commit -m "Deploy: Update website $(date +'%Y-%m-%d %H:%M:%S')"
    
    if [ $? -eq 0 ]; then
        git push origin main
        echo "✅ Deployment successful!"
        echo "🌐 Site will update at https://www.prolance.com.au in ~2 minutes"
    else
        echo "ℹ️  No changes to deploy"
    fi
else
    echo "❌ Deployment cancelled"
fi
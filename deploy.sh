#!/bin/bash

# OpenClaw Course Deployment Script
# Run this to deploy to GitHub Pages

echo "🚀 OpenClaw Course Deployment Script"
echo "====================================="

# Check if we're in the right directory
if [ ! -f "openclaw-course.html" ]; then
    echo "❌ Error: Must run from openclaw-course directory"
    exit 1
fi

# Check Git status
echo "📊 Checking Git status..."
git status

echo ""
echo "📝 Deployment Instructions:"
echo "==========================="
echo ""
echo "1. Create a new repository on GitHub:"
echo "   - Go to https://github.com/new"
echo "   - Repository name: openclaw-course"
echo "   - Description: Interactive course explaining OpenClaw internals"
echo "   - Public repository"
echo "   - DO NOT initialize with README, .gitignore, or license"
echo ""
echo "2. Connect local repository to GitHub:"
echo "   Run these commands:"
echo ""
echo "   git remote add origin https://github.com/tianx-dev/openclaw-course.git"
echo "   git push -u origin main"
echo ""
echo "3. Enable GitHub Pages:"
echo "   - Go to repository Settings → Pages"
echo "   - Source: Deploy from a branch"
echo "   - Branch: main"
echo "   - Folder: / (root)"
echo "   - Save"
echo ""
echo "4. Your course will be available at:"
echo "   https://tianx-dev.github.io/openclaw-course/"
echo ""
echo "5. (Optional) Set up custom domain if desired"
echo ""
echo "📚 Need help? Check GitHub documentation:"
echo "   - Creating a repository: https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository"
echo "   - GitHub Pages: https://docs.github.com/en/pages/getting-started-with-github-pages"
echo ""
echo "🎉 Done! Your interactive OpenClaw course will be live in a few minutes."
# GitHub Deployment Instructions

Follow these steps to host your OpenClaw course on GitHub:

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Fill in:
   - **Repository name**: `openclaw-course`
   - **Description**: `Interactive course explaining OpenClaw internals`
   - **Visibility**: Public
   - **DO NOT** initialize with README, .gitignore, or license
3. Click "Create repository"

## Step 2: Connect and Push

Run these commands in your terminal:

```bash
# Navigate to the course directory
cd openclaw-course

# Add your GitHub repository as remote
git remote add origin https://github.com/tianx-dev/openclaw-course.git

# Push to GitHub
git push -u origin main
```

## Step 3: Enable GitHub Pages

1. Go to your repository: https://github.com/tianx-dev/openclaw-course
2. Click **Settings** → **Pages** (left sidebar)
3. Configure:
   - **Source**: Deploy from a branch
   - **Branch**: `main`
   - **Folder**: `/` (root)
4. Click **Save**

## Step 4: Wait and Access

- GitHub Pages will build and deploy (takes 1-2 minutes)
- Your course will be available at: **https://tianx-dev.github.io/openclaw-course/**

## Step 5: Verify Deployment

1. Visit https://tianx-dev.github.io/openclaw-course/
2. You should see the interactive course
3. Test all features: scrolling, quizzes, navigation

## Troubleshooting

### If you get authentication errors:
```bash
# Use SSH instead of HTTPS
git remote set-url origin git@github.com:tianx-dev/openclaw-course.git
git push -u origin main
```

### If GitHub Pages doesn't show:
- Wait 2-3 minutes for build to complete
- Check repository Settings → Pages for build status
- Ensure `_config.yml` and `index.html` are in root

### To update the course later:
```bash
# Make your changes, then:
git add .
git commit -m "Update course content"
git push
```

## Files Included

The repository contains:
- `openclaw-course.html` - Main interactive course
- `index.html` - Landing page redirect
- `_config.yml` - GitHub Pages configuration
- `README.md` - Project documentation
- `LICENSE` - MIT License
- This deployment guide

## Need Help?

- GitHub Docs: https://docs.github.com
- GitHub Pages: https://pages.github.com
- Contact: Your GitHub account email

---

**Your interactive OpenClaw course will help others understand AI assistant architecture!** 🎓
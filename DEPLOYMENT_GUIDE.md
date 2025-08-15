# Prolance Website Deployment Guide

## ⚠️ CRITICAL: Root Cause of Deployment Issues

The main issue causing white pages is that `vite.config.ts` in prolance-website-dev is configured for GitHub Pages subdirectory deployment (`/prolance-website/`) but we're using a custom domain that requires root paths (`/`).

## 🔧 PERMANENT FIX (Do this ONCE in prolance-website-dev)

1. **Edit vite.config.ts** in prolance-website-dev:
```typescript
// CHANGE THIS:
base: mode === 'production' ? '/prolance-website/' : '/',

// TO THIS:
base: '/',
```

2. **Delete all old deployment scripts** in prolance-website-dev:
```bash
rm build-and-copy-to-public.sh deploy-simple.sh deploy-to-public-repo.sh
```

## 📦 Deployment Process

After fixing vite.config.ts, use this simple process:

### Option 1: Manual Deployment
```bash
# In prolance-website-dev
npm run build

# Copy ONLY the changed files to prolance-website
cp -r dist/* ../prolance-website/

# In prolance-website
git add .
git commit -m "Deploy: Update website $(date +'%Y-%m-%d')"
git push
```

### Option 2: Use the safe deployment script (deploy.sh)
See deploy.sh in this repository.

## ❌ What NOT to do

1. NEVER delete all files in prolance-website
2. NEVER build with base: '/prolance-website/' for custom domain
3. NEVER use multiple confusing deployment scripts

## ✅ Checklist Before Deployment

- [ ] vite.config.ts has `base: '/'`
- [ ] CNAME file exists in prolance-website
- [ ] Build completes without errors
- [ ] Test locally with `npm run preview`

## 🚨 If Something Goes Wrong

The last known working commit is: 9f8bd4c
Restore with: `git reset --hard 9f8bd4c && git push --force`
# Deployment Notes for www.prolance.com.au

## Current Setup
This repository hosts the production build of the Prolance website at www.prolance.com.au using GitHub Pages.

## Important: Custom Domain Configuration
Since we're using a custom domain (www.prolance.com.au) instead of the GitHub Pages subdomain:
- The `CNAME` file must contain: `www.prolance.com.au`
- All asset paths in the build must use root-relative paths (e.g., `/assets/`) NOT subdirectory paths (e.g., `/prolance-website/assets/`)

## Build Process
When rebuilding from `prolance-website-dev`:

1. **Update vite.config.ts** to use root path:
   ```typescript
   base: '/',  // NOT base: '/prolance-website/'
   ```

2. **Build the project**:
   ```bash
   npm run build
   ```

3. **Copy build files** to this repository:
   ```bash
   rm -rf ../prolance-website/*
   cp -r dist/* ../prolance-website/
   echo "www.prolance.com.au" > ../prolance-website/CNAME
   ```

4. **Commit and push**

## Temporary Fix (Currently Active)
Due to the JavaScript being built with `/prolance-website/` paths, we've created a duplicate asset structure:
- `/assets/` - Where the HTML looks for assets
- `/prolance-website/assets/` - Where the JavaScript looks for assets

This duplication ensures the site works but should be removed after a proper rebuild.
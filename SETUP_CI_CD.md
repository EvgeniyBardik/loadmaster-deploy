# CI/CD Setup Instructions

## ✅ What's Been Configured

### 1. Application Repositories (loadmaster-api, loadmaster-web, loadmaster-worker)
- ✅ CI workflows added that build and push Docker images to GitHub Container Registry
- ✅ Automatic deployment trigger to `loadmaster-deploy` repository

### 2. Deploy Repository (loadmaster-deploy)
- ✅ Deploy workflows updated to use images from GitHub Container Registry
- ✅ `docker-compose.yml` updated to use images from registry

## 🔧 Required Setup Steps

### Step 1: Add DEPLOY_TOKEN Secret

For each application repository (`loadmaster-api`, `loadmaster-web`, `loadmaster-worker`):

1. Go to GitHub → Your repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `DEPLOY_TOKEN`
4. Value: Create a Personal Access Token (PAT) with:
   - **Fine-grained token** with `workflow` permission for `loadmaster-deploy` repository
   - Or **Classic token** with `repo` scope
5. Save the secret

**Quick way to create token:**
- GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens
- Generate new token
- Select `loadmaster-deploy` repository
- Grant `workflow` permission
- Copy token and add as `DEPLOY_TOKEN` secret in each app repository

### Step 2: Commit and Push Workflows

Workflows have been copied to your local repositories. Commit and push them:

```bash
# For loadmaster-api
cd /home/yevhen/Documents/loadmaster-api
git add .github/workflows/ci.yml
git commit -m "Add CI/CD workflow with Docker registry push"
git push

# For loadmaster-web
cd /home/yevhen/Documents/loadmaster-web
git add .github/workflows/ci.yml
git commit -m "Add CI/CD workflow with Docker registry push"
git push

# For loadmaster-worker
cd /home/yevhen/Documents/loadmaster-worker
git add .github/workflows/ci.yml
git commit -m "Add CI/CD workflow with Docker registry push"
git push
```

### Step 3: Commit Deploy Repository Changes

```bash
cd /home/yevhen/Documents/loadmaster-deploy
git add .github/workflows/ docker-compose.yml
git commit -m "Update workflows to use images from GitHub Container Registry"
git push
```

## 🚀 How It Works Now

1. **You push code** to `loadmaster-api`, `loadmaster-web`, or `loadmaster-worker`
2. **CI workflow runs** in that repository:
   - Installs dependencies
   - Runs tests and linter
   - Builds the project
   - Builds Docker image
   - Pushes image to `ghcr.io/evgeniybardik/loadmaster-{api|web|worker}:latest`
3. **Deployment is triggered** automatically in `loadmaster-deploy`
4. **Deploy workflow runs**:
   - Pulls the new image from registry
   - Deploys using the image

## 📦 Image Locations

Images are stored in GitHub Container Registry:
- Backend: `ghcr.io/evgeniybardik/loadmaster-api:latest`
- Frontend: `ghcr.io/evgeniybardik/loadmaster-web:latest`
- Worker: `ghcr.io/evgeniybardik/loadmaster-worker:latest`

## 🔍 Manual Deployment

You can also trigger deployment manually:
- Go to `loadmaster-deploy` repository → Actions
- Select "Deploy Backend", "Deploy Frontend", or "Deploy Worker"
- Click "Run workflow"
- Optionally specify a different image tag

## 📝 Notes

- Images are only pushed on push to `main` branch (not on PRs)
- Deployment is automatically triggered only on push to `main` branch
- For other branches, images are built but not pushed/deployed automatically
- You can manually trigger deployment with any image tag


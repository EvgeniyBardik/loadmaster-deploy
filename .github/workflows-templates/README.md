# GitHub Actions Workflows for Application Repositories

These workflow files need to be copied to the corresponding repositories:

## For `loadmaster-api` repository:

1. Create `.github/workflows/` directory in the repository root
2. Copy `ci-backend.yml` as `.github/workflows/ci.yml`

## For `loadmaster-web` repository:

1. Create `.github/workflows/` directory in the repository root
2. Copy `ci-frontend.yml` as `.github/workflows/ci.yml`

## For `loadmaster-worker` repository:

1. Create `.github/workflows/` directory in the repository root
2. Copy `ci-worker.yml` as `.github/workflows/ci.yml`

## What these workflows do:

- ✅ Automatically trigger on push to `main` or `develop` branches
- ✅ Trigger on Pull Request creation
- ✅ Install dependencies
- ✅ Run linter and tests (if available)
- ✅ Build the project
- ✅ Build and push Docker image to GitHub Container Registry (ghcr.io)
- ✅ Automatically trigger deployment in `loadmaster-deploy` repository

## Setup Requirements

### For each application repository:

1. **GitHub Container Registry**: Images will be pushed to `ghcr.io/evgeniybardik/loadmaster-{api|web|worker}`
   - No additional setup needed - uses `GITHUB_TOKEN` automatically

2. **Deploy Token** (for automatic deployment):
   - Go to GitHub Settings → Developer settings → Personal access tokens → Fine-grained tokens
   - Create a token with `workflow` permission for `loadmaster-deploy` repository
   - Add it as a secret named `DEPLOY_TOKEN` in each application repository:
     - `loadmaster-api` → Settings → Secrets and variables → Actions → New repository secret
     - `loadmaster-web` → Settings → Secrets and variables → Actions → New repository secret
     - `loadmaster-worker` → Settings → Secrets and variables → Actions → New repository secret

## How it works:

1. **Push to application repository** → CI workflow runs
2. **Build and test** → Code is validated
3. **Build Docker image** → Image is created
4. **Push to registry** → Image is pushed to `ghcr.io`
5. **Trigger deployment** → `loadmaster-deploy` repository receives notification
6. **Deploy workflow runs** → Pulls image from registry and deploys

After adding workflow files to the repositories, code will automatically rebuild and deploy on every push to `main` branch!


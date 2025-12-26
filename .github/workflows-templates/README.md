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
- ✅ Build Docker image

After adding workflow files to the repositories, code will automatically rebuild on every push!


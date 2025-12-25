# LoadMaster Deploy

Infrastructure and deployment configuration for LoadMaster.

## Contents

- Docker Compose files
- Kubernetes manifests
- GitHub Actions CI/CD
- Deployment scripts
- Monitoring setup

## Quick Start (Docker Compose)

```bash
# Development
docker-compose -f docker-compose.dev.yml up

# Production
docker-compose up -d
```

## Services

- Frontend: http://localhost:3000
- Backend: http://localhost:4000
- RabbitMQ Management: http://localhost:15672
- PostgreSQL: localhost:5432

## Kubernetes Deployment

```bash
# Apply manifests
kubectl apply -f k8s/

# Check status
kubectl get pods -n loadmaster
```

## GitHub Actions

Automated CI/CD pipelines:
- Build & Test
- Docker Image Build
- Deploy to Staging
- Deploy to Production

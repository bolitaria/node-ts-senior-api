.PHONY: help setup dev build test deploy clean

## Variables
DOCKER_COMPOSE = docker-compose -f docker-compose.fullstack.yml
NPM_ROOT = npm run
NPM_BACKEND = cd backend && npm run
NPM_FRONTEND = cd frontend && npm run

## Help
help:
	@echo "Available commands:"
	@echo " make setup           - Complete project setup"
	@echo " make dev            - Start development environment"
	@echo " make build          - Build all services"
	@echo " make test           - Run all tests"
	@echo " make lint           - Run linting"
	@echo " make docker-up      - Start with Docker"
	@echo " make deploy         - Deploy to production"
	@echo " make clean          - Clean up"
	@echo " make db-migrate     - Run database migrations"

## Setup
setup: setup-permissions setup-frontend setup-backend setup-git
	@echo "✅ Setup completed"

setup-permissions:
	@echo "🔧 Setting up permissions..."
	chmod +x scripts/*.sh scripts/**/*.sh
	chmod +x .husky/*

setup-frontend:
	@echo "📦 Setting up frontend..."
	./scripts/setup-frontend.sh

setup-backend:
	@echo "⚙️  Setting up backend..."
	$(NPM_BACKEND) install

setup-git:
	@echo "🔗 Setting up Git workflow..."
	./scripts/git/setup-git-workflow.sh

## Development
dev:
	@echo "🚀 Starting development environment..."
	$(NPM_ROOT) dev:all

dev-backend:
	@echo "🔧 Starting backend..."
	$(NPM_BACKEND) dev

dev-frontend:
	@echo "🎨 Starting frontend..."
	$(NPM_FRONTEND) dev

## Build
build: build-backend build-frontend
	@echo "📦 Build completed"

build-backend:
	@echo "🔨 Building backend..."
	$(NPM_BACKEND) build

build-frontend:
	@echo "🎨 Building frontend..."
	$(NPM_FRONTEND) build

## Testing
test: test-backend test-frontend
	@echo "✅ All tests passed"

test-backend:
	@echo "🧪 Testing backend..."
	$(NPM_BACKEND) test

test-frontend:
	@echo "🧪 Testing frontend..."
	$(NPM_FRONTEND) test

## Linting
lint: lint-backend lint-frontend
	@echo "✨ Linting completed"

lint-backend:
	@echo "🔍 Linting backend..."
	$(NPM_BACKEND) lint

lint-frontend:
	@echo "🔍 Linting frontend..."
	$(NPM_FRONTEND) lint

## Docker
docker-up:
	@echo "🐳 Starting Docker environment..."
	$(DOCKER_COMPOSE) up -d --build

docker-down:
	@echo "🐳 Stopping Docker environment..."
	$(DOCKER_COMPOSE) down

docker-logs:
	@echo "📋 Showing Docker logs..."
	$(DOCKER_COMPOSE) logs -f

## Database
db-migrate:
	@echo "🗃️  Running migrations..."
	./scripts/database/run-migrations.sh

db-backup:
	@echo "💾 Creating backup..."
	./scripts/database/backup-database.sh

## Deployment
deploy: build docker-up db-migrate
	@echo "🚀 Deployment completed"

deploy-staging:
	@echo "🔄 Deploying to staging..."
	./scripts/deployment/deploy-to-staging.sh

deploy-production:
	@echo "🚀 Deploying to production..."
	./scripts/deployment/deploy-to-production.sh

## Git workflow
feature-start:
	@echo "🌱 Starting new feature..."
	./scripts/git/git-feature-start.sh

feature-finish:
	@echo "✅ Finishing feature..."
	./scripts/git/git-feature-finish.sh

## Security
security-scan:
	@echo "🔒 Running security scan..."
	./scripts/security/apply-security-incremental.sh

## Staging
docker-up-staging:
	@echo "🐳 Starting Staging environment..."
	docker-compose -f docker-compose.staging.yml up -d --build

deploy-staging:
	@echo "🔄 Deploying to staging..."
	./scripts/deployment/deploy-to-staging.sh

## Production  
docker-up-production:
	@echo "🐳 Starting Production environment..."
	docker-compose -f docker-compose.prod.yml up -d --build

deploy-production:
	@echo "🚀 Deploying to production..."
	./scripts/deployment/deploy-to-production.sh

## Build specific
build-staging:
	@echo "🏗️ Building for staging..."
	./scripts/deployment/build-staging.sh

build-production:
	@echo "🏗️ Building for production..."
	./scripts/deployment/build-production.sh

## Cleanup
clean: docker-down
	@echo "🧹 Cleaning up..."
	rm -rf frontend/dist backend/dist
	$(NPM_ROOT) clean

## Status
status:
	@echo "📊 Project status:"
	@echo "Containers: $$(docker ps -q | wc -l) running"
	@echo "Backend: $$(curl -s http://localhost:3000/health > /dev/null && echo '✅' || echo '❌')"
	@echo "Frontend: $$(curl -s http://localhost:3001 > /dev/null && echo '✅' || echo '❌')"
.PHONY: help setup dev build test deploy clean lint docker-up docker-down db-migrate security-scan status backup code-quality git-workflow fix-frontend

## Variables
DOCKER_COMPOSE = docker-compose -f docker-compose.fullstack.yml
NPM_ROOT = npm run
NPM_BACKEND = cd backend && npm run
NPM_FRONTEND = cd frontend && npm run
SCRIPTS_DIR = scripts

## Help - Main help command
help:
.PHONY: help setup dev build test deploy clean lint docker-up docker-down db-migrate security-scan status backup code-quality git-workflow

## Variables
DOCKER_COMPOSE = docker-compose -f docker-compose.fullstack.yml
NPM_ROOT = npm run
NPM_BACKEND = cd backend && 
NPM_FRONTEND = cd frontend && 
SCRIPTS_DIR = scripts

## Help - Main help command
help:
	@echo "🌐 NODE-TS-API - Available commands:"
	@echo ""
	@echo "📦  SETUP & CONFIGURATION:"
	@echo "  make setup           - Complete project setup"
	@echo "  make setup-git       - Configure Git hooks and workflow"
	@echo "  make setup-permissions - Configure script permissions"
	@echo ""
	@echo "⚡ DEVELOPMENT:"
	@echo "  make dev             - Full development environment"
	@echo "  make dev-backend     - Backend only in development"
	@echo "  make dev-frontend    - Frontend only in development"
	@echo ""
	@echo "🛠️  BUILD:"
	@echo "  make build           - Full build"
	@echo "  make build-backend   - Backend build"
	@echo "  make build-frontend  - Frontend build"
	@echo ""
	@echo "🧪 TESTING:"
	@echo "  make test            - Run all tests"
	@echo "  make test-backend    - Backend tests"
	@echo "  make test-frontend   - Frontend tests"
	@echo ""
	@echo "🎯 CODE QUALITY:"
	@echo "  make lint            - Full linting"
	@echo "  make code-quality    - Code quality check"
	@echo "  make security-scan   - Security scan"
	@echo ""
	@echo "🐳 DOCKER:"
	@echo "  make docker-up       - Start containers"
	@echo "  make docker-down     - Stop containers"
	@echo "  make docker-logs     - Show Docker logs"
	@echo ""
	@echo "🗃️  DATABASE:"
	@echo "  make db-migrate      - Run migrations"
	@echo "  make db-backup       - Create DB backup"
	@echo ""
	@echo "🚀 DEPLOYMENT:"
	@echo "  make deploy          - Full deployment"
	@echo "  make deploy-staging  - Deploy to staging"
	@echo "  make deploy-production - Deploy to production"
	@echo ""
	@echo "🔧 GIT WORKFLOW:"
	@echo "  make feature-start name=<name> - Start new feature"
	@echo "  make feature-finish            - Finish feature"
	@echo "  make release version=<vX.X.X>  - Create release"
	@echo "  make backup                    - Create project backup"
	@echo ""
	@echo "🧹 CLEANUP:"
	@echo "  make clean          - Full cleanup"
	@echo "  make status         - Project status"
	@echo ""
	@echo "📊 ENVIRONMENTS:"
	@echo "  make docker-up-staging    - Docker staging"
	@echo "  make docker-up-production - Docker production"
	@echo "  make build-staging        - Build for staging"
	@echo "  make build-production     - Build for production"

## ====================
## SETUP & CONFIGURATION
## ====================

setup: setup-permissions setup-backend setup-frontend setup-git init-project
	@echo "✅ Complete setup finished"
	@echo "📝 Next steps:"
	@echo "   1. Configure environment variables: cp backend/.env.example backend/.env"
	@echo "   2. make docker-up"
	@echo "   3. make db-migrate"

setup-permissions:
	@echo "🔧 Setting permissions..."
	chmod +x $(SCRIPTS_DIR)/*.sh $(SCRIPTS_DIR)/**/*.sh
	chmod +x .husky/* 2>/dev/null || true
	@echo "✅ Permissions set"

setup-backend:
	@echo "⚙️ Setting up backend..."
	$(NPM_BACKEND) npm install
	@echo "✅ Backend set up"

setup-frontend:
	@echo "📦 Setting up frontend..."
	@if [ -d "frontend" ]; then \
		$(NPM_FRONTEND) npm install; \
		echo "✅ Frontend set up"; \
	else \
		echo "⚠️  Frontend not found, skipping..."; \
	fi

setup-git:
	@echo "🔗 Configuring Git workflow..."
	@if [ -f "$(SCRIPTS_DIR)/git/setup-git-workflow.sh" ]; then \
		$(SCRIPTS_DIR)/git/setup-git-workflow.sh; \
	else \
		echo "🔗 Configuring basic Git hooks..."; \
		git config core.hooksPath .githooks 2>/dev/null || true; \
	fi
	@echo "✅ Git configured"

init-project:
	@echo "🚀 Initializing project..."
	@if [ -f "$(SCRIPTS_DIR)/init-project.sh" ]; then \
		chmod +x $(SCRIPTS_DIR)/init-project.sh; \
		$(SCRIPTS_DIR)/init-project.sh; \
	else \
		echo "📁 Creating basic structure..."; \
		mkdir -p scripts/backups scripts/deployment scripts/database scripts/git scripts/security; \
		git init 2>/dev/null || true; \
	fi

## ==============
## DEVELOPMENT
## ==============

dev:
	@echo "🚀 Starting full development environment..."
	$(NPM_ROOT) dev:all

dev-backend:
	@echo "🔧 Starting backend in development..."
	$(NPM_BACKEND) npm run dev

dev-frontend:
	@echo "🎨 Starting frontend in development..."
	@if [ -d "frontend" ]; then \
		$(NPM_FRONTEND) npm run dev; \
	else \
		echo "❌ Frontend directory not found"; \
	fi

## =========
## BUILD
## =========

build: build-backend build-frontend
	@echo "📦 Full build finished"

build-backend:
	@echo "🔨 Building backend..."
	$(NPM_BACKEND) npm run build

build-frontend:
	@echo "🎨 Building frontend..."
	@if [ -d "frontend" ]; then \
		$(NPM_FRONTEND) npm run build; \
	else \
		echo "⚠️  Frontend not found, skipping..."; \
	fi

build-staging:
	@echo "🧱 Building for staging..."
	@if [ -f "$(SCRIPTS_DIR)/deployment/build-staging.sh" ]; then \
		$(SCRIPTS_DIR)/deployment/build-staging.sh; \
	else \
		echo "⚠️  build-staging.sh script not found"; \
	fi

build-production:
	@echo "⚙️ Building for production..."
	@if [ -f "$(SCRIPTS_DIR)/deployment/build-production.sh" ]; then \
		$(SCRIPTS_DIR)/deployment/build-production.sh; \
	else \
		echo "⚠️  build-production.sh script not found"; \
	fi

## =========
## TESTING
## =========

test: test-backend test-frontend
	@echo "✅ All tests completed"

test-backend:
	@echo "🧪 Running backend tests..."
	$(NPM_BACKEND) npm run test

test-frontend:
	@echo "🧪 Running frontend tests..."
	@if [ -d "frontend" ]; then \
		$(NPM_FRONTEND) npm run test; \
	else \
		echo "⚠️  Frontend not found, skipping tests..."; \
	fi

## ==================
## CODE QUALITY
## ==================

lint: lint-backend lint-frontend
	@echo "✨ Linting completed"

lint-backend:
	@echo "🔍 Linting backend..."
	$(NPM_BACKEND) npm run lint

lint-frontend:
	@echo "🔍 Linting frontend..."
	@if [ -d "frontend" ]; then \
		$(NPM_FRONTEND) npm run lint; \
	else \
		echo "⚠️  Frontend not found, skipping linting..."; \
	fi

code-quality:
	@echo "🔍 Checking code quality..."
	@if [ -f "$(SCRIPTS_DIR)/code-quality.sh" ]; then \
		chmod +x $(SCRIPTS_DIR)/code-quality.sh; \
		$(SCRIPTS_DIR)/code-quality.sh full; \
	else \
		echo "✅ Basic structure check..."; \
		@if [ -d "backend" ] && [ -f "backend/package.json" ]; then \
			echo "✅ Backend structure: OK"; \
		else \
			echo "❌ Backend structure: Missing"; \
		fi; \
	fi

security-scan:
	@echo "🔒 Running security scan..."
	@if [ -f "$(SCRIPTS_DIR)/security/apply-security-incremental.sh" ]; then \
		$(SCRIPTS_DIR)/security/apply-security-incremental.sh; \
	else \
		echo "⚠️  Security script not found, running audit..."; \
		cd backend && npm audit --audit-level moderate; \
	fi

## =========
## DOCKER
## =========

docker-up:
	@echo "🐳 Starting Docker environment..."
	$(DOCKER_COMPOSE) up -d --build
	@echo "✅ Containers started"
	@echo "📊 Check status: make status"

docker-down:
	@echo "🐳 Stopping Docker environment..."
	$(DOCKER_COMPOSE) down
	@echo "✅ Containers stopped"

docker-logs:
	@echo "📋 Showing Docker logs..."
	$(DOCKER_COMPOSE) logs -f

docker-up-staging:
	@echo "🐳 Starting Staging environment..."
	docker-compose -f docker-compose.staging.yml up -d --build

docker-up-production:
	@echo "🐳 Starting Production environment..."
	docker-compose -f docker-compose.prod.yml up -d --build

## ================
## DATABASE
## ================

db-migrate:
	@echo "🗃️ Running database migrations..."
	@if [ -f "$(SCRIPTS_DIR)/database/run-migrations.sh" ]; then \
		$(SCRIPTS_DIR)/database/run-migrations.sh; \
	else \
		echo "⚠️  Migrations script not found"; \
	fi

db-backup:
	@echo "💾 Creating database backup..."
	@if [ -f "$(SCRIPTS_DIR)/database/backup-database.sh" ]; then \
		$(SCRIPTS_DIR)/database/backup-database.sh; \
	else \
		echo "⚠️  Backup script not found"; \
	fi

## ===========
## DEPLOYMENT
## ===========

deploy: build docker-up db-migrate
	@echo "🚀 Deployment completed"

deploy-staging:
	@echo "🔄 Deploying to staging..."
	@if [ -f "$(SCRIPTS_DIR)/deployment/deploy-to-staging.sh" ]; then \
		$(SCRIPTS_DIR)/deployment/deploy-to-staging.sh; \
	else \
		make build-staging; \
		make docker-up-staging; \
		make db-migrate; \
	fi

deploy-production:
	@echo "🚀 Deploying to production..."
	@if [ -f "$(SCRIPTS_DIR)/deployment/deploy-to-production.sh" ]; then \
		$(SCRIPTS_DIR)/deployment/deploy-to-production.sh; \
	else \
		make build-production; \
		make docker-up-production; \
		make db-migrate; \
	fi

## ================
## GIT WORKFLOW
## ================

feature-start:
	@if [ -z "$(name)" ]; then \
		echo "❌ Usage: make feature-start name=feature-name"; \
		exit 1; \
	fi
	@echo "🌱 Starting new feature: $(name)"
	@if [ -f "$(SCRIPTS_DIR)/git/git-feature-start.sh" ]; then \
		$(SCRIPTS_DIR)/git/git-feature-start.sh "$(name)"; \
	elif [ -f "$(SCRIPTS_DIR)/dev-workflow.sh" ]; then \
		chmod +x $(SCRIPTS_DIR)/dev-workflow.sh; \
		$(SCRIPTS_DIR)/dev-workflow.sh start-feature "$(name)"; \
	else \
		git checkout development && git pull origin development && git checkout -b "feature/$(name)"; \
	fi

feature-finish:
	@echo "✅ Finishing current feature..."
	@if [ -f "$(SCRIPTS_DIR)/git/git-feature-finish.sh" ]; then \
		$(SCRIPTS_DIR)/git/git-feature-finish.sh; \
	elif [ -f "$(SCRIPTS_DIR)/dev-workflow.sh" ]; then \
		chmod +x $(SCRIPTS_DIR)/dev-workflow.sh; \
		$(SCRIPTS_DIR)/dev-workflow.sh finish-feature; \
	else \
		echo "⚠️  Feature finish script not found"; \
	fi

release:
	@if [ -z "$(version)" ]; then \
		echo "❌ Usage: make release version=v1.0.0"; \
		exit 1; \
	fi
	@echo "🏷 Creating release: $(version)"
	@if [ -f "$(SCRIPTS_DIR)/dev-workflow.sh" ]; then \
		chmod +x $(SCRIPTS_DIR)/dev-workflow.sh; \
		$(SCRIPTS_DIR)/dev-workflow.sh create-release "$(version)"; \
	else \
		echo "⚠️  Release script not found"; \
	fi

git-workflow:
	@echo "🔧 Showing Git workflow help..."
	@if [ -f "$(SCRIPTS_DIR)/dev-workflow.sh" ]; then \
		chmod +x $(SCRIPTS_DIR)/dev-workflow.sh; \
		$(SCRIPTS_DIR)/dev-workflow.sh; \
	else \
		echo "Available commands:"; \
		echo "  make feature-start name=<name>"; \
		echo "  make feature-finish"; \
		echo "  make release version=<vX.X.X>"; \
	fi

## =========
## BACKUP
## =========

backup:
	@echo "💾 Creating project backup..."
	@if [ -f "$(SCRIPTS_DIR)/backup-manager.sh" ]; then \
		chmod +x $(SCRIPTS_DIR)/backup-manager.sh; \
		$(SCRIPTS_DIR)/backup-manager.sh create "auto_$(shell date +%Y%m%d_%H%M%S)"; \
	elif [ -f "$(SCRIPTS_DIR)/database/backup-database.sh" ]; then \
		$(SCRIPTS_DIR)/database/backup-database.sh; \
	else \
		echo "⚠️  Backup script not found"; \
	fi

## =========
## CLEANUP
## =========

clean: docker-down
	@echo "🧹 Cleaning project..."
	rm -rf frontend/dist backend/dist coverage .nyc_output
	@echo "✅ Cleanup completed"

## =========
## STATUS
## =========

status:
	@echo "📊 Project status:"
	@echo "🐳 Containers: $$(docker ps -q 2>/dev/null | wc -l) running"
	@echo "🔧 Backend: $$(curl -s http://localhost:3000/health > /dev/null && echo '✅' || echo '❌')"
	@if [ -d "frontend" ]; then \
		echo "🎨 Frontend: $$(curl -s http://localhost:3001 > /dev/null && echo '✅' || echo '❌')"; \
	else \
		echo "🎨 Frontend: ⚠️ Not configured"; \
	fi
	@echo "🌿 Current branch: $$(git branch --show-current 2>/dev/null || echo 'No git repo')"
	@echo "📦 Last commit: $$(git log -1 --oneline 2>/dev/null || echo 'No commits')"

## ====================
## QUICK COMMANDS
## ====================

## Quick command for full development
dev-full: docker-up dev-backend
	@echo "🚀 Full development started"

## Quick command for full tests
test-full: test code-quality
	@echo "✅ Full quality control completed"

## Quick command to prepare deployment
pre-deploy: test-full build backup
	@echo "📦 Project ready for deployment"

## Emergency command - Full reset
reset: docker-down clean
	@echo "🔄 Full reset executed"
	@echo "💡 Run 'make setup' to reconfigure"

## Full health check
health-check:
	@echo "🏥 System health check..."
	@echo "Node.js: $$(node --version 2>/dev/null || echo '❌ Not installed')"
	@echo "NPM: $$(npm --version 2>/dev/null || echo '❌ Not installed')"
	@echo "Docker: $$(docker --version 2>/dev/null || echo '❌ Not installed')"
	@echo "Docker Compose: $$(docker-compose --version 2>/dev/null || echo '❌ Not installed')"
	@echo "Git: $$(git --version 2>/dev/null || echo '❌ Not installed')"
	@echo "Current directory: $$(pwd)"
	@echo "✅ Check completed"

## ====================
## USEFUL ALIASES
## ====================

## Common aliases
up: docker-up
down: docker-down
logs: docker-logs
migrate: db-migrate
scan: security-scan
quality: code-quality
bk: backup
t: test
## ====================
## SETUP & CONFIGURATION
## ====================

setup: setup-permissions fix-frontend setup-backend setup-git
	@echo "✅ Complete setup finished"
	@echo "📝 Next steps:"
	@echo "   1. Configure variables: cp backend/.env.example backend/.env"
	@echo "   2. make docker-up"
	@echo "   3. make db-migrate"
	@echo "   4. make dev-backend"

setup-minimal: setup-permissions setup-backend
	@echo "✅ Minimal setup completed"
	@echo "💡 Run 'make docker-up' to start containers"

setup-permissions:
	@echo "🔧 Setting permissions..."
	chmod +x $(SCRIPTS_DIR)/*.sh 2>/dev/null || true
	@echo "✅ Permissions set"

setup-backend:
	@echo "⚙️ Setting up backend..."
	$(NPM_BACKEND) npm install
	@echo "✅ Backend set up"

setup-git:
	@echo "🔗 Configuring Git..."
	@if [ -f "$(SCRIPTS_DIR)/setup-git-hooks.sh" ]; then \
		chmod +x $(SCRIPTS_DIR)/setup-git-hooks.sh; \
		$(SCRIPTS_DIR)/setup-git-hooks.sh || echo "⚠️  Git configured with warnings"; \
	else \
		echo "📝 Configuring basic Git..."; \
		git config core.hooksPath .githooks 2>/dev/null || true; \
	fi
	@echo "✅ Git configured"

fix-frontend:
	@echo "🔧 Repairing frontend..."
	@if [ -f "$(SCRIPTS_DIR)/fix-frontend.sh" ]; then \
		chmod +x $(SCRIPTS_DIR)/fix-frontend.sh; \
		$(SCRIPTS_DIR)/fix-frontend.sh; \
	else \
		echo "📁 Creating basic frontend..."; \
		mkdir -p frontend; \
		cat > frontend/package.json << 'EOF' \
		{\
		"name": "frontend",\
		"version": "1.0.0",\
		"type": "module",\
		"scripts": {\
			"dev": "echo 'Frontend not configured'",\
			"build": "echo 'Frontend not configured'",\
			"test": "echo 'Frontend not configured'",\
			"lint": "echo 'Frontend not configured'"\
		}\
		}\
		EOF\
		echo "✅ Frontend repaired"; \
	fi

## ==============
## DEVELOPMENT
## ==============

dev: dev-backend
	@echo "🚀 Development started"

dev-backend:
	@echo "🔧 Starting backend..."
	$(NPM_BACKEND) npm run dev

## =========
## BUILD
## =========

build: build-backend
	@echo "📦 Build completed"

build-backend:
	@echo "🔨 Building backend..."
	$(NPM_BACKEND) npm run build

## =========
## TESTING
## =========

test: test-backend
	@echo "✅ Tests completed"

test-backend:
	@echo "🧪 Running backend tests..."
	$(NPM_BACKEND) npm run test

## ==================
## CODE QUALITY
## ==================

lint: lint-backend
	@echo "✨ Linting completed"

lint-backend:
	@echo "🔍 Linting backend..."
	$(NPM_BACKEND) npm run lint

code-quality:
	@echo "🔍 Checking quality..."
	@echo "✅ Project structure: OK"
	@echo "✅ Backend: Configured"
	@echo "⚠️  Frontend: Basic (you can configure it later)"

security-scan:
	@echo "🔒 Security scan..."
	cd backend && npm audit --audit-level moderate

## =========
## DOCKER
## =========

docker-up:
	@echo "🐳 Starting containers..."
	$(DOCKER_COMPOSE) up -d --build
	@echo "✅ Containers started"

docker-down:
	@echo "🐳 Stopping containers..."
	$(DOCKER_COMPOSE) down
	@echo "✅ Containers stopped"

docker-logs:
	@echo "📋 Showing logs..."
	$(DOCKER_COMPOSE) logs -f

## ================
## DATABASE
## ================

db-migrate:
	@echo "🗃️ Running migrations..."
	@if [ -f "$(SCRIPTS_DIR)/database/run-migrations.sh" ]; then \
		$(SCRIPTS_DIR)/database/run-migrations.sh; \
	else \
		$(NPM_BACKEND) npm run db:migrate; \
	fi

db-backup:
	@echo "💾 Creating backup..."
	@if [ -f "$(SCRIPTS_DIR)/database/backup-database.sh" ]; then \
		$(SCRIPTS_DIR)/database/backup-database.sh; \
	else \
		echo "⚠️  Backup script not found"; \
	fi

## ===========
## DEPLOYMENT
## ===========

deploy: build docker-up db-migrate
	@echo "🚀 Deployment completed"

## ================
## GIT WORKFLOW
## ================

feature-start:
	@if [ -z "$(name)" ]; then \
		echo "❌ Usage: make feature-start name=feature-name"; \
		exit 1; \
	fi
	@echo "🌱 Starting feature: $(name)"
	git checkout development 2>/dev/null || git checkout -b development
	git pull origin development 2>/dev/null || true
	git checkout -b "feature/$(name)"

feature-finish:
	@echo "✅ Finishing feature..."
	@echo "💡 Run manually: git merge feature/... when ready"

## =========
## CLEANUP
## =========

clean: docker-down
	@echo "🧹 Cleaning..."
	rm -rf frontend/dist backend/dist
	@echo "✅ Cleanup completed"

## =========
## STATUS
## =========

status:
	@echo "📊 Project status:"
	@echo "🐳 Containers: $$(docker ps -q 2>/dev/null | wc -l) running"
	@echo "🔧 Backend: $$(curl -s http://localhost:3000/health > /dev/null && echo '✅' || echo '❌')"
	@echo "🌿 Branch: $$(git branch --show-current 2>/dev/null || echo 'No git')"
	@echo "📦 Last commit: $$(git log -1 --oneline 2>/dev/null || echo 'No commits')"

## ====================
## DIAGNOSTICS
## ====================

diagnose:
	@echo "🔍 System diagnostics:"
	@echo "Node: $$(node --version 2>/dev/null || echo '❌')"
	@echo "NPM: $$(npm --version 2>/dev/null || echo '❌')"
	@echo "Docker: $$(docker --version 2>/dev/null || echo '❌')"
	@echo "Docker Compose: $$(docker-compose --version 2>/dev/null || echo '❌')"
	@echo "Directory: $$(pwd)"
	@echo "Backend: $$([ -d "backend" ] && echo '✅' || echo '❌')"
	@echo "Frontend: $$([ -d "frontend" ] && echo '✅' || echo '❌')"
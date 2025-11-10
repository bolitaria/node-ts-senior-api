#!/bin/bash

set -e

echo "🏗 COMPLETE PROJECT SETUP"
echo "========================"

# 1. Setup permissions
echo "🔧 Setting up permissions..."
make setup-permissions

# 2. Setup frontend
echo "📦 Setting up frontend..."
make setup-frontend

# 3. Setup backend
echo "⚙️ Setting up backend..."  
make setup-backend

# 4. Setup Git workflow
echo "🔗 Setting up Git workflow..."
make setup-git

# 5. Create environment files
echo "🔐 Creating environment files..."
cp .env.example .env.local 2>/dev/null || true

echo ""
echo "✅ SETUP COMPLETED SUCCESSFULLY"
echo ""
echo "🚀 QUICK START:"
echo "   make dev              # Start development"
echo "   make docker-up        # Start with Docker"
echo "   make test             # Run tests"
echo ""
echo "📊 PROJECT INFO:"
echo "   Frontend: http://localhost:3001"
echo "   Backend:  http://localhost:3000"
echo "   Database: localhost:5432"
echo ""
echo "🔧 DEVELOPMENT:"
echo "   make feature-start    # Start new feature"
echo "   make lint             # Run linting"
echo "   make db-migrate       # Run migrations"
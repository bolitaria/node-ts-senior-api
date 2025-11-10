#!/bin/bash

set -e

echo "🚀 INITIAL SETUP - NODE-TS-API"

# Check requirements
echo "🔍 Checking system requirements..."

check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1 is not installed"
        return 1
    fi
    echo "✅ $1: $(command -v $1)"
}

check_command node
check_command npm
check_command docker
check_command docker-compose
check_command git

# Set permissions
echo "🔧 Setting permissions..."
chmod +x scripts/*.sh scripts/**/*.sh 2>/dev/null || true

# Basic setup
echo "📦 Installing backend dependencies..."
cd backend && npm install && cd ..

# Setup frontend if exists
if [ -d "frontend" ]; then
    echo "🎨 Installing frontend dependencies..."
    cd frontend && npm install && cd ..
fi

# Configure Git
echo "🔗 Configuring Git..."
if [ ! -d ".git" ]; then
    git init
fi

# Create branch structure if not exists
git checkout -b main 2>/dev/null || git checkout main
git checkout -b development 2>/dev/null || git checkout development

# Setup git hooks if script exists
if [ -f "scripts/setup-git-hooks.sh" ]; then
    chmod +x scripts/setup-git-hooks.sh
    ./scripts/setup-git-hooks.sh
fi

echo ""
echo "✅ SETUP COMPLETED"
echo ""
echo "📝 NEXT STEPS:"
echo "   1. Configure environment variables:"
echo "      cp backend/.env.example backend/.env"
echo "   2. Edit backend/.env with your settings"
echo "   3. make docker-up"
echo "   4. make db-migrate"
echo "   5. make dev"
echo ""
echo "🔧 USEFUL COMMANDS:"
echo "   make help          - Show all commands"
echo "   make status        - Show project status"
echo "   make dev           - Start development"
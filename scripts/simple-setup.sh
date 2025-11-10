#!/bin/bash

set -e

echo "🚀 QUICK SETUP - NODE-TS-API"

# Ensure we're in the correct directory
if [ ! -d "backend" ]; then
    echo "❌ Error: backend directory not found"
    echo "   Run this script from the NODE-TS-API project root"
    exit 1
fi

# Set basic permissions
echo "🔧 Setting permissions..."
chmod +x scripts/*.sh 2>/dev/null || true

# Install backend dependencies
echo "📦 Installing backend dependencies..."
cd backend
npm install
cd ..

# Basic Git setup
echo "🔗 Configuring Git..."
if [ ! -d ".git" ]; then
    git init
    git checkout -b main
    git checkout -b development
    echo "✅ Git repository initialized"
fi

echo ""
echo "✅ SETUP COMPLETED"
echo ""
echo "📝 NEXT STEPS:"
echo "   1. make docker-up      # Start containers"
echo "   2. make status         # Check status"
echo "   3. make dev-backend    # Start development"
echo ""
echo "🔧 USEFUL COMMANDS:"
echo "   make help              # Show all commands"
echo "   make health-check      # Check system"
#!/bin/bash

set -e

echo "COMPLETE GIT WORKFLOW SETUP"
echo "========================================"

# Install Git workflow dependencies
echo "Installing Git workflow dependencies..."
npm install

# Configure Git hooks
echo "🔧 Configuring Git hooks..."
npx husky install

# Add hooks
npx husky add .husky/pre-commit "npx lint-staged"
npx husky add .husky/commit-msg "npx --no -- commitlint --edit \$1"

# Configure Git remote if needed
if [ ! -z "$1" ]; then
    echo "🌐 Configuring remote repository: $1"
    git remote add origin $1
    git push -u origin develop
    git push -u origin main
    git push -u origin staging
fi

# Create initial tags
git tag v0.1.0-develop
git tag v0.1.0-main

echo ""
echo "✅ GIT SETUP COMPLETED"
echo ""
echo "📋 RECOMMENDED WORKFLOW:"
echo "   1. feature/     → For new features"
echo "   2. bugfix/      → For bug fixes"
echo "   3. hotfix/      → For urgent production patches"
echo "   4. release/     → For preparing releases"
echo ""
echo "🔧 AVAILABLE TOOLS:"
echo "   npm run commit  → Interactive commit"
echo "   npm run lint    → Code linting"
echo "   npm run test    → Run tests"
echo ""
echo "🎯 MAIN BRANCHES:"
echo "   develop  → Continuous development"
echo "   main     → Production"
echo "   staging  → Pre-production"

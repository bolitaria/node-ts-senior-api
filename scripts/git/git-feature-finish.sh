#!/bin/bash

set -e

CURRENT_BRANCH=$(git branch --show-current)

if [[ ! $CURRENT_BRANCH =~ ^feature/ ]]; then
    echo "❌ Error: You are not on a feature branch"
    echo "You are on: $CURRENT_BRANCH"
    exit 1
fi

echo "✅ Finishing feature: $CURRENT_BRANCH"

# Update with develop
git fetch origin
git merge origin/develop

# Run tests and checks
echo "🧪 Running checks..." 
npm run lint:backend
npm run lint:frontend
npm run test:backend
npm run test:frontend

# Return to develop and merge
git checkout develop
git merge --no-ff $CURRENT_BRANCH -m "feat: merge $CURRENT_BRANCH"

# Delete feature branch
git branch -d $CURRENT_BRANCH

echo "✅ Feature completed and merged into develop"
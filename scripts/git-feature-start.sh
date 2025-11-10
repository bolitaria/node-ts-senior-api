#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "❌ Error: You must provide a name for the feature"
    echo "Usage: ./scripts/git-feature-start.sh feature-name"
    exit 1
fi

FEATURE_NAME=$1
FEATURE_BRANCH="feature/$FEATURE_NAME"

echo "🎯 Starting feature: $FEATURE_NAME"

# Make sure we're on develop
git checkout develop

# Update develop
git pull origin develop

# Create new feature branch
git checkout -b $FEATURE_BRANCH

echo "✅ Feature branch created: $FEATURE_BRANCH"
echo "📝 Make your changes and use 'npm run commit' for commits"
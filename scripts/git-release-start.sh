#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "❌ Error: You must provide the release version"
    echo "Usage: ./scripts/git-release-start.sh 1.2.0"
    exit 1
fi

VERSION=$1
RELEASE_BRANCH="release/v$VERSION"

echo "🚀 Starting release: v$VERSION"

# Make sure we're on develop
git checkout develop
git pull origin develop

# Create release branch
git checkout -b $RELEASE_BRANCH

# Update versions (if needed)
echo "📝 Updating versions..."
# Here you could add scripts to update package.json, etc.

git add .
git commit -m "chore: prepare release v$VERSION" || true

echo "Release branch created: $RELEASE_BRANCH"
echo "Perform final tests and fix any bugs"
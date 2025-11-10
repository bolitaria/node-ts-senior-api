#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "❌ Error: You must provide the release version"
    echo "Usage: ./scripts/git/git-release-start.sh 1.2.0"
    exit 1
fi

VERSION=$1
RELEASE_BRANCH="release/v$VERSION"

echo "🚀 Starting release: v$VERSION"

# Ensure we're on develop
git checkout develop
git pull origin develop

# Create release branch
git checkout -b $RELEASE_BRANCH

echo "✅ Release branch created: $RELEASE_BRANCH"
echo "🔧 Perform final testing and fix any bugs"
#!/bin/bash

echo "🔧 SETTING UP SCRIPT PERMISSIONS"
echo "================================"

# Make all shell scripts executable
echo "Making scripts executable..."
find . -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true

# Specific script directories
chmod +x scripts/*.sh 2>/dev/null || true
chmod +x scripts/git/*.sh 2>/dev/null || true
chmod +x scripts/security/*.sh 2>/dev/null || true
chmod +x scripts/database/*.sh 2>/dev/null || true
chmod +x scripts/deployment/*.sh 2>/dev/null || true

# Husky hooks
chmod +x .husky/* 2>/dev/null || true

echo "✅ Permissions set successfully"
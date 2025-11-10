#!/bin/bash

set -e

if [ -z "$1" ]; then
    echo "❌ Error: You must provide the server address"
    echo "Usage: ./scripts/deployment/deploy-to-server.sh user@server.com"
    exit 1
fi

SERVER=$1

echo "🚀 DEPLOYING TO SERVER: $SERVER"
echo "================================"

# Build production
./scripts/deployment/build-production.sh

# Transfer files
echo "📤 Transferring files to server..."
rsync -avz --delete \
    --exclude 'node_modules' \
    --exclude '.git' \
    --exclude 'logs' \
    . $SERVER:/opt/senior-api/

# Run deployment on server
echo "🔧 Running deployment on server..."
ssh $SERVER "cd /opt/senior-api && docker-compose -f docker-compose.prod.yml up -d"

echo "✅ Deployment completed successfully"
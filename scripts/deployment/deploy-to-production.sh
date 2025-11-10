#!/bin/bash

set -e

echo "🚀 PRODUCTION DEPLOYMENT"
echo "========================"

# Validate environment
if [ -z "$PRODUCTION_SERVER" ]; then
    echo "❌ PRODUCTION_SERVER environment variable not set"
    exit 1
fi

if [ -z "$PRODUCTION_DEPLOY_PATH" ]; then
    PRODUCTION_DEPLOY_PATH="/opt/production-app"
fi

echo "🔧 Environment: Production"
echo "🌐 Server: $PRODUCTION_SERVER"
echo "📁 Deploy path: $PRODUCTION_DEPLOY_PATH"

# Build everything
echo "📦 Building services..."
make build

# Run tests
echo "🧪 Running tests..."
make test

# Security scan
echo "🔒 Security scan..."
make security-scan

# Create production build
echo "🏗️ Creating production build..."
./scripts/deployment/build-production.sh

# Database migrations
echo "🗃️ Running migrations..."
make db-migrate

# Deploy to production
echo "🚀 Deploying to production server..."

# Transfer files to production server
echo "📡 Transferring files..."
rsync -avz --delete \
    --exclude 'node_modules' \
    --exclude '.git' \
    --exclude 'logs' \
    --exclude '.env.local' \
    --include 'docker-compose.prod.yml' \
    . $PRODUCTION_SERVER:$PRODUCTION_DEPLOY_PATH/

# Run deployment on production server
echo "🎯 Running deployment on production server..."
ssh $PRODUCTION_SERVER "cd $PRODUCTION_DEPLOY_PATH && make docker-up-production"

# Health check
echo "🏥 Performing health check..."
sleep 15
if ssh $PRODUCTION_SERVER "curl -s -f https://yourdomain.com/health > /dev/null"; then
    echo "✅ Production health check passed"
else
    echo "❌ Production health check failed"
    exit 1
fi

echo "✅ Production deployment completed successfully"
#!/bin/bash

set -e

echo "🔄 STAGING DEPLOYMENT"
echo "===================="

# Validate environment
if [ -z "$STAGING_SERVER" ]; then
    echo "❌ STAGING_SERVER environment variable not set"
    echo "Please set STAGING_SERVER to your staging server address"
    exit 1
fi

if [ -z "$STAGING_DEPLOY_PATH" ]; then
    STAGING_DEPLOY_PATH="/opt/staging-app"
fi

echo "🔧 Environment: Staging"
echo "🌐 Server: $STAGING_SERVER"
echo "📁 Deploy path: $STAGING_DEPLOY_PATH"

# Build and test
echo "📦 Building services..."
make build

echo "🧪 Running tests..."
make test

echo "🔒 Running security scan..."
make security-scan

# Create staging build
echo "🏗️ Creating staging build..."
./scripts/deployment/build-staging.sh

# Deploy to staging environment
echo "🚀 Deploying to staging server..."

# Transfer files to staging server
echo "📡 Transferring files..."
rsync -avz --delete \
    --exclude 'node_modules' \
    --exclude '.git' \
    --exclude 'logs' \
    --exclude '.env.local' \
    --include 'docker-compose.staging.yml' \
    . $STAGING_SERVER:$STAGING_DEPLOY_PATH/

# Run deployment on staging server
echo "🎯 Running deployment on staging server..."
ssh $STAGING_SERVER "cd $STAGING_DEPLOY_PATH && make docker-up-staging"

# Run database migrations
echo "🗃️ Running database migrations..."
ssh $STAGING_SERVER "cd $STAGING_DEPLOY_PATH && make db-migrate"

# Health check
echo "🏥 Performing health check..."
sleep 10
if ssh $STAGING_SERVER "curl -s -f http://localhost:3000/health > /dev/null"; then
    echo "✅ Backend health check passed"
else
    echo "❌ Backend health check failed"
    exit 1
fi

if ssh $STAGING_SERVER "curl -s -f http://localhost:3001 > /dev/null"; then
    echo "✅ Frontend health check passed"
else
    echo "❌ Frontend health check failed"
    exit 1
fi

echo "✅ Staging deployment completed successfully"
echo ""
echo "📊 Staging Environment:"
echo "   Frontend: http://$STAGING_SERVER:3001"
echo "   Backend:  http://$STAGING_SERVER:3000"
echo "   API Docs: http://$STAGING_SERVER:3000/api-docs"
#!/bin/bash

set -e

echo "🚀 FULL-STACK DEPLOYMENT"
echo "========================"

# Verify Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed"
    exit 1
fi

# Verify Docker Compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed"
    exit 1
fi

echo "🔨 Building services..."
docker-compose -f docker-compose.fullstack.yml build

echo "🚀 Starting services..."
docker-compose -f docker-compose.fullstack.yml up -d

echo "⏳ Waiting for services to be ready..."
sleep 15

echo "🔍 Verifying services..."
docker ps

echo "🏥 Health check..."
curl -f http://localhost:3000/health && echo "✅ Backend is healthy" || echo "⚠️ Backend not responding yet"

echo "🌐 Frontend check..."
curl -f http://localhost:3001 > /dev/null 2>&1 && echo "✅ Frontend is running" || echo "⚠️ Frontend not responding yet"

echo ""
echo "🎯 DEPLOYMENT COMPLETED"
echo ""
echo "📊 SERVICES:"
echo "   Frontend: http://localhost:3001"
echo "   Backend:  http://localhost:3000"
echo "   PostgreSQL: localhost:5432"
echo "   Redis:     localhost:6379"
echo "   ClickHouse: localhost:8123"
echo ""
echo "🔐 CREDENTIALS:"
echo "   PostgreSQL: myapp/user/password"
echo "   API: admin@example.com/password"
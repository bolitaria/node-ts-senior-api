#!/bin/bash

set -e

echo "🏗️ BUILDING FOR PRODUCTION"
echo "=========================="

echo "🔨 Building backend..."
cd backend
npm run build
cd ..

echo "🎨 Building frontend..."
cd frontend
npm run build
cd ..

echo "🐳 Building Docker images for production..."
docker-compose -f docker-compose.prod.yml build

echo "✅ Production build completed"
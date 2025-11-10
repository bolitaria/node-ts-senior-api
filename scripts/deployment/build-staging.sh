#!/bin/bash

set -e

echo "🏗️ BUILDING FOR STAGING"
echo "======================="

echo "🔨 Building backend..."
cd backend
npm run build
cd ..

echo "🎨 Building frontend..."
cd frontend
npm run build
cd ..

echo "🐳 Building Docker images for staging..."
docker-compose -f docker-compose.staging.yml build

echo "✅ Staging build completed"
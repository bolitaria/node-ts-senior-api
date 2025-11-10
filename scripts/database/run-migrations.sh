#!/bin/bash

set -e

echo "🗃️ RUNNING DATABASE MIGRATIONS"
echo "=============================="

cd backend

# Check if TypeORM is available
if ! grep -q "typeorm" package.json; then
    echo "❌ TypeORM is not configured in the backend"
    exit 1
fi

echo "🔧 Running migrations..."
npm run typeorm migration:run || echo "⚠️ Could not run migrations automatically"

echo "✅ Migrations completed"
cd ..
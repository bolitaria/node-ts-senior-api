#!/bin/bash

set -e

echo "⚙️ BACKEND SETUP"
echo "================"

if [ ! -d "backend" ]; then
    echo "❌ Backend directory not found!"
    exit 1
fi

cd backend

echo "📦 Installing backend dependencies..."
npm install

echo "✅ Backend setup completed"
cd ..
#!/bin/bash

set -e

echo "🚀 FRONTEND SETUP"
echo "================="

# Verify backend exists
if [ ! -d "backend" ]; then
    echo "❌ Error: Backend folder not found!"
    exit 1
fi

# Create frontend directory
echo "📁 Creating frontend structure..."
mkdir -p frontend/src/{components/{ui,layout,sections},pages,hooks,services,types,utils,data,assets}

cd frontend

# Initialize Vite project
echo "⚡ Initializing Vite + React + TypeScript..."
npm create vite@latest . -- --template react-ts --yes

# Install base dependencies
echo "📦 Installing dependencies..."
npm install

# Production dependencies
echo "📦 Installing runtime dependencies..."
npm install react-router-dom axios zustand @tanstack/react-query
npm install react-hook-form @hookform/resolvers zod
npm install jwt-decode lucide-react clsx

# Development dependencies  
echo "🔧 Installing dev dependencies..."
npm install -D tailwindcss postcss autoprefixer
npm install -D @types/react @types/react-dom @types/node @types/jwt-decode
npm install -D @tailwindcss/forms @tailwindcss/typography

# Configure Tailwind
echo "🎨 Configuring Tailwind CSS..."
npx tailwindcss init -p

echo "✅ Frontend setup completed"
cd ..
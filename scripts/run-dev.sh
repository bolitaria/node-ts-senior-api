#!/bin/bash

echo "🛠️ DEVELOPMENT MODE"
echo "==================="

# Start backend if not running
if ! curl -f http://localhost:3000/health > /dev/null 2>&1; then
    echo "🔧 Starting backend..."
    cd backend
    npm run dev &
    cd ..
    sleep 5
fi

# Start frontend
echo "🎨 Starting frontend in development mode..."
cd frontend
npm run dev
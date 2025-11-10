#!/bin/bash

echo "🔍 SERVICE STATUS CHECK"
echo "======================="

# Check Docker containers
echo "🐳 Docker Containers:"
sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "🌐 Service URLs:"

# Check frontend
echo -n "Frontend (http://localhost:3001): "
if curl -s -f http://localhost:3001 > /dev/null; then
    echo "✅ RUNNING"
else
    echo "❌ NOT RESPONDING"
fi

# Check backend
echo -n "Backend API (http://localhost:3000/health): "
if curl -s -f http://localhost:3000/health > /dev/null; then
    echo "✅ RUNNING"
    # Show health response
    echo "   Response: $(curl -s http://localhost:3000/health | head -c 100)"
else
    echo "❌ NOT RESPONDING"
fi

# Check databases
echo -n "PostgreSQL (port 5432): "
if sudo docker ps | grep -q postgres; then
    echo "✅ RUNNING"
else
    echo "❌ NOT RUNNING"
fi

echo -n "Redis (port 6379): "
if sudo docker ps | grep -q redis; then
    echo "✅ RUNNING"
else
    echo "❌ NOT RUNNING"
fi

echo ""
echo "📁 Project Structure:"
echo "Frontend: $(ls -la frontend/ 2>/dev/null | wc -l) files"
echo "Scripts: $(find scripts -name "*.sh" 2>/dev/null | wc -l) scripts"

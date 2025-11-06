#!/bin/bash

echo "🔍 Ejecutando diagnóstico..."

echo "1. Verificando estructura de archivos..."
find src/modules/auth -name "*.ts" | head -10

echo ""
echo "2. Verificando imports en app.ts..."
grep -n "authRoutes" src/app.ts

echo ""
echo "3. Verificando que las rutas se exportan correctamente..."
grep "export" src/modules/auth/auth.routes.ts

echo ""
echo "4. Verificando contenedores..."
docker ps | grep api

echo ""
echo "5. Probando rutas base..."
curl -s http://localhost:3000/ | jq . 2>/dev/null || curl -s http://localhost:3000/

echo ""
echo "6. Verificando logs de la API..."
docker-compose logs api --tail=20
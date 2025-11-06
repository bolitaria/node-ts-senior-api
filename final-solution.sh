#!/bin/bash

echo "🎯 SOLUCIÓN DEFINITIVA"

# Paso 1: Parar todo
echo "1. 🛑 Parando contenedores..."
docker-compose down

# Paso 2: Limpiar
echo "2. 🧹 Limpiando..."
rm -rf dist node_modules package-lock.json

# Paso 3: Reinstalar
echo "3. 📦 Reinstalando dependencias..."
npm install

# Paso 4: Usar Dockerfile de desarrollo
echo "4. 🐳 Configurando para desarrollo..."
cat > Dockerfile << 'DOCKERFILE'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 3000

CMD ["npx", "ts-node", "--transpile-only", "src/app.ts"]
DOCKERFILE

# Paso 5: Reconstruir
echo "5. 🏗️ Reconstruyendo..."
docker-compose build --no-cache

# Paso 6: Levantar servicios
echo "6. 🚀 Iniciando servicios..."
docker-compose up -d

# Paso 7: Esperar y verificar
echo "7. ⏳ Esperando que esté listo..."
sleep 15

# Paso 8: Verificar
echo "8. 🔍 Verificando..."
docker-compose logs api --tail=10

echo ""
echo "✅ SOLUCIÓN COMPLETADA"
echo "🌐 Probar con:"
echo "   curl http://localhost:3000/api/debug"
echo "   curl -X POST http://localhost:3000/api/auth/register \\"
echo "     -H \"Content-Type: application/json\" \\"
echo "     -d '{\"email\": \"test@example.com\", \"password\": \"password123\", \"name\": \"Test User\"}'"
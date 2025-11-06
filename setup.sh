#!/bin/bash

# Script para implementar todo automáticamente
echo "🚀 Implementando API completa..."

# 1. Instalar dependencias adicionales
npm install typeorm reflect-metadata pg bcryptjs jsonwebtoken joi
npm install @types/bcryptjs --save-dev

# 2. Crear estructura de archivos
mkdir -p src/migrations

# 3. Actualizar package.json con nuevos scripts
# Nota: Usamos una herramienta como `jq` para actualizar package.json de manera idempotente
# Si no tienes jq, puedes hacerlo manualmente o usar sed. En este caso, como es un ejemplo, lo haremos con echo y redirección.
# Pero ten cuidado porque esto podría sobrescribir el package.json. En su lugar, vamos a usar jq.

# Instalar jq si no está disponible (en sistemas Debian/Ubuntu)
if ! command -v jq &> /dev/null; then
    echo "Instalando jq..."
    sudo apt-get update && sudo apt-get install -y jq
fi

# Usar jq para agregar scripts a package.json
if [ -f package.json ]; then
    jq '.scripts += {
        "typeorm": "typeorm-ts-node-commonjs",
        "migration:generate": "npm run typeorm -- migration:generate",
        "migration:run": "npm run typeorm -- migration:run",
        "migration:revert": "npm run typeorm -- migration:revert"
    }' package.json > package.tmp.json && mv package.tmp.json package.json
else
    echo "package.json no encontrado. Asegúrate de estar en el directorio correcto."
    exit 1
fi

# 4. Actualizar tsconfig.json para TypeORM
# Agregar estas opciones al tsconfig.json existente:
if [ -f tsconfig.json ]; then
    jq '.compilerOptions += {
        "emitDecoratorMetadata": true,
        "experimentalDecorators": true
    }' tsconfig.json > tsconfig.tmp.json && mv tsconfig.tmp.json tsconfig.json
else
    echo "tsconfig.json no encontrado."
    exit 1
fi

# 5. Construir y ejecutar
npm run build
npm run docker:up

echo "✅ Implementación completada!"
echo "📚 Endpoints disponibles:"
echo "   POST /api/auth/register"
echo "   POST /api/auth/login"
echo "   GET  /api/auth/profile (requiere auth)"
echo "   POST /api/auth/refresh-token"
echo "   POST /api/auth/logout"
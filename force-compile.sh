#!/bin/bash

echo "🔧 Compilación forzada..."

# Limpiar dist
rm -rf dist

# Compilar archivos críticos uno por uno
echo "📦 Compilando archivos de autenticación..."
npx tsc src/modules/auth/auth.controller.ts --outDir dist --module commonjs --target ES2020 --esModuleInterop --experimentalDecorators --emitDecoratorMetadata --skipLibCheck
npx tsc src/modules/auth/auth.service.ts --outDir dist --module commonjs --target ES2020 --esModuleInterop --experimentalDecorators --emitDecoratorMetadata --skipLibCheck
npx tsc src/modules/auth/auth.routes.ts --outDir dist --module commonjs --target ES2020 --esModuleInterop --experimentalDecorators --emitDecoratorMetadata --skipLibCheck
npx tsc src/modules/auth/auth.entity.ts --outDir dist --module commonjs --target ES2020 --esModuleInterop --experimentalDecorators --emitDecoratorMetadata --skipLibCheck

# Compilar archivos de usuarios
npx tsc src/modules/users/user.entity.ts --outDir dist --module commonjs --target ES2020 --esModuleInterop --experimentalDecorators --emitDecoratorMetadata --skipLibCheck

# Compilar archivos shared
npx tsc src/shared/utils/validation.ts --outDir dist --module commonjs --target ES2020 --esModuleInterop --skipLibCheck
npx tsc src/shared/middleware/auth.ts --outDir dist --module commonjs --target ES2020 --esModuleInterop --skipLibCheck

# Compilar archivos de configuración
npx tsc src/config/database.ts --outDir dist --module commonjs --target ES2020 --esModuleInterop --experimentalDecorators --emitDecoratorMetadata --skipLibCheck

# Compilar app principal
npx tsc src/app.ts --outDir dist --module commonjs --target ES2020 --esModuleInterop --experimentalDecorators --emitDecoratorMetadata --skipLibCheck

echo "✅ Verificando compilación:"
find dist -name "*.js" | head -15
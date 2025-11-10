#!/bin/bash

set -e

echo "🚀 CONFIGURACIÓN ROBUSTA - NODE-TS-API"

# Función para verificar comandos
check_command() {
    if command -v $1 &> /dev/null; then
        echo "✅ $1: $(command -v $1)"
        return 0
    else
        echo "❌ $1: No encontrado"
        return 1
    fi
}

# Verificar requisitos
echo "🔍 Verificando requisitos..."
check_command node
check_command npm
check_command docker
check_command docker-compose
check_command git

# Configurar permisos
echo "🔧 Configurando permisos..."
find scripts/ -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true

# Setup backend
echo "⚙️ Configurando backend..."
if [ -d "backend" ] && [ -f "backend/package.json" ]; then
    cd backend
    npm install
    cd ..
    echo "✅ Backend configurado"
else
    echo "❌ Backend no encontrado"
    exit 1
fi

# Setup frontend básico
echo "📦 Configurando frontend básico..."
mkdir -p frontend
if [ ! -f "frontend/package.json" ]; then
    cat > frontend/package.json << 'EOF'
{
  "name": "frontend",
  "version": "1.0.0", 
  "type": "module",
  "scripts": {
    "dev": "echo 'Frontend no configurado'",
    "build": "echo 'Frontend no configurado'",
    "test": "echo 'No tests'",
    "lint": "echo 'No linting'"
  }
}
EOF
fi

# Configurar Git
echo "🔗 Configurando Git..."
if [ ! -d ".git" ]; then
    git init
    git checkout -b main
    git checkout -b development
fi

echo ""
echo "✅ CONFIGURACIÓN COMPLETADA"
echo ""
echo "🎯 PRÓXIMOS PASOS:"
echo "   1. make docker-up       # Iniciar contenedores"
echo "   2. make db-migrate      # Ejecutar migraciones" 
echo "   3. make dev-backend     # Iniciar desarrollo"
echo "   4. make status          # Verificar estado"
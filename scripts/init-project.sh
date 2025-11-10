#!/bin/bash

set -e

echo "🚀 Inicializando proyecto NODE-TS-API..."

# Verificar que estamos en el directorio correcto
if [ ! -f "Makefile" ]; then
    echo "❌ Error: Debes ejecutar este script desde la raíz del proyecto"
    exit 1
fi

# Crear estructura de directorios
echo "📁 Creando estructura de directorios..."
mkdir -p frontend scripts/backups infrastructure/kubernetes docs/api

# Configurar Git
echo "🔧 Configurando Git..."

# Inicializar Git si no está inicializado
if [ ! -d ".git" ]; then
    git init
fi

# Crear ramas principales
git checkout -b main
git checkout -b development

# Configurar gitignore global
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Production builds
dist/
build/

# Environment variables
.env
.env.local
.env.production

# Logs
logs/
*.log
npm-debug.log*

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Docker
.docker/

# Backup files
*.bak
*.backup

# Temporary files
tmp/
temp/

# Database
*.db
*.sqlite
*-journal

# SSL
*.pem
*.key
*.crt

# Archives
*.tar.gz
*.zip
*.7z

# Runtime data for Docker Compose
data/
EOF

# Configurar gitattributes para manejar line endings
cat > .gitattributes << 'EOF'
# Auto detect text files and perform LF normalization
* text=auto

# These files are text and should be normalized
*.js text
*.ts text
*.json text
*.md text
*.txt text
*.yml text
*.yaml text
*.xml text
*.html text
*.css text
*.scss text

# These files are binary and should not be modified
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.ico binary
*.pdf binary
*.woff binary
*.woff2 binary
*.eot binary
*.ttf binary
*.svg binary
EOF

echo "✅ Proyecto inicializado correctamente"
echo "📝 Next steps:"
echo "   1. git remote add origin https://github.com/tu-usuario/NODE-TS-API.git"
echo "   2. git add ."
echo "   3. git commit -m 'Initial commit: Project structure'"
echo "   4. git push -u origin development"
#!/bin/bash

set -e

echo "🔍 Ejecutando verificaciones de calidad de código..."

# Verificar formato de commit messages (para hooks)
check_commit_message() {
    local message=$1
    local pattern="^(feat|fix|docs|style|refactor|test|chore|ci|build|perf|revert)(\([a-z-]+\))?: .+$"
    
    if ! echo "$message" | grep -qE "$pattern"; then
        echo "❌ Invalid commit message format: $message"
        echo "   Use: <type>(<scope>): <description>"
        return 1
    fi
    return 0
}

# Verificar que no hay archivos de entorno
check_env_files() {
    if git ls-files | grep -E "\.env"; then
        echo "❌ Se encontraron archivos .env en el repositorio"
        return 1
    fi
    return 0
}

# Verificar que el backend compila
check_backend_build() {
    echo "🏗 Verificando compilación del backend..."
    cd backend
    
    if ! npm run typecheck; then
        echo "❌ TypeScript compilation failed"
        return 1
    fi
    
    if ! npm run build; then
        echo "❌ Build failed"
        return 1
    fi
    
    cd ..
    return 0
}

# Verificar estructura de archivos
check_project_structure() {
    echo "📁 Verificando estructura del proyecto..."
    
    local required_dirs=("backend" "scripts" "infrastructure" "docs")
    local missing_dirs=()
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            missing_dirs+=("$dir")
        fi
    done
    
    if [ ${#missing_dirs[@]} -ne 0 ]; then
        echo "❌ Directorios faltantes: ${missing_dirs[*]}"
        return 1
    fi
    
    return 0
}

# Ejecutar todas las verificaciones
run_all_checks() {
    local all_passed=true
    
    if ! check_project_structure; then
        all_passed=false
    fi
    
    if ! check_env_files; then
        all_passed=false
    fi
    
    if ! check_backend_build; then
        all_passed=false
    fi
    
    if $all_passed; then
        echo "✅ Todas las verificaciones pasaron"
        return 0
    else
        echo "❌ Algunas verificaciones fallaron"
        return 1
    fi
}

case $1 in
    "pre-commit")
        check_commit_message "$(cat $2)"
        ;;
    "pre-push")
        run_all_checks
        ;;
    "full")
        run_all_checks
        ;;
    *)
        echo "Uso: $0 [pre-commit|pre-push|full]"
        ;;
esac
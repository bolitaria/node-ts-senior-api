#!/bin/bash

set -e

echo "🔄 Iniciando workflow de desarrollo..."

# Función para mostrar ayuda
show_help() {
    echo "Uso: $0 [comando]"
    echo ""
    echo "Comandos:"
    echo "  start-feature <nombre>  - Crear nueva feature branch"
    echo "  finish-feature          - Terminar feature y mergear a development"
    echo "  start-hotfix <nombre>   - Crear hotfix branch desde main"
    echo "  finish-hotfix           - Terminar hotfix y mergear a main/development"
    echo "  create-release <version> - Crear release desde development"
    echo "  deploy-staging         - Desplegar en staging"
    echo "  deploy-production      - Desplegar en producción"
}

# Verificar que estamos en el directorio correcto
if [ ! -f "Makefile" ]; then
    echo "❌ Error: Debes ejecutar este script desde la raíz del proyecto"
    exit 1
fi

case $1 in
    "start-feature")
        if [ -z "$2" ]; then
            echo "❌ Debes proporcionar un nombre para la feature"
            exit 1
        fi
        
        FEATURE_NAME=$2
        echo "🌱 Creando feature branch: feature/$FEATURE_NAME"
        
        # Asegurarse de estar en development
        git checkout development
        git pull origin development
        
        # Crear nueva rama
        git checkout -b "feature/$FEATURE_NAME"
        
        echo "✅ Feature branch creada. ¡Feliz coding!"
        ;;
        
    "finish-feature")
        CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
        
        if [[ ! $CURRENT_BRANCH =~ ^feature/ ]]; then
            echo "❌ No estás en una feature branch"
            exit 1
        fi
        
        echo "🎯 Finalizando feature: $CURRENT_BRANCH"
        
        # Actualizar development
        git checkout development
        git pull origin development
        
        # Mergear la feature
        git merge --no-ff "$CURRENT_BRANCH" -m "feat: merge $CURRENT_BRANCH into development"
        
        # Push a development
        git push origin development
        
        # Eliminar branch local y remota
        git branch -d "$CURRENT_BRANCH"
        git push origin --delete "$CURRENT_BRANCH" 2>/dev/null || true
        
        echo "✅ Feature mergeada y branch eliminada"
        ;;
        
    "start-hotfix")
        if [ -z "$2" ]; then
            echo "❌ Debes proporcionar un nombre para el hotfix"
            exit 1
        fi
        
        HOTFIX_NAME=$2
        echo "🚑 Creando hotfix branch: hotfix/$HOTFIX_NAME"
        
        # Asegurarse de estar en main
        git checkout main
        git pull origin main
        
        # Crear nueva rama
        git checkout -b "hotfix/$HOTFIX_NAME"
        
        echo "✅ Hotfix branch creada"
        ;;
        
    "finish-hotfix")
        CURRENT_BRANCH=$(git symbolic-ref --short HEAD)
        
        if [[ ! $CURRENT_BRANCH =~ ^hotfix/ ]]; then
            echo "❌ No estás en una hotfix branch"
            exit 1
        fi
        
        echo "🔧 Finalizando hotfix: $CURRENT_BRANCH"
        
        # Mergear a main
        git checkout main
        git pull origin main
        git merge --no-ff "$CURRENT_BRANCH" -m "fix: $CURRENT_BRANCH"
        
        # Mergear a development
        git checkout development
        git pull origin development
        git merge main -m "chore: merge hotfix from main"
        
        # Push ambas ramas
        git push origin main
        git checkout main
        git push origin development
        
        # Eliminar branch local y remota
        git branch -d "$CURRENT_BRANCH"
        git push origin --delete "$CURRENT_BRANCH" 2>/dev/null || true
        
        echo "✅ Hotfix completado y mergeado a main/development"
        ;;
        
    "create-release")
        if [ -z "$2" ]; then
            echo "❌ Debes proporcionar una versión (ej: v1.0.0)"
            exit 1
        fi
        
        VERSION=$2
        echo "🏷 Creando release: $VERSION"
        
        # Asegurarse de estar en development
        git checkout development
        git pull origin development
        
        # Crear branch de release
        git checkout -b "release/$VERSION"
        
        # Actualizar versiones si es necesario
        # (Aquí podrías actualizar package.json, etc.)
        
        # Mergear a main
        git checkout main
        git pull origin main
        git merge --no-ff "release/$VERSION" -m "release: $VERSION"
        
        # Taggear la release
        git tag -a "$VERSION" -m "Release $VERSION"
        
        # Push a main y tags
        git push origin main
        git push origin "$VERSION"
        
        # Mergear a development
        git checkout development
        git merge main -m "chore: merge release $VERSION"
        git push origin development
        
        # Eliminar branch de release
        git branch -d "release/$VERSION"
        
        echo "✅ Release $VERSION creada y publicada"
        ;;
        
    "deploy-staging")
        echo "🚀 Desplegando en staging..."
        
        # Asegurarse de estar en development
        git checkout development
        git pull origin development
        
        # Aquí iría tu lógica de deploy a staging
        echo "📦 Implementar lógica de deploy a staging aquí"
        
        echo "✅ Deploy a staging completado"
        ;;
        
    "deploy-production")
        echo "🚀 Desplegando en producción..."
        
        # Asegurarse de estar en main
        git checkout main
        git pull origin main
        
        # Aquí iría tu lógica de deploy a producción
        echo "📦 Implementar lógica de deploy a producción aquí"
        
        echo "✅ Deploy a producción completado"
        ;;
        
    *)
        show_help
        ;;
esac
#!/bin/bash

set -e

echo "💾 Gestor de backups..."

BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

show_help() {
    echo "Uso: $0 [comando]"
    echo ""
    echo "Comandos:"
    echo "  create <nombre>    - Crear backup"
    echo "  list              - Listar backups"
    echo "  restore <nombre>  - Restaurar backup"
    echo "  cleanup           - Eliminar backups antiguos"
}

create_backup() {
    local name=$1
    local backup_path="$BACKUP_DIR/${TIMESTAMP}_${name}"
    
    echo "📦 Creando backup: $backup_path"
    
    mkdir -p "$backup_path"
    
    # Backup de código
    echo "  Backup de código..."
    git bundle create "$backup_path/code.bundle" --all
    
    # Backup de configuración
    echo "  Backup de configuración..."
    cp -r backend/.env* "$backup_path/" 2>/dev/null || true
    
    # Backup de base de datos (si está corriendo)
    echo "  Backup de base de datos..."
    cd backend
    docker-compose exec -T postgres pg_dumpall -U admin > "../$backup_path/database.sql" 2>/dev/null || true
    cd ..
    
    # Crear checksum
    find "$backup_path" -type f -exec sha256sum {} \; > "$backup_path/checksums.sha256"
    
    # Comprimir
    tar -czf "$backup_path.tar.gz" -C "$BACKUP_DIR" "${TIMESTAMP}_${name}"
    rm -rf "$backup_path"
    
    echo "✅ Backup creado: $backup_path.tar.gz"
}

list_backups() {
    echo "📋 Backups disponibles:"
    find "$BACKUP_DIR" -name "*.tar.gz" -type f | sort -r
}

restore_backup() {
    local name=$1
    local backup_file="$BACKUP_DIR/${name}.tar.gz"
    
    if [ ! -f "$backup_file" ]; then
        echo "❌ Backup no encontrado: $backup_file"
        exit 1
    fi
    
    echo "🔄 Restaurando backup: $name"
    
    # Extraer backup
    local temp_dir=$(mktemp -d)
    tar -xzf "$backup_file" -C "$temp_dir"
    
    # Verificar integridad
    echo "  Verificando integridad..."
    cd "$temp_dir/${name%.tar.gz}"
    if sha256sum -c checksums.sha256; then
        echo "  ✅ Integridad verificada"
        
        # Restaurar código
        echo "  Restaurando código..."
        git clone code.bundle restored_code
        
        # Aquí podrías agregar más lógica de restauración
        
        echo "✅ Backup restaurado en: restored_code"
    else
        echo "❌ El backup está corrupto"
        exit 1
    fi
    
    # Limpiar
    rm -rf "$temp_dir"
}

cleanup_backups() {
    echo "🧹 Limpiando backups antiguos..."
    
    # Mantener solo los últimos 10 backups
    find "$BACKUP_DIR" -name "*.tar.gz" -type f | sort -r | tail -n +11 | while read backup; do
        echo "  Eliminando: $backup"
        rm "$backup"
    done
    
    echo "✅ Limpieza completada"
}

# Crear directorio de backups
mkdir -p "$BACKUP_DIR"

case $1 in
    "create")
        if [ -z "$2" ]; then
            echo "❌ Debes proporcionar un nombre para el backup"
            exit 1
        fi
        create_backup "$2"
        ;;
    "list")
        list_backups
        ;;
    "restore")
        if [ -z "$2" ]; then
            echo "❌ Debes proporcionar el nombre del backup a restaurar"
            exit 1
        fi
        restore_backup "$2"
        ;;
    "cleanup")
        cleanup_backups
        ;;
    *)
        show_help
        ;;
esac
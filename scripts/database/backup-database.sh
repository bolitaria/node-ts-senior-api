#!/bin/bash

set -e

echo "💾 DATABASE BACKUP"
echo "=================="

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="backups"
BACKUP_FILE="backup_${TIMESTAMP}.sql"

mkdir -p $BACKUP_DIR

echo "📦 Creating backup: $BACKUP_FILE"

# Backup PostgreSQL (assuming Docker)
docker-compose exec -T postgres pg_dump -U user appdb > "${BACKUP_DIR}/${BACKUP_FILE}"

echo "✅ Backup created: ${BACKUP_DIR}/${BACKUP_FILE}"
echo "📊 Backup size: $(du -h "${BACKUP_DIR}/${BACKUP_FILE}" | cut -f1)"
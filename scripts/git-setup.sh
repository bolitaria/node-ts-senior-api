#!/bin/bash

echo "CONFIGURACIÓN GIT PROFESIONAL"
echo "================================"

# Configuración inicial de Git
git init

# Crear ramas principales
git checkout -b main
git checkout -b develop
git checkout -b staging

# Crear ramas de soporte
git checkout -b hotfix
git checkout -b release

# Volver a develop
git checkout develop

echo "✅ Ramas creadas:"
echo "   - main (producción)"
echo "   - develop (desarrollo)"
echo "   - staging (pre-producción)"
echo "   - hotfix (parches urgentes)"
echo "   - release (preparación releases)"

# Configurar rama por defecto
git symbolic-ref HEAD refs/heads/develop

echo "Configuración de Git completada"
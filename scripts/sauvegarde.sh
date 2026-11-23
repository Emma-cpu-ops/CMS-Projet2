#!/bin/bash
# ==============================================================================
# Script de sauvegarde - Projet Boutique WooCommerce (Partie 7)
# Rôle 3 : DevOps, Docker & API
# ==============================================================================

set -e

BACKUP_DIR="$(pwd)/sauvegardes"
DATE=$(date +%F)
mkdir -p "$BACKUP_DIR"

echo "📦 [1/2] Export de la base de données..."
if command -v wp &> /dev/null; then
    # Exécution directe si lancé dans le shell Local/Studio
    wp db export "$BACKUP_DIR/base-$DATE.sql"
else
    # Exécution via Docker Compose
    COMPOSE="docker-compose"
    if docker compose version &>/dev/null; then COMPOSE="docker compose"; fi
    $COMPOSE run --rm cli wp db export "/sauvegardes/base-$DATE.sql" --allow-root
fi

echo "🖼️ [2/2] Compression des médias (dossier uploads)..."
if [ -d "wp-content/uploads" ]; then
    tar -czf "$BACKUP_DIR/medias-$DATE.tar.gz" -C wp-content uploads
    echo "📁 Archive des médias créée dans $BACKUP_DIR/medias-$DATE.tar.gz"
fi

echo "✅ Sauvegarde terminée avec succès dans le dossier sauvegardes/ !"

#!/bin/bash
# ==============================================================================
# Script de restauration - Projet Boutique WooCommerce (Partie 7)
# Rôle 3 : DevOps, Docker & API
# ==============================================================================

set -e

# Détection de la commande compose disponible
if docker compose version &>/dev/null; then
    COMPOSE="docker compose"
else
    COMPOSE="docker-compose"
fi

# Recherche du fichier SQL le plus récent dans sauvegardes/
SQL_FILE=$(ls -t sauvegardes/base-*.sql 2>/dev/null | head -n 1)

if [ -z "$SQL_FILE" ]; then
    # Fallback si le fichier s'appelle db_backup.sql
    if [ -f "sauvegardes/db_backup.sql" ]; then
        SQL_FILE="sauvegardes/db_backup.sql"
    else
        echo "❌ Aucun fichier SQL trouvé dans le dossier sauvegardes/ (ex: sauvegardes/base-YYYY-MM-DD.sql)."
        exit 1
    fi
fi

SQL_FILENAME=$(basename "$SQL_FILE")

echo "🚀 [1/4] Démarrage des conteneurs Docker..."
$COMPOSE up -d

echo "🔄 [2/4] Import de la base de données ($SQL_FILENAME)..."
$COMPOSE run --rm cli wp db import "/sauvegardes/$SQL_FILENAME" --allow-root

echo "🌐 [3/4] Remplacement des URLs (search-replace) vers http://localhost:8080..."
# Adapte les URLs d'origine vers l'adresse Docker locale
$COMPOSE run --rm cli wp search-replace "http://boutique.local" "http://localhost:8080" --all-tables --allow-root || true
$COMPOSE run --rm cli wp search-replace "http://localhost" "http://localhost:8080" --all-tables --allow-root || true

echo "🔌 [4/4] Vérification et activation de l'extension WooCommerce..."
$COMPOSE run --rm cli wp plugin install woocommerce --activate --allow-root || true

echo "✅ Restauration terminée avec succès !"
echo "👉 Votre boutique est accessible sur : http://localhost:8080"

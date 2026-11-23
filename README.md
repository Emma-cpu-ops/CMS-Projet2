# 🛒 Projet E-Commerce : Boutique WooCommerce

> **Module :** B3.2 CMS, E-Commerce & Mobile (M1 Info Dev - IRIS)  
> **Échéance de rendu :** Lundi 7 décembre 2026 (avant le début du cours)  
> **Soutenance :** 5 minutes par groupe le 7 décembre 2026  
> **Dépôt Git :** [https://github.com/Emma-cpu-ops/CMS-Projet2](https://github.com/Emma-cpu-ops/CMS-Projet2)

---

## 👥 Équipe & Rôles

* **Membre 1 (Identité & Design) :** *(Allan)* — Charte graphique, logo, thème en blocs Twenty Twenty-Five, pages d'accueil et responsive (390px).
* **Membre 2 (Cadrage & Catalogue) :** *(Dibé)* — Note de cadrage `NOTE.md`, 12 fiches produits, variations, promotions, TVA, livraison.
* **Membre 3 (DevOps, Docker & API) :** **Emmanuelle** — Docker Compose, scripts d'automatisation, collection Postman API, sécurité.

---

## 🏢 Présentation du Client & de la Boutique

* **Commerce choisi :** *Savonnerie*
* **Nom de la marque :** *Kabakourou*
* **Slogan & Promesse :** *(Exemple : Cafés de spécialité torréfiés localement et issus du commerce équitable)*
* **Cible :** Particuliers et amateurs de produits artisanaux à la recherche de qualité et de traçabilité.

---

## 🚀 Guide de Démarrage & Relance de la Boutique

Ce guide permet à tout évaluateur de cloner le dépôt et de relancer la boutique localement en quelques minutes grâce à Docker.

### Prérequis
* [Docker](https://www.docker.com/) ou [Colima](https://github.com/abiosoft/colima) actif sur la machine.
* `docker-compose` ou plugin `docker compose` installé.

### Procédure d'installation

```bash
# 1. Cloner le dépôt et entrer dans le dossier
git clone https://github.com/Emma-cpu-ops/CMS-Projet2.git
cd CMS-Projet2

# 2. Préparer les variables d'environnement
cp .env.example .env

# 3. Démarrer les conteneurs (WordPress + MariaDB)
docker-compose up -d

# 4. Restaurer la base de données et les médias de démonstration
bash scripts/restauration.sh
```

👉 **Accès à la boutique :** [http://localhost:8080](http://localhost:8080)  
👉 **Back-office WordPress :** [http://localhost:8080/wp-admin](http://localhost:8080/wp-admin)

---

## 📸 Captures d'Écran Obligatoires (6 Vues Clés)

| # | Vue | Aperçu |
| :-: | :--- | :--- |
| **1** | **Page d'accueil (Desktop)**<br>*(Bannière, sélection produits, réassurance)* | ![Accueil](charte/captures/01-accueil.png) |
| **2** | **Fiche produit détaillée**<br>*(Variations d'attributs, stock et prix TTC)* | ![Produit](charte/captures/02-produit.png) |
| **3** | **Panier d'achat**<br>*(Calcul TVA, frais de port, code promo)* | ![Panier](charte/captures/03-panier.png) |
| **4** | **Tunnel de commande / Checkout**<br>*(Paiement test, case de consentement)* | ![Commande](charte/captures/04-commande.png) |
| **5** | **Vue mobile responsive**<br>*(Testé et vérifié à 390 px de large)* | ![Mobile](charte/captures/05-mobile-390px.png) |
| **6** | **Boutique restaurée sous Docker**<br>*(Tournant sur http://localhost:8080)* | ![Docker](charte/captures/06-docker-restauration.png) |

---

## 🖼️ Sources des Médias & Crédits Photos

Conformément aux consignes, aucune photo ne provient d'une marque commerciale. Toutes les images sont libres de droits :
* **Images produits & bannières :** [Unsplash](https://unsplash.com) & [Pexels](https://pexels.com) (auteurs cités dans la note de livraison).
* **Logo & pictogrammes :** Création vectorielle originale (SVG fond transparent) située dans le dossier `charte/`.

---

## 🔌 Documentation de l'API WooCommerce (Partie 5)

La collection Postman complète et exécutable se trouve dans [`api/boutique.postman_collection.json`](file:///Users/emmanuelle/CMS-Projet2/api/boutique.postman_collection.json). Elle utilise la variable `{{baseUrl}}` (`http://localhost:8080`).

### Analyse des 5 requêtes et de leurs en-têtes (Headers) :

1. **`GET /wp-json/wc/store/v1/products`**
   * **En-têtes envoyés :** `Accept: application/json` pour demander une réponse au format JSON.
   * **En-têtes reçus :** `Content-Type: application/json`, `X-WP-Total` (nombre total de produits) et `X-WP-TotalPages`.
   * **Vérification :** Renvoie un code `200 OK` avec la liste des produits et les prix en centimes (`currency_minor_unit`).

2. **`GET /wp-json/wc/store/v1/cart`**
   * **En-têtes envoyés :** Aucun en-tête d'authentification particulier lors de l'appel initial.
   * **En-têtes reçus :** Le serveur retourne l'en-tête `Cart-Token: <token>`, qui identifie de manière unique le panier du visiteur sans session PHP classique. Ce jeton est automatiquement sauvegardé dans la variable d'environnement Postman `cartToken`.

3. **`POST /wp-json/wc/store/v1/cart/add-item`**
   * **En-têtes envoyés :** `Cart-Token: {{cartToken}}` pour lier l'ajout au panier créé, et `Content-Type: application/json` avec l'ID du produit dans le body.
   * **En-têtes reçus :** `Cart-Token` mis à jour et code de statut `201 Created` confirmant l'ajout de l'article.

4. **`POST /wp-json/wc/store/v1/checkout`**
   * **En-têtes envoyés :** `Cart-Token: {{cartToken}}` et `Content-Type: application/json` contenant les coordonnées de facturation et de livraison du client fictif.
   * **En-têtes reçus :** Statut `200 OK` ou `201 Created` avec les détails de la commande créée dans WooCommerce.

5. **`GET /wp-json/wc/v3/orders` (sans clé d'API)**
   * **En-têtes envoyés :** Requête brute sans en-tête d'autorisation (`Authorization` absent).
   * **En-têtes reçus :** `HTTP/1.1 401 Unauthorized` avec message `woocommerce_rest_cannot_view`.
   * **Pourquoi c'est une excellente nouvelle :** Cela démontre que les données sensibles d'administration (commandes, adresses des clients, montants) sont hermétiquement protégées et inaccessibles aux utilisateurs non authentifiés.

---

## 🛡️ Mesures de Sécurité en Place & Recommandations Production (Partie 6)

Cinq mesures clés sont appliquées ou prévues pour le passage en production :

1. **Suppression du compte `admin` générique :**
   * *Risque couvert :* Attaques par force brute automatisées ciblant le nom d'utilisateur par défaut `admin`. Un identifiant personnalisé complexe est utilisé.
2. **Cloisonnement des secrets et variables (`.env`) :**
   * *Risque couvert :* Fuite d'identifiants de base de données et de clés secrètes sur GitHub. Le `.gitignore` bloque strictement le `.env` et les clés privées.
3. **Limitation des tentatives de connexion (Rate Limiting) :**
   * *Risque couvert :* Attaques par déni de service et force brute sur la page `wp-login.php` et sur l'endpoint REST API d'authentification.
4. **Masquage de la liste des utilisateurs dans l'API REST :**
   * *Risque couvert :* Énumération des comptes (`/wp-json/wp/v2/users`) permettant à un pirate de découvrir les logins des administrateurs et rédacteurs.
5. **Principe du moindre privilège pour les rôles WooCommerce :**
   * *Risque couvert :* Élévation de privilèges. Les comptes clients ne possèdent que le rôle `Customer` et les gestionnaires de boutique le rôle `Shop Manager`, sans accès aux fichiers ni aux extensions.

---

## 💾 Stratégie de Sauvegarde & Déploiement (Partie 7)

### 1. Automatisation nocturne par tâche Cron
Sur un serveur de production Linux, le script `scripts/sauvegarde.sh` serait planifié chaque nuit à 3h00 du matin via la crontab système :
```cron
0 3 * * * /bin/bash /var/www/boutique/scripts/sauvegarde.sh >> /var/log/backup_boutique.log 2>&1
```
* **Destination des fichiers :** Les sauvegardes ne doivent **jamais** rester sur le même disque que le site (en cas de panne matérielle du serveur). Elles sont automatiquement chiffrées et synchronisées vers un stockage objet distant (ex. bucket AWS S3, Cloudflare R2 ou serveur NAS dédié) via l'outil `rclone` ou `aws s3 sync`.

### 2. Comparatif : Hébergement mutualisé avec cPanel vs Docker / VPS

| Critère | Hébergement mutualisé cPanel | Déploiement Conteneurisé (Docker / VPS) |
| :--- | :--- | :--- |
| **Mise en place** | Simple via SFTP, phpMyAdmin et interface graphique | Nécessite des compétences DevOps et un terminal SSH |
| **Gestion DB & Fichiers** | Import manuel via phpMyAdmin (limite d'upload PHP) | Automatisation scriptée via WP-CLI sans limite de taille |
| **Reproductibilité** | Dépend de la version PHP et des modules de l'hébergeur | 100% reproductible à l'identique grâce aux images Docker |
| **Performance & Isolation** | Ressources partagées avec d'autres clients | Ressources dédiées et isolation complète des services |
| **Quand choisir ?** | Petit site vitrine avec budget restreint et sans dev dédié | Boutique e-commerce critique avec besoins de scalabilité |

### 3. Comparatif : Script shell maison vs Extension WordPress (ex. UpdraftPlus)

* **Ce qu'une extension fait de plus :** Interface graphique pour débutants, planification native depuis le tableau de bord WordPress, envoi direct en un clic vers Google Drive / Dropbox, restauration guidée sans toucher au terminal.
* **Ce qu'une extension fait de moins (sa faille critique) :** Elle est exécutée **à l'intérieur** de WordPress. Si le cœur WordPress est corrompu, infecté par un malware, ou si une erreur critique PHP empêche le site de démarrer ("White Screen of Death"), l'extension est inaccessible et ne peut pas restaurer le site. Le script shell, exécuté depuis l'extérieur par le système d'exploitation, fonctionne en toute circonstance.

---

## 🎤 Déroulé de la Soutenance (5 Minutes Chrono)

Chaque membre prend la parole obligatoirement :

* **1 min (Membre 1) :** Identité du client, proposition de valeur, charte graphique et intégration du thème.
* **2 min (Membre 2) :** Démonstration en direct du parcours d'achat (fiche produit, variation, panier, code promo, validation).
* **1 min (Membre 3 - Emmanuelle) :** Démonstration technique (restauration Docker ou exécution des requêtes Postman).
* **1 min (Collectif) :** Rétrospective, difficultés surmontées et axes d'amélioration.

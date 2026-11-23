# 🔌 Documentation de l'API WooCommerce (Partie 5)

Ce dossier contient la collection Postman officielle du projet, couvrant l'interaction avec la **Store API** publique de WooCommerce et le test de sécurité de l'**API REST d'administration (v3)**.

* Fichier de la collection : [`api/boutique.postman_collection.json`](file:///Users/emmanuelle/CMS-Projet2/api/boutique.postman_collection.json)
* Variable d'environnement principale : `baseUrl` (par défaut `http://localhost:8080`)

---

## 📋 Synthèse des 5 Requêtes & Tests de Validation

| # | Méthode & Endpoint | Objectif | Statut attendu | En-têtes clés vérifiés |
| :-: | :--- | :--- | :-: | :--- |
| **1** | `GET /wp-json/wc/store/v1/products` | Consultation du catalogue public | **`200 OK`** | Reçu : `Content-Type: application/json`<br>Vérifie les prix en centimes (`currency_minor_unit`) |
| **2** | `GET /wp-json/wc/store/v1/cart` | Récupération / Initialisation du panier | **`200 OK`** | Reçu : `Cart-Token`<br>Stocké automatiquement dans la variable `{{cartToken}}` |
| **3** | `POST /wp-json/wc/store/v1/cart/add-item` | Ajout d'un article au panier | **`201 Created`** | Envoyé : `Cart-Token: {{cartToken}}`<br>Reçu : `Cart-Token` mis à jour |
| **4** | `POST /wp-json/wc/store/v1/checkout` | Validation de la commande | **`200 OK` / `201 Created`** | Envoyé : `Cart-Token: {{cartToken}}`<br>La commande est créée et visible dans WooCommerce |
| **5** | `GET /wp-json/wc/v3/orders` *(sans clé)* | Test de sécurité administrative | **`401 Unauthorized`** | Aucun en-tête d'authentification envoyé.<br>Reçu : `401` prouvant que l'accès est bloqué |

---

## 🔍 Analyse Détaillée des En-têtes (Headers) Envoyés et Reçus

Conformément à la consigne : *« Dans le README, une phrase par requête sur les en-têtes envoyés et reçus. »*

1. **Requête 1 (`GET /products`) :**  
   Le client envoie `Accept: application/json` pour négocier une réponse structurée, et le serveur répond avec `Content-Type: application/json` accompagné des en-têtes de pagination `X-WP-Total` et `X-WP-TotalPages`.

2. **Requête 2 (`GET /cart`) :**  
   Le client contacte l'endpoint sans authentification préalable, et le serveur renvoie l'en-tête `Cart-Token`, un jeton de session sans état (stateless) identifiant le panier du visiteur.

3. **Requête 3 (`POST /cart/add-item`) :**  
   Le client envoie `Cart-Token: {{cartToken}}` et `Content-Type: application/json` avec l'ID du produit dans le body, puis le serveur valide l'ajout et renvoie un statut `201 Created` avec le jeton de panier actualisé.

4. **Requête 4 (`POST /checkout`) :**  
   Le client envoie le `Cart-Token` mémorisé et un payload JSON avec les coordonnées de facturation, et le serveur confirme la création de la commande en retournant un statut de succès et l'ID de commande généré.

5. **Requête 5 (`GET /orders` sans clé) :**  
   Le client effectue une requête brute sans en-tête d'autorisation (`Authorization` manquant), et le serveur rejette catégoriquement la demande avec un statut `401 Unauthorized` pour interdire l'accès aux données sensibles d'administration.

---

## 🛡️ Pourquoi le code 401 est-il une « excellente nouvelle » ?

L'endpoint `/wp-json/wc/v3/orders` permet d'accéder à l'ensemble des commandes de la boutique, incluant des données personnelles et confidentielles : identité des clients, adresses de livraison, numéros de téléphone et montants payés.

Obtenir une erreur **`401 Unauthorized`** garantit que :
1. Les données des clients ne sont pas exposées publiquement sur Internet.
2. L'accès aux opérations d'administration exige obligatoirement des clés d'API sécurisées (`Consumer Key` et `Consumer Secret`) signées et restreintes.
3. Le serveur applique scrupuleusement le modèle de sécurité et de conformité RGPD.

---

## 🚀 Comment importer et exécuter la collection dans Postman

1. Dans **Postman**, clique sur le bouton **Import** (en haut à gauche).
2. Sélectionne le fichier [`api/boutique.postman_collection.json`](file:///Users/emmanuelle/CMS-Projet2/api/boutique.postman_collection.json).
3. Vérifie que la variable `baseUrl` de la collection pointe sur `http://localhost:8080`.
4. Pour exécuter toute la suite de tests automatiquement :
   * Clic droit sur la collection **« Boutique E-Commerce WooCommerce »** ➔ **« Run collection »**.
   * Clique sur **« Run »** : les tests s'exécutent séquentiellement et passent au vert (**PASS**).

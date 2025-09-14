# Taram Event

## Application mobile de gestion d'événements et de billetterie numérique

### Description du projet

**Taram Event** est une solution mobile complète, conçue pour transformer la gestion d'événements et l'expérience de la billetterie. Elle permet aux organisateurs (concerts, conférences, soirées, salons) de créer, promouvoir et gérer leurs événements directement depuis leur smartphone. Pour les participants, l'application simplifie la découverte d'événements, l'achat de billets numériques sécurisés et l'accès rapide aux lieux via un simple QR Code.

### Objectifs clés

- **Simplifier la gestion :** Offrir une plateforme intuitive aux organisateurs pour la création et la promotion d'événements.
- **Optimiser l'expérience utilisateur :** Faciliter l'achat, la réception et la validation des billets pour les participants.
- **Sécuriser et innover :** Remplacer les billets papier par des solutions numériques sécurisées basées sur des QR Codes, réduisant ainsi la fraude et l'impact écologique.

---

## Fonctionnalités principales

### Rôles utilisateurs

L'application propose trois rôles distincts, chacun avec des fonctionnalités dédiées :

- **Organisateur / Gestionnaire :** Crée et configure des événements (date, lieu, prix, capacité), gère les images promotionnelles, suit les ventes en temps réel et valide les billets à l'entrée avec un scanner QR.
- **Participant / Utilisateur :** Explore les événements par catégorie ou lieu, consulte les détails, achète des tickets en ligne et reçoit un QR Code unique pour l'accès.
- **Administrateur :** Gère l'ensemble de la plateforme, modère le contenu, gère les utilisateurs et les organisateurs et supervise les transactions.

### MVP (Minimum Viable Product)

La première version de l'application inclura les fonctionnalités essentielles pour un lancement efficace :

- **Authentification :** Inscription et connexion sécurisée (email, téléphone, réseaux sociaux).
- **Gestion de profil :** Espaces dédiés pour chaque rôle (Organisateur, Utilisateur).
- **Création d'événement :** Formulaire détaillé avec ajout d'images et de vidéos.
- **Découverte d'événements :** Liste avec filtres de recherche (catégorie, ville, date).
- **Billetterie numérique :** Achat de tickets en ligne et génération instantanée d'un QR Code unique.
- **Validation des tickets :** Module de scan QR Code pour un contrôle d'accès rapide et fiable.
- **Tableau de bord :** Vue en temps réel des ventes et des revenus pour les organisateurs.

### Fonctionnalités de la version améliorée

Pour les futures versions, nous prévoyons d'ajouter des fonctionnalités qui enrichiront l'expérience :

- **Notifications Push :** Rappels d'événements, annonces de nouvelles mises à jour.
- **Mode hors ligne :** Validation des billets sans connexion internet.
- **Intégration sociale :** Partage d'événements et invitations via les réseaux sociaux.
- **Programme de fidélité :** Récompenses pour les utilisateurs fréquents (réductions, points).
- **Avis et commentaires :** Permettre aux participants de donner leur avis sur les événements passés.

---

## Stack technique

- **Front-end Mobile :** **Flutter** pour une application performante sur **Android et iOS**.
- **Front-end Web :** **JTE** et **Bootstrap** pour une interface web simple et efficace.
- **Back-end :** **Spring Boot** (Java) avec une architecture **REST API** pour une communication robuste.
- **Base de données :** **PostgreSQL**, choisie pour sa fiabilité, sa scalabilité et sa gestion des transactions complexes.
- **Paiement :** Intégration de solutions de paiement sécurisées (ex. **Stripe**, **PayPal** ou solutions locales comme **IPay**).
- **QR Code :** Bibliothèques dédiées comme **`qr_flutter`** pour la génération et **`qr_code_scanner`** pour la lecture.
- **Notifications :** **Firebase Cloud Messaging (FCM)** ou **Supabase** pour des notifications push fiables.

---

## Points de vigilance et défis techniques

- **Sécurité des transactions :** Mettre en place des protocoles de sécurité stricts pour les paiements et la protection des données utilisateur.
- **Fiabilité de la billetterie :** Assurer l'unicité et la non-reproduction des QR Codes pour prévenir la fraude.
- **Gestion des remboursements :** Développer un système clair et automatisé pour le traitement des demandes d'annulation.
- **Performance hors ligne :** Garantir que la validation des billets fonctionne de manière fluide, même sans connexion internet stable.
- **Évolutivité :** Concevoir une architecture capable de gérer un grand nombre d'événements et de participants simultanément.

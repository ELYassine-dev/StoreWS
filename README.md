# StoreWS
Application web simple développée en Java EE avec une architecture en microservices pour la gestion de la vente de produits.

# Mini Projet Java EE : StoreWS

## Description du Projet

Ce projet consiste à développer une application web permettant la vente de produits avec un système de gestion des clients et des factures. L'application est conçue en architecture microservices pour assurer modularité et scalabilité.

## Fonctionnalités Principales

### 1. Gestion des Produits
- **Ajouter un Produit** : Permet d'ajouter de nouveaux produits.
- **Modifier un Produit** : Mise à jour des détails d'un produit existant.
- **Supprimer un Produit** : Retirer un produit du catalogue.
- **Lister les Produits** : Affichage des produits disponibles.

### 2. Gestion des Clients
- **Ajouter un Client** : Enregistrement de nouveaux clients.
- **Modifier un Client** : Mise à jour des informations client.
- **Supprimer un Client** : Suppression d'un client.
- **Lister les Clients** : Affichage de tous les clients.

### 3. Gestion des Factures
- **Créer une Facture** : Génération d'une facture pour un achat.
- **Lister les Factures** : Affichage de l'historique des factures.

## Technologies Utilisées

- **Langage** : Java EE
- **Frontend** : JSP
- **Backend** : Servlets, JDBC
- **Base de Données** : MySQL
- **Serveur d'Applications** : Apache Tomcat version 10
- **Outil de Build** : Maven
- **IDE** : Eclipse

## Installation

### Prérequis

- **Java JDK 23**
- **Java JRE 17**
- **Apache Tomcat 10** 
- **MySQL** (ou autre SGBD)

### Étapes d'Installation

1. **Cloner le Répertoire**
   git clone https://github.com/ELYassine-dev/StoreWS

Configurer la Base de Données

Créez une base de données MySQL nommée store.
Importez les scripts SQL présents dans le dossier sql/ pour créer les tables nécessaires.
Configurer le Fichier de Propriétés

Modifiez le fichier src/main/resources/config.properties pour y ajouter les informations de connexion à la base de données.
Déployer l'Application

Importez le projet dans votre IDE préféré.
Construisez le projet avec Maven :


Ouvrez votre navigateur et allez à l'adresse : http://localhost:8081/StoreWS/

identifiant : admin@gmail.com

mot de passe : ad1234

S'inscrire ou se connecter pour consulter, emprunter et retourner des livres.
Bibliothécaires :
Accéder à l'interface d'administration pour gérer les livres et les utilisateurs.

### Auteur 1

Youssef Mabchour
https://www.linkedin.com/in/mabchour-youssef
ysf.mabchour@gmail.com

### Auteur 2

Yassine EL Mansoury 
yassineelmansoury1000@gmail.com 

### Auteur 2

Hamza El Behbetti 

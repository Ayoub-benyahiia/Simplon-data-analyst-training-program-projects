# 📊 Projet Data Engineering – Pipeline YouTube API avec Airflow, Docker et PostgreSQL

## 📌 Contexte du projet

Dans un contexte professionnel, les pipelines de données ne peuvent pas être exécutés sous forme de simples scripts Python locaux. Ils doivent être industrialisés afin de garantir :

- la portabilité
- la reproductibilité
- l’automatisation
- la scalabilité

Ce projet simule une architecture réelle de Data Engineering où les données sont extraites depuis l’API YouTube, stockées dans un Data Warehouse PostgreSQL, puis transformées et orchestrées automatiquement via Apache Airflow dans un environnement Dockerisé.

---

# 🎯 Objectifs pédagogiques

- Conteneuriser une application Data Engineering avec Docker
- Construire et configurer une image Docker personnalisée
- Comprendre et utiliser Apache Airflow pour orchestrer un pipeline
- Décomposer un ETL en tâches indépendantes (DAG)
- Mettre en place un Data Warehouse PostgreSQL (staging / core)
- Manipuler PostgreSQL via Python (hooks, cursor, psycopg2)
- Implémenter des opérations CRUD (insert, update, delete)
- Transformer des données brutes en données analytiques
- Automatiser un pipeline complet de bout en bout
- Explorer et analyser les données via SQL et DBeaver

---

# 🏗️ Architecture du projet

```text
YouTube API
     ↓
Extraction Python
     ↓
Airflow DAG
     ↓
PostgreSQL - Staging
     ↓
Transformations ELT
     ↓
PostgreSQL - Core
     ↓
Analyse SQL / DBeaver
```

---

# 🪜 Étapes du projet

## 🟢 1. Mise en place de l’environnement Docker

- Installation et configuration de Docker Desktop
- Création de la structure du projet
- Compréhension du rôle des conteneurs dans un environnement Data Engineering
- Introduction aux services multi-conteneurs

---

## 🔐 2. Gestion des variables d’environnement

Création et configuration du fichier `.env`.

Stockage sécurisé des informations sensibles :

- API YouTube
- Credentials PostgreSQL
- Variables Airflow

### ✅ Bonne pratique

Aucune donnée sensible n’est stockée directement dans le code source.

---

## 🟡 3. Construction de l’environnement Airflow avec Docker

### Création du Dockerfile

- Image basée sur Apache Airflow
- Installation des dépendances Python via `requirements.txt`
- Configuration des variables d’environnement

### Mise en place de Docker Compose

Services utilisés :

- Airflow Webserver
- Airflow Scheduler
- Airflow Worker
- PostgreSQL
- Redis

Fonctionnalités :

- Réseau interne entre conteneurs
- Volumes persistants
- Centralisation du lancement via `docker-compose.yml`

---

## 🔵 4. Architecture Airflow

Architecture basée sur `CeleryExecutor`.

### Composants principaux

- **Webserver** : interface utilisateur
- **Scheduler** : planification des DAGs
- **Worker** : exécution des tâches
- **Executor** : distribution des tâches
- **PostgreSQL** : metadata database + Data Warehouse
- **Redis** : broker de communication

### DAG (Directed Acyclic Graph)

Workflow représentant des tâches dépendantes :

```python
task1 >> task2 >> task3 >> task4
```

---

## 🟣 5. Structuration du projet Airflow

```text
project/
│
├── dags/
├── logs/
├── data/
├── include/
├── tests/
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
└── .env
```

### Rôle des dossiers

- `dags/` → pipelines Airflow
- `logs/` → logs des exécutions
- `data/` → fichiers temporaires
- `include/` → scripts Python
- `tests/` → tests du projet

---

## 🐘 6. Mise en place du Data Warehouse PostgreSQL

Architecture en 2 couches :

### Staging

Stockage des données brutes provenant de l’API YouTube.

### Core

Stockage des données transformées et prêtes pour l’analyse.

### Conception SQL

- Définition des types SQL
- Clés primaires
- Structuration analytique des données

---

## ⚙️ 7. Connexion Airflow ↔ PostgreSQL

Technologies utilisées :

- `PostgresHook`
- `psycopg2`
- curseurs SQL

Fonctionnalités :

- gestion des connexions
- exécution des requêtes SQL
- abstraction propre des accès base de données

---

## 📥 8. Ingestion et gestion des données

### Pipeline de données

- Extraction depuis l’API YouTube
- Chargement dans `staging`
- Transformation des données
- Chargement dans `core`

### Gestion des données

- insert
- update
- delete
- upsert

### Métriques dynamiques

- views
- likes
- comments

---

## 🔄 9. Transformation des données (ELT)

Transformations réalisées directement dans PostgreSQL.

### Exemples

- Conversion ISO 8601 → durée lisible
- Création de `video_type`
  - shorts
  - normal
- Enrichissement des données pour analyse BI

---

## 🔁 10. Orchestration avec Airflow

Transformation du pipeline en DAG Airflow.

### Tâches du DAG

1. Extraction API YouTube
2. Chargement staging
3. Transformation des données
4. Chargement core

### Dépendances

```python
extract_task >> staging_task >> transform_task >> core_task
```

### Résultat

Pipeline ELT entièrement automatisé.

---

## 🚀 11. Déploiement et exécution

### Lancement du projet

```bash
docker compose up --build
```

### Vérifications

- Airflow UI
- PostgreSQL
- Redis
- DAGs Airflow

### Monitoring

- logs des tâches
- état des containers
- exécution des DAGs

---

# 🛠️ Technologies utilisées

- Python
- Docker
- Docker Compose
- Apache Airflow
- PostgreSQL
- Redis
- psycopg2
- SQL
- DBeaver
- YouTube Data API v3

---

# 📚 Compétences développées

- Data Engineering
- Orchestration de pipelines
- Dockerisation d’applications
- Architecture Airflow
- Data Warehouse
- ELT
- SQL avancé
- PostgreSQL
- Monitoring et debugging

---

# ▶️ Commandes utiles

## Lancer les containers

```bash
docker compose up --build
```

## Voir les containers

```bash
docker ps
```

## Accéder au container PostgreSQL

```bash
docker exec -it postgres bash
```

## Ouvrir PostgreSQL

```bash
psql -U postgres
```

## Voir les schemas

```sql
\dn
```

## Voir les tables d’un schema

```sql
\dt staging.*
```

## Vérifier les données

```sql
SELECT * FROM staging.youtube_videos LIMIT 10;
```

---

# ✅ Résultat final

Un pipeline Data Engineering complet permettant :

- l’extraction automatisée de données YouTube
- le stockage dans un Data Warehouse PostgreSQL
- les transformations ELT
- l’orchestration avec Airflow
- le monitoring dans Docker
- l’analyse via SQL et DBeaver
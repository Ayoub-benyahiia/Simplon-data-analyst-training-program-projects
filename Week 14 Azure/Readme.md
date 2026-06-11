# 🚀 Azure Data Engineering Pipeline – Retail Analytics Project

## 📌 Contexte du projet

Dans le cadre de la modernisation de son système décisionnel, une entreprise du secteur **Retail** souhaite mettre en place une plateforme Data Engineering Cloud capable d'ingérer, stocker, transformer et analyser ses données de manière automatisée.

Ce projet consiste à concevoir un pipeline de données complet en utilisant les services Azure et Databricks, tout en appliquant une architecture **Medallion (Bronze → Silver → Gold)** afin de garantir la qualité, la traçabilité et la valorisation des données.

---

## 🎯 Objectifs

À travers ce projet, les objectifs sont de :

- Comprendre l'architecture d'une plateforme Data Engineering sur Azure.
- Mettre en œuvre un pipeline d'ingestion avec Azure Data Factory.
- Structurer un Data Lake selon une architecture Medallion.
- Utiliser Databricks et Apache Spark pour le traitement des données.
- Produire des datasets analytiques prêts à l'exploitation.
- Concevoir des indicateurs métiers pour l'aide à la décision.
- Préparer les données pour une visualisation dans Power BI.

---

# 🏗️ Architecture du projet

```text
                +------------------+
                | Azure SQL DB     |
                | Products         |
                | Stores           |
                | Transactions     |
                +--------+---------+
                         |
                         |
                +--------v---------+
                | Azure Data       |
                | Factory          |
                +--------+---------+
                         |
                         |
         +---------------v---------------+
         | Azure Data Lake Storage Gen2 |
         +---------------+---------------+
                         |
         +---------------+---------------+
         |                               |
     Bronze Layer                    Customers API
         |                               |
         +---------------+---------------+
                         |
                         v
                  Databricks
                         |
          +--------------+-------------+
          |                            |
      Silver Layer               Gold Layer
 (Clean & Transform)      (Business Aggregation)
          |                            |
          +--------------+-------------+
                         |
                         v
                     Power BI
```

---

# 🛠️ Technologies utilisées

| Service | Description |
|----------|-------------|
| Azure SQL Database | Stockage des données transactionnelles |
| Azure Data Lake Storage Gen2 | Stockage des données brutes et transformées |
| Azure Data Factory | Orchestration et ingestion des données |
| Azure Databricks | Transformation et traitement analytique |
| Apache Spark | Traitement distribué des données |
| Delta Lake | Stockage optimisé des données Silver et Gold |
| Power BI | Visualisation et reporting |

---

# 📂 Architecture Medallion

```text
Data Lake
│
├── bronze
│   ├── transactions
│   ├── products
│   ├── stores
│   └── customers
│
├── silver
│   └── sales_cleaned
│
└── gold
    └── sales_analytics
```

### 🥉 Bronze Layer
Contient les données brutes provenant des différentes sources :

- Azure SQL Database
- API JSON Clients

Format : **Parquet**

---

### 🥈 Silver Layer

Contient les données nettoyées et enrichies :

- Conversion des types
- Suppression des doublons
- Contrôles qualité
- Jointures entre les tables

Format : **Delta**

---

### 🥇 Gold Layer

Contient les données métier agrégées et optimisées pour l'analyse :

- Quantité vendue
- Chiffre d'affaires
- Nombre de transactions
- Valeur moyenne des transactions

Format : **Delta**

---

# 📖 Phase 0 — Documentation

Étude des services Azure utilisés :

## Azure SQL Database

- Base de données relationnelle managée.
- Stockage des tables métiers.
- Source principale du pipeline.

### Tables créées

- Products
- Stores
- Transactions

---

## Azure Data Lake Storage Gen2

- Stockage massivement scalable.
- Support du Hierarchical Namespace.
- Organisation en containers et dossiers.

Architecture utilisée :

```text
bronze/
silver/
gold/
```

---

## Azure Data Factory

Service d'orchestration ETL/ELT permettant :

- Création de pipelines
- Gestion des Linked Services
- Création de Datasets
- Utilisation des Copy Activities

---

## Databricks Community Edition

Plateforme d'analyse basée sur Apache Spark.

Fonctionnalités utilisées :

- Notebooks
- Spark DataFrames
- Traitements distribués
- Delta Lake

---

# 📖 Phase 1 — Préparation des sources

## Création de la base Azure SQL

Tables :

### Products

| Champ | Type |
|---------|---------|
| ProductID | INT |
| ProductName | VARCHAR |
| Category | VARCHAR |
| Price | FLOAT |

### Stores

| Champ | Type |
|---------|---------|
| StoreID | INT |
| StoreName | VARCHAR |
| City | VARCHAR |

### Transactions

| Champ | Type |
|---------|---------|
| TransactionID | INT |
| ProductID | INT |
| StoreID | INT |
| Quantity | INT |
| TransactionDate | DATE |

---

## Source API JSON

Source publique contenant les données clients :

```text
Customers API (JSON)
```

Sources finales :

- Products
- Stores
- Transactions
- Customers

---

# 📖 Phase 2 — Création du Data Lake

## Création du Storage Account

Configuration :

- Azure Data Lake Storage Gen2
- Hierarchical Namespace activé

---

## Création du Container

```text
retail-data
```

---

## Structure du stockage

```text
bronze/
│
├── transactions/
├── products/
├── stores/
└── customers/

silver/

gold/
```

---

# 📖 Phase 3 — Orchestration avec Azure Data Factory

## Pipeline d'ingestion

### Copy Activities

| Source | Destination |
|----------|-------------|
| Transactions SQL | Bronze/transactions |
| Products SQL | Bronze/products |
| Stores SQL | Bronze/stores |
| Customers API | Bronze/customers |

Format de sortie :

```text
Parquet
```

---

## Validation

Vérification de la présence des fichiers dans :

```text
bronze/
```

---

# 📖 Phase 4 — Databricks

## Création du cluster

Configuration d'un cluster Spark.

---

## Notebook

Création d'un notebook PySpark pour le traitement des données.

---

## Montage du Data Lake

Configuration du point de montage ADLS :

```python
dbutils.fs.mount(...)
```

---

## Vérification

```python
display(dbutils.fs.ls("/mnt/retail"))
```

---

# 📖 Phase 5 — Traitement Silver

## Chargement des données Bronze

DataFrames créés :

- transactions_df
- products_df
- stores_df
- customers_df

---

## Nettoyage des données

Actions réalisées :

- Cast des types
- Suppression des doublons
- Vérification des valeurs nulles
- Contrôle qualité

---

## Jointures

Fusion des données :

```text
Transactions
     +
Products
     +
Stores
     +
Customers
```

---

## Calcul métier

Création de l'indicateur :

```python
total_amount = quantity * price
```

---

## Sauvegarde Silver

Format :

```text
Delta Lake
```

Emplacement :

```text
silver/sales_cleaned
```

---

# 📖 Phase 6 — Traitement Gold

## Lecture de Silver

Chargement du dataset nettoyé.

---

## Agrégations métier

Calcul des indicateurs :

### Quantité vendue

```sql
SUM(quantity)
```

### Chiffre d'affaires

```sql
SUM(total_amount)
```

### Nombre de transactions

```sql
COUNT(transaction_id)
```

### Valeur moyenne transactionnelle

```sql
AVG(total_amount)
```

---

## Sauvegarde Gold

Format :

```text
Delta Lake
```

Emplacement :

```text
gold/sales_analytics
```

---

# 📊 Visualisation Power BI

Le dataset Gold est utilisé pour construire un tableau de bord comprenant :

- Chiffre d'affaires total
- Ventes par produit
- Ventes par magasin
- Évolution temporelle des ventes
- Top produits
- Top magasins

---

# ✅ Résultats obtenus

- Pipeline d'ingestion automatisé
- Architecture Medallion mise en œuvre
- Nettoyage et transformation avec Databricks
- Création d'indicateurs métier
- Dataset analytique prêt pour Power BI
- Architecture Data Engineering Cloud de bout en bout

---

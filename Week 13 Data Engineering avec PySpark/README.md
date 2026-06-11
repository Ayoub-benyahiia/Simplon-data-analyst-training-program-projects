# ⚽ Projet Data Engineering – Analyse Football avec PySpark & Power BI

## 📌 Contexte du projet

Les données footballistiques représentent une source importante pour analyser les performances des équipes et identifier les tendances au fil des saisons.

Dans ce projet, nous construisons un pipeline de traitement de données avec PySpark permettant de :

- Charger et préparer des données de matchs de football
- Calculer des statistiques avancées par équipe et par saison
- Identifier les champions de chaque saison
- Sauvegarder les résultats dans un format optimisé (Parquet partitionné)
- Visualiser les performances des équipes avec Power BI

---

# 🎯 Objectifs du projet

Le pipeline permet de :

✅ Analyser les performances des équipes  
✅ Calculer les statistiques offensives et défensives  
✅ Déterminer les champions de Bundesliga par saison  
✅ Générer des datasets optimisés pour l’analyse BI  
✅ Créer des dashboards interactifs dans Power BI  

---

# 👥 User Stories

### 👨‍💻 Analyste
> Je veux un tableau clair des performances par équipe et par saison.

### ⚽ Supporter
> Je veux connaître les champions de chaque saison.

### 📊 Manager sportif
> Je veux visualiser des indicateurs clés (% victoires, buts marqués, différence de buts) pour prendre des décisions.

---

# 🛠️ Technologies utilisées

- **PySpark**
- **Pandas**
- **Matplotlib**
- **Parquet**
- **Power BI**
- **Jupyter Notebook**

---

# 📂 Structure du projet

```bash
football-project/
│
├── data/
│   └── football_matches.csv
│
├── output/
│   ├── football_stats_partitioned/
│   └── football_top_teams/
│
├── notebooks/
│   └── football_pipeline.ipynb
│
├── images/
│   └── dashboard.png
│
└── README.md
```

---

# ⚙️ Pipeline pédagogique – Étapes principales

## 1️⃣ Chargement et préparation des données

- Chargement du fichier CSV dans un DataFrame PySpark
- Compréhension des colonnes
- Renommage des colonnes
- Suppression des colonnes inutiles

### Exemple :

```python
df = spark.read.csv("football_matches.csv", header=True, inferSchema=True)
```

---

## 2️⃣ Création de colonnes supplémentaires

Création des colonnes :

- `HomeTeamWin`
- `AwayTeamWin`
- `GameTie`

### Exemple :

```python
df = df.withColumn(
    "HomeTeamWin",
    when(col("FTHG") > col("FTAG"), 1).otherwise(0)
)
```

---

## 3️⃣ Filtrage des données

Le pipeline conserve uniquement :

- La Bundesliga (`Div = D1`)
- Les saisons entre 2000 et 2015

### Exemple :

```python
df_filtered = df.filter(
    (col("Div") == "D1") &
    (col("Season") >= 2000) &
    (col("Season") <= 2015)
)
```

---

## 4️⃣ Agrégations avec Group By

Création de deux DataFrames :

### 📌 `df_home_matches`
Statistiques des matchs à domicile :

- Buts marqués
- Buts encaissés
- Victoires
- Défaites
- Matchs nuls

### 📌 `df_away_matches`
Statistiques des matchs à l’extérieur.

---

## 5️⃣ Jointure des DataFrames

Fusion des statistiques domicile et extérieur :

```python
df_merged = df_home_matches.join(
    df_away_matches,
    ["Season", "Team"],
    "inner"
)
```

---

## 6️⃣ Création de colonnes synthétiques

### Colonnes totales

- `GoalsScored`
- `GoalsAgainst`
- `Win`
- `Loss`
- `Tie`

### Colonnes avancées

- `GoalDifferentials`
- `WinPercentage`
- `GoalsPerGame`
- `GoalsAgainstPerGame`

### Exemple :

```python
df_merged = df_merged.withColumn(
    "GoalDifferentials",
    col("GoalsScored") - col("GoalsAgainst")
)
```

---

## 7️⃣ Classement avec Window Functions

Création d’une fenêtre partitionnée par saison afin de classer les équipes.

### Classement selon :

1. `% de victoires`
2. `GoalDifferentials`

### Exemple :

```python
window_spec = Window.partitionBy("Season") \
    .orderBy(
        col("WinPercentage").desc(),
        col("GoalDifferentials").desc()
    )
```

Ajout de la colonne :

- `TeamPosition`

---

## 8️⃣ Extraction des champions & sauvegarde Parquet

Filtrage des champions :

```python
df_champions = df_ranked.filter(col("TeamPosition") == 1)
```

### Sauvegarde des datasets :

### 📁 `football_stats_partitioned`
Toutes les équipes  
➡️ Partitionné par saison

### 📁 `football_top_teams`
Champions uniquement

### Exemple :

```python
df_ranked.write.partitionBy("Season").parquet(
    "football_stats_partitioned"
)
```

---

# 📊 Visualisation des données

Les données des champions sont converties en Pandas afin de créer plusieurs graphiques :

- % de victoires des champions
- Nombre de buts marqués
- GoalDifferentials par saison

### Exemple :

```python
champions_pd = df_champions.toPandas()
```

---

# 📈 Power BI Dashboard

Les fichiers Parquet générés sont chargés dans Power BI Desktop :

- `football_stats_partitioned`
- `football_top_teams`

## Visualisations réalisées

### 📌 KPIs

- Nombre total de champions
- Moyenne des buts marqués
- Moyenne du % de victoires
- Meilleure différence de buts

### 📌 Graphiques

- % de victoires par équipe et saison
- Buts marqués vs buts encaissés
- GoalDifferentials par saison
- Classement des équipes

### 📌 Filtres dynamiques

- Saison
- Équipe

---

# 🚀 Résultats du projet

Ce pipeline permet :

✅ Une analyse complète des performances des équipes  
✅ Une identification rapide des champions  
✅ Une optimisation du stockage avec Parquet  
✅ Une intégration simple avec Power BI  
✅ Une visualisation claire des indicateurs clés  

---

# ▶️ Lancer le projet

## Installation des dépendances

```bash
pip install pyspark pandas matplotlib
```

## Exécution du notebook

```bash
jupyter notebook
```

---

# 📚 Concepts PySpark utilisés

- DataFrame API
- Group By
- Aggregations
- Window Functions
- Joins
- Partitionnement Parquet

---

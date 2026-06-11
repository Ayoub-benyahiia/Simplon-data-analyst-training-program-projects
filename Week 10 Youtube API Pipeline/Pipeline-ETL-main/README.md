###### **📊Pipeline d’ingestion et transformation de données YouTube (ETL)**



**📌 Description**

Ce projet implémente un pipeline ETL (Extract – Transform – Load) permettant de collecter des données depuis l’API YouTube Data v3, de les transformer en dataset analytique avec Python, puis de les exploiter dans Power BI.



**🎯 Objectifs**

* Interroger l’API YouTube Data v3
* Extraire et structurer des données JSON
* Transformer les données en dataset analytique
* Produire des visualisations dans Power BI



🔄 **Pipeline**

Le projet suit une logique ETL :

*Extract → Transform → Load*

* **Extract** : récupération des données via l’API YouTube
* **Transform** : nettoyage et structuration avec Python (pandas)
* **Load** : génération d’un dataset pour Power BI



**⚙️ Technologies**

* Python (requests, pandas, json)
* dotenv (gestion des variables d’environnement)
* YouTube Data API v3
* Power BI



**🔐 Configuration**

* Créer un projet sur Google Cloud
* Activer l’API YouTube Data v3
* Générer une clé API
* Créer un fichier .env : *YOUTUBE\_API\_KEY=your\_api\_key\_here*



🚀 **Exécution**

*pip install -r requirements.txt*

*python src/extract.py*

*python src/transform.py*

*python src/load.py*



**📊 Données extraites**

* Titre de la vidéo
* Date de publication
* Durée
* Nombre de vues
* Likes
* Commentaires



**📈 Analyse**

Les données sont exploitées dans Power BI pour :

* analyser la performance des vidéos
* suivre l’évolution des vues
* mesurer l’engagement


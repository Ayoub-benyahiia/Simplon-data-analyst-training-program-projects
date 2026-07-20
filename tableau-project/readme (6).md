📋 Présentation du Projet
Ce projet consiste en la création d'un dashboard décisionnel interactif sous Tableau Desktop. L'objectif est d'analyser les performances commerciales d'une entreprise en croisant les données de ventes, de retours clients et de satisfaction pour fournir un support stratégique à la direction.

🛠️ Architecture des Données (Modélisation)
La structure du modèle de données repose sur une combinaison de jointures physiques et de relations logiques pour garantir l'intégrité des métriques :

Jointures Physiques :

Achats ↔ Évaluations (LEFT JOIN) : Pour inclure tous les achats, même ceux sans évaluation.

Achats ↔ Retours (LEFT JOIN) : Pour identifier les produits retournés.

Achats ↔ Personnes (INNER JOIN) : Pour lier chaque vente à un responsable ou client spécifique.

Relation Logique : Utilisée entre Achats et Évaluations pour maintenir la granularité au niveau de la commande et calculer correctement la moyenne de satisfaction sans duplication de lignes.

💡 Analyses & Calculs Avancés
Le dashboard intègre plusieurs champs calculés stratégiques :

% Marge Profit : [Profit] / [Montant des ventes]

Eco-Taxe (5%) : Calcul conditionnel appliqué uniquement à la catégorie Technologie, excluant les produits dont le nom contient "Recyclé".

KPI Dynamique : Utilisation d'un paramètre % accroissement profit pour simuler des scénarios de croissance et calculer un Profit Ajusté.

Segmentation (Flag) : Identification automatique des ventes inférieures à 1000 pour un audit rapide.

📊 Contenu du Dashboard
Le dashboard final regroupe les visualisations les plus pertinentes :

Executive KPIs : Vue d'ensemble sur le CA, le profit et l'éco-taxe totale.

Analyse Géographique : Carte interactive des ventes par pays/région.

Comparaison Miroir : Profit Réel vs Profit Ajusté (Simulation).

Matrice de Performance : Analyse croisée Segment × Région × Sous-catégorie.

Satisfaction Client : Suivi de l'expérience client par commande.

🚀 Instructions d'Utilisation
Téléchargez le fichier .twbx présent dans ce repository.

Ouvrez-le avec Tableau Desktop ou Tableau Public.

Utilisez les filtres en haut à droite (Pays, Date, Segment) pour explorer les données.

Modifiez le paramètre "% accroissement profit" pour voir l'impact immédiat sur les projections financières.

Période du projet : Du 26/01/2026 au 30/01/2026. Outil : Tableau Desktop Public Edition."# Tableau" 

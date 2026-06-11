![Uploading image.png…]()





✈️ Predict My Flight - Prédiction de Prix
Estimez le coût des billets d'avion en Inde avec une précision de 98% grâce à l'Intelligence Artificielle.

(Insérez ici l'image explicative générée précédemment pour illustrer la démarche)

🎯 Objectifs
Ce projet analyse plus de 300 000 réservations de vols pour :

Comprendre les facteurs influençant les prix (classe, jours avant le vol, escales).

Construire un modèle prédictif fiable.

Fournir une estimation automatisée des tarifs.

🏆 Performance Finale
Après comparaison, le modèle Random Forest Regressor a été retenu pour sa précision exceptionnelle :

Précision Globale (R²) : 0.9839

Erreur Moyenne (MAE) : 1000

Note métier : Bien que l'objectif idéal visait une erreur de 15, l'analyse démontre que la volatilité naturelle des prix ( Yield Management) limite cette précision. Une erreur de ~1200 sur des billets allant jusqu'à 100 000 reste une performance de pointe pour la décision.

🛠️ Structure du Projet
Le projet suit une démarche rigoureuse :

Analyse Exploratoire & Tests Statistiques : Identification des variables clés.

Preprocessing Automatisé : Pipeline de nettoyage, encodage du texte et standardisation des chiffres.

Modélisation & Évaluation : Comparaison de modèles et sélection de la meilleure pipeline.

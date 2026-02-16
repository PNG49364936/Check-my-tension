## Description
App destinée à suivre la tension artérielle d'un patient.
Lire https://www.hirslanden.ch/fr/corporate/a-chaque-episode-de-votre-vie/coeur-en-rythme/tension-arterielle.html pour comprendre la tension arterielle

## Technologies
- Rails 7.1.6
- Ruby 3.2.2
- SQLite3 (base de données locale)
- hotwire
- Tailwind CSS
- stimulus (si nécessaire)

### Organisation equipe codeur.

Un agents backend. (sonnet)
- Cree la structure rails, les gems, les controlleurs,etc
Un agent front-end (sonnet)
- il consulte impetativement le fichier claude.MD dans .claude et prend en compte les contraintes qualité de l'affichage. Très important.
- Un agent test. (sonnet)
Se limiter aux tests fonctionnels via Curl


### Saisie des données
- possibilité de plusieurs utilisateurs donc creation d'une fiche utilisateur simple avec nom et prenom.
- il faut une landing page avec creation utilisateur (sans mot de passe) et accès à ses données et renseignements des données.
- **Nouveau formulaire** : crée un nouveau jour avec date d'observation + tension matin (systolique/diastolique)
- **Formulaire en cours** : ajoute les mesures du soir sur un jour existant
  - Si 1 seul jour incomplet → ouvre directement le formulaire soir
  - Si plusieurs jours incomplets → affiche un sélecteur pour choisir le jour à compléter
- **Modification** : toutes les données peuvent être modifiées (bouton Modifier sur chaque carte)
- **Suppression** : suppression d'un jour entier (bouton Supprimer sur chaque carte)

### Affichage des résultats
- Sélection libre de jours : le patient choisit exactement les jours qu'il veut voir
- Boutons "Tout sélectionner" / "Tout désélectionner"
- Tableau type Excel avec colonnes : Date | Matin (Syst/Diast) | Soir (Syst/Diast) | Moyenne jour
- **Total par jour** (moyenne systolique et diastolique matin+soir)
- **Total global** si plusieurs jours (moyenne, min, max)
- **Export PDF** avec tableau formaté pour impression

### Validations
- Date obligatoire et unique (pas de doublon)
- Valeurs tension entre 1 et 299
- Messages d'erreur en français


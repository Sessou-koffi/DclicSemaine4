
---

## 1. Introduction
Ce rapport présente le développement en deux étapes de l'application mobile "Magazine Infos" réalisée avec le framework Flutter et le langage Dart, en respectant les principes du Material Design.

---

## 2. Version 4.1 : Interface de base
### Description
Mise en place de la structure initiale de l'application à l'aide d'un widget principal `MaterialApp` et d'une page d'accueil utilisant un `Scaffold`. Cette version intègre une barre d'application (`AppBar`) centrée avec des icônes d'action, une image de couverture principale en haut de l'écran, ainsi qu'un bouton d'action flottant (`FloatingActionButton`) interactif.

### Capture d'écran (Version 4.1)
LA CAPTURE D'ÉCRAN DE MON ÉMULATEUR POUR LA PREMIÈRE VERSION 

---

## 3. Version 4.2 : Restructuration modulaire (Widgets personnalisés)
### Description
Afin de respecter les bonnes pratiques de développement Flutter, le code source a été entièrement restructuré. L'interface a été découpée en quatre sous-widgets indépendants héritant de `StatelessWidget` :
* **PartieTitre :** Conteneur affichant le titre principal et le sous-titre alignés à gauche.
* **PartieTexte :** Paragraphe descriptif justifié présentant le magazine.
* **PartieIcone :** Une rangée (`Row`) alignant trois boutons d'action (TEL, MAIL, PARTAGE) colorés en rose.
* **PartieRubrique :** Une rangée exploitant le widget `Expanded` et `ClipRRect` pour afficher proprement deux images locales côte à côte avec des bords arrondis.

### Gestion des ressources locales
Les images ont été ajoutées dans le répertoire `assets/images/` et correctement déclarées dans le fichier de configuration `pubspec.yaml` en respectant scrupuleusement l'indentation par espaces.

### Capture d'écran (Version 4.2)
CAPTURE D'ÉCRAN DE MON ÉMULATEUR POUR LA VERSION FINALE ]


---

## 4. Lien du Dépôt GitHub
L'historique complet des commits et l'évolution du code entre la version initiale et la version restructurée sont accessibles à l'adresse suivante :
👉 https://github.com/Sessou-koffi/DclicSemaine4/blob/dev/activite1/lib/main.dart

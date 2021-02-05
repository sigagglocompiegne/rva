![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Prescriptions locales de la base adresse locale

(x) en cours de rédaction

# Documentation du standard

# Changelog

- 05/02/2021 : description initiale du gabarit de production et de mise à jour des adresses et des voies

# Livrables

## Gabarits

- Fichier hors gabarit à télécharger au format csv (non géographique) (à venir)
- Fichier hors gabarit au format shape (géographique) (à venir)
- Fichier gabarit Qgis 3.x (vierge) complet à télécharger (à venir)

## Principe fonctionnel et modalités de mises à jour

La gestion commune des adresses et des voies repose sur le simple principe qu'une adresse doit être conforme, donc disposer d'un numéro de voirie et d'un libellé de voie, donc rattachée à une voie normmée.
La constitution d'une base adresse locale a démontré l'intérêt de réaliser en parallèle une base locale des voies pour la collectivité.

Ce couple permet ainsi de rattacher chaque point d'adresse à un tronçon de voies et à une voie nommée. Les automatismes de gestion de la donnée ont été développés autour de ce principe.

La gestion des données des adresses est conforme au standard de l'AITF (association des ingénieurs territoriaux de france). Pour plus d'informations, vous pouvez consulter cette [page](https://aitf-sig-topo.github.io/voies-adresses/). 
Chaque point d'adresse est localisé le plus précisément possible (à l'entrée piétonne pour la précision la plus fine) et rattaché à une voie.

La gestion des voies correspond à une logique de connaissance des caractéristiques des tronçons qui la compose. La modélisation des tronçons repose sur des principes de ruptures.
Ces ruptures sont diverses et peuvent correspondre à des intersections, des coupures aux limites des communes, des changements d'usage, ... 

## Système de coordonnées

Les coordonnées seront exprimées en mètre avec trois chiffres après la virgule dans le système national en vigueur.
Sur le territoire métropolitain s'applique le système géodésique français légal RGF93 associé au système altimétrique IGN69. La projection associée Lambert 93 France (epsg:2154) sera à utiliser pour la livraison des données.

## Topologie

- Pour les adresses : tout objet est nécessairement inclu dans l'emprise des communes du Pays Compiégnois. Les points d'adresse doivent être inclus dans une parcelle cadastrale (sauf si la qualité du référentiel ne le permet pas) et positionnés au meilleur emplacement possible connu. 

- Pour les voies : 
  - la saisie du tronçon correspond au centre de la chaussée que se soit une route, un chemin, une piste cyclable, une sente, ...
  - les tronçons sont jointifs en leur extrémité
  - les tronçons sont découpés aux intersections, aux limites communales, et à chaque modification d'usage.


## Format des fichiers

Les fichiers sont disponibles au format ESRI Shape (.SHP) contenant la géométrie mais également au format CSV et contenant les coordonnées X et Y pour les points d'adresse.
L'encodage des caractères est en UTF8. Les différents supports sont téléchargeables dans la rubrique Gabarits.

## Description des classes d'objets

|Nom fichier|Définition|Catégorie|Géométrie|
|:---|:---|:---|:---|
|geo_v_adresse|Localisation des points d'adresse |Patrimoine|Ponctuel|
|geo_v_troncon|Localisation des tronçons de voies |Patrimoine|Linéaire|


## Implémentation informatique

### Patrimoine

Ensemble des données décrivant les objets des points d'adresse

`geo_v_adresse` : points d'adresse

|Nom attribut|Définition|Type|Contraintes|
|:---|:---|:---|:---|
|id_adresse|Identifiant local unique de l'adresse|integer|valeur vide interdite|
|id_voie|Identifiant local unique de la voie|integer|valeur vide interdite|
|id_tronc|Identifiant local unique du tronçon|integer|valeur vide interdite|   
|numero|Numéro de l'adresse|character varying(10)| |
|repet|Indice de répétition de l'adresse|character varying(10)| |
|complement|Complément d'adresse|character varying(80)| |
|etiquette|Etiquette|character varying(10)| |
|angle|Angle de l'écriture exprimé en degré|integer|Par rapport à l'horizontale, dans le sens trigonométrique|
|observ|Observations|character varying(254)| |
|src_adr|Origine de l'adresse|character varying(2)||
|diag_adr|Diagnostic qualité de l'adresse|character varying(2)||
|qual_adr|Indice de qualité simplifié de l'adresse|character varying(1)||
|ld_compl|Nom du lieu-dit historique ou complémentaire|character varying(80)| |  

|dest_adr|Destination de l'adresse (habitation, commerce, ...)|character varying(2)||
|etat_adr|Etat de la construction à l'adresse (non commencé, en cours, achevé, muré, supprimé ...)|character varying(2)||
|refcad|Référence(s) cadastrale(s)|character varying(254)| |
|nb_log|Nombre de logements|integer| |
|pc|Numéro du permis de construire|character varying(30)| |
|groupee|Adresse groupée (O/N)|character varying(1)||
|secondaire|Adresse d'un accès secondaire (O/N)|character varying(1)||
|id_ext1|Identifiant d'une adresse dans une base externe (1) pour appariemment|character varying(80)| |
|id_ext2|Identifiant d'une adresse dans une base externe (2) pour appariemment|character varying(80)| |
|insee_cd|code Insee de la commune déléguée (en cas de fusion de commune)|character varying(5)| |
|nom_cd|Libellé de la commune déléguée (en cas de fusion de commune)|character varying(80)| |
|libvoie_c|Libellé complet de la voie (minuscule et caractère accentué)|character varying(100)| |
|insee|Code insee rattachée à l'adresse|character(5)| |
|commune|Libellé de la commune rattachée à l'adresse|character(5)| |
|codepostal|Code postal|character(5)| |
|rivoli|Code rivoli - FANTOIR|character(4)| |
|rivoli_cle|Clé rivoli|character(1)| |
|position|Type de position du point adresse|character varying(2)| |
|src_geom|Référentiel de saisie|character varying(2)||
|src_date|Année du millésime du référentiel de saisie|character varying(4)||
|date_sai|Horodatage de l'intégration en base de l'objet|timestamp without time zone||
|date_maj|Horodatage de la mise à jour en base de l'objet|timestamp without time zone| |
|x_l93|Coordonnée X en mètre|numeric| |
|y_l93|Coordonnée Y en mètre|numeric| |

`geo_v_troncon` : tronçons de voies

|Nom attribut|Définition|Type|Valeurs|Contraintes|
|:---|:---|:---|:---|:---|
|idtroncon|Identifiant local unique du tronçon de voie|integer||valeur vide interdite|


### Les identifiants

Les identifiants des adresses sont des identifiants non signifiants (un simple numéro incrémenté de 1 à chaque insertion).

### Liste de valeurs

Le contenu des listes de valeurs est disponible dans la documentation complète de la base de données en cliquant [ici]() dans la rubrique `Liste de valeurs`.

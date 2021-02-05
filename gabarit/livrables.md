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

La gestion des données des adresses est conforme au standard de l'AITF (association des ingénieurs territoriaux de france). Pour plus d'informations, vous pouvez consulter cette [page](). 
Chaque point d'adresse est localisé le plus précisément possible (à l'entrée piétonne pour la précision la plus fine) et rattaché à une voie.

La gestion des voies correspond à une logique de connaissance des caractéristiques des tronçons qui la compose. La modélisation des tronçons repose sur des principes de ruptures.
Ces ruptures sont diverses et peuvent correspondre à des intersections, des coupures aux limites des communes, des changements d'usage, ... 

## Système de coordonnées

Les coordonnées seront exprimées en mètre avec trois chiffres après la virgule dans le système national en vigueur.
Sur le territoire métropolitain s'applique le système géodésique français légal RGF93 associé au système altimétrique IGN69. La projection associée Lambert 93 France (epsg:2154) sera à utiliser pour la livraison des données.

## Topologie

- Tout objet est nécessairement inclu dans l'emprise des communes du Pays Compiégnois.
- Pour les adresses :

- Pour les voies :



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

`geo_v_adresse` : point d'adresse

|Nom attribut|Définition|Type|Valeurs|Contraintes|
|:---|:---|:---|:---|:---|
|idadresse|Identifiant local unique de l'adresse|integer||valeur vide interdite|

`geo_v_troncon` : tronçon de voies

|Nom attribut|Définition|Type|Valeurs|Contraintes|
|:---|:---|:---|:---|:---|
|idtroncon|Identifiant local unique du tronçon de voie|integer||valeur vide interdite|


### Les identifiants

Les identifiants des adresses sont des identifiants non signifiants (un simple numéro incrémenté de 1 à chaque insertion).

### Liste de valeurs

Le contenu des listes de valeurs est disponible dans la documentation complète de la base de données en cliquant [ici]() dans la rubrique `Liste de valeurs`.

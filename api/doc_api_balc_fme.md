![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Paramétrage de l'API BALC pour FME #

## Principe

L'alimentation de la BaseAdresseLocale évolue et permet à présent de téléverser les fichiers communaux au format BAL via une API. L'Agglomération de la Région de Compiègne, signataire de la [charte "Base Adresse Locale"](https://geo.compiegnois.fr/portail/index.php/2021/05/30/adresse-le-compiegnois-sur-la-bonne-voie/), diffuse quotidiennement les informations certifiées des communes du Pays Compiégnois. 

Le service SIG qui utilise déjà l'ETL FME de la société "Safe Software" pour l'ensemble de ces traitements, a paramétré un projet pour utiliser cette API.

## Changelog

 * 20/09/2021 : Version 0.1 - téléversement d'un fichier commune au format BAL 1.2 dans la BaseAdresseLocale via l'API

## Paramétrage

Cette première version est une version béta permettant le téléversement d'un seul fichier BAL commune à la fois. Il sera amélioré pour automatiser un versement de lots de communes. La version de FME utilisée est la 2021.1.1.0.

 * 1 - Création de paramètres publiés

Certains valeurs peuvent être paramétrées au lancement du traitement FME pour faciliter le processus de téléversement, elles sont au nombre de 3 :
 - Commune : cet attribut contiendra le code Insee de la commune à téléverser
 - Taille : cet attribut contiendra la taille du fichier à téléverser en octet (une amélioration sera apportée au projet pour automatiser la récupération de la taille du fichier)
 - Jeton : cet attribut contiendra votre clé jeton fournit par la BAL

* 2 - Création de la chaîne de traitement



## Voir aussi

- [Documentation de l'API BALC de la BaseAdresseNantionale](https://github.com/etalab/ban-api-depot/wiki/Documentation)
- Téléchargement du projet FME (vierge) (à venir)

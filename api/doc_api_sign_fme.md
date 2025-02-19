![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Paramétrage de l'API de signalement "Mes Adresses" pour FME #

## Principe

L'alimentation de la BaseAdresseLocale évolue et permet à présent de téléverser les fichiers communaux au format BAL via une API. L'Agglomération de la Région de Compiègne (ARC), signataire de la [charte "Base Adresse Locale"](https://geo.compiegnois.fr/portail/index.php/2021/05/30/adresse-le-compiegnois-sur-la-bonne-voie/), diffuse quotidiennement les informations certifiées de ses communes membres ainsi que celles de trois autres EPCI également signataires de la charte, à savoir la Communauté de Communes de la Plaine d'Estrées (CCPE), la Communauté de Communes des Lisières de l'Oise (CCLO) et la Communauté de Communes des 2 Vallées (CC2V). 

Le service SIG qui utilise déjà l'ETL FME de la société "Safe Software" pour l'ensemble de ces traitements, a paramétré un projet pour utiliser cette API.

Contact : sig@agglo-compiegne.fr

## Changelog

 * 12/02/2025 : Version 1.5.1 - téléversement d'un lot de données communal au format BAL 1.4 avec la nouvelle API de dépôt BAL (depuis le 11/02/2025), traitement de base sans contrôle
 * 12/02/2025 : Version 1.5 - téléversement d'un lot de données communal au format BAL 1.4 avec la nouvelle API de dépôt BAL (depuis le 11/02/2025) avec vérification d'une BAL existante, vérification des mises à jour d'adresses intégrant un état ou un objet adresse supprimé (par lecture de la variable `rowCount`)
 * 07/02/2025 : Version 1.4 (obsolète) - téléversement d'un lot de données communal au format BAL 1.4 dans la nouvelle API de dépôt BAL avec vérification d'une BAL existante (mode démo)
 * 09/04/2024 : Version 1.3 (obsolète) - téléversement d'un lot de données communal au format BAL 1.4 dans l'API de dépôt BAL avec vérification d'une BAL existante, vérification des mises à jour d'adresses intégrant un état ou un objet adresse supprimé (par lecture de la variable `rowCount`)
 * 06/12/2021 : Version 1.2 (obsolète) - téléversement d'un lot de données communal au format BAL 1.3 dans l'API de dépôt BAL avec vérification d'une BAL existante et vérification des mises à jour d'adresses
 * 21/09/2021 : Version 1 (obsolète) - téléversement d'un fichier ou d'un lot de données communal au format BAL 1.2 dans l'API de démo BAL
 
## Gabarit

- [Téléchargement du projet FME version 1.5.1 - traitement par lot sans contrôle](https://geo.compiegnois.fr/documents/metiers/rva/API_BAL_LOT_FME_v151.zip)
- [Téléchargement du projet FME version 1.5 - traitement par lot avec contrôle](https://geo.compiegnois.fr/documents/metiers/rva/API_BAL_LOT_FME_v15.zip)

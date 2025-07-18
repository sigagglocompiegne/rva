![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Gestion des signalements sur "Mes adresses" via l'API "Mes signalements"

## Paramétrage de l'API de signalement "Mes Adresses" pour FME #

### Principe

L'alimentation de la BaseAdresseLocale évolue. En 2025, l'intégration de signalements d'adresses a été introduite dans l'applicatif "Mes Adresses". Le service SIG de l'ARC, partenaire des 4 EPCI téléversant déjà ses adresses via l'API de dépôt, a développé un processus automatique, en complément de son application Web "Voies et Adresses", pour récupérer les signalements déposés, les traiter et renvoyer une réponse. Les communes ne seront pas destinaires des signalements directement déposés sur "Mes Adresses".

    . Récupération des signalements avec l'API depuis l'ETL FME
    . Intégration dans la base de données
    . Visibilité des signalements dans l'application "Voies et Adresses" avec un visuel et une fiche spécifiques
    . Gestion du signalement dans l'application "Voies et Adresses"
    . Renvoi de la réponse via l'API depuis l'ETL FME

Le service SIG qui utilise déjà l'ETL FME de la société "Safe Software" pour l'ensemble de ces traitements, a paramétré deux projets pour utiliser cette API de signalement. Ils peuvent être utilisés séparemment en-dehors d'une automatisation sous FMEFlow (FME Server).

Contact : sig@agglo-compiegne.fr

### Changelog

 * 18/07/2025 : Version 1.0 - récupération des signalements "Mes Adresses" en GET et renvoie d'une réponse en PUT en mode production
 * 19/02/2025 : Version 0.1 - récupération des signalements "Mes Adresses" en GET et renvoie d'une réponse en PUT en mode test
 
### Gabarit

- Téléchargement du projet FME version 1.0 - Mode GET (mode production) (à venir)
- Téléchargement du projet FME version 1.0 - Mode PUT (mode production) (à venir)
- Téléchargement du projet FME version 0.1 - Mode GET (mode test) (à venir)
- Téléchargement du projet FME version 0.1 - Mode PUT (mode test) (à venir)

## Schéma fonctionnel

Le SIG de l'Agglomération de la Région de Compiègne est structuré autour d'une base de données Postgres/Gis sur laquelle repose des applicatifs métiers WEB sous GEO. La méthode de récupération et de traitement des données de signalements est propre à cette structure. Néanmoins, ce fonctionnel peut-être repris et adapté pour d'autres territoires car la première partie des traitements est la lecture de l'API en mode GET. Le traitement du PUT est quant à lui commun dans sa partie finale (envoie des variables de retour).

Le service SIG de l'ARC a mis en place une gestion des statuts du signalement parallèle à celui issu des signalements. Ce mode paralèlle de gestion permet de vérifier, si une fois le signalement retourné (en mode PUT) celui-ci est bien pris en compte dans "Mes Adresses" par récupération de la nouvelle valeur du statut renvoyé par l'API GET.

![schema](https://github.com/sigagglocompiegne/rva/blob/master/api/img/schema_fonctionnel_api_sign.png)

## Fonctionnement du site "Mes Signalements"

Les signalements réalisés par les extérieurs peuvent l'être via "Mes Adresses" ou directement via le site "Mes signalements" [https://signalement.adresse.data.gouv.fr/#/](https://signalement.adresse.data.gouv.fr/#/).

Pour voir tous les signalements et leurs statuts : [https://signalement.adresse.data.gouv.fr/#/all](https://signalement.adresse.data.gouv.fr/#/all)

#### Déposer un signalement sur une adresse existante

![schema](https://github.com/sigagglocompiegne/rva/blob/master/api/img/mes_signalements_saisies.png)

1 - Cliquer sur une adresse et indiquer dans la fiche la demande de modification. A la validation, une autre fenêtre vous demandera votre nom et email pour le retour.

2 - Cliquer sur le nom de la voie pour uen demande concernant une adresse non présente dans la base "Adresse".

[Accès à la documentation détaillée.] A venir

Le signalement est ensuite moissonné par l'API depuis les outils du GéoCompiégnois tous les soirs.

## Paramétrage de l'API via l'ETL FME

#### Le mode GET : récupération des signalements

Le traitement est stocké ici : `R:\Ressources\4-Partage\3-Procedures\FME\open_data\open-data_bal_signalement_get_fmeflow.fmw`

![get](https://github.com/sigagglocompiegne/rva/blob/master/api/img/API_SIGNALEMENT_FME_PARAMETRAGE.png)

Le premier bloc de traitement permet de fabriquer la requête qui sera envoyée. Récupération des codes Insee souhaitées et paramétrages de la requête.

    . adresse : https://plateforme-bal.adresse.data.gouv.fr/api-signalement/signalements
    . variable : codeCommunes = [code insee]
    . variable : limit = 100 et page = 1

Un transformer personnalisé a été créé pour gérer la boucle de renvoie à l'API si le nombre de signalements dépassent les 100.

Ce traitement est exécuté via FME tous les soirs.

Ce traitement intègre également la notion de "double vie" du signalement par rapport au fonctionnel du GéoCompiégnois. Afin de mettre en oeuvre les automatismes de mise à jour interne et de renvoie à l'API, il a été intégré dans la base de données des attributs parallèles aux attributs de l'API pour effectuer des comparaisons, notamment sur la notion de statuts.

**Le statut des signalements de l'API 'Mes Adresses' a été intégré dans la liste de domaines des statuts des signalements du GéoCompiégnois. Une harmonisation a été intégrée afin de gérer les signalements dans le fonctionnel applicatif. Le retour en mode GET transforme le statut local en statut API.**
    

#### Le mode PUT : envoi des signalements traités

Le traitement est stocké ici : `R:\Ressources\4-Partage\3-Procedures\FME\open_data\open-data_bal_signalement_put_fmeflow.fmw`

Ce traitement est plus simple, puisqu'il utilise simplement la classe d'objets des signalements présents dans la base de données et effectue une comparaison pour formater la requeête de retour.

![put](https://github.com/sigagglocompiegne/rva/blob/master/api/img/API_SIGNALEMENT_FME_PARAMETRAGE_PUT.png)

Le test consiste a récupérer les signalements avec un traitement codé 3 (demande traitée) ou 5 (demande rejetée) et un statut d'origine (provenant du GET), différent du statut renvoyé (

Ce traitement est exécuté via FME tous les soirs avant le traitement exécutant le GET.

## Paramétrage de la base de données

## Paramétrage de l'application GEO "Voie et Adresse"

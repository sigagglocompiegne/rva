![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Gestion des signalements sur "Mes adresses" via l'API "Mes signalements"

## Paramétrage de l'API de signalement "Mes Adresses" pour FME #

### Principe

L'alimentation de la BaseAdresseLocale évolue. En 2025, l'intégration de signalements d'adresses a été introduite dans l'applicatif "Mes Adresses". Le service SIG de l'ARC, partenaire des 4 EPCI téléversant déjà ses adresses via l'API de dépôt, a développé un processus automatique, en complément de son application Web "Voies et Adresses", pour récupérer les signalements déposés, les traiter et renvoyer une réponse. Les communes ne seront pas destinaires des signalements directement déposés sur "Mes Adresses".

    . Récupération des signalements avec l'API depuis l'ETL FME
    . Intégration dans la base de données
    . Visibilité des signalements dans l'application "Voies et Adresses" avec un visuel et une fiche spécifique
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

Ce traitement est exécuté via FMEFlow (FMEServer) tous les soirs.

Ce traitement intègre également la notion de "double vie" du signalement par rapport au fonctionnel du GéoCompiégnois. Afin de mettre en oeuvre les automatismes de mise à jour interne et de renvoie à l'API, il a été intégré dans la base de données des attributs parallèles aux attributs de l'API pour effectuer des comparaisons, notamment sur la notion de statuts.

**Le statut des signalements de l'API 'Mes Adresses' a été intégré dans la liste de domaines des statuts des signalements du GéoCompiégnois. Une harmonisation a été opérée afin de gérer les signalements dans le fonctionnel applicatif. Le retour en mode GET transforme le statut local en statut API.**

Ce traitement génère des envois d'emails au Service Information Géographique :

    . pour un nouveau signalement reçu
    . pour confirmer les signalements renvoyés par l'API en mode PUT
    . pour une erreur liée à l'API, une erreur d'un statut inconnu ou pour une erreur d'une type de signalement inconnu

#### Le mode PUT : envoi des signalements traités

Le traitement est stocké ici : `R:\Ressources\4-Partage\3-Procedures\FME\open_data\open-data_bal_signalement_put_fmeflow.fmw`

Ce traitement est plus simple, puisqu'il utilise simplement la classe d'objets des signalements présents dans la base de données et effectue une comparaison pour formater la requête de retour.

![put](https://github.com/sigagglocompiegne/rva/blob/master/api/img/API_SIGNALEMENT_FME_PARAMETRAGE_PUT.png)

Le test consiste a récupérer les signalements avec un traitement codé 3 (demande traitée) ou 5 (demande rejetée) et un statut d'origine (provenant du GET), différent du statut renvoyé également par le GET. Ici, le transformer GET a une double fonction. Comme il récupère tous les signalements (traités ou non), une comparaison est faite avec la base de données pour trier les nouveaux et anciens signalements. Pour les anciens signalements, le statut est récupéré dans un attribut double, et il est mis à jour dans la base de données. Le PUT etant lancé avant, ce statut est comparé au statut local. Si il est différent, cela signifie que le signalement doit être envoyé à l'API en retour.

Ce traitement est exécuté via FMEFlow (FMEServer) tous les soirs avant le traitement exécutant le GET.

Ce traitement ne génère pas d'envoi d'emails au Service Information Géographique.

## Paramétrage de la base de données

Une classe d'objets spécifique au signalement reçu de "Mes adresses" a été créée.

`m_signalement.geo_rva_apisignal` : table des points de signalements alimentée via le processus FME GET.

   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|idsignal|Identifiant du signalement via l'API|text| |
|idban_adresse|Identifiant adresse|text| |
|dcreate|Date de création du signalement|timestamp without time zone| |
|dupdate|Date de modification du signalement|timestamp without time zone| |
|ddelete|Date de suppression du signalement|timestamp without time zone| |
|typ|Type de signalement|character varying(2)| |
|statut|Statut du signalement|character varying(2)| |
|statut_e|Statut du signalement en attente du retour API (permettra de vérifier la bonne mise à jour dans Mes Adresse|character varying(2)| |
|insee|Code insee de la demande|character varying(5)| |
|type_dem|type de demande déduite des informations présentes dans le signalement|text| |
|numero|numéro de voie présente dans le signalement|smallint| |
|suffixe|suffixe présent dans le signalement|text| |
|nomvoie|nom de la voie présent dans le signalement|text| |
|position|position présente dans le signalement|text| |
|comment_s|commentaire présent dans le signalement|text| |
|parcelle|Parcelle(s) présente dans le signalement|text| |
|complt|complément ?|text| |
|traite_sig|Niveau du traitement du signalement au sein du service SIG (lié à la liste de valeur lt_traite_sig)|character varying(1)|'1'::character varying|
|bal_adresse|Adresse originelle sur laquelle a eu lieu le signalement|text| |
|comment_r|commentaire de retour du service SIG|text| |
|dbupdate|Date de mise à jour du signalement dans la base de données igeo_compiegnois|timestamp without time zone| |
|op_maj|dernier opérateur ayant mis à jour le signalement|text| |
|geom|Géométrie des objets|point(2154)| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ `idsignal` 
* 2 triggers :
  * `t_t1_controle` : trigger permettant d'automatiser les contrôles de saisies
  * `t_t3_date_maj` : trigger permettant d'automatiser la génération de la date de mise à jour 
 

## Paramétrage de l'application GEO "Voies et Adresses"

La classe d'objets `geo_rva_apisignal` a été ajouté à l'application "Voies et Adresses", avec un système de symbologie spécifique.

![put](https://github.com/sigagglocompiegne/rva/blob/master/api/img/GEO_menucarte_api_signalement.png.png)

Les signalements chargés via l'API apparaîtront sur la carte avec cette nouvelle symbologie.

![put](https://github.com/sigagglocompiegne/rva/blob/master/api/img/GEO_tab_api_signalement.png)

Les signalements sont également disponibles dans les différents onglets du tableau bord avec la symbologie de la Base Adresse Locale pour les différenciés de ceux des communes du GéoCompiégnois.

![put](https://github.com/sigagglocompiegne/rva/blob/master/api/img/GEO_vie_signalement.png)

Comme pour les signalements du GéoCompiègnois, il est possible de cliquer dessus et ils apparaissent dans le menu "Résultats". Ce menu donne l'indication du niveau du traitement en cours (cf ci-dessus).

![put](https://github.com/sigagglocompiegne/rva/blob/master/api/img/GEO_fiche_api_signalement.png)

Une fiche d'information est accéssible pour modifier le signalement et apporter une réponse qui sera renvoyée par l'API en mode PUT. La partie justification peut être remplie, mais seul le statut "Rejeté" en bénéficiera dans l'API. Si le signalement est accepté (traité), cette partie ne sera pas transmise.

**ATTENTION : la saisie du statut est primordial à ce stade pour une bonne compréhension via l'API**

**Un statut `demande traitée` version GéoCompiégnois sera considéré comme `accepté` par l'API. Si le signalement n'est pas accepté par nos services, il faudra indiquer `Demande rejetée`**

## Les retours

Deux retours par emails de bonnes transmissions des signalements sont opérationnels.

Le premier concerne directement l'application "Mes Adresses" qui renvoie un email lors de la réception d'une réponse à un signalement (API en mode PUT). Cet email (cf ci-dessous) indique la prise en compte ou non du signalement et dans le cas d'un rejet uniquement, mentionne la justification. Cette justification correspond au message indiqué dans la fiche d'information du signalement dans l'application `Voies et adresses`.

![put](https://github.com/sigagglocompiegne/rva/blob/master/api/img/BAL_email_retour.png)

Le second email est envoyé par le traitement FME de l'API en mode GET. Il détecte les signalements pris en compte par "Mes Adresses" et envoi une confirmation au service information géoégraphique parallèlement à l'email officiel de "Mes Adresses".

![put](https://github.com/sigagglocompiegne/rva/blob/master/api/img/BAL_email_retour_sig.png)





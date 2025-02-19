![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Paramétrage de l'API de signalement "Mes Adresses" pour FME #

## Principe

L'alimentation de la BaseAdresseLocale évolue. En 2025, l'intégration de signalements d'adresses sera introduit dans l'applicatif "Mes Adresses". Le service SIG de l'ARC, partenaire des 4 EPCI téléversant déjà ces adresses via l'API de dépôt, a développé un processus automatique, en complément de son application Web "Voies et Adresses", pour récupérer les signalements déposés, les traiter et renvoyer une réponse. Les communes ne seront pas destinaires des signalements directement déposés sur "Mes Adresses".

Le service SIG qui utilise déjà l'ETL FME de la société "Safe Software" pour l'ensemble de ces traitements, a paramétré deux projets pour utiliser cette API de signalement. Ils peuvent être utilisés séparemment en-dehors d'une automatisation sous FMEFlow (FME Server).

Le développment de l'API étant toujours en cours au niveau national, les traitements ne sont pas diffusés à ce jour.

Contact : sig@agglo-compiegne.fr

## Changelog

 * 19/02/2025 : Version 0.1 - récupération des signalements "Mes Adresses" en GET et renvoie d'une réponse en PUT
 
## Gabarit

- Téléchargement du projet FME version 0.1 - Mode GET (en cours de développement et test)
- Téléchargement du projet FME version 0.1 - Mode PUT (en cours de développement et test)


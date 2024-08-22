![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Documentation d'administration des signalements de la Route de l'IGN #

## Principes
  * **généralité** :
Afin d'améliorer la remontée des informations gérées dans la base de voies locales à l'ensemble des producteurs de cartographies en ligne, GPS, ... il s'est avéré nécessaire d'alimenter la base Route de la BDTopo de l'IGN qui est généralement utilisé par ces producteurs. Une expertise de l'IGN a été menée sur notre base de voies avant d'entamer une démarche de signalements. Celle-ci a été mise en place à l'issue.
 
 * **résumé fonctionnel** :
L'objectif n'est pas de créér des signalements "manuels" comme pour les adresses, mais de les générer de façon automatique. Cette génération nosu oblige à mettre en place un fonctionnel permettant d'isoler les modifications réalisées et celles devant être envoyées à l'IGN. L'ensemble de ces contraintes sont gérées en 2 temps. Un permier temps isole l'ensemble des traces dans une table spécifique alimentée par la vue de gestion des tronçons de voies. Le second temps consiste à réaliser un post-traitement dans FME afin de préparer les données à envoyer à l'IGN. En effet l'IGN a développé un transformer pour envoyer les signalements.

## Schéma fonctionnel

![schema_fonctionnel](schema_fonctionnel_ign_sign.png)

## Modèle conceptuel simplifié

![mcd](MCD_ign_sign.png)


## Dépendances

L'écriture des traces, ensemble des modifications effectuées sur la base de voies, est réalisée à partir de la vue de gestion des tronçons de voies. Cette vue est stockée dans le schéma `m_voirie` et se nomme `geo_v_troncon_voirie`.

Sur cette vue a été intégrée un trigger pour générer les traces.

* 1 trigger :
  * `t_t4_sign_ign` : à l'insertion, mise à jour ou suppression

Cette fonction permet d'écrire l'ensemble des traces selon les paramètres définis avec l'IGN. En effet, toutes les modifications réalisées sur la base de voies ne doivent pas être envoyées à l'IGN. Ci-dessous, la liste des critères d'envois (donc d'écriture d'une trace).

- quand je supprime un tronçon (pour les statuts hors département, national, autoroute, chemin forestier, chemin de halage)
- quand j'insère un tronçon (pour les statuts hors département, national, autoroute, chemin forestier, chemin de halage)
- à la mise à jour d'un tronçon (géométrie ou attribut) et toujours pour les statuts hors département, national, autoroute, chemin forestier, chemin de halage :
 - en géométrie : filtre sur les ajustements de tracés inférieur à 6m non tracé
 - attribut : filtre uniquement sur les modifications des attributs suivants (`date_ouv`, `type_tronc`, `id_voie`,`sens_circu`,`nb_voie`,`projet`,`statut_jur`,`num_statut`)

Le fonctionnel mis en place à travers un workflow FME (envoi mensuel pour rappel), permet de post-traiter l'ensemble des traces du mois enregistrés. Se référer à la partie des traitements FME (ci-après) pour plus de précisions.


## Classes d'objets

L'ensemble des classes d'objets de gestion sont stockés dans le schéma `m_signalement`.

 ### classes d'objets de gestion :
  
   `m_signelement.an_log_ign_signalement_send` : table des traces (modification) effectuées sur la base de voies
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id_tronc` lui-même contenant une séquence pour l'attribution automatique d'une référence tronçon unique. 
* Un index est présent sur le champ geom
* 3 triggers :
  * `t_t1_noeud_insert` : avant insertion ou mise à jour, recherche si il existe un noeud de épart ou de fin, sinon création des noeud du tronçon
  * `t_t2_noeud_sup` : après suppression ou mise à jour, si il n'y a aucun noeud dans la table des noeuds alors on supprime tout, sinon suppression uniquement des noeuds ne faisant plus partie d'un début ou d'une fin.
  * `t_t3_maj_insee_gd` : avant insertion ou mise à jour, recherche code insee et nom de la commune à droite et à gauche du tronçon.
  
---

### classes d'objets applicatives métiers sont classés dans le schéma x_apps :
 
Sans objet

### classes d'objets applicatives grands publics sont classés dans le schéma x_apps_public :

Sans objet

### classes d'objets opendata sont classés dans le schéma x_opendata :

Sans objet

## Liste de valeurs

Sans objet

## Traitement automatisé mis en place (Workflow de l'ETL FME)

 * `voie_ign_api_signalement_send.fmw` : post-traitement FME des traces enregistrées dans le mois. Une synthèse est réalisée sur l'ensemble des traces d'un même tronçon (pour éviter des envois multiples)
   - qsffq

### Récupération des signalements de la base Route de l'IGN

### Envoie des signalements à la base Route de l'IGN



## Projet QGIS pour la gestion

Le projet QGIS utilisé est celui de la gestion de la base de voie. Il est stocké ici :
R:\Ressources\4-Partage\3-Procedures\QGIS\RVA_3.x.qgs

Dans ce projet, sont visibles les signalements uploadés de l'IGN et ceux du mois en cours qui seront envoyés le 1er jour du mois suivant.


## Export Open Data

Sans objet

---








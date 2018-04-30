
![picto](/doc/img/Logo_web-GeoCompiegnois.png)

# Documentation d'administration de la base Voie #

## Principes
  * **généralité** :
Afin d'améliorer la connaissance sur les voies existantes, une Base de Voies a été initiée sur le Pays Compiégnois à partir d'un travail de regroupement des bases de voies existantes (IGN, cadastre,...) et d'un travail de vérification sur le terrain. Cette base est alimentée par les signalements des communes via une application WebSIG dédiée. Elle est également liée à la Base des Adresses Locales.
 
 * **résumé fonctionnel** :
La base de données Voies fonctionne de manière urbanisée. La géométrie du tronçon de voies est gérée de manière indépendante et contient uniquement les informations de référence et d'appartenance à une voie nommée et à une commune. Les données dites métiers sont gérées dans des tables alphanumériques spécifiques. Il existe des informations liées à des données de références du tronçon et des informations liées aux métiers de la voirie (gestion et circulation). Un suivi des voies historiques a également été introduit.
L'ensemble de cette base est modifiable via des vues simples en base de données et consultable via les applicatifs WebSIG à partir de vues matérialisées reconstituant les informations à la voie ou au tronçon.

## Dépendances (non critiques)

Sans objet


## Classes d'objets

L'ensemble des classes d'objets de gestion sont stockés dans plusieurs schémas r_objet (pour la géométrie des points d'adresse), r_voie, m_voirie (pour les informations alphanumériques liéesa aux tronçons de voies), et celles applicatives dans les schémas x_apps (pour les applications pro) ou x_apps_public (pour les applications grands publiques).

 ### classes d'objets de gestion :
  
   `r_objet.geo_objet_troncon` : table des tronçons de voies.
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|id_tronc|Identifiant unique de l'objet tronçon|bigint|nextval('r_objet.geo_objet_troncon_id_seq'::regclass)|
|id_voie_g|Identifiant unique de l'objet voie à gauche du tronçon|bigint| |
|id_voie_d|Identifiant unique de l'objet voie à droite du tronçon|bigint| |
|insee_g|Code INSEE à gauche du tronçon|character varying(5)| |
|insee_d|Code INSEE à droite du tronçon|character varying(5)| |
|noeud_d|Identifiant du noeud de début du tronçon|bigint| |
|noeud_f|Identifiant du noeud de fin de tronçon|bigint| |
|pente|Pente exprimée en % et calculée à partir des altimétries des extrémités du tronçon|numeric| |
|observ|Observations|character varying(254)| |
|src_geom|Référentiel de saisie|character varying(5)|'00'::bpchar|
|src_date|Année du millésime du référentiel de saisie|character varying(4)|'0000'::bpchar|
|date_sai|Horodatage de l'intégration en base de l'objet|timestamp without time zone|now()|
|date_maj|Horodatage de la mise à jour en base de l'objet|timestamp without time zone| |
|geom|Géomètrie linéaire de l'objet|LineString,2154| |
|src_tronc|Source des informations au tronçon|character varying(100)| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ `id_tronc` lui-même contenant une séquence pour l'attribution automatique d'une référence tronçon unique. 
* Une clé étrangère existe sur la table de valeur `id_voie_d` (lien vers l'identifiant `id_voie` de la table `r_voie.an_voie`)
* Une clé étrangère existe sur la table de valeur `id_voie_g` (lien vers l'identifiant `id_voie` de la table `r_voie.an_voie`)
* Une clé étrangère existe sur la table de valeur `src_geom` (source du référentiel géographique pour la saisie `r_objet.lt_src_geom`).
* Une clé étrangère existe sur la table de valeur `noeud_d` (table des objets noeuds `r_objet.geo_objet_noeud`).
* Une clé étrangère existe sur la table de valeur `noeud_f` (table des objets noeuds `r_objet.geo_objet_noeud`).
* Un index est présent sur le champ geom
* 3 triggers :
  * `t_t1_noeud_insert` : avant insertion ou mise à jour, recherche si il existe un noeud de épart ou de fin, sinon création des noeud du tronçon
  * `t_t2_noeud_sup` : après suppression ou mise à jour, si il n'y a aucun noeud dans la table des noeuds alors on supprime tout, sinon suppression uniquement des noeuds ne faisant plus partie d'un début ou d'une fin.
  * `t_t3_maj_insee_gd` : avant insertion ou mise à jour, recherche code insee et nom de la commune à droite et à gauche du tronçon.
  
---

   `r_objet.geo_objet_noeud` : Table des noeuds constituant le début et la fin d'un tronçon
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|id_noeud|Identifiant unique de l'objet noeud|bigint|nextval('r_objet.geo_objet_noeud_id_seq'::regclass)|
|id_voie|Identifiant unique de l'objet voie|bigint| |
|x_l93|Coordonnée X en mètre|numeric| |
|y_l93|Coordonnée Y en mètre|numeric| |
|z_ngf|Altimétrie ngf du noeud en mètre|numeric| |
|observ|Observations|character varying(254)| |
|date_sai|Horodatage de l'intégration en base de l'objet|timestamp without time zone|now()|
|date_maj|Horodatage de la mise à jour en base de l'objet|timestamp without time zone| |
|geom|Géomètrie ponctuelle de l'objet|Point,2154| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id_noeud`
* Une clé étrangère exsiste sur la table de valeur `id_voie` (table r_voie.an_voie des voies nommées)
* Un index est présent sur le champ geom
  
---

`r_voie.an_troncon` : Table alphanumérique des tronçons

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|  


Particularité(s) à noter : aucune
* Une clé primaire existe sur le champ `id_adresse`
* Une clé étrangère exsiste sur la table de valeur `diag_adr` (liste de valeur `lt_diag_adr` définissant le type de diagnostic de l'adresse)
* Une clé étrangère exsiste sur la table de valeur `qual_adr` (liste de valeur `lt_qual_adr` définissant la qualité de l'adresse)
* Une clé étrangère exsiste sur la table de valeur `src_adr` (liste de valeur `lt_src_adr` définissant les sources de l'adresse)

---

`r_voie.an_troncon_h` : Table alphanumérique des tronçons historisés

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|



Particularité(s) à noter :
* Une clé primaire existe sur le champ `id_adresse`
* Une clé étrangère exsiste sur la table de valeur `id_adresse` de la table geo_objet_pt_adresse
* Une clé étrangère exsiste sur la table de valeur `groupee` (liste de valeur `lt_groupee` définissant si une adresse est considérée comme groupée)
* Une clé étrangère exsiste sur la table de valeur `secondaire` (liste de valeur `lt_secondaire` définissant si une adresse est secondaire)

---

`r_voie.an_voie` : Table alphanumérique des voies nommmées

Se référer à la documentation de la base Adresse pour plus de détail sur cette table.

---

`public.geo_rva_signal` : Table des signalements des Voies et Adresses saisies par les collectivités

Se référer à la documentation de la base Adresse pour plus de détail sur cette table.

---

`m_voirie.an_voirie_circu` : Table alphanumérique des éléments de circulation de la voirie

---

`m_voirie.an_voirie_gest` : Table alphanumérique des éléments de gestion de la voirie

---

`m_voirie.geo_v_troncon_voirie` : 

`r_voie.geo_v_troncon_voirie` : 

`r_voie.an_v_voie_rivoli_null` : 

`r_voie.an_v_voie_adr_rivoli_null` : 


---

### classes d'objets applicatives métiers sont classés dans le schéma x_apps :
 
`x_apps.xapps_geo_vmr_adresse` : Vue matérialisée complète et décodée des adresses destinée à l'exploitation applicative  métier (générateur d'apps)
 
`x_apps.xapps_an_v_adresse_h` : Vue d'exploitation permettant de lister les adresses historiques et supprimées (intégration dans la fiche adresse dans l''application GEO RVA et utilisation dans la recherche des anciennes adresses)

### classes d'objets applicatives grands publics sont classés dans le schéma x_apps_public :

`x_apps_public.xappspublic_geo_v_adresse` : Vue complète et décodée des adresses destinée à l'exploitation applicative  publique (générateur d'apps)

### classes d'objets opendata sont classés dans le schéma x_opendata :

`x_opendata.xopendata_an_v_bal` : Vue alphanumérique simplifiée des adresses au format d''échange BAL

`x_opendata.xopendata_geo_v_openadresse` : Vue destinée à la communication extérieure des données relatives aux adresses. Exclusion des adresses supprimées, non attribuées pour projet ou à confirmer

## Liste de valeurs

`r_objet.lt_position` : Liste des valeurs permettant de décrire le type de position de l'adresse

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code de la liste énumérée relative au type de position de l'adresse|character varying(2)| |
|valeur|Valeur de la liste énumérée relative au type de position de l'adresse|character varying(80)| |
|definition|Définition de la liste énumérée relative au type de position de l'adresse|character varying(254)| |
|inspire|Equivalence INSPIRE LocatorDesignatorTypeValue relative au type de position de l'adresse|character varying(80)| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|01|Délivrance postale|
|02|Entrée|
|03|Bâtiment|
|04|Cage d'escalier|
|05|Logement|
|06|Parcelle|
|07|Segment|
|08|Service technique|
|00|Non renseigné|

---

`r_objet.lt_src_geom` : Liste des valeurs permettant de décrire le type de référentiel géométrique

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code de la liste énumérée relative au type de référentiel géométrique|character varying(2)| |
|valeur|Valeur de la liste énumérée relative au type de référentiel géométrique|character varying(254)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|10|Cadastre|
|11|PCI vecteur|
|12|BD Parcellaire|
|13|RPCU|
|20|Ortho-images|
|21|Orthophotoplan IGN|
|22|Orthophotoplan partenaire|
|23|Orthophotoplan local|
|30|Filaire voirie|
|31|Route BDTopo|
|32|Route OSM|
|40|Cartes|
|41|Scan25|
|50|Lever|
|51|Plan topographique|
|52|PCRS|
|53|Trace GPS|
|60|Geocodage|
|71|Plan masse vectoriel|
|72|Plan masse redessiné|
|80|Thématique|
|81|Document d'urbanisme|
|82|Occupation du Sol|
|83|Thèmes BDTopo|
|99|Autre|
|00|Non renseigné|
|70|Plan masse|
|61|Base Adresse Locale|

---

`r_voie.lt_type_voie` : Liste des valeurs permettant de décrire le type de voie

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code de la liste énumérée relative au type de voie|character varying(2)| |
|valeur|Valeur de la liste énumérée relative au type de voie|character varying(254)| |
|definition|Definition de la liste énumérée relative au type de voie|character varying(254)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|01|R|Rue|
|02|RTE|Route|
|03|BD|Boulevard|
|04|AV|Avenue|
|05|CHE|Chemin|
|06|ALL|Allée|
|08|CAR|Carrefour|
|09|IMP|Impasse|
|10|LD|Lieu dit|
|11|CITE|Cité|
|12|CLOS|Clos|
|13|COUR|Cour|
|14|CRS|Cours|
|15|CD|Chemin Départemental|
|16|CR|Chemin rural|
|17|CTRE|Centre|
|18|D|Départementale|
|19|GR|Grande Rue|
|20|PARC|Parc|
|21|N|Nationale|
|22|PAS|Passage|
|23|PRV|Parvis|
|24|PL|Place|
|25|PNT|Pont|
|26|PRT|Petite Route|
|27|PORT|Port|
|28|PROM|Promenade|
|29|QU|Quai|
|30|RES|Résidence|
|31|RLE|Ruelle|
|32|RPT|Rond Point|
|34|SQ|Square|
|35|VC|Voie Communale|
|36|VLA|Villa|
|37|VOI|Voie|
|38|VOIR|Voirie|
|39|ZAC|ZAC|
|40|CAV|Cavée|
|41|CHS|Chaussée|
|42|COTE|Côte|
|43|CV|Chemin vicinal|
|44|DOM|Domaine|
|45|PLE|Passerelle|
|33|ZZ|Sente(ier)|
|00|Non renseigné|Non renseigné|
|99|Autre|Autre|
|ZZ|Non concerné|Non concerné|
|46|LOT|Lotissement|

---

`r_adresse.lt_dest_adr` : Liste des valeurs permettant de décrire la destination de l'adresse

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code de la liste énumérée relative au type de voie|character varying(2)| |
|valeur|Valeur de la liste énumérée relative au type de voie|character varying(80)| |
|definition|Definition de la liste énumérée relative au type de voie|character varying(254)| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné||
|01|Habitation|Appartement, maison ...|
|02|Etablissement|Commerce, entreprise ...|
|03|Equipement urbain|Stade, piscine ...|
|04|Communauté|Maison de retraite, internat, gendarmerie, ...|
|05|Habitation + Etablissement|Logements et commerces à la même adresse|
|99|Autre|Parking, garage privés ...|

---

`r_adresse.lt_diag_adr` : Liste des valeurs permettant de décrire un diagnostic qualité d'une adresse

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character(2)| |
|valeur|Valeur|character varying(80)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|11|Adresse conforme|
|12|Adresse supprimée|
|20|Adresse à améliorer (position, usage, dégrouper ...)|
|21|Adresse à améliorer (position)|
|22|Adresse à améliorer (usage)|
|23|Adresse à améliorer (dégrouper)|
|24|Adresse à améliorer (logement)|
|25|Adresse à améliorer (état)|
|31|Adresse non attribuée (projet)|
|32|Adresse non numérotée|
|33|Adresse à confirmer (existence, numéro ...)|
|99|Autre|

---

`r_adresse.lt_etat_adr` : Liste des valeurs permettant de décrire l'état de la construction à l''adresse

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|
|code|Code de la liste énumérée relative au type de voie|character varying(2)| |
|valeur|Valeur de la liste énumérée relative au type de voie|character varying(80)| |
|definition|Definition de la liste énumérée relative au type de voie|character varying(254)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Sous code|Valeur|Référence législative|Référence réglementaire|
|:---|:---|:---|:---|:---|
|01|Non commencé|
|02|En cours|
|03|Achevé|
|04|Muré|
|05|Supprimé|
|99|Autre|
|00|Non renseigné|

---

`r_adresse.lt_groupee` : Liste des valeurs permettant de définir si une adresse est groupée ou non

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|
|code|Code|character(1)||
|valeur|Valeur|character varying(80)||


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|0|Non renseigné|
|1|Oui|
|2|Non|

---

`r_adresse.lt_qual_adr` : Liste des valeurs permettant de décrire un indice de qualité simplifié d'une adresse

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character varying(1)| |
|valeur|Valeur|character varying(80)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|0|Non renseigné|
|1|Bon|
|2|Moyen|
|3|Mauvais|
|9|Autre|

---

`r_adresse.lt_secondaire` : Liste des valeurs permettant de définir si une adresse est un accès secondaire

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character varying(1)| |
|valeur|Valeur|character varying(80)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|0|Non renseigné|
|1|Oui|
|2|Non|

---

`r_adresse.lt_src_adr` : Liste des valeurs permettant de décrire l'origine de l'adresse

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character varying(2)| |
|valeur|Valeur|character varying(80)| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|00|Non renseigné|
|01|Cadastre|
|02|OSM|
|03|BAN|
|04|Intercommunalité|
|05|Commune|
|99|Autre|

---

`public.lt_nat_signal` : Liste des valeurs permettant de décrire la nature du signalement sur le référentiel voie/adresse

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character varying(1)| |
|valeur|Valeur|character varying(100)| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|0|Non renseigné|
|1|Création|
|2|Modification|
|3|Suppression|
|9|Autre|

---

`public.lt_traite_sig` : Liste des valeurs permettant de décrire l''état du traitement du signalement par le service SIG

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character varying(1)| |
|valeur|Valeur|character varying(80)| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|0|Non renseigné|
|1|Nouvelle demande|
|2|Demande prise en compte|
|3|Demande traitée|

---


`public.lt_type_rva` : Liste des valeurs permettant de décrire le type de référentiel voie/adresse concerné par un signalement

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character varying(1)| |
|valeur|Valeur|character varying(80)| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|0|Non renseigné|
|1|Adresse|
|2|Voie|
|9|Autre|

---

## Traitement automatisé mis en place (Workflow de l'ETL FME)

### Gestion des procédures de contrôle des données Adresse

L'ensemble des fichiers a utilisé est placé ici `Y:\Ressources\4-Partage\3-Procedures\FME\prod\RVA`.

**Vérification de la qualité des adresse** `RVA_ctrl_qualite_adresse.fmw`

Ce traitement permet de :
- croiser plusieurs sources de données Adresse pour évaluer d'éventuels oublis d'adresse,
- croiser avec la base des voies pour vérifier la bonne affectation de l'adresse au tronçon et à la voie nommée
- vérifier les cohérences àl 'intérieur de la base Adresse (ex : numméro + repet = etiquette, .....)
- ...


## Export Open Data

L'ensemble des fichiers a utilisé est placé ici `Y:\Ressources\4-Partage\3-Procedures\FME\prod\OPEN-DATA`.

 - `RVA_adresse_metadonnees.fmw` : ce traitement exporte l'ensemble des données Adresse à de multiples formats téléchargeables via la fiche de métadonnées (csv, shape, kml, geojson, excel) et il est exécuté tous les jours à 21h00 sur le serveur sig-applis.

---

## Modèle conceptuel simplifié

![mcd](img/MCD_voie_v1.png)

## Schéma fonctionnel

![schema_fonctionnel](img/schema_fonctionnel_voie.png)



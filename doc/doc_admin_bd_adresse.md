![picto](/doc/img/Logo_web-GeoCompiegnois.png)

# Documentation d'administration de la base #

## Principes
  * **généralité** :
Afin d'améliorer la connaissance sur les adresses existantes, une Base Adresse Locale a été initiée sur le Pays Compiégnois à partir d'un travail de regroupement des bases adresses existantes (IGN, cadastre,...) et d'un travail de vérification sur le terrain. Cette base s'est appuyée sur le standard d'échange BAL de l'AITF et elle est alimentée par les signalements des communes via une application WebSIG dédiée.
 
 * **résumé fonctionnel** :
La base de données Adresse fonctionne de manière urbanisée. La géométrie du point d'adresse est gérée de manière indépendante et contient uniquement les informations de référence et d'appartenance à la voie et au tronçon de voie. Les données dites métiers sont gérées dans des tables alphanumériques spécifiques. Les libellés de voies sont concidérés comme un référentiel de voies (non géographique) et il est issu primitivement des informations du cadastre. Les informations purement liées à l'adresse (numéro, qualité, ...) sont gérées dans une table alphanumérique particulière ainsi que les données complémentaires qualifiant l'adresse (état, destination, nombre de logements, ...). Un suivi des adresses historiques a également été introduit.
L'ensemble de cette base est modifiable via des vues simples en base de données et consultable via les applicatifs WebSIG à partir de vues matérialisées reconstituant les informations à l'adresse.

## Dépendances (non critiques)

Sans objet


## Classes d'objets

L'ensemble des classes d'objets de gestion sont stockés dans plusieurs schémas r_objet (pour la géométrie des points d'adresse), r_voie (pour le référentiel de voies), r_adresse (pour les informations alphanumériques liées à l'adresse) ,et celles applicatives dans les schémas x_apps (pour les applications pro) ou x_apps_public (pour les applications grands publiques).

 ### classes d'objets de gestion :
  
   `r_objet.geo_objet_pt_adresse` : table des points d'adresse.
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|id_adresse|Identifiant unique de l'objet point adresse|bigint|nextval('r_objet.geo_objet_pt_adresse_id_seq'::regclass)|
|id_voie|Identifiant unique de l'objet voie|bigint| |
|id_tronc|Identifiant unique de l'objet troncon|bigint| |
|position|Type de position du point adresse|character varying(2)| |
|x_l93|Coordonnée X en mètre|numeric| |
|y_l93|Coordonnée Y en mètre|numeric| |
|src_geom|Référentiel de saisie|character varying(2)|'00'::bpchar|
|src_date|Année du millésime du référentiel de saisie|character varying(4)|'0000'::bpchar|
|date_sai|Horodatage de l'intégration en base de l'objet|timestamp without time zone|now()|
|date_maj|Horodatage de la mise à jour en base de l'objet|timestamp without time zone| |
|geom|Géomètrie ponctuelle de l'objet|Point,2154| |

Particularité(s) à noter :
* Une clé primaire existe sur le champ `id_adresse` lui-même contenant une séquence pour l'attribution automatique d'une référence adresse unique. 
* Une clé étrangère exsiste sur la table de valeur `id_troncon` (lien vers un identifiant id_troncon existant de la table `r_objet.geo_objet_troncon`)
* Une clé étrangère exsiste sur la table de valeur `id_voie` (identifiant de la voie nommée `r_voie.an_voie`)
* Une clé étrangère exsiste sur la table de valeur `position` (précision du positionnement du point adresse `r_objet.lt_position`)
* Une clé étrangère exsiste sur la table de valeur `src_geom` (source du référentiel géographique pour la saisie `r_objet.lt_src_geom`).
* Un index est présent sur le champ geom
* 1 trigger :
  * `t_t1_date_maj` : calcul des coordonnées X et Y avant l'insertion ou la mise à jour d'une géométrie ou des champs x_l93 et y_l93.  
  
Une adresse ne peut pas être créée sans qu'il y ait un tronçon de voirie.

---

   `r_objet.an_voie` : Table alphanumérique des voies à circulation terrestre nommées
   
|Nom attribut | Définition | Type | Valeurs par défaut |
|:---|:---|:---|:---|
|id_voie|Identifiant unique de l'objet voie|bigint|nextval('r_voie.an_voie_id_seq'::regclass)|
|type_voie|Type de la voie|character varying(2)|'01'::character varying|
|nom_voie|Nom de la voie|character varying(80)| |
|libvoie_c|Libellé complet de la voie (minuscule et caractère accentué)|character varying(100)| |
|libvoie_a|Libellé abrégé de la voie (AFNOR)|character varying(100)| |
|mot_dir|Mot directeur de la voie|character varying(100)| |
|insee|Code insee|character(5)| |
|rivoli|Code rivoli|character(4)| |
|rivoli_cle|Clé rivoli|character(1)| |
|observ|Observations|character varying(80)| |
|src_voie|Référence utilisée pour le nom de la voie|character varying(100)| |
|date_sai|Date de saisie dans la base de données|timestamp without time zone|now()|
|date_maj|Date de la dernière mise à jour dans la base de données|timestamp without time zone| |
|date_lib|Année du libellé la voie (soit l''année entière est saisie soit une partie en remplaçant les 0 par des x)|character(4)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `idvoie`
* Une clé étrangère exsiste sur la table de valeur `type_voie` (liste de valeur `lt_type_voie` définissant les abréviations des types de voies)
* Un index est présent sur le champ libvoie_c
* 1 trigger :
  * `t_date_maj` : insertion de la date du jour avant la mise à jour
  
---

`r_adresse.an_adresse` : Table alphanumérique des adresses

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|  
|id_adresse|Identifiant unique de l'objet point adresse|bigint| |
|numero|Numéro de l'adresse|character varying(10)| |
|repet|Indice de répétition de l'adresse|character varying(10)| |
|complement|Complément d'adresse|character varying(80)| |
|etiquette|Etiquette|character varying(10)| |
|angle|Angle de l'écriture exprimé en degré, par rapport à l'horizontale, dans le sens trigonométrique|integer| |
|observ|Observations|character varying(254)| |
|src_adr|Origine de l'adresse|character varying(2)|'00'::bpchar|
|diag_adr|Diagnostic qualité de l'adresse|character varying(2)|'00'::bpchar|
|qual_adr|Indice de qualité simplifié de l'adresse|character varying(1)|'0'::character varying|
|verif_base|Champ informant si l'adresse a été vérifié par rapport aux erreurs de bases (n°, tronçon, voie, correspondance BAN).
Par défaut à non.|boolean|false|

Particularité(s) à noter : aucune
* Une clé primaire existe sur le champ `id_adresse`
* Une clé étrangère exsiste sur la table de valeur `diag_adr` (liste de valeur `lt_diag_adr` définissant le type de diagnostic de l'adresse)
* Une clé étrangère exsiste sur la table de valeur `qual_adr` (liste de valeur `lt_qual_adr` définissant la qualité de l'adresse)
* Une clé étrangère exsiste sur la table de valeur `src_adr` (liste de valeur `lt_src_adr` définissant les sources de l'adresse)

---

`r_adresse.an_adresse_info` : Table alphanumérique des informations complémentaires des adresses

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|
|id_adresse|Identifiant unique de l'objet point adresse|bigint| |
|dest_adr|Destination de l'adresse (habitation, commerce, ...)|character varying(2)|'00'::character varying|
|etat_adr|Etat de la construction à l'adresse (non commencé, en cours, achevé, muré, supprimé ...)|character varying(2)|'00'::character varying|
|refcad|Référence(s) cadastrale(s)|character varying(254)| |
|nb_log|Nombre de logements|integer| |
|pc|Numéro du permis de construire|character varying(30)| |
|groupee|Adresse groupée (O/N)|character varying(1)|'0'::character varying|
|secondaire|Adresse d'un accès secondaire (O/N)|character varying(1)|'0'::character varying|
|id_ext1|Identifiant d'une adresse dans une base externe (1) pour appariemment|character varying(80)| |
|id_ext2|Identifiant d'une adresse dans une base externe (2) pour appariemment|character varying(80)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id_adresse`
* Une clé étrangère exsiste sur la table de valeur `id_adresse` de la table geo_objet_pt_adresse
* Une clé étrangère exsiste sur la table de valeur `groupee` (liste de valeur `lt_groupee` définissant si une adresse est considérée comme groupée)
* Une clé étrangère exsiste sur la table de valeur `secondaire` (liste de valeur `lt_secondaire` définissant si une adresse est secondaire)

---

`r_adresse.an_adresse_h` : Table alphanumérique des historisations des adresses suite à une renumérotation

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|  
|id|Identifiant unique de l'historisation|bigint|nextval('r_adresse.an_adresse_h_id_seq'::regclass)|
|id_adresse|Identifiant unique de l'objet point adresse|bigint| |
|id_voie|Identifiant unique de la voie|integer| |
|numero|Numéro de l'adresse|character varying(10)| |
|repet|Indice de répétition de l'adresse|character varying(10)| |
|complement|Complément d'adresse|character varying(80)| |
|etiquette|Etiquette|character varying(10)| |
|codepostal|Code postal de l'adresse|character varying(5)| |
|commune|Libellé de la commune|character varying(100)| |
|date_arr|Date de l'arrêté de numérotation remplaçant le numéro historisé ici présent|timestamp without time zone| |
|date_sai|Date de saisie de l'information dans la base|timestamp without time zone|now()|


Particularité(s) à noter :
* Une clé primaire existe sur le champ `id_adresse`

---

`r_adresse.an_v_adresse_bal_ban_commune` : Vue d'exploitation permettant de comparer le nombre d''enregistrement d''adresse par commune entre la BAL et la BAN

`r_adresse.an_v_adresse_bal_commune` : Vue d'exploitation permettant de compter le nombre d''enregistrement d''adresse par commune de la BAL

`r_adresse.an_v_adresse_bal_epci` : Vue d'exploitation permettant de compter le nombre d''enregistrement d''adresse par epci de la BAL

`r_adresse.an_v_adresse_ban_commune` : Vue d'exploitation permettant de compter le nombre d''enregistrement d''adresse par commune dans la BAN

`r_adresse.an_v_adresse_commune` : Vue d'exploitation permettant de compter le nombre d''enregistrement d''adresse par commune

`r_adresse.geo_v_adresse` : Vue éditable destinée à la modification des données relatives aux adresses

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
|code|Code|character(4)| |
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
|code|Code|character(2)||
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

`lt_typeref` : Liste des valeurs de l'attribut typeref de la donnée doc_urba

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character varying(2)| |
|valeur|Valeur|character varying(80)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|01|PCI|
|02|BD Parcellaire|
|03|RPCU|
|04|Référentiel local|

---

`lt_typesect` : Liste des valeurs de l'attribut typesect de la donnée zone_urba

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character varying(2)| |
|valeur|Valeur|character varying(100)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|ZZ|Non concerné|
|01|Secteur ouvert à la construction|
|02|Secteur réservé aux activités|
|03|Secteur non ouvert à la construction, sauf exceptions prévues par la loi|
|99|Zone non couverte par la carte communale|

`lt_typezone` : Liste des valeurs de l'attribut typezone de la donnée zone_urba

|Nom attribut | Définition | Type  | Valeurs par défaut |
|:---|:---|:---|:---|    
|code|Code|character varying(3)| |
|valeur|Valeur|character varying(80)| |


Particularité(s) à noter :
* Une clé primaire existe sur le champ code 

Valeurs possibles :

|Code|Valeur|
|:---|:---|
|U|Urbaine|
|AUc|A urbaniser|
|AUs|A urbaniser bloquée|
|A|Agricole|
|N|Naturel et forestière|

---

## Traitement automatisé mis en place (Workflow de l'ETL FME)

Plusieurs Workflow ont été mis en place pour gérer à la fois l'intégration ou la mise à jour de nouvelles procédures d'urbanisme ainsi que la mise à jour de la partie applicative lors d'une nouvelle procédure, d'une mise à jour du cadastre, d'une servitude ou de la prise en compte d'une nouvelle information jugée utile non présente dans les documents d'urbanisme.

Des fiches de procédures ont été réalisées, elles sont ici `Y:\Ressources\4-Partage\3-Procedures\Fiches` et intégrées dans le classeur des procédures.

### Gestion des procédures PLU

L'ensemble des fichiers a utilisé est placé ici `Y:\Ressources\4-Partage\3-Procedures\FME\prod\URB\PLU`.

Une série de traitement a été mis en place pour gérer l'ensemble des cas généré par une procédure de mise à jour des données.

**Intégration d'une procédure nouvellement approuvée** `00_PLU_integration_finale_executoire.fmw`
 
Ce traitement fait appel à des traitements secondaires :
   - `\bloc\01_PLU_Prod_à_Archi_sup_Prod_executoire.fmw` : les données des tables de production `geo_p_` sont intégrées dans les tables d' archives `geo_a_` puis supprimées des tables de production `geo_p_`
   - `\bloc\02_PLU_Test_à_Prod_sup_Test_executoire.fmw` : les données des tables de pré-production `geo_t_` sont intégrées dans les tables de production `geo_p_` puis supprimées des tables de pré-production `geo_t_`
   - `\bloc\05_PLU_Export_Format_CNIG.fmw` : les données sont exportées au format CNIG correspondant ici `Y:\fichiers_ref\metiers\urba\docurba`
   - à la fin du traitement les vues matérialisées applicatives, dans le schéma x_apps, concernées sont mises à jour (xapps_an_vmr_p_information, xapps_an_vmr_p_information_dpu, xapps_an_vmr_p_prescription, xapps_geo_vmr_p_zone_urba, xapps_an_vmr_parcelle_plu)
   
**Récupération d'une procédure annulée** `02_PLU_recuperation_annulation.fmw`

Ce traitement fait appel à des traitements secondaires :
   - `\bloc\03_PLU_Prod_à_Archi_sup_Prod_annulation.fmw` : les données des tables de production `geo_p_` sont intégrées dans les tables d'archives `geo_a_` puis supprimées des tables de production `geo_p_`
   - `\bloc\04_PLU_Archi_à_Prod_sup_Archi_annulation.fmw` : les données des tables d'archives `geo_a_` sont intégrées dans les tables de production `geo_p_` puis supprimées des tables d'archive `geo_a_`
   - à la fin du traitement les vues matérialisées applicatives, dans le schéma x_apps, concernées sont mises à jour (xapps_an_vmr_p_information, xapps_an_vmr_p_information_dpu, xapps_an_vmr_p_prescription, xapps_geo_vmr_p_zone_urba, xapps_an_vmr_parcelle_plu)
   
**Intégration de données reçues par un bureau d'étude** `03_PLU_integration_BE_shape_test.fmw`

Les données reçues d'un bureau d'étude doivent être vérifier au préalable dans QGIS avant intégration dans les données de pré-production `geo_t_` via ce traitement. Une fois la vérification et les corrections réalisées, le traitement d'intégration d'une procédure approuvée peut-être lancé.

**Préparation d'une nouvelle procédure à partir des données des tables production** `geo_p_`(pour les procédures gérées en interne) `011_PLU_Prod_à_Test_pour_modification.fmw`

**Préparation d'une nouvelle procédure à partir des données des tables d'archive** `geo_a_`(pour les procédures gérées en interne) `012_PLU_Archi_à_test_pour_modification.fmw`

### Gestion des procédures d'intégration des SUP et des informations jugées utiles (hors PLU)

L'ensemble des fichiers a utilisé est placé ici `Y:\Ressources\4-Partage\3-Procedures\FME\prod\URB`.

Une série de traitement a été mis en place pour créer des tables de références listant l'ensemble des parcelles avec les SUP et les informations jugées utiles (hors PLU) s'y appliquant. Ces procédures doivent être lancées uniquement lors d'une mise à jour du cadastre, d'une servitude, d'une information ou de l'intégration d'une nouvelle servitude ou informations.

**Mise à jour complète après une intégration d'un nouveau millésime cadastrale** `00_MAJ_COMPLETE_SUP_INFO_UTILES.fmw`
 
Ce traitement fait appel à des traitements secondaires et intègre une série de requêtes directement exécutée dans la base de données :
   - `\SUP\00_SUP_integration_globale.fmw`
   Ce traitement fait appel à des traitements secondaires :
       - `\bloc\01_SUP_mise_a_jour_liste_commune.fmw` : permet d'intégrer le fichier Excel par commune des SUP restant à intégrer (cette liste s'affiche dans la fiche de renseignement d'urbanisme). Le fichier est ici `R:\Projets\Metiers\1306URB-ARC-numSUP\2-PreEtude\servitude_par_commune_restant_a_integrer.xlsx`
       - `\bloc\02_SUP_generer_table_idu_sup_GEO.fmw` : génère la table `m_urbanisme_reg.an_sup_geo` dans la base de données qui est liée dans GEO listant l'ensemble des parcelles et les SUP concernées. Dans le cas d'une nouvelle SUP, son traitement doit-être intégré dans ce WorkFlow et lancé individuellement.
       - `\bloc\03_SUP_generer_table_AC4_protect_GEO.fmw` : génère la table `m_urbanisme_reg.an_sup_ac4_geo_protect` spécifique à la SUP AC4 (ZPPAUP) directement dans la base de données et liée à GEO
   - `\Information_jugées_utiles\00_INFOJU_integration_globale.fmw` : 
   Ce traitement fait appel à des traitements secondaires et refraichit en fin de processus l'ensemble des vues matérialisées des traitements PLU en base de données :
       - `\bloc\01_INFO_JUGEE_UTILE_hors_plu.fmw` : génère des tables spécifiques aux informations dans la base de données qui sont liées à la vue matérialisée `x_apps.xapps_an_vmr_p_information` . Dans le cas d'une nouvelle information à traiter, elle doit-être intégrée dans ce WorkFlow et lancé individuellement.
       - `\bloc\02_TAUX_FISCALITE_GEO.fmw` : génère la table `m_fiscalite.an_fisc_geo_taxe_amgt` formatant les données de la taxe d'aménagement par commune ou infra-communal dans la base de données et qui est liée dans GEO.
       
       
## Export Open Data

Sans objet

---

## Modèle conceptuel simplifié

![mcd](img/MCD.png)

## Schéma fonctionnel

![schema_fonctionnel](img/schema_fonctionnel_docurba.png)



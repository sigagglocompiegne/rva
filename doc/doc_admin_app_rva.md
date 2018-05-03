![picto](img/Logo_web-GeoCompiegnois.png)

# Documentation d'administration de l'application #

(en cours de rédaction)

# Généralité

|Représentation| Nom de l'application |Résumé|
|:---|:---|:---|
|![picto](/doc/img/picto_rva.png)|Voies-Adresses|Cette application est dédiée à la consultation des données détaillées des Voies et Adresses ainsi qu'à la possibilité d'insérer un signalement pour en améliorer le contenu.|

# Accès

|Public|Métier|Accès restreint|
|:-:|:-:|:---|
||X|Accès réservé aux personnels des communes et des EPCI ayant les droits d'accès.|

# Droit par profil de connexion

* **Prestataires**

Sans Objet

* **Personnes du service métier**

|Fonctionnalités|Lecture|Ecriture|Précisions|
|:---|:-:|:-:|:---|
|Toutes|x||L'ensemble des fonctionnalités (recherches, cartographie, fiches d'informations, ...) sont accessibles par tous les utilisateurs connectés.|
|Modification géométrique - Faire un signalement d'adresses ou de voies|x||Cette fonctionnalité est uniquement visible par les utilisateurs inclus dans les groupes ADMIN et RVA_EDIT|

* **Autres profils**

Sans objet

# Les données

Sont décrites ici les Géotables et/ou Tables intégrées dans GEO pour les besoins de l'application. Les autres données servant d'habillage (pour la cartographie ou les recherches) sont listées dans les autres parties ci-après. Le tableau ci-dessous présente uniquement les changements (type de champ, formatage du résultat, ...) ou les ajouts (champs calculés, filtre, ...) non présents dans la donnée source. 

## GeoTable : `public.geo_rva_signal`

|Attributs| Champ calculé | Formatage |Renommage|Particularité/Usage|Utilisation|Exemple|
|:---|:-:|:-:|:---|:---|:---|:---|
|acte_admin||x|Document administratif||Fiche de suivi d'un signalement voie/adresse||
|affche_info|x|x|`null`|Champ HTML formatant le type de traitement fait par le service SIG (décodage du champ `traite_sig`) |Fiche de suivi d'un signalement voie/adresse||
|affiche_result |x|||Champ HTML formatant le type de traitement fait par le service SIG (décodage du champ `traite_sig`) |Affichage dans le menu résultat||
|affiche_titre |x|||Titre  |Affichage du titre de la demande dans le menu résultat à partir de la recherche d'un signalement||
|date_maj ||x|Date du traitement|Formate la date en dd/mm/yyyy |Fiche de suivi d'un signalement voie/adresse||
|date_sai  ||x|Date du signalement|Formate la date en dd/mm/yyyy |Fiche de suivi d'un signalement voie/adresse||
|id_signal  ||x|Signalement n°||Fiche de suivi d'un signalement voie/adresse||
|insee  ||x|Code INSEE||Fiche de suivi d'un signalement voie/adresse||
|mail   ||x|Email du contributeur||Fiche de suivi d'un signalement voie/adresse||
|nat_signal   ||x|Nature du signalement||Fiche de suivi d'un signalement voie/adresse||
|observ    ||x|Description du signalement||Fiche de suivi d'un signalement voie/adresse||
|op_sai    ||x|Nom du contributeur||Fiche de suivi d'un signalement voie/adresse||
|traite_sig     ||x|Suivi de la demande||Fiche de suivi d'un signalement voie/adresse||
|type_rva     ||x|Type de signalement||Fiche de suivi d'un signalement voie/adresse||

   * filtres :

|Nom|Attribut| Au chargement | Type | Condition |Valeur|Description|
|:---|:---|:-:|:---:|:---:|:---|:---|
|Demande traitée|traite_sig|x|Alphanumérique|est différent de une valeur par défaut|3|Ne charge pas les demandes de signalements traitées par le service SIG,n'apparaît donc pas sur la carte|
   
   * relations :

|Géotables ou Tables| Champs de jointure | Type |
|:---|:---|:---|
| an_rva_signal_media |id_signal = id | 0..n (égal) |

   * particularité(s) : aucune

## GeoTable : `xapps_geo_vmr_adresse`

|Attributs| Champ calculé | Formatage |Renommage|Particularité/Usage|Utilisation|Exemple|
|:---|:-:|:-:|:---|:---|:---|:---|
|adresse|x|x|Adresse complète|Reconstitution (format HTML) de l'adresse complète avec la gestion des indices de répétition non rempli|Suggestion dans la Recherche dans la Base Adresse Locale et dans la fiche d'information Fiche adresse ||
|adresse_apostrophe |x|x||Gestion de l'apostrophe pour la recherche d'adresse |Rechercher dans la Recherche dans la Base Adresse Locale ||
|adresse_apostrophe_histo |x|x||Gestion de l'apostrophe pour la rechercge d'adresse hisrotisée|Rechercher dans la Recherche dans la Base Adresse Locale ||
|affiche_adresse |x|x||Formate en HTML l'affichage de l'adresse|Afficher dans la Recherche dans la Base Adresse Locale ||
|affiche_nouvelle_adresse |x|x||Formate en HTML l'affichage de la nouvelle adresse si l'adresse n'est pas supprimée|Afficher dans Recherche d'une ancienne adresse ||
|affiche_result  |x|x||Formate le titre du résultat dans le menu Résultat (si adresse trouvée ou supprimée) |Afficher dans la Recherche dans la Base Adresse Locale ||
|affiche_qual_adr  |x|x||Formate l'affichage de la qualité par rapport à l'adresse supprimée (`si supprimé affiche Conforme (supprimé) sinon la valeur de qual_adr`|Plus utilisée ||
|angle_geo  |x|x||Multiplie l'angle par -1 pour lagestion des étiquettes de n° de voies dans GEO|Cartothèque ||
|complement   ||x|Complément| |Fiche d'information Fiche adresse et utilisé dans les champs calculés gérant l'affichage ou la recherche des adresses ||
|date_maj    ||x|Date  de mise à jour| |Fiche d'information Fiche adresse ||
|date_sai    ||x|Date de saisie| |Fiche d'information Fiche adresse ||
|dest_adr    ||x|Destination| |Fiche d'information Fiche adresse ||
|diag_adr     ||x|Diagnostic| |Fiche d'information Fiche adresse ||
|etat_adr      ||x|Etat| |Fiche d'information Fiche adresse ||
|groupee       ||x|Groupée| |Fiche d'information Fiche adresse ||
|id_adresse        ||x|Identifiant||Fiche d'information Fiche adresse ||
|id_tronc         ||x|Identifiant du tronçon de voie||Fiche d'information Fiche adresse ||
|id_voie          ||x|Identifiant de la voie| |Fiche d'information Fiche adresse ||
|infobulle           |x|x||Formatage en HTML du contenu de l'info bulle au survol d'une adresse |Cartothèque ||
|lat           ||x|Latitude| |Fiche d'information Fiche adresse ||
|libvoie_c            ||x|Voie| |Fiche d'information Fiche adresse ||
|long            ||x|Longitude| |Fiche d'information Fiche adresse ||
|nb_log            ||x|Logement| |Fiche d'information Fiche adresse ||
|numero             ||x|Numéro| |Fiche d'information Fiche adresse ||
|numero_complet              |x|x|Numéro complet| Concaténisation du numéro et de l'indice de répétition|Filtre dans Recherche avancée d'une adresse ||
|observ             ||x|Observations| |Fiche d'information Fiche adresse ||
|pc              ||x|N° du permis de construire| |Fiche d'information Fiche adresse ||
|qual_adr               ||x|Qualité| |Fiche d'information Fiche adresse ||
|refcad               ||x|Parcelle(s)| |Fiche d'information Fiche adresse ||
|repet                ||x|Indice de répétition| |Fiche d'information Fiche adresse ||
|rivoli                 ||x|N° Rivoli| |Fiche d'information Fiche adresse ||
|rivoli_cle                 ||x|Clé Rivoli| |Fiche d'information Fiche adresse ||
|secondaire                 ||x|Accès secondaire| |Fiche d'information Fiche adresse ||
|src_adr                  ||x|Source de l'adresse| |Fiche d'information Fiche adresse ||
|src_date                  ||x|Date de la source de l'adresse| |Fiche d'information Fiche adresse ||
|src_geom                   ||x|Référentiel de saisie| |Fiche d'information Fiche adresse ||
|x_l93                    ||x|Coordonnée X en Lambert 93| |Fiche d'information Fiche adresse ||
|y_l93                    ||x|Coordonnée Y en Lambert 93| |Fiche d'information Fiche adresse ||

   * filtres : aucun
   * relations :

|Géotables ou Tables| Champs de jointure | Type |
|:---|:---|:---|
| xapps_an_v_adresse_h |id_adresse | 0..n (égal) |

   * particularité(s) : aucune
   
## GeoTable : `xapps_geo_v_voie`

|Attributs| Champ calculé | Formatage |Renommage|Particularité/Usage|Utilisation|Exemple|
|:---|:-:|:-:|:---|:---|:---|:---|
|affiche_message |x|x|`null`||Fiche d'information sur la voie||
|long||x|Linéaire||Fiche d'information sur la voie||

   * filtres : aucun
   * relations :

|Géotables ou Tables| Champs de jointure | Type |
|:---|:---|:---|
| xapps_v_troncon_voirie | id_voie | 0 à n (égal) |
| xapps_an_voie | id_voie | 1 (égal) |

   * particularité(s) : aucune
   
## GeoTable : `xapps_geo_v_troncon_voirie`

|Attributs| Champ calculé | Formatage |Renommage|Particularité/Usage|Utilisation|Exemple|
|:---|:-:|:-:|:---|:---|:---|:---|
|affiche_commune|x|x||Formate en HTML le titre Commune de |Fiche d'information sur un tronçon||
|affiche_message |x|x|`null`|Format en HTML un message sur la donnée|Fiche d'information sur un tronçon||
|affiche_result |x|x|`null`|Format en HTML un message sur la donnée|Fiche d'information sur un tronçon||
|affiche_troncon  |x|x|`null`|Format en HTML l'affichage du n° du tronçon avec un titre|Résultat de la recherche Recherche avancée d'une voie||
|c_circu||x|Types de restrictions||Fiche d'information sur un tronçon||
|c_observ||x|Autres restrictions||Fiche d'information sur un tronçon||
|date_extract ||x|Date d'extraction||Visible dans les résultats pour les recherches générant l'export des synthèses communales||
|date_lib||x|Période de création du libellé de la voie||Fiche d'information sur un tronçon||
|date_maj ||x|Date de mise à jour|Formate la date en dd/mm/yyyy|Fiche d'information sur un tronçon||
|date_ouv ||x|Année d'ouverture à la circulation||Fiche d'information sur un tronçon||
|date_rem ||x|Dernière année de remise en état de la chaussée||Fiche d'information sur un tronçon||
|date_sai ||x|Date de saisie|Formate la date en dd/mm/yyyy|Fiche d'information sur un tronçon||
|doman  ||x|Domanialité||Fiche d'information sur un tronçon||
|fictif   ||x|Fictif (ne rentre pas en compte dans le calcul du linéaire de voie)||Fiche d'information sur un tronçon||
|franchiss    ||x|Franchissement||Fiche d'information sur un tronçon||
|hierarchie     ||x|Hiérarchie||Fiche d'information sur un tronçon||
|id_tronc      ||x|Identifiant du tronçon||Fiche d'information sur un tronçon||
|id_voie       ||x|Identifiant de la voie||Fiche d'information sur un tronçon||
|insee        ||x|Code Insee||Fiche d'information sur un tronçon||
|libvoie        ||x|Libellé de la voie||Fiche d'information sur un tronçon||
|long        ||x|Longueur de la voie (en m)||Fiche d'information sur un tronçon||
|long_troncon        ||x|Longueur du tronçon (en m)||Fiche d'information sur un tronçon||
|nb_voie         ||x|Nombre de voies||Fiche d'information sur un tronçon||
|noeud_d          ||x|Identifiant du noeud de départ||||
|noeud_d          ||x|Identifiant du noeud de fin||||
|num_statut          ||x|N° de statut||Fiche d'information sur un tronçon||
|observ           ||x|Observation(s)||Fiche d'information sur un tronçon||
|proprio            ||x|Propriétaire||Fiche d'information sur un tronçon||
|rivoli             ||x|Code RIVOLI||Fiche d'information sur un tronçon||
|sens_circu             ||x|Sens de circulation||Fiche d'information sur un tronçon||
|statut_jur              ||x|Statut juridique||Fiche d'information sur un tronçon||
|titre_info_bulle_troncon              |x|x||Formatage en HTML du titre pour les informations au tronçon dans l'info bulle |champ calculé `voie_info_bulle `||
|titre_info_bulle_voie              |x|x||Formatage en HTML du titre pour les informations sur la voie dans l'info bulle |champ calculé `voie_info_bulle `||
|type_circu               ||x|Type de circulation||Fiche d'information sur un tronçon||
|type_tronc                ||x|Type de tronçon||Fiche d'information sur un tronçon||
|v_max                ||x|Vitesse maximum||Fiche d'information sur un tronçon||
|voie_info_bulle              |x|x||Formatage en HTML des informations du tronçonn et de la voie affichées dans l'info bulle du tronçon |Cartothèque||

   * filtres : aucun
   * relations :

|Géotables ou Tables| Champs de jointure | Type |
|:---|:---|:---|
| r_bg_edigeo.PARCELLE (Parcelle (Alpha) V3 dans GEO | idu | 0 à n (égal) |

   * particularité(s) : aucune
   
## GeoTable : `geo_objet_noeud`

|Attributs| Champ calculé | Formatage |Renommage|Particularité/Usage|Utilisation|Exemple|
|:---|:-:|:-:|:---|:---|:---|:---|
|date_maj||x|Horodatage de la mise à jour en base de l'objet||||
|date_sai||x|Horodatage de l'intégration en base de l'objet||||
|id_noeud ||x|Identifiant unique de l'objet noeud||||
|id_voie  ||x|Identifiant unique de l'objet voie||||
|observ  ||x|Observations||||
|x_l93 ||x|Coordonnée X en mètre||||
|y_l93 ||x|Coordonnée Y en mètre||||
|z_ngf ||x|Altimétrie ngf du noeud en mètre||||

   * filtres : aucun
   * relations : aucune
   * particularité(s) : aucune
   
## Table : `xapps_an_v_troncon_h`

|Attributs| Champ calculé | Formatage |Renommage|Particularité/Usage|Utilisation|Exemple|
|:---|:-:|:-:|:---|:---|:---|:---|
|date_lib||x|Arrêté communal du||Fiche d'information sur un tronçon||
|date_sai ||x|Intégré le||Fiche d'information sur un tronçon||
|troncon_h ||x|Ancien libellé||Fiche d'information sur un tronçon||

   * filtres : aucun
   * relations : aucune
   * particularité(s) : aucune
   
## Table : `xapps_an_voie`

|Attributs| Champ calculé | Formatage |Renommage|Particularité/Usage|Utilisation|Exemple|
|:---|:-:|:-:|:---|:---|:---|:---|
|affiche_titre   |x|x||Formate le résultat affiché dans le menu Résultat depuis la Recherche d'une voie|||
|affiche_voie   |x|x||Format l'affichage de la voie avec le mot directeur |Plus utilisé||
|affiche_voie_commune   |x|x||Formate l'affichage du libellé de la voie et de la commune dans le menu Résultat depuis la Recherche dans la Base Voie Locale |||
|voie_apostrophe   |x|x||Replace l'apostrophe dans le libellé de la voie|Utiliser dans les recherches par voie||

   * filtres : aucun
   * relations : aucune
   * particularité(s) : aucune
   
## Table : `xapps_an_v_adresse_h`

|Attributs| Champ calculé | Formatage |Renommage|Particularité/Usage|Utilisation|Exemple|
|:---|:-:|:-:|:---|:---|:---|:---|
|adresse_h    ||x|Ancienne adresse||Fiche adresse||
|affiche_ancienne_adresse    |x|x||Formate en HTML l'affichage d'une ancienne adresse si supprimée ou historisée  | Recherche d'une ancienne adresse||
|date_arr   ||x|Arrêté communal du||Fiche adresse||
|date_sai    ||x|Intégrée le||Fiche adresse||
|numero_complet    |x|x||Concaténation du n° et l'indice de répétition  | Filtre pour la recherche avancée d'une adresse historique||

   * filtres : aucun
   * relations :

|Géotables ou Tables| Champs de jointure | Type |
|:---|:---|:---|
| xapps_geo_v_adresse | id_adresse | 0 à n (égal) |
| xapps_an_voie | id_voie | 1 (égal) |

   * particularité(s) : aucune
   
   
## Table : `xapps_an_commune`

|Attributs| Champ calculé | Formatage |Renommage|Particularité/Usage|Utilisation|Exemple|
|:---|:-:|:-:|:---|:---|:---|:---|
|affiche_lien_export_liste_voie_open_data     |x|x||Formate en HTML le lien de téléchargement vers le fichier OpenData de la liste des voies au format excel|Recherche Exporter la liste des voies (avec linéaire)||

   * filtres : aucun
   * relations : aucune
   * particularité(s) : aucune

# Les fonctionnalités

Sont présentées ici uniquement les fonctionnalités spécifiques à l'application.

## Recherche globale : `Recherche dans la Base Adresse Locale`

Cette recherche permet à l'utilisateur de faire une recherche libre sur une adresse.

Cette recherche a été créée pour l'application RVA. Le détail de celle-ci est donc à visualiser dans le répertoire GitHub rva au niveau de la documentation applicative.

## Recherche globale : `Recherche d'une voie`

Cette recherche permet à l'utilisateur de faire une recherche libre sur le libellé d'une voie.

* Configuration :

Source : `xapps_geo_v_voie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|affiche_titre|x|||||
|voie_apostrophe||x||||
|Libellé de la voie|||x|||
|geom||||x||

(Calcul des suggestions par "Contient les mots entiers")
(la détection des doublons n'est pas activée ici)

 * Filtres : aucun

 * Fiches d'information active : Fiche d'information sur la voie
 
## Recherche globale : `Localiser un équipement`

Cette recherche permet à l'utilisateur de faire une recherche un équipement localisé dans une commune du Pays Compiégnois.
Elle est détaillée dans le répertoire GitHub `docurba`


## Recherche (clic sur la carte) : `Recherche dans la Base Adresse Locale`

Cette recherche permet à l'utilisateur de cliquer sur la carte et de remonter les informations de l'adresse.

  * Configuration :

Source : `xapps_geo_vmr_adresse`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|adresse_apostrophe||x||||
|adresse_apostrophe_histo||x||||
|affiche_result|x|||||
|affiche_adresse|x|||||
|Adresse complète|||x|||
|Complément||x|x|||
|geom||||x||

(Calcul des suggestions par "Contient les mots entiers")
(la détection des doublons n'est pas activée ici)

 * Filtres : aucun

 * Fiches d'information active : Fiche adresse
 
## Recherche (clic sur la carte) : `Recherche tronçon`

Cette recherche permet à l'utilisateur de cliquer sur la carte et de remonter les informations de la parcelle et d'accéder soit à la fiche de renseignement d'urbanisme ou de la fiche parcelle détaillée (si les droits).

  * Configuration :

Source : `xapps_geo_v_troncon_voirie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Libellé de la voie|x|x|x|||
|Commune|x|||||
|affiche_troncon|x|||||
|geom||||x||

(Calcul des suggestions par "Contient les mots entiers")
(la détection des doublons n'est pas activée ici)

 * Filtres :

Sans objet

 * Fiches d'information active : Fiche d'information sur un tronçon
 
## Recherche (clic sur la carte) : `Signalement voie/adresse`

Cette recherche permet à l'utilisateur de cliquer sur la carte et de remonter les informations du signalement non traité par le service SIG

  * Configuration :

Source : `xapps_geo_v_troncon_voirie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Commune|x|||||
|affiche_result|x|||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

Sans objet

 * Fiches d'information active : Fiche de suivi d'un signalement voie/adresse
 
## Recherche (clic sur la carte) : `Recherche avancée d'une voie`

Cette recherche permet à l'utilisateur de cliquer sur la carte et de remonter les informations d'une voie

  * Configuration :

Source : `xapps_geo_v_voie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Libellé de la voie|x|||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

Sans objet

 * Fiches d'information active : Fiche d'information sur la voie
 
## Recherche (clic sur la carte) : `Parcelle(s) sélectionnée(s) (Parcelle (Alpha) V3)`

Cette recherche permet à l'utilisateur de cliquer sur la carte et de remonter les informations de la parcelle
Cette recherche est détaillée dans le répertoire GitHub `docurba`.


## Recherche : `Toutes les recherches cadastrales`

L'ensemble des recherches cadastrales ont été formatées et intégrées par l'éditeur via son module GeoCadastre.
Seul le nom des certaines recherches a été modifié par l'ARC pour plus de compréhension des utilisateurs.

Cette recherche est détaillée dans le répertoire GitHub `docurba`.


## Recherche : `Rechercher un signalement par commune`

Cette recherche permet à l'utilisateur de faire une recherche sur les signalements.

  * Configuration :

Source : `geo_rva_signal`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|affiche_titre|x|||||
|affiche_result|x|x|x|||
|geom||||x||

(Calcul des suggestions par "Contient la chaine")
(la détection des doublons n'est pas activée ici)

 * Filtres :

|Groupe|Jointure|Filtres liés|
|:---|:-:|:-:|
|Groupe de filtres par défaut|`ET`|x|

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Commune|x|commune|Alphanumérique est égale à une valeur de liste de choix|Liste de domaine (Commune avec un signalement d'adresse)|commune|commune|commune|||
|Traitement SIG||traite_sig|Alphanumérique est égale à une valeur de liste de choix|Liste de domaine (lt_traite_sig)|valeur|code|code|||

(1) si liste de domaine

 * Fiches d'information active : Fiche de suivi d'un signalement voie/Adresse
 
## Recherche : `Recherche avancée d'une adresse`

Cette recherche permet à l'utilisateur de faire une recherche guidée d'une adresse.

  * Configuration :

Source : `xapps_geo_vmr_adresse`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|affiche_result|x|||||
|Adresse complète|x|||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Groupe|Jointure|Filtres liés|
|:---|:-:|:-:|
|Groupe de filtres par défaut|`ET`|x|

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Adresse par commune|x|commune|Prédéfinis à filtre à liste de choix|||||||
|Adresse par voie|x|id_voie|Alphanumérique est égale à une valeur de liste de choix|Liste de domaine (Liste de voie)|affiche_voie|id_voie|mot_dir|||
|Numéro complet de l'adresse||numero_complet|Prédéfinis à filtre à liste de choix|||||||

(1) si liste de domaine

 * Fiches d'information active : Fiche adresse
 
## Recherche : `Recherche d'une ancienne adresse`

Cette recherche permet à l'utilisateur de faire une recherche guidée d'une adresse historisée.

* Configuration :

Source : `xapps_an_v_adresse_h`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|affiche_ancienne_adresse|x|||||
|affiche_nouvelle_adresse|x|||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Groupe|Jointure|Filtres liés|
|:---|:-:|:-:|
|Groupe de filtres par défaut|`ET`|x|

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Commune|x|commune|Prédéfinis à filtre à liste de choix|||||||
|Voie|x|id_voie|Alphanumérique est égale à une valeur de liste de choix|Liste de domaine (Liste de voie)|affiche_voie|id_voie|mot_dir|||
|Numéro||numero_complet|Prédéfinis à filtre à liste de choix|||||||

(1) si liste de domaine

 * Fiches d'information active : aucune

 ## Recherche : `Recherche, export de la base Adresses (par commune et voie)`

Cette recherche permet à l'utilisateur de faire une recherche guidée par commune et voie afin d'exporter l'ensemble des adresses.

* Configuration :

Source : `xapps_geo_vmr_adresse`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|identifiant (id_adresse)||||||
|identifiant de la voie (id_voie)||||||
|identifiant du tronçon de voie (id_tronc)||||||
|Adresse complète (adresse)|x|x|x|||
|Numéro (numero)||||||
|Indice de répétition (repet)||||||
|Complément (complement)||||||
|Etiquette (etiquette)||||||
|Angle (angle)||||||
|Voie (libvoie_c)||||||
|Insee (insee)||||||
|Code postal (codepostal)||||||
|Commune (commune)||||||
|N° RIVOLI (rivoli)||||||
|Clé Rivoli (rivoli_cle)||||||
|Position (position)||||||
|Destination (dest_adr)||||||
|Etat (etat_adr)||||||
|Parcelle(s) (refcad)||||||
|Logement (nb_log)||||||
|Diagnostic (diag_adr)||||||
|Qualité (qua_adr)||||||
|N° du permis de construire (pc)||||||
|Groupée (groupee)||||||
|Accès secondaire (secondaire)||||||
|Source de l'adresse (src_adr)||||||
|Référentiel de saisie (src_geom)||||||
|Date de la source de l'adresse (src_date)||||||
|Date de saisie (date_sai)||||||
|Date de mise à jour (date_maj)||||||
|Observations (observ)||||||
|Coordonnées X en Lambert 93 (x_l93)||||||
|Coordonnées Y en Lambert 93 (y_l93)||||||
|Latitude (lat)||||||
|Longitude (long)||||||
|geom||||x||

(Calcul des suggestions par "Contient la chaine")
(la détection des doublons n'est pas activée ici)

 * Filtres :

|Groupe|Jointure|Filtres liés|
|:---|:-:|:-:|
|Groupe de filtres par défaut|`ET`|x|

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Adresse par commune|x|commune|Prédéfinis à filtre à liste de choix|||||||
|Voie||id_voie|Alphanumérique est égale à une valeur de liste de choix|Liste de domaine (Liste de voie)|affiche_voie|id_voie|mot_dir|||

(1) si liste de domaine

 * Fiches d'information active : Fiche adresse

## Recherche : `Recherche, export des adresses par qualité, diagnostic à la commune`

Cette recherche permet à l'utilisateur de faire une recherche guidée par commune et par qualité et diagnostic afin d'exporter l'ensemble des adresses.

* Configuration :

Source : `xapps_geo_vmr_adresse`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Numéro (numero)||||||
|Indice de répétition (repet)||||||
|Voie (libvoie_c)||||||
|Complément (complement)||||||
|Code postal (codepostal)||||||
|Commune (commune)||||||
|Adresse complète (adresse)|x|x|x|||
|Position (position)||||||
|Destination (dest_adr)||||||
|Logement (nb_log)||||||
|Etat (etat_adr)||||||
|Diagnostic (diag_adr)||||||
|Qualité (qua_adr)||||||
|Groupée (groupee)||||||
|Accès secondaire (secondaire)||||||
|Parcelle(s)||||||
|Observations (observ)||||||
|Coordonnées X en Lambert 93 (x_l93)||||||
|Coordonnées Y en Lambert 93 (y_l93)||||||
|Latitude (lat)||||||
|Longitude (long)||||||
|geom||||x||

(Calcul des suggestions par "Contient la chaine")
(la détection des doublons n'est pas activée ici)

 * Filtres :

|Groupe|Jointure|Filtres liés|
|:---|:-:|:-:|
|Groupe de filtres par défaut|`ET`|x|

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Adresse par commune|x|commune|Prédéfinis à filtre à liste de choix|||||||
|Adresse par qualité||qua_adr|Prédéfinis à filtre à liste de choix|||||||
|Adresse par diagnostic||diag_adr|Prédéfinis à filtre à liste de choix|||||||

(1) si liste de domaine

 * Fiches d'information active : Fiche adresse
 
## Recherche : `Recherche, export des adresses par nombre de logements à la commune`

Cette recherche permet à l'utilisateur de faire une recherche guidée par commune et nombre de logements afin d'exporter l'ensemble des adresses.

* Configuration :

Source : `xapps_geo_vmr_adresse`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Numéro (numero)||||||
|Indice de répétition (repet)||||||
|Voie (libvoie_c)||||||
|Complément (complement)||||||
|Code postal (codepostal)||||||
|Commune (commune)||||||
|Adresse complète (adresse)|x|x|x|||
|Position (position)||||||
|Destination (dest_adr)||||||
|Logement (nb_log)||||||
|Etat (etat_adr)||||||
|Diagnostic (diag_adr)||||||
|Qualité (qua_adr)||||||
|Groupée (groupee)||||||
|Accès secondaire (secondaire)||||||
|Parcelle(s)||||||
|Observations (observ)||||||
|Coordonnées X en Lambert 93 (x_l93)||||||
|Coordonnées Y en Lambert 93 (y_l93)||||||
|Latitude (lat)||||||
|Longitude (long)||||||
|geom||||x||

(Calcul des suggestions par "Contient la chaine")
(la détection des doublons n'est pas activée ici)

 * Filtres :

|Groupe|Jointure|Filtres liés|
|:---|:-:|:-:|
|Groupe de filtres par défaut|`ET`|x|

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Adresse par commune|x|commune|Prédéfinis à filtre à liste de choix|||||||
|Nombre de logements (=)||nb_log|Alphanumérique est égale à une valeur saisie|||||||
|Nombre de logements (>=)||nb_log|Alphanumérique est supérieure ou égale à une valeur saisie|||||||
|Nombre de logements (<=)||nb_log|Alphanumérique est inférieure ou égale à une valeur saisie|||||||

(1) si liste de domaine

 * Fiches d'information active : Fiche adresse
 
## Recherche : `Recherche avancée d'une voie`

Requêté détaillée dans la recherche au clic plus haut sur cette page.

## Recherche : `Tronçon de voie par statut juridique`

Cette recherche permet à l'utilisateur de faire une recherche sur les tronçons de voies par statut juridique.

* Configuration :

Source : `xapps_geo_v_troncon_voirie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Identifiant du tronçon (id_tronc)||||||
|Libellé de la voie (libvoie)|x|||||
|Code Insee (insee)||||||
|Commune (commune)|x|||||
|Type de tronçon (type_tronc)||||||
|Hiérarchie (hierarchie)||||||
|Franchissement (franchiss)||||||
|Nombre de voies (nb_voie)||||||
|Statut juridique (statut_jur)|x|x||||
|N° de statut (num_statut)||||||
|Gestion (gestion)||||||
|Domanialité (doman)||||||
|Propriétaire (proprio)||||||
|Type de circulation (type_circu)||||||
|Sens de circualtion (sens_ciruc)||||||
|Vitesse maximun (v_max)||||||
|Pente (pente)||||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Groupe|Jointure|Filtres liés|
|:---|:-:|:-:|
|Groupe de filtres par défaut|`ET`|x|

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Voie par commune|x|commune|Prédéfinis à filtre à liste de choix|||||||
|Voie par statut juridique|x|statut_jur|Prédéfinis à filtre à liste de choix|||||||

(1) si liste de domaine

 * Fiches d'information active : Fiche d'information sur un tronçon

## Recherche : `Exporter la synthèse communale selon le statut juridique`

Cette recherche permet à l'utilisateur de faire une recherche et d'exporter les tronçons de voies par statut juridique.

* Configuration :

Source : `xapps_an_v_troncon`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Insee (insee)||||||
|Commune (commune)|x|||||
|Résumé (affiche_result_statut)|x|||||
|Précaution d'usage (affiche_message_statut)||||||
|Extraction du (date_extract)||||||
|Non renseigné (long_ts00)||||||
|Autoroute (long_ts01)||||||
|Route nationale (long_ts02)||||||
|Route départementale (long_ts03)||||||
|Voie d'intérêt Communautaire (long_ts04)||||||
|Voie communale (long_ts05)||||||
|Chemin rural (long_ts06)||||||
|Chemin d'exploitation (long_ts07)||||||
|Chemin forestier (long_ts08)||||||
|Chemin de halage (long_ts09)||||||
|Voie privée (long_ts10)||||||
|Piste cyclable (long_ts11)||||||
|Voie verte (long_ts12)||||||
|Autre (long_ts99)||||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Commune|x|commune|Prédéfinis à filtre à liste de choix|||||||

(1) si liste de domaine

 * Fiches d'information active : aucune
 
## Recherche : `Tronçon de voie par domanialité`

Cette recherche permet à l'utilisateur de faire une recherche sur les tronçons de voies par domanialité.

* Configuration :

Source : `xapps_geo_v_troncon_voirie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Identifiant du tronçon (id_tronc)||||||
|Libellé de la voie (libvoie)|x|||||
|Code Insee (insee)||||||
|Commune (commune)|x|||||
|Type de tronçon (type_tronc)||||||
|Hiérarchie (hierarchie)||||||
|Franchissement (franchiss)||||||
|Nombre de voies (nb_voie)||||||
|Statut juridique (statut_jur)||||||
|N° de statut (num_statut)||||||
|Gestion (gestion)||||||
|Domanialité (doman)|x|x||||
|Propriétaire (proprio)||||||
|Type de circulation (type_circu)||||||
|Sens de circualtion (sens_ciruc)||||||
|Vitesse maximun (v_max)||||||
|Pente (pente)||||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Groupe|Jointure|Filtres liés|
|:---|:-:|:-:|
|Groupe de filtres par défaut|`ET`|x|

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Voie par commune|x|commune|Prédéfinis à filtre à liste de choix|||||||
|RVA - Domanialité|x|doman|Prédéfinis à filtre à liste de choix|||||||

(1) si liste de domaine

 * Fiches d'information active : Fiche d'information sur un tronçon
 
## Recherche : `Exporter la synthèse communale selon la domanialité`

Cette recherche permet à l'utilisateur de faire une recherche et d'exporter les tronçons de voies par domanialité.

* Configuration :

Source : `xapps_an_v_troncon`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Insee (insee)||||||
|Commune (commune)|x|||||
|Résumé (affiche_result_statut)|x|||||
|Précaution d'usage (affiche_message_statut)||||||
|Extraction du (date_extract)||||||
|Non renseigné (long_td00)||||||
|Public (long_td01)||||||
|Privé (long_td02)||||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Commune|x|commune|Prédéfinis à filtre à liste de choix|||||||

(1) si liste de domaine

 * Fiches d'information active : aucune
 
## Recherche : `Tronçon de voie par gestionnaire`

Cette recherche permet à l'utilisateur de faire une recherche sur les tronçons de voies par gestionnaire.

* Configuration :

Source : `xapps_geo_v_troncon_voirie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Identifiant du tronçon (id_tronc)||||||
|Libellé de la voie (libvoie)|x|||||
|Code Insee (insee)||||||
|Commune (commune)|x|||||
|Type de tronçon (type_tronc)||||||
|Hiérarchie (hierarchie)||||||
|Franchissement (franchiss)||||||
|Nombre de voies (nb_voie)||||||
|Statut juridique (statut_jur)||||||
|N° de statut (num_statut)||||||
|Gestion (gestion)|x|x||||
|Domanialité (doman)||||||
|Propriétaire (proprio)||||||
|Type de circulation (type_circu)||||||
|Sens de circualtion (sens_ciruc)||||||
|Vitesse maximun (v_max)||||||
|Pente (pente)||||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Groupe|Jointure|Filtres liés|
|:---|:-:|:-:|
|Groupe de filtres par défaut|`ET`|x|

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Voie par commune|x|commune|Prédéfinis à filtre à liste de choix|||||||
|RVA - Gestionnaire|x|gestion|Prédéfinis à filtre à liste de choix|||||||

(1) si liste de domaine

 * Fiches d'information active : Fiche d'information sur un tronçon
 
## Recherche : `Exporter la synthèse communale selon le gestionnaire`

Cette recherche permet à l'utilisateur de faire une recherche et d'exporter les tronçons de voies par gestionnaire.

* Configuration :

Source : `xapps_an_v_troncon`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Insee (insee)||||||
|Commune (commune)|x|||||
|Résumé (affiche_result_statut)|x|||||
|Précaution d'usage (affiche_message_statut)||||||
|Extraction du (date_extract)||||||
|Non renseigné (long_tg00)||||||
|Etat (long_tg01)||||||
|Région (long_tg02)||||||
|Département (long_tg03)||||||
|EPCI (long_tg04)||||||
|Commune (long_tg05)||||||
|Office HLM (long_tg06)||||||
|Privé (long_tg07)||||||
|Autre (long_tg08)||||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Commune|x|commune|Prédéfinis à filtre à liste de choix|||||||

(1) si liste de domaine

 * Fiches d'information active : aucune

## Recherche : `Vitesse maximum autorisée`

Cette recherche permet à l'utilisateur de faire une recherche sur les tronçons de voies selon la vitesse maximale autorisée.

* Configuration :

Source : `xapps_geo_v_troncon_voirie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Libellé de la voie (libvoie)|x|||||
|Commune (commune)|x|||||
|affiche_troncon|x|||||
|Vitesse maximun (v_max)|x|||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Vitesse|x|v_max|Alphanumérique est égale à une valeur de liste de choix|Liste de domaine (lt_v_max)|valeur|valeur|code|||

(1) si liste de domaine

 * Fiches d'information active : Fiche d'information sur un tronçon

## Recherche : `Autres restrictions de circulation`

Cette recherche permet à l'utilisateur de faire une recherche sur les tronçons de voies selon les restructions de circulation (hors vitesse).

* Configuration :

Source : `xapps_geo_v_troncon_voirie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Libellé de la voie (libvoie)|x|||||
|Commune (commune)|x|||||
|affiche_troncon|x|||||
|Autres restrictions (c_observ)|x|||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Restriction de circulation|x|c_circu|Alphanumérique est égale à une valeur de liste de choix|Liste de domaine (lt_cont_circu)|valeur|code|code|||

(1) si liste de domaine

 * Fiches d'information active : Fiche d'information sur un tronçon

## Recherche : `Exporter la base de données des tronçons`

Cette recherche permet à l'utilisateur de faire une recherche et d'exporter la base des tronçons par commune.

* Configuration :

Source : `xapps_geo_v_troncon_voirie`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|Libellé de la voie (libvoie)|x|x|x|||
|Commune (commune)|x|||||
|affiche_troncon|x|||||
|Code rivoli (rivoli)||||||
|Code Insee (insee)||||||
|Identifiant du noeud de départ (noeud_d)||||||
|Identifiant du noeud de fin (noeud_f)||||||
|Type de tronçon (type_tronc)||||||
|Hiérarchie (hierarchie)||||||
|Franchissement (franchiss)||||||
|Nombre de voies (nb_voie)||||||
|Projet (projet)||||||
|Fictif (ne rentre pas en compte dans le calcul du linéaire de voie) (fictif)||||||
|Statut juridique (statut_jur)||||||
|N° de statut (num_statut)||||||
|Gestion (gestion)||||||
|Domanialité (doman)||||||
|Propriétaire (proprio)||||||
|Type de circulation (type_circu)||||||
|Sens de circulation (sens_circu)||||||
|Vitesse maximum (v_max)||||||
|Pente (pente)||||||
|Observation(s) (observ)||||||
|Source du référentiel de saisie (src_geom)||||||
|Date de saisie (date_sai)||||||
|Date de mise à jour (date_maj)||||||
|Longueur du tronçon (en m) (long_troncon)||||||
|Date d'extraction (date_extract)||||||
|Période de création du libellé de la voie (date_lib)||||||
|Types de restrictions (c_circu)||||||
|Année d'ouverture à la circulation (date_ouv)||||||
|Dernière année de remise en état de la chaussé (date_rem)||||||
|Source des informations du tronçons (src_tronc)||||||
|Libellé de la voie (libvoie_c)||||||
|Longueur de la voie (en m) (long)||||||
|geom||||x||

(la détection des doublons n'est pas activée ici)

 * Filtres :

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Commune|x|commune|Prédéfinis par un filtre à liste de choix||||||

(1) si liste de domaine

 * Fiches d'information active : Fiche d'information sur un tronçon

## Recherche : `Exporter la base de données des voies (avec linéaire)`

Cette recherche permet à l'utilisateur de faire une recherche et d'exporter la base des voies par commune via un lien http directement sur le fichier OpenData exporté par FME.

* Configuration :

Source : `xapps_an_commune`

|Attribut|Afficher|Rechercher|Suggestion|Attribut de géométrie|Tri des résultats|
|:---|:-:|:-:|:-:|:-:|:-:|
|affiche_lien_export_liste_voie_open_data|x|||||


(la détection des doublons n'est pas activée ici)

 * Filtres :

|Nom|Obligatoire|Attribut|Condition|Valeur|Champ d'affichage (1)|Champ de valeurs (1)|Champ de tri (1)|Ajout autorisé (1)|Particularités|
|:---|:-:|:---|:---|:---|:---|:---|:---|:-:|:---|
|Commune|x|commune|Prédéfinis par un filtre à liste de choix||||||

(1) si liste de domaine

 * Fiches d'information active : aucune
 * Particularité(s) : cette table est une simple vue dans la base de données Postgres avec la liste des communes du Pays Compiégnois permettant d'y lier un champ calculé contenant le lien de téléchargement du fichier OpenData. Cette vue permet d'assoir la recherche par commune et d'accéder à ce lien dans GEO au niveau du menu résultat.

## Fiche d'information : `Fiche adresse`

Source : `xapps_geo_vmr_adresse`

* Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|530x650|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|Adresse|adresse,nuemro,repet,libvoie_c,complement,codepostal, commune|Par défaut|Vertical||||
|Historique des adresses (sous-section de Adresse)|adresse_h,date_arr,date_sai|Par défaut|Vertical||||
|Qualité des adresses|||Vertical||||
|Conformité (sous-section de Qualité des adresses)|diag_adr,qual_adr,etat_adr,observ|Par défaut|Vertical||||
|Positionnement (sous-section de Qualité des adresses)|position,groupee,secondaire,refcad|Par défaut|Vertical||||
|Destination de l'adresse|dest_adr,nb_log,pc|Par défaut|Vertical||||
|Informations complémentaires|id_adresse,rivoli,insee|Par défaut|Vertical||||
|Source|src_adr,src_geom|Par défaut|Vertical||||
|Suivi des mises à jour|date_sai, date_maj|Par défaut|Vertical||||

 * Saisie : aucune

 * Modèle d'impression : Fiche standard + carte

## Fiche d'information : `Fiche d'information sur la voie`

Source : `xapps_geo_v_voie`

* Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|700x650|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|(vide)|affiche_voie_commune|Par défaut|Vertical||||
|Caractéristique(s)|long,affiche_message|Par défaut|Vertical||||
|Tronçon(s) composant la voie|long_troncon,statut_jur,doman,gestion,proprio|Par défaut|Vertical||Fiche d'information sur un tronçon (Accès à)||

 * Saisie : aucune

 * Modèle d'impression : aucun

## Fiche d'information : `Fiche équipement`

Détail dans le répertoire GitHub `docurba`

## Fiche d'information : `Fiche parcelle` et `Fiche local`

Source : `r_bg_majic.NBAT_10 (Parcelle (Alpha) V3)`

Ces fiches sont liées au module GeoCadastre de l'éditeur et ne sont pas modifiable par l'ARC. 

## Fiche d'information : `Fiche de suivi d'un signalement voie/adresse`

Source : `geo_rva_signal`

* Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|530x700|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|Gestion des signalement|traite_sig,type_rva,nat_signal,acte_admin,observ,op_sai,mail,date_sai,affiche_info|Par défaut|Vertical||||

 * Saisie :
 
 Sont présent ici uniquement les attributs éditables ou disposant d'un mode de représentation spécifique.

|Attribut|Obligatoire|Valeur par défaut|Liste de domaine|Représentation|
|:---|:---|:---|:---|:---|
|Type de signalement (type_rva)|x|0|Type de signalement|Liste de choix|
|Nature du signalement (nat_signal)|x|0|Nature du signalement|Liste de choix|
|Document administratif (acte_admin)|x|false||Boutons radios|
|Description du signalement (observ)|x|||Champ texte à plusieurs lignes|
|Nom du contributeur (op_sai)|x|%USER_LOGIN%|||
|Email du contributeur (mail)|x|%USER_MAIL%|||
|Suivi de la demande (traite_sig)|(non saisie par les utilisateurs)|1|Suivi de la demande d'un signalement|Liste de choix|

 * Modèle d'impression : aucun

## Fiche d'information : `Fiche d'information sur un tronçon`

Source : `xapps_geo_v_troncon_voirie`

* Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|530x650|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|Caractéristiques du tronçon|id_tronc,type de tronçon,hierarchie,franchiss,nb_voie,long_troncon,projet,fictif,observ|Par défaut|Vertical||||
|Voie d'appartenance|id_voie,libvoie,rivoli,insee,commune|Par défaut|Vertical||||
|Informations complémentaires sur la voie (sous-secteur de Voie d'appartenance)|long|Par défaut|Vertical||Fiche d'information sur la voie (+ d'infos)||
|Historique des noms de voies (sous-secteur de Voie d'appartenance) |troncon_h,date_lib,date_sai |Par défaut|Vertical||||
|Informations de gestion|statut_jur,num_statut,doman,gestion,proprio,date_rem|Par défaut|Vertical||||
|Informations de circulation|date_ouv,type_circu,sens_circu,v_max,autres restriciton,pente|Par défaut|Vertical||||
|Informations de suivi|date_sai,date_maj|Par défaut|Vertical||||

 * Saisie : aucune

 * Modèle d'impression : aucun

 
## Analyse :

Aucune

## Statistique :

Aucune

## Modification géométrique : `Faire un signalement d'adresses ou de voies`

Cette recherche permet à l'utilisateur de saisir un sigbnalement concernant une voie ou une adresse.

  * Configuration :
  
Source : `geo_rva_signal`

 * Filtres : aucun
 * Accrochage : aucun
 * Fiches d'information active : Fiche de suivi d'un signalement voie/adresse
 * Topologie : aucune 
 
 # La cartothèque

|Groupe|Sous-groupe|Visible dans la légende|Visible au démarrage|Détails visibles|Déplié par défaut|Geotable|Renommée|Issue d'une autre carte|Visible dans la légende|Visible au démarrage|Déplié par défaut|Couche sélectionnable|Couche accrochable|Catégorisation|Seuil de visibilité|Symbologie|Autres|
|:---|:---|:-:|:-:|:-:|:-:|:---|:---|:-:|:-:|:-:|:-:|:-:|:---|:---|:---|:---|:---|
|||||||geo_rva_signal|Suivi des signalements||x|x|x||x|traite_sig||Symbole signalement_rouge.svg pour Nvlle demande et signalement_orange.svg pour Prise en compte,taille 25|Interactivité avec le champ infobulle|
|||||||geo_v_osm_commune_apc|Limite communale|||x||||||Contour marron épais||
|Adresse||x|x|x|x|xapps_geo_vmr_adresse|Conformité||x|x|x|||affiche_qual_adr|0 à 1999è|Couleur par conformité|Interactivité avec le champ infobulle|
|Adresse||x|x|x|x|xapps_geo_vmr_adresse|Points d'adresse||x|x|||||1999 à 10000è|Carré bleu de taille 5|Interactivité avec le champ infobulle (avec seuil de zoom de 1999 à 5000è)|
|Voie||x|x|x|x|xapps_geo_v_voie|Voie (agrégée pour clic carte)|||x|||||0 à 100 000è|aucune symbologie||
|Voie||x|x|x|x|xapps_geo_v_troncon_voirie|Tronçon (pour clic carte)|||x|||||0 à 100 000è|aucune symbologie||
|Voie|Tronçons|x||||geo_objet_noeud|Noeuds||x|x|||x||0 à 50 000è|Point gris de taille 3||
|Voie|Tronçons|x||||xapps_geo_v_troncon_voirie|Tronçons||x|x|||x||0 à 50 000è|trait de 0.5 noir||
|Voie||x|x|x|x|xapps_geo_v_troncon_voirie|Statut juridique des voies||x|||||statut_jur|0 à 50000è|Couleur par statut|Interactivité avec le champ voie_info_bulle (avec seuil de zoom de 0 à 25000è)|
|Voie||x|x|x|x|xapps_geo_v_troncon_voirie|Gestionnaire des voies||x|x|x|||gestion|0 à 50000è|Couleur par gestionnaire|Interactivité avec le champ voie_info_bulle (avec seuil de zoom de 0 à 25000è)|
|Voie||x|x|x|x|xapps_geo_v_troncon_voirie|Domanialité||x|||||doman|0 à 50000è|Couleur par domanialité|Interactivité avec le champ voie_info_bulle (avec seuil de zoom de 0 à 25000è)|

# L'application

* Généralités :

|Gabarit|Thème|Modules spé|Impression|Résultats|
|:---|:---|:---|:---|:---|
|Pro|Thème GeoCompiegnois 1.0.7|StreetView,GeoCadastre (V3),Google Analytics,Page de connexion perso, Export Fonctionnalités (Adresse),Multimédia (signalement Voie/Adresse),javascript|8 Modèles standards A4 et A3||

* Particularité de certains modules :
  * Module introduction : ce menu s'ouvre automatiquement à l'ouverture de l'application grâce un code dans le module javascript. Ce module contient une introduction sur l'application, et des liens vers des fiches d'aide.
  * Module javacript : 
  `var injector = angular.element('body').injector();
var acfApplicationService = injector.get('acfApplicationService');
acfApplicationService.whenLoaded(setTimeout(function(){
$(".sidepanel-item.launcher-application").click();
}, 100));`
  * Module Google Analytics : le n° ID est disponible sur le site de Google Analytics

* Recherche globale :

|Noms|Tri|Nb de sugggestion|Texte d'invite|
|:---|:---|:---|:---|
|Recherche dans la Base Adresse Locale,Recherche dans la Base de Voie locale, Localiser une commune de l'APC, Localiser un équipement|alpha|20|Rechercher une adresse, une voie, une commune, un équipement, ...|

* Carte : `Cadastre V4`

Comportement au clic : (dés)active uniquement l'item cliqué
Liste des recherches : Parcelle(s) sélectionnée(s) (description : GeoCadastre V3), PPRi zonage (projet) - remarque

* Fonds de plan :

|Nom|Au démarrage|opacité|
|:---|:---|:---|
|Cadastre|x|100%|
|Plan de ville||100%|
|Carte IGN 25000||100%|
|Photographie aérienne 2013|x|70%|

* Fonctionnalités

|Groupe|Nom|
|:---|:---|
|Recherche cadastrale (V3)||
||Parcelles par référence|
||Parcelles par adresse fiscale (V3)|
||Parcelles par nom du propriétaire (V3) (non disponible pour l'application URBANISME)|
||Parcelles multicritères (V3)|
||Parcelles par nom du propriétaire d'un local (V3) (non disponible pour l'application URBANISME)|
||Parcelles par surface (V3)|
|Recherche zone PLU||
||Par libellé de zone PLU|
||Par type de zone PLU|
|Recherche avancée d'une voie ou d'une adresse||
||Recherche avancée d'une adresse|
||Recherche avancée d'une voie|
|Modification d'objets||
||PPRi (projet) - remarque|


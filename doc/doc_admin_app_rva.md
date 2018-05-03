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

 * Saisie : aucune

 * Modèle d'impression : aucun

## Fiche d'information : `Fiche équipement`

Source : `r_plan.geo_plan_refpoi (usage APC)`

 * Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|530x650|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|Etablissement|poi_lib|Par défaut|Vertical||INFORMATIONS / CONTACT||

 * Saisie : aucune

 * Modèle d'impression : aucun
 
## Fiche d'information : `Fiche détaillée POI`

Source : `r_plan.an_plan_refcontactpoi`

 * Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|530x650|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|Etablissement|poi_lib,poi_alias|Par défaut|Vertical||||
|Adresse|adr_compl|Par défaut|Vertical||||
|Contact|tel, fax, mail|Par défaut|Vertical||||
|Lien(s) internet|site,url1,url2|Par défaut|Vertical||||
|Remarques|observ|Par défaut|Vertical||||

 * Saisie : aucune

 * Modèle d'impression : aucun
 * Particularité : cette fiche est liée à la fiche équipement, et n'est accessaible qu'à partir de celle-ci 
 
## Fiche d'information : `Fiche parcelle` et `Fiche local`

Source : `r_bg_majic.NBAT_10 (Parcelle (Alpha) V3)`

Ces fiches sont liées au module GeoCadastre de l'éditeur et ne sont pas modifiable par l'ARC. 

## Fiche d'information : `Fiche détaillée POS-PLU-CC`

Source : `x_apps_geo_vmr_p_zone_urba`

 * Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|530x650|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|Caractéristiques de la zone|LIBELLE (commune-BG),libelle,gestion_libelle_long,typezone,destdomi_lib,fermreco,l_surf_cal,l_observ|Par défaut|Vertical||||
|Validité du document|datappro_date|Par défaut|Vertical||||
|Accès au réglement|urlfic|Par défaut|Vertical||||

 * Saisie : aucune

 * Modèle d'impression : Fiche standard
 
 ## Fiche d'information : `Fiche adresse` et `Fiche d'information sur la voie`

Ces deux fiches sont issues de l'application RVA. Se référer au répertoire GitHub du même nom pour plus de précisions.

## Fiche d'information : `PPRi zonage (projet) - remarque`

Source : `m_urbanisme_reg.geo_sup_pm1_ppri_projet_rq (PPRi zonage (projet) - remarque)`

 * Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|530x650|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|Caractéristiques de l'annotation|id_rq,nom,tyep_rq,observ,date_sai,date_maj|Par défaut|Vertical||||

 * Saisie : aucune

 * Modèle d'impression : Fiche standard+carte
 
## Fiche d'information : `Renseignements d'urbanisme`

Source : `r_bg_majic.NBAT_10 (Parcelle (Alpha) V3)`

 * Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|600x650|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|(vide)|affiche_commune|Masqué|Vertical||||
|(vide)|titre_html|Masqué|Vertical||||
|(vide)|section_parcelle|Masqué|Vertical||||
|(vide)|tableau_proprio|Masqué|Vertical||||
|(vide)|titre_doc_urba_valide_html|Masqué|Vertical||||
|(vide)|tableau_doc_vigueur|Masqué|Vertical||||
|(vide)|libelle(xapps_an_vmr_parcelle_plu),libelong,urlfic (xapps_an_vmr_parcelle_plu)|Masqué|Vertical||Fiche POS-PLU-CC||
|(vide)|titre_prescription_html|Masqué|Vertical||||
|(vide)|libelle(xapps_an_vmr_p_prescription),lien(xapps_an_vmr_p_prescription)|Masqué|Vertical||||
|(vide)|titre_dpu_html|Masqué|Vertical||||
|(vide)|application,beneficiaire,date_ins,urlfic(xapps_an_vmr_p_information_dpu)|Masqué|Vertical||||
|(vide)|titre_info_utile_html|Masqué|Vertical||||
|(vide)|libelle(xapps_an_vmr_p_information),lien(xapps_an_vmr_p_information)|Masqué|Vertical||||
|(vide)|titre_sup_html,titre_sup_impact|Masqué|Vertical||||
|(vide)|ligne_aff(an_sup_geo),l_url(an_sup_geo)|Masqué|Vertical||||
|(vide)|titre_ac4|Masqué|Vertical||||
|(vide)|message,protec,typeprotec(an_sup_ac4_geo_protect)|Masqué|Vertical||||
|(vide)|titre_liste_sup_com|Masqué|Vertical||||
|(vide)|titre_taxe_amgt|Masqué|Vertical||||
|(vide)|affiche_taux,affiche_url(an_fisc_geo_taxe_amgt)|Masqué|Vertical||||

 * Saisie : aucune

 * Modèle d'impression : Fiche standard
 * Particularité : le champ calculé tableau_proprio a été intégré en plus de l'éditeur. Ce champ doit-être recréer à chaque mise à jour du module GeoCadastre et de la création de la structure dans GEO si besoin (champ HTML <b>{BG_FULL_NAME} /st de ligne/
{BG_FULL_ADDRESS}</b>) et renommé Le ou les propriétaire(s).

## Fiche d'information : `Renseignements d'urbanisme (non DGFIP)`

Source : `r_bg_majic.NBAT_10 (Parcelle (Alpha) V3)`

 * Statistique : aucune
 
 * Représentation :
 
|Mode d'ouverture|Taille|Agencement des sections|
|:---|:---|:---|
|dans le gabarit|600x650|Vertical|

|Nom de la section|Attributs|Position label|Agencement attribut|Visibilité conditionnelle|Fichie liée|Ajout de données autorisé|
|:---|:---|:---|:---|:---|:---|:---|
|(vide)|affiche_commune|Masqué|Vertical||||
|(vide)|titre_html|Masqué|Vertical||||
|(vide)|section_parcelle|Masqué|Vertical||||
|(vide)|titre_doc_urba_valide_html|Masqué|Vertical||||
|(vide)|tableau_doc_vigueur|Masqué|Vertical||||
|(vide)|libelle(xapps_an_vmr_parcelle_plu),libelong,urlfic (xapps_an_vmr_parcelle_plu)|Masqué|Vertical||Fiche POS-PLU-CC||
|(vide)|titre_prescription_html|Masqué|Vertical||||
|(vide)|libelle(xapps_an_vmr_p_prescription),lien(xapps_an_vmr_p_prescription)|Masqué|Vertical||||
|(vide)|titre_dpu_html|Masqué|Vertical||||
|(vide)|application,beneficiaire,date_ins,urlfic(xapps_an_vmr_p_information_dpu)|Masqué|Vertical||||
|(vide)|titre_info_utile_html|Masqué|Vertical||||
|(vide)|libelle(xapps_an_vmr_p_information),lien(xapps_an_vmr_p_information)|Masqué|Vertical||||
|(vide)|titre_sup_html,titre_sup_impact|Masqué|Vertical||||
|(vide)|ligne_aff(an_sup_geo),l_url(an_sup_geo)|Masqué|Vertical||||
|(vide)|titre_ac4|Masqué|Vertical||||
|(vide)|message,protec,typeprotec(an_sup_ac4_geo_protect)|Masqué|Vertical||||
|(vide)|titre_liste_sup_com|Masqué|Vertical||||
|(vide)|titre_taxe_amgt|Masqué|Vertical||||
|(vide)|affiche_taux,affiche_url(an_fisc_geo_taxe_amgt)|Masqué|Vertical||||

 * Saisie : aucune

 * Modèle d'impression : Fiche standard
 * Particularité : cette fiche est identique à la fiche "Renseignement d'urbanisme" sauf qu'elle n'affiche pas le nom des propriétaires et n'est accessible uniquement pour les profils non DGI à partir des applicatifs GEO.

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
||||x|||xapps_geo_vmr_adresse|Adresse|x||x|||||0 à 2000|Symbole réduit à 8 et 1% opacité et contour 0% (pour ne pas le voir sur la carte)|Interactivité avec le champ infobulle `{adresse} || '<br>' || CASE WHEN {diag_adr} <> 'Adresse conforme' THEN {diag_adr} ELSE '' END`|
|Servitudes d'utilités publique||x||x||||||||||||||
|Servitudes d'utilités publique|A4-Cours d'eau non domaniaux|x||x||geo_sup_a4_generateur_sup_l|Générateur||x|x||||||Ligne bleue||
|Servitudes d'utilités publique|A4-Cours d'eau non domaniaux|x||x||geo_sup_a4_assiette_sup_s|Assiette||x|x||||||Contour vert pointillé||
|Servitudes d'utilités publique|AC1-Monuments historiques|x||x||geo_sup_ac1_generateur_sup_s_060|Générateur (MH)||x|x||||||Contour noir épais et fond orangé plein|Interactivité sur le champ info_bulle `CASE WHEN {nomgen} IS NOT NULL THEN 'Nom du générateur (monuments historiques)' || chr(10) || replace(replace({nomgen}, 'AC1_', ''), '_gen', '') END`|
|Servitudes d'utilités publique|AC1-Monuments historiques|x||x||geo_sup_ac1_assiette_sup_s_060|Assiette (MH)||x|x||||||Contour orangé et hachure en ligne oblique orange fine en fond|Interactivité sur le champ info_bulle `CASE WHEN {nomass} IS NOT NULL THEN 'Nom de l''assiette (monuments historiques)' || chr(10) || replace(replace({nomass}, 'AC1_', ''), '_ass', '') || chr(10) ||
'Type : ' || {typeass} END`|
|Servitudes d'utilités publique|AC1-Monuments historiques|x||x||geo_vmr_sup_ac1_parcelle|Parcelles impactées par un MH||x|||||||Pas de contour et fond orangé à 50% d'opacité||
|Servitudes d'utilités publique|AC2-Sites inscrits et classés|x||x||geo_sup_ac2_assiette_sup_s|Assiette (Sites inscrits et classés)||x|x||||||Cadrillage rouge|Interactivité sur le champ info_bulle `CASE WHEN {nomass} IS NOT NULL THEN
'Nom de l''assiette (sites inscrits et classés)' || chr(10) || replace(replace({nomass}, 'AC2_', ''), '_ass', '') || chr(10) ||
'Type : ' || {typeass} END`|
|Servitudes d'utilités publique|AC4-ZPPAUP|x||||geo_sup_ac4_zppaup_protect|Info Bulle||x|x|||||0 à 13 000è|Fond blanc opacaité 1%|Interactivité sur le champ info_bulle `ZPPAUP (protection des bâtiments) Mesure : {protec} Objet : {typeprotec}`|
|Servitudes d'utilités publique|AC4-ZPPAUP|x||||ZPPAUP (flux geoserver)|ZPPAUP||x|x||||||||
|Servitudes d'utilités publique|AS1-Périmètres captages|x||x||geo_sup_as1_generateur_sup_p_060|Point de captage||x|x||||||Point bleu|Interactivité sur le champ info_bulle `Nom du générateur (AS1-Point de captage) : {ins_nom}` |
|Servitudes d'utilités publique|AS1-Périmètres captages|x||x||geo_sup_as1_assiette_pepi_sup_s_060|Périmètre immédiat (captage)||x|x||||||Pas de fond, contour bleu|Interactivité sur le champ info_bulle `CASE WHEN {nomass} IS NOT NULL THEN
'Nom de l'assiette (AS1-Périmètre de protection immédiat du captage)' || chr(10) ||
replace(replace({nomass}, 'AS1_', ''), '_ass', '') END`|
|Servitudes d'utilités publique|AS1-Périmètres captages|x||x||geo_sup_as1_assiette_pepr_sup_s_060|Périmètre rapproché (captage)||x|x||||||Hachure bleue fine en fond, contour bleu|Interactivité sur le champ info_bulle `Nom de l'assiette (AS1-Périmètre de protection rapproché du captage) {nom_pp_aep}`|
|Servitudes d'utilités publique|AS1-Périmètres captages|x||x||geo_sup_as1_assiette_pepr_sup_s_060|Périmètre éloigné (captage)||x|x||||||Hachure bleue épaisse en fond, contour bleu|Interactivité sur le champ info_bulle `Nom de l'assiette (AS1-Périmètre de protection éloigné du captage) {nom_pp_aep}`|
|Servitudes d'utilités publique|EL3-Alignement|x||x||geo_sup_el3_assiette_sup_s|Assiette||x|x||||typeass||Ligne noire épais pour le halage et pointillé noir pour le marche pied||
|Servitudes d'utilités publique|EL7-Alignement|x||x||geo_sup_el7_assiette_sup_l_060|Assiette||x|x||||||Ligne pointillée noire épais||
|Servitudes d'utilités publique|I4 - Lignes électriques (RTE uniquement pour le moment)|x||x||geo_sup_i4_generateur_sup_l_060|Générateur (ligne)||x|x||||||Ligne pointillée violette épaisse|Interactivité sur le champ info_bulle `'Opérateur : ' || {srcgeogen} || chr(10) || 'Type de ligne : ' || {l_type} || chr(10) || CASE WHEN {l_tension} = 0 THEN 'Tension = hors tension' ELSE 'Tension : ' || {l_tension} || ' kV' END`|
|Servitudes d'utilités publique|I4 - Lignes électriques (RTE uniquement pour le moment))|x||x||geo_sup_i4_assiette_sup_s_060|Assiette (RTE - Distance Limite d’Investigation)||x|x||||||Fond hachuré fin violet et contour épais violet||
|Servitudes d'utilités publique|INT1 - Cimetières|x||x||geo_sup_int1_generateur_sup_s|Générateur (cimetières)||x|x||||||Quadrillage fin noir||
|Servitudes d'utilités publique|INT1 - Cimetières|x||x||geo_sup_int1_assiette_sup_s|Assiette (cimetières)||x|x||||||Fond  hachuré fin noir avec contour noir épais||
|Servitudes d'utilités publique|PM1-PPR naturels ou miniers|x||x||geo_sup_ppri_cote_compiegne|Cote PPRi Compiègne-Pt Ste Maxence||x|x||||||Trait noir épais|Champ calculé etiquette_code `round({ngf}::decimal,2) || 'm(NGF)'`|
|Servitudes d'utilités publique|PM1-PPR naturels ou miniers|x||x||geo_sup_pm1_generateur_sup_s_060|Zone PPRi||x|x||||l_zone||Couleur par type de zone|Interactivité sur info_bulle `PPR inondation (type de zone) : {l_zone}`|
|Servitudes d'utilités publique|PM3-PPR technologiques|x||x||geo_sup_pm3_assiette_sup_s_060|Assiette (PPRT)||x|x||||||Contour épais orangé et quadrillage orangé croisé oblique|Interactivité sur info_bulle `CASE WHEN {nomass} IS NOT NULL THEN
'Nom de l''assiette (PPR technologique)' || chr(10) || replace(replace({nomass}, 'PM3_', ''), '_ass', '') || chr(10) || 'Type : ' || {typeass} END`|
|Servitudes d'utilités publique|PT1-Perturbations électromagnétiques pour un centre radioélectrique|x||x||geo_sup_pt1_assiette_sup_s|Nature de la protection||x|x||||typeass (zone de garde (coutour épais bleu-violet et fond hachuré fin bleu violet oblique / ) et zone de protection (coutour épais bleu-violet et fond hachuré fin bleu violet oblique \ )|||Interactivité sur info_bulle `CASE WHEN {nomass} IS NOT NULL THEN 'Nom de l''assiette' || chr(10) || '(Servitude de protection des centres de réception radioélectrique' || chr(10) || 'contre les perturbations électromagnétiques)' || chr(10) || replace(replace({nomass}, 'PT1_', ''), '_ass', '') || chr(10) || 'Type : ' || {typeass} END`|
|Servitudes d'utilités publique|PT2-Obstacles pour un centre radioélectrique||x||x||geo_sup_pt2_assiette_sup_s|Zone primaire de dégagement|x|x||||||Coutour épais bleu-violet et fond hachuré fin bleu violet oblique /|Interactivité sur info_bulle `CASE WHEN {nomass} IS NOT NULL THEN 'Nom de l''assiette' || chr(10) || '(Servitudes de protection des centres radioélectriques' || chr(10) || 'd''émission et de récéption contre les obstacles)' || chr(10) || replace(replace({nomass}, 'PT2_', ''), '_ass', '') || chr(10) || 'Type : ' || {typeass} END`|
|Servitudes d'utilités publique|PT2LH-Obstacles pour une liaison hertzienne||x||x||geo_sup_pt2lh_assiette_sup_s|Zone spéciale de dégagement|x|x||||||Coutour épais bleu-violet et fond hachuré fin bleu violet oblique /|Interactivité sur info_bulle `CASE WHEN {nomass} IS NOT NULL THEN 'Nom de l''assiette' || chr(10) || '(Servitudes de protection contre ' || chr(10) || 'les obstacles pour une liaison hertzienne) ' || chr(10) || replace(replace({nomass}, 'PT2LH_', ''), '_ass', '') || chr(10) || 'Type : ' || {typeass} END`|
|Servitudes d'utilités publique|T1-Chemin de fer|x||x||geo_sup_t1_assiette_sup_s|Emprise de voie ferrée (SNCF-RFF)||x|x||||||Coutour épais noir et fond haburé fin noir oblique /|Interactivité sur info_bulle `CASE WHEN {nomass} IS NOT NULL THEN 'Nom de l''assiette' || chr(10) || '(Servitude de visibilité sur les voies publiques.' || chr(10) || 'Zones de servitudes relatives aux chemins de fer)' || chr(10) || replace(replace({nomass}, 'T1_', ''), '_ass', '') || chr(10) || 'Type : ' || {typeass} END`|
|Servitudes d'utilités publique|T4-T5-Servitudes aéronautiques|x||x||geo_sup_t5_assiette_sup_s|Zone de dégagement ou de balisage||x|x||||||Coutour épais noir|Interactivité sur info_bulle `CASE WHEN {nomass} IS NOT NULL THEN 'Nom de l''assiette' || chr(10) || 'Servitudes aéronautique de balisage et de dégagement.' || chr(10) ||  replace(replace({nomass}, 'T5_', ''), '_ass', '') || chr(10) || 'Type : ' || {typeass} END`|
|Autres informations jugées utiles||x||x||||||||||||||
|Autres informations jugées utiles|Atlas des zones inondables|x||x||geo_risq_azi_ngf_l|Cote||x|x||||||Trait épais noir|Etiquette sur etiquette_cote `round({ngf}::decimal,2) || 'm(NGF)'`|
|Autres informations jugées utiles|Atlas des zones inondables|x||x||geo_risq_azi_crue9330|Zonage||x|x||||||Fond bleu transparent 50% et contour même couleur pas transparent|
|Autres informations jugées utiles|Natura 2000|x||x||geo_env_n2000_zps_m2010|périmètre ZPS (Natura 2000)||x|x||||||Contour fin violet et hachuré oblique violet /|
|Autres informations jugées utiles|Natura 2000|x||x||geo_env_n2000_sic_m2010|périmètre SIC  (Natura 2000)||x|x||||||Contour fin orangé et hachuré oblique orangé /|
|Autres informations jugées utiles|Zone humide (SMOA)|x||x||geo_smoa_inv_zh|Zone humide par classement||x|x||||classement_carte `CASE WHEN {classement} = 'H' THEN {classement} WHEN {classement} = 'PP' THEN {classement} WHEN ({classement} = 'NZH' or {classement} = 'P') THEN 'P' END`|| H = Zone humide avérée (fond vert 60% sans contour), P = Potentiellement humide - nécessite analyse sol (sans contour hachure / bleu), PP = Potentiellement humide - nécessite analyse végétation et sol (sans contour fond bleu clair 60%)||
|Autres informations jugées utiles|Zone humide (SAGEBA)|x||x||geo_env_sageba_zhv4|Zone humide identifiée||x|x||||||Fond vert sans contour 60%||
|Autres informations jugées utiles|ZICO (Zones Importantes pour la Conservation des Oiseaux)|x||x||geo_env_zico|Zone humide identifiée||x|x||||||Contour violet épais et quadrillage oblique violet||
|Autres informations jugées utiles|ZNIEFF (Zones Naturelles d'Intêret Ecologique, Faunistique et Floristique)|x||x||geo_env_znieff1|ZNIEFF Type 1||x|x||||||Coutour épais marron et hachure oblique / fine marron||
|Autres informations jugées utiles|ZNIEFF (Zones Naturelles d'Intêret Ecologique, Faunistique et Floristique)|x||x||geo_env_znieff2|ZNIEFF Type 2||x|x||||||Coutour épais vert foncé et hachure oblique / fine vert foncé||
|Autres informations jugées utiles|ZDH (Zone à Dominante Humide)|x||x||geo_env_zdh|Périmètre ZDH||x|x||||||Coutour bleu clair foncé et hachuré -- forme de vague bleu clair||
|Autres informations jugées utiles|APB (Arrêté de Protection de Biotope)|x||x||geo_env_apb|Périmètre APB||x|x||||||Coutour rouge épais et fond jaune ||
|Autres informations jugées utiles|Zone sensible Grande Faune|x||x||geo_env_inventairezonesensible|Périmètre Zone Sensible Grande Faune||x|x||||||Pas de contour font kaki 50% ||
|Autres informations jugées utiles|ENS (Espace Naturel Sensible)|x||x||geo_env_ens|Périmètre ENS||x|x||||||Contour vert moyen et hachuré -- forme de vague vert moyen||
|Autres informations jugées utiles|Aléa de retrait-gonflement des argiles|x||x||geo_risq_alea_retraitgonflement_argiles|Zone d'aléa||x|x||||alea||Faible (violet foncé 40%), Moyen (violet foncé 60%),Fort (violet foncé 80%)||
|Autres informations jugées utiles|Inventaire du patrimoine vernaculaire|x||x||geo_inv_patrimoine_lin|Inventaire du patrimoine vernaculaire||x|x|||||0 à 5001è|Trait marron épais 3||
|Autres informations jugées utiles|Zonage d'assainissement|x||x||geo_eu_zonage|Zonage d'assainissement||x|x||||zone||Collectif (trait épais violet et fond violet 50%), Collectif futur (trait violet sans fond), Non collectif (trait vert clair et fond vert clair 50%)||
|Altimétrie|MNT allégé issu du LIDAR|x||x||Flux (MNT allégé issu du LIDAR)|Zonage d'assainissement||x|x||||||||
|Crues||x||x||||||||||||||
|Crues|Aléa de la crue trentennale|x||x||Flux (Crue trentennale - cote de référence)|Crue trentennale - cote de référence||x|x||||||||
|Crues|Aléa de la crue trentennale|x||x||Flux (Crue trentennale - hauteur d'eau)|Crue trentennale - hauteur d'eau||x|x|||||||Onglet avancé activé pour définir un icône dans la thématique et afficher la légende du flux au clic sur cette incône|
|Crues|Aléa de la crue centennale|x|x|x||Flux (Crue centennale - cote de référence)|Crue centennale - cote de référence||x|x||||||||
|Crues|Aléa de la crue centennale|x|x|x||Flux (Crue centennale - hauteur d'eau)|Crue centennale - hauteur d'eau||x|x|||||||Onglet avancé activé pour définir un icône dans la thématique et afficher la légende du flux au clic sur cette incône|
|Crues|Aléa de la crue millénale|x||x||Flux (Crue millénale - cote de référence)|Crue millénale - cote de référence||x|x||||||||
|Crues|Aléa de la crue millénale|x||x||Flux (Crue millénale - hauteur d'eau)|Crue millénale - hauteur d'eau||x|x|||||||Onglet avancé activé pour définir un icône dans la thématique et afficher la légende du flux au clic sur cette incône|
|Urbanisme||x|x|x||||||||||||||
|Urbanisme|Prescriptions PLU (info bulle)|x|x|||geo_p_prescription_pct|Prescription ponctuelle||x|x|||||0 à 4000è|Aucune|Interactivité sur le champ info_bulle `CASE WHEN {libelle} is not null THEN 'Prescription : ' || {libelle} WHEN {l_nature} is not null THEN 'Nature : ' || {l_nature} END ` |
|Urbanisme|Prescriptions PLU (info bulle)|x|x|||geo_p_prescription_lin|Prescription linéaire||x|x|||||0 à 4000è|Aucune|Interactivité sur le champ info_bulle `CASE WHEN {libelle} is not null THEN 'Prescription : ' || {libelle}
WHEN {l_nature} is not null THEN 'Nature : ' || {l_nature} WHEN {l_valrecul} is not null THEN 'Valeur du recul : ' || {l_valrecul}END` |
|Urbanisme|Prescriptions PLU (info bulle)|x|x|||geo_p_prescription_surf|Prescription surfacique||x|x|||||0 à 4000è|Aucune|Interactivité sur le champ info_bulle `CASE WHEN {libelle} is not null THEN 'Prescription : ' || {libelle}
WHEN {l_nature} is not null THEN 'Nature : ' || {l_nature} WHEN {l_valrecul} is not null THEN 'Valeur du recul : ' || {l_valrecul}END` |
|Urbanisme|Informations jugées utiles PLU (info bulle)|x|x|||geo_p_info_pct|Information ponctuelle||x|x|||||0 à 4000è|Aucune|Interactivité sur le champ info_bulle `CASE WHEN {libelle} is not null THEN 'Information jugée utile : ' || {libelle} END` |
|Urbanisme|Informations jugées utiles PLU (info bulle)|x|x|||geo_p_info_pct|Information ponctuelle||x|x|||||0 à 4000è|Aucune|Interactivité sur le champ info_bulle `CASE WHEN {libelle} is not null THEN 'Information jugée utile : ' || {libelle} END` |
|Urbanisme|Informations jugées utiles PLU (info bulle)|x|x|||geo_p_info_lin|Information linéaire||x|x|||||0 à 4000è|Aucune|Interactivité sur le champ info_bulle `CASE WHEN {libelle} is not null THEN 'Information jugée utile : ' || {libelle} WHEN {l_valrecul} is not null THEN 'Valeur de recul : ' || {l_valrecul} END` |
|Urbanisme|Informations jugées utiles PLU (info bulle)|x|x|||geo_p_info_surf|Information surfacique||x|x|||||0 à 4000è|Aucune|Interactivité sur le champ info_bulle `CASE WHEN {libelle} is not null THEN 'Information jugée utile : ' || {libelle} WHEN {l_valrecul} is not null THEN 'Valeur du recul : ' || {l_valrecul} END` |
|Urbanisme||||||geo_p_zone_pau|PAU (informatif)||x|x||||||Trait vert pomme épais et hachuré / fin vert pomme|Cette couche est visible uniquement pour certaines personnes du droit des sols (groupe PAU_CONSULT)|
|Urbanisme||||||Flux (Document d'urbanisme)|Document d'urbanisme||x|x||||||||
|PPRi (projet)||x||x||||||||||||||
|PPRi (projet)||||||geo_sup_pm1_ppri_projet_rq (PPRi zonage (projet) - remarque)|Annotation||x|x|x|x||type_rq|0 à 500000è|Symbole Goutte rouge pour remarque générale et verte pour remarque ponctuelle|Interactivité sur le champ info_bulle `'<i>Remarque</i>' || chr(10) || {type_rq} || chr(10) || '<i>annotée par</i>' || chr(10) || {nom} || chr(10) || 'le ' || to_char({date_sai},'DD-MM-YYYY') || chr(10) || CASE WHEN {date_maj} IS NOT NULL THEN 'modifiée le ' || to_char({date_maj},'DD-MM-YYYY') ELSE '' END || chr(10) || '<br><i>Activez l''outil<img src="http://geo.compiegnois.fr/documents/cms/i_geo.png" width="20" height="25"> puis cliquez sur l''icône<br> pour accéder aux informations détaillées</i>''<br><br><i>Accédez à la fiche d''aide sur la gestion <br> des annotations en faisant un clic gauche.</i>'` |3
|PPRi (projet)||||||Flux (Crue centennale - cote de référence)|Crue centennale - cote de référence||x|x||||||||
|PPRi (projet)||||||Flux (PPRi (projet) - zone de danger)|PPRi (projet) - zone de danger||x|x|||||||Onglet avancé activé pour définir un icône dans la thématique et afficher la légende du flux au clic sur cette incône|
|PPRi (projet)||||||Flux (PPRi (projet) - CSNE-MAGEO)|PPRi (projet) - CSNE-MAGEO||x|x|||||||Onglet avancé activé pour définir un icône dans la thématique et afficher la légende du flux au clic sur cette incône|
|PPRi (projet)||||||Flux (SUP PM1 - PPRi (projet) - zonage)|SUP PM1 - PPRi (projet) - zonage||x|x|||||||Onglet avancé activé pour définir un icône dans la thématique et afficher la légende du flux au clic sur cette incône|
|Foncier||x||x||||||||||||||
|Foncier||||||geo_v_fon_proprio_pu_pays|Propriété institutionnelle||x|x|x|||foncier_public_type||Une couleur par type||
|Cadastre||||x||||||||||||||
|Cadastre||||||r_bg_edigeo.PARCELLE (Parcelle V3)|Parcelle V3|||x|||x||0 à 8000è|Fond blanc 1% sans contour||

# L'application

* Généralités :

|Gabarit|Thème|Modules spé|Impression|Résultats|
|:---|:---|:---|:---|:---|
|Pro|Thème GeoCompiegnois 1.0.7|Bandeaux HTML,StreetView,GeoCadastre,Google Analytics,Page de connexion perso, coordonnées au survol|8 Modèles standards A4 et A3||

* Particularité de certains modules :
  * Module introduction : aucun.
  * Module javacript : aucun
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


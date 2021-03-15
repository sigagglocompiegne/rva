-- #################################################################### SUIVI CODE SQL ####################################################################

-- 2016/05/20 : FV / initialisation du code
-- 2016/05/25 : FV / confirmation réunion SIG des orientations suivantes : urbanisation base et sépération troncon/noeud avec les attributs métiers séparés de gestion de voirie
-- 2016/05/26 : FV / table objet troncon, noeud, voie, voirie_gest et voirie_circu
-- 2016/05/30 : FV / domaine de valeur # cas des non concernés traités (définit avec valeur "ZZ")
-- 2016/05/30 : FV / vue troncon-gest-circu est OK, triggerS sur vue "éditable" ok, prb valeur par défaut non géré côté qgis sur la vue "éditable"
-- 2016/06/14 : FV / trigger recup id_noeud pour noeud début et fin de troncon OK sur modif geom troncon
-- 2016/06/14 : FV / trigger recup id_noeud pour noeud début et fin de troncon OK en lien avec modif geom noeud
-- 2016/06/20 : GB / reprise des triggers existant dans un trigger permettant de produire/gérer les noeuds en auto lors de la saisie des troncons
-- 2016/07/07 : FV / choix de modélisation, e:troncon a:nomme [0,1], e:voie a:nomme [1,n] ==> id_voie placé sur les tables objets de référence noeud et troncon ==> un objet ne peut être nommé (voie) que 1 fois
-- 2016/07/11 : FV / résolution accès concurrentiel à la séquence id_tronc de geo_objet_troncon dans les triggers impliquant les tables tierces (an_troncon, an_voirie_circu, an_voirie_gest).
--                   il faut faire référence au currval qui impose en préalable dans la session, la réalisation d'un nextval de séquence. Ceci est possible par le fait de passer le trigger impliquant le nextval en préable des autres triggers, ceci est lié à l'ordre alphabétique des triggers associés à cette vue.
-- 2016/07/13 : FV / gestion insee_g/d non calculé si l'utilisateur fait une saisie manuelle préalable (ex : pour traiter les prb de raccord en limite de communes)
-- 2016/07/13 : FV / prb trigger (temps de requete) pour suppression des noeuds apres modif ou sup de troncon du fait de l'union des troncons. Voir pour passer sur le principe de sup du noeud lorsque son id n'est plus référencé sur les troncons 
-- 2016/07/19 : FV / domaine de valeur type_tronc
-- 2016/07/20 : FV / compte tenu du choix de modélisation un troncon nommé 1 fois par commune et du cas où le troncon fait office de délimitation communale avec 2 noms de voie différents, alors on prévoit 2 champs de nommage guache/droite
-- 2016/07/20 : FV / ajout attribut projet pour le troncon
-- 2016/07/26 : GB / trigger sup_noeud réécrit sur la base de la présence ou non de l'id_noeud indexé aux troncons
-- 2016/07/26 : FV / ajout attribut fictif pour le troncon (permet d'identifier les troncons ne rentrant pas dans des calculs de linéaires de voie comme les parking ou les troncons hors du pays compiégnois mais utiles dans le rendu graphique pour le fond perdu)
-- 2016/07/29 : FV / adaptations mineures du domaine de valeur src_geom pour usage à l'ensemble des bases de données
-- 2016/07/29 : FV / prise en charge pour la vue unifiant les tables "troncons" de la gestion des valeurs "null" > "non renseigné" dans les triggers
-- 2016/08/24 : GB / ajout de la valeur Non concerné ZZ àa la table de valeur lt_sens_circu
-- 2016/09/13 : FV / ajout trigger date_maj pour la classe de référence an_voie
-- 2017/02/27 : FV / longueur de la chaine de caractères de l'attribut observations (observ) augmenté de 80 à 254 caractères pour les tables an_voirie_gest et an_voirie_circu
-- 2017/07/25 : FV / création d'une vue troncon-voirie "décodée" pour l'exploitation applicative
-- 2017/11/09 : GB / encodage des type de voie dans an_voie avec la table de valeur lt_type_voie
-- 2018/03/18 : GB / Intégration du code des vues de contrôles voie-rivoli et ajout d'un numéro automatique dans la vue an_v_voie_adr_rivoli_null pour ouverture dans QGIS
-- 2018/03/19 : GB / Intégration des modifications suite au groupe de travail RVA du 13 mars 2018
--		- dans la table an_voirie_circu : ajout de 3 attributs (c_circu pour les contraintes de circulation issue d'une liste de valeur, c_observ pour les commentaires sur les valeurs que prennent les restrictions, date_ouv pour intégrer une année ou une période d'ouverture à la circulation
--		- dans la table an_voirie_gest : ajout de 1 attribut (date_rem pour l'année ou la période de dernière de remise en état de la chaussée)
--		- dans la table an_voie: ajout de 1 attribut (date_lib intégrant la date ou la période de l'arrêté nommant la voie)
--		- création de la table an_troncon_h pour le suivi du libellé de voie : 5 attributs créés qui seront automatiquement rempli à la saisie (id,identifiant unique de l'historisation, id_tronc, id_voie, date_sai,date_maj)
--              - création d'une séquence pour gérer l'id de l'historisation
--		- affectation du trigger de mise à jour de la date date_maj
--		- intégration d'un trigger supplémentaire à la saisie de la vue des tronçons pour implémentation de la base historique lorsque que la case historique est cochée dans la fiche QGIS
--		- modification des vues et triggers de mise à jour intégrant ces différents éléments
-- 2018/03/20 : GB / Intégration d'une partie VUES APPLICATIVES et intégration du codes SQL
--		- création de bloc pour séparer les vues de gestion, applicatives et open data
-- 2018/04/12 : GB / Adaptation des requêtes applicatives historiques dans le formatage des résultats pour l'utilisateur dans GEO
-- 2018/08/07 : GB / Insertion des nouveaux rôles de connexion et leurs privilèges
-- 2021/02/16 : GB / Insertion fonction trigger de vérification du saisie code RIVOLI sur classe an_voie
-- 2021/03/15 : GB / Modification des droits


-- ToDo

-- tablé métier voirie sur acte de dénomination voie
-- calcul de pente 
-- table suivi modif
-- voie : trigger pour changement CASE + CONCAT 
-- noeud (pour type noeud, plutot considérer dans les schémas métier. ex : pour noeud panneau d'agglomération, plutot mettre une table alpha dans le schéma voirie avec id externe du noeud considéré)
-- #trigger : harmoniser la dénomination ft/t
-- #reste versionnement à définir et voir question de l'utilité des champs date_sai et date_maj
 

-- #################################################################### SCHEMA  ####################################################################

-- Schema: r_objet

-- DROP SCHEMA r_objet;

CREATE SCHEMA r_objet
  AUTHORIZATION create_sig;

GRANT ALL ON SCHEMA r_objet TO create_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_objet
GRANT ALL ON TABLES TO sig_create;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_objet
GRANT SELECT ON TABLES TO sig_read;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_objet
GRANT ALL ON TABLES TO create_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_objet
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO sig_edit;

COMMENT ON SCHEMA r_objet
  IS 'Schéma contenant les objets géographiques virtuels métiers (zonages, lots, entités administratives, ...). Les données métiers (alphanumériques) sont stockées dans le schéma correspondant, et le lien s''effectue via la référence géographique. Une donnée géographique spécifique à un seul métier, reste dans le schéma du métier.';


-- Schema: m_voirie

-- DROP SCHEMA m_voirie;

CREATE SCHEMA m_voirie
  AUTHORIZATION create_sig;
  

GRANT ALL ON SCHEMA m_voirie TO create_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_voirie
GRANT ALL ON TABLES TO sig_create;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_voirie
GRANT SELECT ON TABLES TO sig_read;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_voirie
GRANT ALL ON TABLES TO create_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA m_voirie
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO sig_edit;

COMMENT ON SCHEMA m_voirie
  IS 'Données géographiques métiers sur la voirie';

-- Schema: r_voie

-- DROP SCHEMA r_voie;

CREATE SCHEMA r_voie
AUTHORIZATION create_sig;

GRANT ALL ON SCHEMA r_voie TO create_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_voie
GRANT ALL ON TABLES TO sig_create;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_voie
GRANT SELECT ON TABLES TO sig_read;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_voie
GRANT ALL ON TABLES TO create_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_voie
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO sig_edit;

COMMENT ON SCHEMA r_voie
  IS 'Référentiel local des voies';
  
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      REF OBJET                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### OBJET troncon #################################################################


-- Table: r_objet.geo_objet_troncon

-- DROP TABLE r_objet.geo_objet_troncon;

CREATE TABLE r_objet.geo_objet_troncon
(
  id_tronc bigint NOT NULL, -- Identifiant unique de l'objet tronçon
  id_voie_g bigint, -- Identifiant unique de l'objet voie à gauche du tronçon
  id_voie_d bigint, -- Identifiant unique de l'objet voie à droite du tronçon
  insee_g character varying(5) NOT NULL, -- Code INSEE à gauche du tronçon
  insee_d character varying(5) NOT NULL, -- Code INSEE à droite du tronçon
  noeud_d bigint NOT NULL, -- Identifiant du noeud de début du tronçon
  noeud_f bigint NOT NULL, -- Identifiant du noeud de fin de tronçon
  pente numeric(5,2), -- Pente exprimée en % et calculée à partir des altimétries des extrémités du tronçon
  observ character varying(254), -- Observations
  src_geom character varying(5) NOT NULL DEFAULT '00' ::bpchar, -- Référentiel de saisie
  src_date character varying(4) NOT NULL DEFAULT '0000' ::bpchar, -- Année du millésime du référentiel de saisie
  scr_tronc character varying(100), -- Source des informations au tronçon
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Horodatage de l'intégration en base de l'objet   
  date_maj timestamp without time zone, -- Horodatage de la mise à jour en base de l'objet
  geom geometry(LineString,2154), -- Géométrie linéaire de l'objet

  CONSTRAINT geo_objet_troncon_pkey PRIMARY KEY (id_tronc)

)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_objet.geo_objet_troncon
    OWNER to create_sig;

GRANT ALL ON TABLE r_objet.geo_objet_troncon TO sig_create;
GRANT SELECT ON TABLE r_objet.geo_objet_troncon TO sig_read;
GRANT ALL ON TABLE r_objet.geo_objet_troncon TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_objet.geo_objet_troncon TO sig_edit


COMMENT ON TABLE r_objet.geo_objet_troncon
  IS 'Classe décrivant un troncon du filaire de voie à circulation terrestre';
COMMENT ON COLUMN r_objet.geo_objet_troncon.id_tronc IS 'Identifiant unique de l''objet tronçon';
COMMENT ON COLUMN r_objet.geo_objet_troncon.id_voie_g IS 'Identifiant unique de l''objet voie à gauche du tronçon';
COMMENT ON COLUMN r_objet.geo_objet_troncon.id_voie_d IS 'Identifiant unique de l''objet voie à droite du tronçon';
COMMENT ON COLUMN r_objet.geo_objet_troncon.insee_g IS 'Code INSEE à gauche du tronçon';
COMMENT ON COLUMN r_objet.geo_objet_troncon.insee_d IS 'Code INSEE à droite du tronçon';
COMMENT ON COLUMN r_objet.geo_objet_troncon.noeud_d IS 'Identifiant du noeud de début du tronçon';
COMMENT ON COLUMN r_objet.geo_objet_troncon.noeud_f IS 'Identifiant du noeud de fin de tronçon';
COMMENT ON COLUMN r_objet.geo_objet_troncon.pente IS 'Pente exprimée en % et calculée à partir des altimétries des extrémités du tronçon';
COMMENT ON COLUMN r_objet.geo_objet_troncon.observ IS 'Observations';
COMMENT ON COLUMN r_objet.geo_objet_troncon.src_geom IS 'Référentiel de saisie';
COMMENT ON COLUMN r_objet.geo_objet_troncon.src_date IS 'Année du millésime du référentiel de saisie';
COMMENT ON COLUMN r_objet.geo_objet_troncon.src_tronc IS 'Source des informations au tronçon';
COMMENT ON COLUMN r_objet.geo_objet_troncon.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN r_objet.geo_objet_troncon.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN r_objet.geo_objet_troncon.geom IS 'Géomètrie linéaire de l''objet';

-- Index: r_objet.geo_objet_troncon_geom

-- DROP INDEX r_objet.geo_objet_troncon_geom;

CREATE INDEX sidx_geo_objet_troncon_geom
  ON r_objet.geo_objet_troncon
  USING gist
  (geom);

  
-- Sequence: r_objet.geo_objet_troncon_id_seq

-- DROP SEQUENCE r_objet.geo_objet_troncon_id_seq;

CREATE SEQUENCE r_objet.geo_objet_troncon_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 0
  CACHE 1;
ALTER SEQUENCE r_objet.geo_objet_troncon_id_seq
    OWNER TO create_sig;

GRANT ALL ON SEQUENCE r_objet.geo_objet_troncon_id_seq TO PUBLIC;
GRANT ALL ON SEQUENCE r_objet.geo_objet_troncon_id_seq TO create_sig;


ALTER TABLE r_objet.geo_objet_troncon ALTER COLUMN id_tronc SET DEFAULT nextval('r_objet.geo_objet_troncon_id_seq'::regclass);



-- #################################################################### OBJET noeud ###################################################################


-- Table: r_objet.geo_objet_noeud

-- DROP TABLE r_objet.geo_objet_noeud;

CREATE TABLE r_objet.geo_objet_noeud
(
  id_noeud bigint NOT NULL, -- Identifiant unique de l'objet noeud
  id_voie bigint, -- Identifiant unique de l'objet voie
  x_l93 numeric(8,2), -- Coordonnée X en mètre
  y_l93 numeric(9,2), -- Coordonnée Y en mètre
  z_ngf numeric(5,2), -- Altimétrie ngf du noeud en mètre
  observ character varying(254), -- Observations
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Horodatage de l'intégration en base de l'objet   
  date_maj timestamp without time zone, -- Horodatage de la mise à jour en base de l'objet
  geom geometry(Point,2154), -- Géométrie point de l'objet

  CONSTRAINT geo_objet_noeud_pkey PRIMARY KEY (id_noeud)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_objet.geo_objet_noeud
    OWNER to create_sig;

GRANT ALL ON TABLE r_objet.geo_objet_noeud TO sig_create;
GRANT SELECT ON TABLE r_objet.geo_objet_noeud TO sig_read;
GRANT ALL ON TABLE r_objet.geo_objet_noeud TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_objet.geo_objet_noeud TO sig_edit;

COMMENT ON TABLE r_objet.geo_objet_noeud
  IS 'Classe décrivant un noeud du filaire de voie à circulation terrestre';
COMMENT ON COLUMN r_objet.geo_objet_noeud.id_noeud IS 'Identifiant unique de l''objet noeud';
COMMENT ON COLUMN r_objet.geo_objet_noeud.id_voie IS 'Identifiant unique de l''objet voie';
COMMENT ON COLUMN r_objet.geo_objet_noeud.x_l93 IS 'Coordonnée X en mètre';
COMMENT ON COLUMN r_objet.geo_objet_noeud.y_l93 IS 'Coordonnée Y en mètre';
COMMENT ON COLUMN r_objet.geo_objet_noeud.z_ngf IS 'Altimétrie ngf du noeud en mètre';
COMMENT ON COLUMN r_objet.geo_objet_noeud.observ IS 'Observations';
COMMENT ON COLUMN r_objet.geo_objet_noeud.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN r_objet.geo_objet_noeud.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN r_objet.geo_objet_noeud.geom IS 'Géomètrie ponctuelle de l''objet';

-- Index: r_objet.geo_objet_noeud_geom

-- DROP INDEX r_objet.geo_objet_noeud_geom;

CREATE INDEX sidx_geo_objet_noeud_geom
  ON r_objet.geo_objet_noeud
  USING gist
  (geom);

-- Sequence: r_objet.geo_objet_noeud_id_seq

-- DROP SEQUENCE r_objet.geo_objet_noeud_id_seq;

CREATE SEQUENCE r_objet.geo_objet_noeud_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 0
  CACHE 1;
ALTER SEQUENCE r_objet.geo_objet_noeud_id_seq
    OWNER TO create_sig;

GRANT ALL ON SEQUENCE r_objet.geo_objet_noeud_id_seq TO PUBLIC;
GRANT ALL ON SEQUENCE r_objet.geo_objet_noeud_id_seq TO create_sig;

ALTER TABLE r_objet.geo_objet_noeud ALTER COLUMN id_noeud SET DEFAULT nextval('r_objet.geo_objet_noeud_id_seq'::regclass);



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      REF VOIE                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### OBJET an_troncon ###################################################################

-- Table: r_voie.an_troncon

-- DROP TABLE r_voie.an_troncon;

CREATE TABLE r_voie.an_troncon
(
  id_tronc bigint NOT NULL, -- Identifiant unique de l'objet tronçon
  type_tronc character varying(2) NOT NULL DEFAULT '00'::bpchar, -- Type de troncon
  hierarchie character varying(1) NOT NULL DEFAULT '0'::bpchar, -- Niveau hierarchique du troncon dans la trame viaire
  franchiss character varying(2) NOT NULL DEFAULT 'ZZ'::bpchar, -- Indication d'un franchissement
  nb_voie integer, -- Nombre de voies sur le tronçon
  projet boolean DEFAULT 'f', -- Indication de l'état de projet du tronçon
  fictif boolean DEFAULT 'f', -- Indication de la prise en compte du tronçon dans des calculs
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Date de saisie dans la base de données
  date_maj timestamp without time zone, -- Date de la dernière mise à jour dans la base de données
    
  CONSTRAINT an_troncon_pkey PRIMARY KEY (id_tronc)
  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_voie.an_troncon
    OWNER to create_sig;

GRANT ALL ON TABLE r_voie.an_troncon TO sig_create;
GRANT SELECT ON TABLE r_voie.an_troncon TO sig_read;
GRANT ALL ON TABLE r_voie.an_troncon TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_voie.an_troncon TO sig_edit;

COMMENT ON TABLE r_voie.an_troncon
  IS 'Table alphanumérique des troncons';
COMMENT ON COLUMN r_voie.an_troncon.id_tronc IS 'Identifiant unique de l''objet tronçon';    
COMMENT ON COLUMN r_voie.an_troncon.type_tronc IS 'Type de troncon';
COMMENT ON COLUMN r_voie.an_troncon.hierarchie IS 'Niveau hierarchique du troncon dans la trame viaire';
COMMENT ON COLUMN r_voie.an_troncon.franchiss IS 'Indication d''un franchissement';
COMMENT ON COLUMN r_voie.an_troncon.nb_voie IS 'Nombre de voies sur le tronçon';  
COMMENT ON COLUMN r_voie.an_troncon.projet IS 'Indication de l''état de projet du tronçon';
COMMENT ON COLUMN r_voie.an_troncon.fictif IS 'Indication de la prise en compte du tronçon dans des calculs';  
COMMENT ON COLUMN r_voie.an_troncon.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN r_voie.an_troncon.date_maj IS 'Horodatage de la mise à jour en base de l''objet';


-- #################################################################### OBJET an_troncon_h ###################################################################


-- Sequence: r_voie.an_troncon_h_id_seq

-- DROP SEQUENCE r_voie.an_troncon_h_id_seq;

CREATE SEQUENCE r_voie.an_troncon_h_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

ALTER SEQUENCE r_voie.an_troncon_h_id_seq
    OWNER TO create_sig;

GRANT ALL ON SEQUENCE r_voie.an_troncon_h_id_seq TO PUBLIC;
GRANT ALL ON SEQUENCE r_voie.an_troncon_h_id_seq TO create_sig;


-- Table: r_voie.an_troncon_h

-- DROP TABLE r_voie.an_troncon_h;

CREATE TABLE r_voie.an_troncon_h
(
  id bigint NOT NULL DEFAULT nextval('r_voie.an_troncon_h_id_seq'::regclass), -- Identifiant unique de l'historisation
  id_tronc bigint NOT NULL, -- Identifiant de l'objet tronçon
  id_voie_g bigint, -- Identifiant de l'objet voie gauche
  id_voie_d bigint, -- Identifiant de l'objet voie droite
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Date de saisie dans la base de données
    
  CONSTRAINT an_troncon_h_id_pkey PRIMARY KEY (id)
  
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_voie.an_troncon_h
    OWNER to create_sig;

GRANT ALL ON TABLE r_voie.an_troncon_h TO sig_create;
GRANT SELECT ON TABLE r_voie.an_troncon_h TO sig_read;
GRANT ALL ON TABLE r_voie.an_troncon_h TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_voie.an_troncon_h TO sig_edit;

COMMENT ON TABLE r_voie.an_troncon_h
  IS 'Table historique alphanumérique des troncons pour le suivi des noms de voies';
COMMENT ON COLUMN r_voie.an_troncon_h.id IS 'Identifiant unique de l''historisation';    
COMMENT ON COLUMN r_voie.an_troncon_h.id_tronc IS 'Identifiant unique de l''objet tronçon';    
COMMENT ON COLUMN r_voie.an_troncon_h.id_voie_g IS 'Identifiant de l''objet voie gauche';
COMMENT ON COLUMN r_voie.an_troncon_h.id_voie_d IS 'Identifiant de l''objet voie droite';
COMMENT ON COLUMN r_voie.an_troncon_h.date_sai IS 'Date de saisie dans la base de données';





-- #################################################################### OBJET voie ###################################################################

-- Table: r_voie.an_voie

-- DROP TABLE r_voie.an_voie;

CREATE TABLE r_voie.an_voie
(
  id_voie bigint NOT NULL, -- Identifiant unique de l'objet voie
  type_voie character varying(2) DEFAULT '01'::character varying, -- Type de la voie (par défaut 01 = Rue)
  nom_voie character varying(80), -- Nom de la voie
  libvoie_c character varying(100), -- Libellé complet de la voie (minuscule et caractère accentué)
  libvoie_a character varying(100), -- Libellé abrégé de la voie (AFNOR)
  mot_dir character varying(30), -- Mot directeur de la voie
  insee character(5) NOT NULL, -- Code insee
  rivoli character(4), -- Code rivoli
  rivoli_cle character(1), -- Clé rivoli
-- #
  observ character varying(254), -- Observations
  src_voie character varying(100), -- Référence utilisée pour la voie
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Date de saisie dans la base de données
  date_maj timestamp without time zone, -- Date de la dernière mise à jour dans la base de données
  date_lib character(4), -- Année du libellé la voie (soit l'année entière est saisie soit une partie en remplaçant les 0 par des x)
  
  CONSTRAINT an_voie_pkey PRIMARY KEY (id_voie)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_voie.an_voie
    OWNER to create_sig;

GRANT ALL ON TABLE r_voie.an_voie TO sig_create;
GRANT SELECT ON TABLE r_voie.an_voie TO sig_read;
GRANT ALL ON TABLE r_voie.an_voie TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_voie.an_voie TO sig_edit;

COMMENT ON TABLE r_voie.an_voie
  IS 'Table alphanumérique des voies à circulation terrestre nommées';
COMMENT ON COLUMN r_voie.an_voie.id_voie IS 'Identifiant unique de l''objet voie';
COMMENT ON COLUMN r_voie.an_voie.type_voie IS 'Type de la voie (par défaut 01 = Rue)';
COMMENT ON COLUMN r_voie.an_voie.nom_voie IS 'Nom de la voie';
COMMENT ON COLUMN r_voie.an_voie.libvoie_c IS 'Libellé complet de la voie (minuscule et caractère accentué)';
COMMENT ON COLUMN r_voie.an_voie.libvoie_a IS 'Libellé abrégé de la voie (AFNOR)';
COMMENT ON COLUMN r_voie.an_voie.mot_dir IS 'Mot directeur de la voie';
COMMENT ON COLUMN r_voie.an_voie.insee IS 'Code INSEE de la commune';
COMMENT ON COLUMN r_voie.an_voie.rivoli IS 'Code rivoli';
COMMENT ON COLUMN r_voie.an_voie.rivoli_cle IS 'Clé rivoli';
-- #
COMMENT ON COLUMN r_voie.an_voie.observ IS 'Observations';
COMMENT ON COLUMN r_voie.an_voie.src_voie IS 'Référence utilisée pour le nom de la voie';
COMMENT ON COLUMN r_voie.an_voie.date_sai IS 'Date de saisie dans la base de données';
COMMENT ON COLUMN r_voie.an_voie.date_maj IS 'Date de la dernière mise à jour dans la base de données';
COMMENT ON COLUMN r_voie.an_voie.date_lib IS 'Année du libellé la voie (soit l''année entière est saisie soit une partie en remplaçant les 0 par des x)';

GRANT SELECT(id_voie) ON r_voie.an_voie TO public;
GRANT SELECT(id_voie) ON r_voie.an_voie TO groupe_sig WITH GRANT OPTION;


  
-- Sequence: r_voie.an_voie_id_seq

-- DROP SEQUENCE r_voie.an_voie_id_seq;

CREATE SEQUENCE r_voie.an_voie_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 0
  CACHE 1;
  
ALTER SEQUENCE r_voie.an_voie_id_seq
    OWNER TO create_sig;

GRANT ALL ON SEQUENCE r_voie.an_voie_id_seq TO PUBLIC;
GRANT ALL ON SEQUENCE r_voie.an_voie_id_seq TO create_sig;

ALTER TABLE r_voie.an_voie ALTER COLUMN id_voie SET DEFAULT nextval('r_voie.an_voie_id_seq'::regclass);



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                   METIER VOIRIE                                                              ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### An_voirie_gest  ###############################################

-- Table: m_voirie.an_voirie_gest

-- DROP TABLE m_voirie.an_voirie_gest;

CREATE TABLE m_voirie.an_voirie_gest
(
  id_tronc bigint NOT NULL, -- Identifiant unique de l'objet tronçon
  statut_jur character varying(2) DEFAULT '00'::bpchar, -- Statut juridique du tronçon de la voie
  num_statut character varying(10), -- Numéro de statut du tronçon de la voie
  gestion character varying(2) DEFAULT '00'::bpchar, -- Gestionnaire du tronçon de la voie
  doman character varying(2) DEFAULT '00'::bpchar, -- Domanialité du tronçon de la voie  
  proprio character varying(2) DEFAULT '00'::bpchar, -- Propriétaire du tronçon de la voie
  observ character varying(254), -- Observations
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Date de saisie dans la base de données
  date_maj timestamp without time zone, -- Date de la dernière mise à jour dans la base de données
  date_rem character(4), -- Date de la dernière remise en état de la chaussée (soit l'année entière est saisie soit une partie en remplaçant les 0 par des x)
  CONSTRAINT an_voirie_gest_pkey PRIMARY KEY (id_tronc)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_voirie.an_voirie_gest
    OWNER to create_sig;

GRANT ALL ON TABLE m_voirie.an_voirie_gest TO sig_create;
GRANT SELECT ON TABLE m_voirie.an_voirie_gest TO sig_read;
GRANT ALL ON TABLE m_voirie.an_voirie_gest TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.an_voirie_gest TO sig_edit;

COMMENT ON TABLE m_voirie.an_voirie_gest
  IS 'Table alphanumérique des éléments de gestion de la voirie';
COMMENT ON COLUMN m_voirie.an_voirie_gest.id_tronc IS 'Identifiant du tronçon';
COMMENT ON COLUMN m_voirie.an_voirie_gest.statut_jur IS 'Statut juridique du tronçon de la voie';
COMMENT ON COLUMN m_voirie.an_voirie_gest.num_statut IS 'Numéro de statut du tronçon de la voie';
COMMENT ON COLUMN m_voirie.an_voirie_gest.gestion IS 'Gestionnaire du tronçon de la voie';
COMMENT ON COLUMN m_voirie.an_voirie_gest.doman IS 'Domanialité du tronçon';
COMMENT ON COLUMN m_voirie.an_voirie_gest.proprio IS 'Propriétaire du tronçon';
COMMENT ON COLUMN m_voirie.an_voirie_gest.observ IS 'Observations';
COMMENT ON COLUMN m_voirie.an_voirie_gest.date_sai IS 'Date de saisie dans la base de données';
COMMENT ON COLUMN m_voirie.an_voirie_gest.date_maj IS 'Date de la dernière mise à jour dans la base de données';
COMMENT ON COLUMN m_voirie.an_voirie_gest.date_rem IS 'Date de la dernière remise en état de la chaussée (soit l''année entière est saisie soit une partie en remplaçant les 0 par des x)';




-- #################################################################### An_voirie_circu  ###############################################

-- Table: m_voirie.an_voirie_circu

-- DROP TABLE m_voirie.an_voirie_circu;

CREATE TABLE m_voirie.an_voirie_circu
(
  id_tronc bigint NOT NULL, -- Identifiant unique de l'objet tronçon
  type_circu character varying(2) DEFAULT '00'::bpchar, -- Type de circulation principale
  sens_circu character varying(2) DEFAULT '00'::bpchar, -- Indique si le sens de circulation du tronçon
  v_max character varying(3) DEFAULT '000'::bpchar, -- Vitesse maximale autorisée pour un véhicule léger
  observ character varying(80), -- Observations
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Date de saisie dans la base de données
  date_maj timestamp without time zone, -- Date de la dernière mise à jour dans la base de données
  c_circu character varying(15), -- Liste des codes des contraintes de circulation. Lien non dynamique avec la liste des valeurs lt_cont_circu. Incrémentation par GEO par défaut dans la table des signalements (public.geo_rva_signal) et dans l'attribut c_circu comme suit : 10;20 ... Ce champ devra être copier/coller via QGIS.
  c_observ character varying(1000), -- Champ libre pour détailler le type de restriction (ex : hauteur de 4,10 m, ...)
  date_ouv char(4), -- Date d'ouverture du tronçon à la circulation (soit l'année entière est saisie soit une partie en remplaçant les 0 par des x)
  CONSTRAINT an_voirie_circu_pkey PRIMARY KEY (id_tronc)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_voirie.an_voirie_circu
    OWNER to create_sig;

GRANT ALL ON TABLE m_voirie.an_voirie_circu TO sig_create;
GRANT SELECT ON TABLE m_voirie.an_voirie_circu TO sig_read;
GRANT ALL ON TABLE m_voirie.an_voirie_circu TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.an_voirie_circu TO sig_edit;

COMMENT ON TABLE m_voirie.an_voirie_circu
  IS 'Table alphanumérique des éléments de circulation de la voirie';
COMMENT ON COLUMN m_voirie.an_voirie_circu.id_tronc IS 'Identifiant du tronçon';
COMMENT ON COLUMN m_voirie.an_voirie_circu.type_circu IS 'Type de circulation principale';
COMMENT ON COLUMN m_voirie.an_voirie_circu.sens_circu IS 'Indique si le sens de circulation du tronçon';
COMMENT ON COLUMN m_voirie.an_voirie_circu.v_max IS 'Vitesse maximale autorisée pour un véhicule léger';
COMMENT ON COLUMN m_voirie.an_voirie_circu.observ IS 'Observations';
COMMENT ON COLUMN m_voirie.an_voirie_circu.date_sai IS 'Date de saisie dans la base de données';
COMMENT ON COLUMN m_voirie.an_voirie_circu.date_maj IS 'Date de la dernière mise à jour dans la base de données';
COMMENT ON COLUMN m_voirie.an_voirie_circu.c_circu IS 'Liste des codes des contraintes de circulation. Lien non dynamique avec la liste des valeurs lt_cont_circu. Incrémentation par GEO par défaut dans la table des signalements (public.geo_rva_signal) et dans l''attribut c_circu comme suit : 10;20 ... Ce champ devra être copier/coller via QGIS.';
COMMENT ON COLUMN m_voirie.an_voirie_circu.c_observ IS 'Champ libre pour détailler le type de restriction (ex : hauteur de 4,10 m, ...)';
COMMENT ON COLUMN m_voirie.an_voirie_circu.date_ouv IS 'Date d''ouverture du tronçon à la circulation (soit l''année entière est saisie soit une partie en remplaçant les 0 par des x)';



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                             DOMAINES DE VALEURS VOIE                                                         ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- ################################################################# Domaine valeur - src_geom  ###############################################

-- Table: r_objet.lt_src_geom

-- DROP TABLE r_objet.lt_src_geom;

CREATE TABLE r_objet.lt_src_geom
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au type de référentiel géométrique
  valeur character varying(254) NOT NULL, -- Valeur de la liste énumérée relative au type de référentiel géométrique
  CONSTRAINT lt_src_geom_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_objet.lt_src_geom
    OWNER to create_sig;

GRANT ALL ON TABLE r_objet.lt_src_geom TO sig_create;
GRANT SELECT ON TABLE r_objet.lt_src_geom TO sig_read;
GRANT ALL ON TABLE r_objet.lt_src_geom TO create_sig;

COMMENT ON TABLE r_objet.lt_src_geom
  IS 'Code permettant de décrire le type de référentiel géométrique';
COMMENT ON COLUMN r_objet.lt_src_geom.code IS 'Code de la liste énumérée relative au type de référentiel géométrique';
COMMENT ON COLUMN r_objet.lt_src_geom.valeur IS 'Valeur de la liste énumérée relative au type de référentiel géométrique';

INSERT INTO r_objet.lt_src_geom(
            code, valeur)
    VALUES
    ('10','Cadastre'),
    ('11','PCI vecteur'),
    ('12','BD Parcellaire'),
    ('13','RPCU'),
    ('20','Ortho-images'),
    ('21','Orthophotoplan IGN'),
    ('22','Orthophotoplan partenaire'),
    ('23','Orthophotoplan local'),
    ('30','Filaire voirie'),
    ('31','Route BDTopo'),    
    ('32','Route OSM'),
    ('40','Cartes'),
    ('41','Scan25'),
    ('50','Lever'),
    ('51','Plan topographique'),
    ('52','PCRS'),
    ('53','Trace GPS'),
    ('60','Geocodage'),
    ('70','Plan masse'),
    ('71','Plan masse vectoriel'),
    ('72','Plan masse redessiné'),
    ('80','Thématique'),
    ('81','Document d''urbanisme'),
    ('82','Occupation du Sol'),
    ('83','Thèmes BDTopo'),
    ('99','Autre'),
    ('00','Non renseigné');


-- ################################################################# Domaine valeur - type_tronc  ###############################################

-- Table: r_voie.lt_type_tronc

-- DROP TABLE r_voie.lt_type_tronc;

CREATE TABLE r_voie.lt_type_tronc
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au type de tronçon
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au type de tronçon
  code_val character varying(80) NOT NULL, -- Couple Code-Valeur de la liste énumérée relative au type de tronçon
  definition character varying(254) NOT NULL, -- Définition de la liste énumérée relative au type de tronçon
  CONSTRAINT lt_type_tronc_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_voie.lt_type_tronc
    OWNER to create_sig;

GRANT ALL ON TABLE r_voie.lt_type_tronc TO sig_create;
GRANT SELECT ON TABLE r_voie.lt_type_tronc TO sig_read;
GRANT ALL ON TABLE r_voie.lt_type_tronc TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_voie.lt_type_tronc TO sig_edit;

COMMENT ON TABLE r_voie.lt_type_tronc
  IS 'Code permettant de décrire le type de tronçon';
COMMENT ON COLUMN r_voie.lt_type_tronc.code IS 'Code de la liste énumérée relative au type de tronçon';
COMMENT ON COLUMN r_voie.lt_type_tronc.valeur IS 'Valeur de la liste énumérée relative au type de tronçon';
COMMENT ON COLUMN r_voie.lt_type_tronc.code_val IS 'Couple Code-Valeur de la liste énumérée relative au type de tronçon';
COMMENT ON COLUMN r_voie.lt_type_tronc.definition IS 'Définition de la liste énumérée relative au type de tronçon';

INSERT INTO r_voie.lt_type_tronc(
            code, valeur, code_val, definition)
    VALUES
    ('10','Troncon de type routier','10:Troncon de type routier','*'),
    ('11','Autoroute','11:Autoroute','Route sans croisement accessible uniquement en certains points, réservée à certains véhicules motorisés et de statut autoroutier'),
    ('12','Voie rapide/express','12:Voie rapide/express','Route sans croisement accessible uniquement en certains points, réservée à certains véhicules motorisés, de statut non autoroutier'),
    ('13','Bretelle','13:Bretelle','Dispositif de liaison ou voie d''accès'),
    ('14','Route','14:Route','Route goudronnée'),    
    ('15','Chemin','15:Chemin','Chemin permettant la circulation de véhicules ou d''engins d''exploitation'),    
    ('20','Troncon de type cyclable','20:Troncon de type cyclable','*'),
    ('21','Voie cyclable','21:Voie cyclable','Voie réservée à un usage cyclable'),
    ('30','Troncon de type piéton','30:Troncon de type piéton','*'),
    ('31','Sentier','31:Sentier','Chemin étroit ne permettant pas le passage de véhicules'),
    ('32','Passerelle','32:Passerelle','Passerelle supportant une allée'),    
    ('33','Escalier','33:Escalier','Escalier'),
    ('40','Troncon hors réseau','40:Troncon hors réseau','*'),
    ('41','Parking','41:Parking','Voie de stationnement interne'),  
    ('99','Autre','99:Autre','*'),
    ('ZZ','Non concerné','ZZ:Non concerné','*'),
    ('00','Non renseigné','00:Non renseigné','*');



-- ################################################################# Domaine valeur - hierarchie  ###############################################

-- Table: r_voie.lt_hierarchie

-- DROP TABLE r_voie.lt_hierarchie;

CREATE TABLE r_voie.lt_hierarchie
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à la hierarchisation du troncon dans la trame viaire
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la hierarchisation du troncon dans la trame viaire
  code_val character varying(80) NOT NULL, -- Couple Code-Valeur de la liste énumérée relative à la hierarchisation du troncon dans la trame viaire
  exemple character varying(254) NOT NULL, -- Exemple de troncon adapté à la catégorie
  CONSTRAINT lt_hierarchie_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_voie.lt_hierarchie
    OWNER to create_sig;

GRANT ALL ON TABLE r_voie.lt_hierarchie TO sig_create;
GRANT SELECT ON TABLE r_voie.lt_hierarchie TO sig_read;
GRANT ALL ON TABLE r_voie.lt_hierarchie TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_voie.lt_hierarchie TO sig_edit;

COMMENT ON TABLE r_voie.lt_hierarchie
  IS 'Code permettant de décrire la hierarchie du troncon dans la trame viaire';
COMMENT ON COLUMN r_voie.lt_hierarchie.code IS 'Code de la liste énumérée relative à la hierarchisation du troncon dans la trame viaire';
COMMENT ON COLUMN r_voie.lt_hierarchie.valeur IS 'Valeur de la liste énumérée relative à la hierarchisation du troncon dans la trame viaire';
COMMENT ON COLUMN r_voie.lt_hierarchie.code_val IS 'Couple Code-Valeur de la liste énumérée relative à la hierarchisation du troncon dans la trame viaire';
COMMENT ON COLUMN r_voie.lt_hierarchie.exemple IS 'Exemple de troncon adapté à la catégorie';

INSERT INTO r_voie.lt_hierarchie(
            code, valeur, code_val, exemple)
    VALUES
    ('1','Voie d''interêt national ou régional','1:Voie d''interêt national ou régional','*'),
    ('2','Voie structurant l''aire urbaine','2:Voie structurant l''aire urbaine','*'),
    ('3','Ceinture de desserte d''agglomération','3:Ceinture de desserte d''agglomération','*'),
    ('4','Voie de desserte urbaine','4:Voie de desserte urbaine','*'),
    ('5','Voie principale hors agglomération','5:Voie principale hors agglomération','*'),
    ('6','Voie principale communale','6:Voie principale communale','*'),
    ('7','Voie inter-quartier','7:Voie inter-quartier','*'),
    ('8','Voie de desserte locale','8:Voie de desserte locale','*'),
    ('9','Autre','9:Autre','*'),
    ('0','Non renseigné','0:Non renseigné','*'),
    ('Z','Non concerné','Z:Non concerné','*');


-- ################################################################# Domaine valeur - franchissement  ###############################################

-- Table: r_voie.lt_franchiss

-- DROP TABLE r_voie.lt_franchiss;

CREATE TABLE r_voie.lt_franchiss
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au type de franchissement du tronçon
  valeur character varying(254) NOT NULL, -- Valeur de la liste énumérée relative au type de franchissement du tronçon
  CONSTRAINT lt_franchiss_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_voie.lt_franchiss
    OWNER to create_sig;

GRANT ALL ON TABLE r_voie.lt_franchiss TO sig_create;
GRANT SELECT ON TABLE r_voie.lt_franchiss TO sig_read;
GRANT ALL ON TABLE r_voie.lt_franchiss TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_voie.lt_franchiss TO sig_edit;

COMMENT ON TABLE r_voie.lt_franchiss
  IS 'Code permettant de décrire le type de franchissement du tronçon';
COMMENT ON COLUMN r_voie.lt_franchiss.code IS 'Code de la liste énumérée relative au type de franchissement du tronçon';
COMMENT ON COLUMN r_voie.lt_franchiss.valeur IS 'Valeur de la liste énumérée relative au type de franchissement du tronçon';

INSERT INTO r_voie.lt_franchiss(
            code, valeur)
    VALUES
    ('01','Pont'),
    ('02','Tunnel'),
    ('03','Passage à niveau sur voie ferrée'),
    ('04','Porche (passage sous un bâtiment)'),
    ('05','Escalier'),
    ('06','Passerelle'),
    ('99','Autre'),
    ('ZZ','Non concerné'),
    ('00','Non renseigné');


-- ################################################################# Domaine valeur - type_voie  ###############################################

-- Table: r_voie.lt_type_voie

-- DROP TABLE r_voie.lt_type_voie;

CREATE TABLE r_voie.lt_type_voie
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au type de voie
  valeur character varying(254) NOT NULL, -- Valeur de la liste énumérée relative au type de voie
  definition character varying(254) NOT NULL, -- Definition de la liste énumérée relative au type de voie
  CONSTRAINT lt_type_voie_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_voie.lt_type_voie
    OWNER to create_sig;

GRANT ALL ON TABLE r_voie.lt_type_voie TO sig_create;
GRANT SELECT ON TABLE r_voie.lt_type_voie TO sig_read;
GRANT ALL ON TABLE r_voie.lt_type_voie TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_voie.lt_type_voie TO sig_edit;

COMMENT ON TABLE r_voie.lt_type_voie
  IS 'Code permettant de décrire le type de voie';
COMMENT ON COLUMN r_voie.lt_type_voie.code IS 'Code de la liste énumérée relative au type de voie';
COMMENT ON COLUMN r_voie.lt_type_voie.valeur IS 'Valeur de la liste énumérée relative au type de voie';
COMMENT ON COLUMN r_voie.lt_type_voie.definition IS 'Definition de la liste énumérée relative au type de voie';

INSERT INTO r_voie.lt_type_voie(
            code, valeur, definition)
    VALUES
    ('01','R','Rue'),
    ('02','RTE','Route'),
    ('03','BD','Boulevard'),
    ('04','AV','Avenue'),
    ('05','CHE','Chemin'),
    ('06','ALL','Allée'),
    ('08','CAR','Carrefour'),
    ('09','IMP','Impasse'),
    ('10','LD','Lieu dit'),
    ('11','CITE','Cité'),
    ('12','CLOS','Clos'),
    ('13','COUR','Cour'),
    ('14','CRS','Cours'),
    ('15','CD','Chemin Départemental'),
    ('16','CR','Chemin rural'),
    ('17','CTRE','Centre'),
    ('18','D','Départementale'),
    ('19','GR','Grande Rue'),
    ('20','PARC','Parc'),
    ('21','N','Nationale'),
    ('22','PAS','Passage'),
    ('23','PRV','Parvis'),
    ('24','PL','Place'),
    ('25','PNT','Pont'),
    ('26','PRT','Petite Route'),
    ('27','PORT','Port'),
    ('28','PROM','Promenade'),
    ('29','QU','Quai'),    
    ('30','RES','Résidence'),
    ('31','RLE','Ruelle'),
    ('32','RPT','Rond Point'),
    ('33','SEN','Sente(ier)'),
    ('34','SQ','Square'),
    ('35','VC','Voie Communale'),
    ('36','VLA','Villa'),
    ('37','VOI','Voie'),
    ('38','VOIR','Voirie'),
    ('39','ZAC','ZAC'),
    ('40','CAV','Cavée'),
    ('41','CHS','Chaussée'),
    ('42','COTE','Côte'),
    ('43','CV','Chemin vicinal'),
    ('44','DOM','Domaine'),
    ('45','PLE','Passerelle'),
    ('46','LOT','Lotissement'),
    ('47','COR','Corniche'),
    ('48','DSC','Descente'),
    ('49','ECA','Ecart'),
    ('50','ESP','Esplanade'),
    ('51','FG','Faubourg'),
    ('52','HAM','Hameau'),
    ('53','HLE','Halle'),
    ('54','MAR','Marché'),
    ('55','MTE','Montée'),
    ('56','PLN','Plaine'),
    ('57','PLT','Plateau'),    
    ('99','Autre','*'),
    ('ZZ','Non concerné','*'),
    ('00','Non renseigné','*');



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                            DOMAINES DE VALEURS VOIRIE                                                        ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- ################################################################# Domaine valeur - statut juridique  ###############################################

-- Table: m_voirie.lt_statut_jur

-- DROP TABLE m_voirie.lt_statut_jur;

CREATE TABLE m_voirie.lt_statut_jur
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au statut juridique du tronçon
  valeur character varying(254) NOT NULL, -- Valeur de la liste énumérée relative au statut juridique du tronçon
  CONSTRAINT lt_statut_jur_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_voirie.lt_statut_jur
    OWNER to create_sig;

GRANT ALL ON TABLE m_voirie.lt_statut_jur TO sig_create;
GRANT SELECT ON TABLE m_voirie.lt_statut_jur TO sig_read;
GRANT ALL ON TABLE m_voirie.lt_statut_jur TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.lt_statut_jur TO sig_edit;

COMMENT ON TABLE m_voirie.lt_statut_jur
  IS 'Code permettant de décrire le statut juridique du tronçon';
COMMENT ON COLUMN m_voirie.lt_statut_jur.code IS 'Code de la liste énumérée relative au statut juridique du tronçon';
COMMENT ON COLUMN m_voirie.lt_statut_jur.valeur IS 'Valeur de la liste énumérée relative au statut juridique du tronçon';

INSERT INTO m_voirie.lt_statut_jur(
            code, valeur)
    VALUES
    ('01','Autoroute'),
    ('02','Route Nationale'),
    ('03','Route Départementale'),
    ('04','Voie d''Interêt Communautaire'),
    ('05','Voie Communale'),
    ('06','Chemin Rural'),
    ('07','Chemin d''Exploitation'),
    ('08','Chemin Forestier'),
    ('09','Chemin de Halage'),
    ('10','Voie Privée'),     
    ('11','Piste Cyclable'),  
    ('12','Voie Verte'),      
    ('99','Autre statut'),
    ('ZZ','Non concerné'),
    ('00','Non renseigné');


-- ################################################################# Domaine valeur - gestionnaire/propriétaire  ###############################################

-- Table: m_voirie.lt_gestion

-- DROP TABLE m_voirie.lt_gestion;

CREATE TABLE m_voirie.lt_gestion
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au gestionnaire/propriétaire du tronçon
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au gestionnaire/propriétaire du tronçon
  CONSTRAINT lt_gestion_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_voirie.lt_gestion
    OWNER to create_sig;

GRANT ALL ON TABLE m_voirie.lt_gestion TO sig_create;
GRANT SELECT ON TABLE m_voirie.lt_gestion TO sig_read;
GRANT ALL ON TABLE m_voirie.lt_gestion TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.lt_gestion TO sig_edit;

COMMENT ON TABLE m_voirie.lt_gestion
  IS 'Code permettant de décrire le gestionnaire/propriétaire du tronçon';
COMMENT ON COLUMN m_voirie.lt_gestion.code IS 'Code de la liste énumérée relative au gestionnaire/propriétaire du tronçon';
COMMENT ON COLUMN m_voirie.lt_gestion.valeur IS 'Valeur de la liste énumérée relative au gestionnaire/propriétaire du tronçon';

INSERT INTO m_voirie.lt_gestion(
            code, valeur)
    VALUES
    ('01','Etat'),
    ('02','Région'),
    ('03','Département'),
    ('04','Intercommunalité'),
    ('05','Commune'),
    ('06','Office HLM'),
    ('07','Privé'),
    ('99','Autre'), 
    ('ZZ','Non concerné'),  
    ('00','Non renseigné');




-- ################################################################# Domaine valeur - domanialité  ###############################################

-- Table: m_voirie.lt_doman

-- DROP TABLE m_voirie.lt_doman;

CREATE TABLE m_voirie.lt_doman
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à la domanialité du tronçon
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la domanialité du tronçon
  CONSTRAINT lt_doman_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_voirie.lt_doman
    OWNER to create_sig;

GRANT ALL ON TABLE m_voirie.lt_doman TO sig_create;
GRANT SELECT ON TABLE m_voirie.lt_doman TO sig_read;
GRANT ALL ON TABLE m_voirie.lt_doman TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.lt_doman TO sig_edit;

COMMENT ON TABLE m_voirie.lt_doman
  IS 'Code permettant de décrire la domanialité du tronçon';
COMMENT ON COLUMN m_voirie.lt_doman.code IS 'Code de la liste énumérée relative à la domanialité du tronçon';
COMMENT ON COLUMN m_voirie.lt_doman.valeur IS 'Valeur de la liste énumérée relative à la domanialité du tronçon';

INSERT INTO m_voirie.lt_doman(
            code, valeur)
    VALUES
    ('01','Public'),
    ('02','Privé'),
    ('00','Non renseigné'),
    ('ZZ','Non concerné');

-- ################################################################# Domaine valeur - type circulation  ###############################################

-- Table: m_voirie.lt_type_circu

-- DROP TABLE m_voirie.lt_type_circu;

CREATE TABLE m_voirie.lt_type_circu
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au type de circulation sur le tronçon
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au type de circulation sur un tronçon
  CONSTRAINT lt_type_circu_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_voirie.lt_type_circu
    OWNER to create_sig;

GRANT ALL ON TABLE m_voirie.lt_type_circu TO sig_create;
GRANT SELECT ON TABLE m_voirie.lt_type_circu TO sig_read;
GRANT ALL ON TABLE m_voirie.lt_type_circu TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.lt_type_circu TO sig_edit;

COMMENT ON TABLE m_voirie.lt_type_circu
  IS 'Code permettant de décrire la type_circulation sur le tronçon';
COMMENT ON COLUMN m_voirie.lt_type_circu.code IS 'Code de la liste énumérée relative au type de circulation sur un tronçon';
COMMENT ON COLUMN m_voirie.lt_type_circu.valeur IS 'Valeur de la liste énumérée relative au type de circulation sur un tronçon';

INSERT INTO m_voirie.lt_type_circu(
            code, valeur)
    VALUES
    ('01','Routier'),
    ('02','Cyclable'),
    ('03','Piéton'),
    ('04','Mixte à dominante routière'),
    ('05','Mixte à dominante cyclable'),
    ('06','Mixte à dominante piétonne'),
    ('07','Mixte sans dominante particulière'),    
    ('00','Non renseigné');

-- ################################################################# Domaine valeur - sens de circulation  ###############################################

-- Table: m_voirie.lt_sens_circu

-- DROP TABLE m_voirie.lt_sens_circu;

CREATE TABLE m_voirie.lt_sens_circu
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au sens de circulation du tronçon
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au sens de circulation du tronçon
  CONSTRAINT lt_sens_circu_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_voirie.lt_sens_circu
    OWNER to create_sig;

GRANT ALL ON TABLE m_voirie.lt_sens_circu TO sig_create;
GRANT SELECT ON TABLE m_voirie.lt_sens_circu TO sig_read;
GRANT ALL ON TABLE m_voirie.lt_sens_circu TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.lt_sens_circu TO sig_edit;

COMMENT ON TABLE m_voirie.lt_sens_circu
  IS 'Code permettant de décrire le sens de circulation du tronçon';
COMMENT ON COLUMN m_voirie.lt_sens_circu.code IS 'Code de la liste énumérée relative au sens de circulation du tronçon';
COMMENT ON COLUMN m_voirie.lt_sens_circu.valeur IS 'Valeur de la liste énumérée relative au sens de circulation du tronçon';

INSERT INTO m_voirie.lt_sens_circu(
            code, valeur)
    VALUES
    ('01','Double sens'),
    ('02','Sens unique direct (sens de saisie du troncon)'),
    ('03','Sens unique inverse (sens de saisie du troncon)'),
    ('00','Non renseigné'),
    ('ZZ','Non concerné');

-- ######################################################## Domaine valeur - Contrainte de circulation  #############################################


-- Table: m_voirie.lt_cont_circu

-- DROP TABLE m_voirie.lt_cont_circu;

CREATE TABLE m_voirie.lt_cont_circu
(
  code character varying(3) NOT NULL, -- Code de la liste énumérée relative aux contraintes de circulation possible (hors vitesse)
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative aux contraintes de circulation possible (hors vitesse)
  CONSTRAINT lt_cont_circu_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_voirie.lt_cont_circu
    OWNER to create_sig;

GRANT ALL ON TABLE m_voirie.lt_cont_circu TO sig_create;
GRANT SELECT ON TABLE m_voirie.lt_cont_circu TO sig_read;
GRANT ALL ON TABLE m_voirie.lt_cont_circu TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.lt_cont_circu TO sig_edit;

COMMENT ON TABLE m_voirie.lt_cont_circu
  IS 'Code permettant de décrire la vitesse maximale autorisée pour un véhicule léger';
COMMENT ON COLUMN m_voirie.lt_cont_circu.code IS 'Code de la liste énumérée relative aux contraintes de circulation possible (hors vitesse)';
COMMENT ON COLUMN m_voirie.lt_cont_circu.valeur IS 'Valeur de la liste énumérée relative aux contraintes de circulation possible (hors vitesse)';

INSERT INTO m_voirie.lt_cont_circu(
            code, valeur)
    VALUES
    ('10','Hauteur'),
    ('20','Largeur'),
    ('30','Poids'),
    ('40','Marchandises dangereuses'),
    ('50','Type de véhicule');


-- ################################################################# Domaine valeur - vitesse max vl  ###############################################

-- Table: m_voirie.lt_v_max

-- DROP TABLE m_voirie.lt_v_max;

CREATE TABLE m_voirie.lt_v_max
(
  code character varying(3) NOT NULL, -- Code de la liste énumérée relative à la vitesse maximale autorisée pour un véhicule léger
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la vitesse maximale autorisée pour un véhicule léger
  CONSTRAINT lt_v_max_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_voirie.lt_v_max
    OWNER to create_sig;

GRANT ALL ON TABLE m_voirie.lt_v_max TO sig_create;
GRANT SELECT ON TABLE m_voirie.lt_v_max TO sig_read;
GRANT ALL ON TABLE m_voirie.lt_v_max TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.lt_v_max TO sig_edit;

COMMENT ON TABLE m_voirie.lt_v_max
  IS 'Code permettant de décrire la vitesse maximale autorisée pour un véhicule léger';
COMMENT ON COLUMN m_voirie.lt_v_max.code IS 'Code de la liste énumérée relative à la vitesse maximale autorisée pour un véhicule léger';
COMMENT ON COLUMN m_voirie.lt_v_max.valeur IS 'Valeur de la liste énumérée relative à la vitesse maximale autorisée pour un véhicule léger';

INSERT INTO m_voirie.lt_v_max(
            code, valeur)
    VALUES
    ('010','10 km/h'),
    ('015','15 km/h'),
    ('020','20 km/h'),
    ('030','30 km/h'),
    ('040','40 km/h'),
    ('045','45 km/h'),
    ('050','50 km/h'),
    ('060','60 km/h'),
    ('070','70 km/h'),
    ('080','80 km/h'),
    ('090','90 km/h'),
    ('110','110 km/h'),
    ('130','130 km/h'),
    ('999','Autre vitesse'),    
    ('000','Non renseigné'),
    ('ZZZ','Non concerné');


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        FKEY                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Foreign Key: r_objet.noeud_d_fkey

-- ALTER TABLE r_objet.geo_objet_troncon DROP CONSTRAINT r_objet.noeud_d_fkey;

ALTER TABLE r_objet.geo_objet_troncon
  ADD CONSTRAINT noeud_d_fkey FOREIGN KEY (noeud_d)
      REFERENCES r_objet.geo_objet_noeud (id_noeud) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;
      
-- Foreign Key: r_objet.noeud_f_fkey

-- ALTER TABLE r_objet.geo_objet_troncon DROP CONSTRAINT r_objet.noeud_f_fkey;

ALTER TABLE r_objet.geo_objet_troncon
  ADD CONSTRAINT noeud_f_fkey FOREIGN KEY (noeud_f)
      REFERENCES r_objet.geo_objet_noeud (id_noeud) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

-- Foreign Key: r_voie.an_tronc_id_tronc_fkey

-- ALTER TABLE r_voie.an_troncon DROP CONSTRAINT an_tronc_id_tronc_fkey;

ALTER TABLE r_voie.an_troncon
  ADD CONSTRAINT an_tronc_id_tronc_fkey FOREIGN KEY (id_tronc)
      REFERENCES r_objet.geo_objet_troncon (id_tronc) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;
 
      
-- Foreign Key: m_voirie.an_voirie_circu_id_tronc_fkey

-- ALTER TABLE m_voirie.an_voirie_circu DROP CONSTRAINT an_voirie_circu_id_tronc_fkey;

ALTER TABLE m_voirie.an_voirie_circu
  ADD CONSTRAINT an_voirie_circu_id_tronc_fkey FOREIGN KEY (id_tronc)
      REFERENCES r_objet.geo_objet_troncon (id_tronc) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;
      
-- Foreign Key: m_voirie.an_voirie_gest_id_tronc_fkey

-- ALTER TABLE m_voirie.an_voirie_gest DROP CONSTRAINT an_voirie_gest_id_tronc_fkey;

ALTER TABLE m_voirie.an_voirie_gest
  ADD CONSTRAINT an_voirie_gest_id_tronc_fkey FOREIGN KEY (id_tronc)
      REFERENCES r_objet.geo_objet_troncon (id_tronc) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;


-- Foreign Key: r_objet.id_voie_g_fkey

-- ALTER TABLE r_objet.geo_objet_troncon DROP CONSTRAINT id_voie_g_fkey;

ALTER TABLE r_objet.geo_objet_troncon
  ADD CONSTRAINT id_voie_g_fkey FOREIGN KEY (id_voie_g)
      REFERENCES r_voie.an_voie (id_voie) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

-- Foreign Key: r_objet.id_voie_d_fkey

-- ALTER TABLE r_objet.geo_objet_troncon DROP CONSTRAINT id_voie_d_fkey;

ALTER TABLE r_objet.geo_objet_troncon
  ADD CONSTRAINT id_voie_d_fkey FOREIGN KEY (id_voie_d)
      REFERENCES r_voie.an_voie (id_voie) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

-- Foreign Key: r_objet.id_voie_fkey

-- ALTER TABLE r_objet.geo_objet_noeud DROP CONSTRAINT id_voie_fkey;

ALTER TABLE r_objet.geo_objet_noeud
  ADD CONSTRAINT id_voie_fkey FOREIGN KEY (id_voie)
      REFERENCES r_voie.an_voie (id_voie) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;


-- Foreign Key: r_objet.lt_src_geom_fkey

-- ALTER TABLE r_objet.geo_objet_troncon DROP CONSTRAINT lt_src_geom_fkey;

ALTER TABLE r_objet.geo_objet_troncon
  ADD CONSTRAINT lt_src_geom_fkey FOREIGN KEY (src_geom)
      REFERENCES r_objet.lt_src_geom (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;


-- Foreign Key: r_voie.lt_type_tronc_fkey

-- ALTER TABLE r_voie.an_troncon DROP CONSTRAINT lt_type_tronc_fkey;

ALTER TABLE r_voie.an_troncon
  ADD CONSTRAINT lt_type_tronc_fkey FOREIGN KEY (type_tronc)
      REFERENCES r_voie.lt_type_tronc (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;


-- Foreign Key: r_voie.lt_hierarchie_fkey

-- ALTER TABLE r_voie.an_troncon DROP CONSTRAINT lt_hierarchie_fkey;

ALTER TABLE r_voie.an_troncon
  ADD CONSTRAINT lt_hierarchie_fkey FOREIGN KEY (hierarchie)
      REFERENCES r_voie.lt_hierarchie (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;


-- Foreign Key: r_voie.lt_franchiss_fkey

-- ALTER TABLE r_voie.an_troncon DROP CONSTRAINT lt_franchiss_fkey;

ALTER TABLE r_voie.an_troncon
  ADD CONSTRAINT lt_franchiss_fkey FOREIGN KEY (franchiss)
      REFERENCES r_voie.lt_franchiss (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;


-- Foreign Key: m_voirie.lt_type_circu_fkey

-- ALTER TABLE m_voirie.an_voirie_circu DROP CONSTRAINT lt_type_circu_fkey;

ALTER TABLE m_voirie.an_voirie_circu
  ADD CONSTRAINT lt_type_circu_fkey FOREIGN KEY (type_circu)
      REFERENCES m_voirie.lt_type_circu (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: m_voirie.lt_sens_circu_fkey

-- ALTER TABLE m_voirie.an_voirie_circu DROP CONSTRAINT lt_sens_circu_fkey;

ALTER TABLE m_voirie.an_voirie_circu
  ADD CONSTRAINT lt_sens_circu_fkey FOREIGN KEY (sens_circu)
      REFERENCES m_voirie.lt_sens_circu (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      

      
-- Foreign Key: m_voirie.lt_v_max_fkey

-- ALTER TABLE m_voirie.an_voirie_circu DROP CONSTRAINT lt_v_max_fkey;

ALTER TABLE m_voirie.an_voirie_circu
  ADD CONSTRAINT lt_v_max_fkey FOREIGN KEY (v_max)
      REFERENCES m_voirie.lt_v_max (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;          

 
-- Foreign Key: m_voirie.lt_statut_jur_fkey

-- ALTER TABLE m_voirie.an_voirie_gest DROP CONSTRAINT lt_statut_jur_fkey;

ALTER TABLE m_voirie.an_voirie_gest
  ADD CONSTRAINT lt_statut_jur_fkey FOREIGN KEY (statut_jur)
      REFERENCES m_voirie.lt_statut_jur (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
-- Foreign Key: m_voirie.lt_gestion_fkey

-- ALTER TABLE m_voirie.an_voirie_gest DROP CONSTRAINT lt_gestion_fkey;

ALTER TABLE m_voirie.an_voirie_gest
  ADD CONSTRAINT lt_gestion_fkey FOREIGN KEY (gestion)
      REFERENCES m_voirie.lt_gestion (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
-- Foreign Key: m_voirie.lt_doman_fkey

-- ALTER TABLE m_voirie.an_voirie_gest DROP CONSTRAINT lt_doman_fkey;

ALTER TABLE m_voirie.an_voirie_gest
  ADD CONSTRAINT lt_doman_fkey FOREIGN KEY (doman)
      REFERENCES m_voirie.lt_doman (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
-- Foreign Key: m_voirie.lt_proprio_fkey

-- ALTER TABLE m_voirie.an_voirie_gest DROP CONSTRAINT lt_proprio_fkey;

ALTER TABLE m_voirie.an_voirie_gest
  ADD CONSTRAINT lt_proprio_fkey FOREIGN KEY (proprio)
      REFERENCES m_voirie.lt_gestion (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Foreign Key: r_voie.lt_type_voie_fkey

-- ALTER TABLE r_voie.an_voie DROP CONSTRAINT lt_type_voie_fkey;

ALTER TABLE r_voie.an_voie
  ADD CONSTRAINT lt_type_voie_fkey FOREIGN KEY (type_voie)
      REFERENCES r_voie.lt_type_voie (code) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- View: r_voie.geo_v_troncon_voie

-- DROP VIEW r_voie.geo_v_troncon_voie;

CREATE OR REPLACE VIEW r_voie.geo_v_troncon_voie AS 
 SELECT t.id_tronc,t.id_voie_g,t.id_voie_d, vg.libvoie_c as libvoie_g, vg.rivoli as rivoli_g, vd.libvoie_c as libvoie_d, vd.rivoli as rivoli_d, t.insee_g,t.insee_d,t.noeud_d,t.noeud_f,t.src_tronc,a.type_tronc,a.hierarchie,a.franchiss,a.nb_voie,a.projet,a.fictif,t.pente,t.observ, t.src_geom, t.src_date, t.geom
   FROM r_objet.geo_objet_troncon t
   LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
   LEFT JOIN r_voie.an_voie vg ON vg.id_voie = t.id_voie_g
   LEFT JOIN r_voie.an_voie vd ON vd.id_voie = t.id_voie_d;

ALTER TABLE r_voie.geo_v_troncon_voie
    OWNER TO create_sig;
COMMENT ON VIEW r_voie.geo_v_troncon_voie
    IS 'Vue de synthèse de la base de voie (pas d''information métier voirie)';

GRANT ALL ON TABLE r_voie.geo_v_troncon_voie TO sig_create;
GRANT SELECT ON TABLE r_voie.geo_v_troncon_voie TO sig_read;
GRANT ALL ON TABLE r_voie.geo_v_troncon_voie TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_voie.geo_v_troncon_voie TO sig_edit;

-- View: m_voirie.geo_v_troncon_voirie

-- DROP VIEW m_voirie.geo_v_troncon_voirie;

CREATE OR REPLACE VIEW m_voirie.geo_v_troncon_voirie AS 
 SELECT t.id_tronc,t.id_voie_g,t.id_voie_d, t.insee_g,t.insee_d,t.noeud_d,t.noeud_f,
        false as h_troncon,
        a.type_tronc,a.hierarchie,a.franchiss,a.nb_voie,a.projet,a.fictif,g.statut_jur,
        g.num_statut,g.gestion,g.doman,g.proprio,g.date_rem,c.type_circu,c.sens_circu,c.c_circu,c.c_observ,c.date_ouv,c.v_max,t.pente,t.observ, t.src_geom, t.src_date, t.src_tronc, t.geom
   FROM r_objet.geo_objet_troncon t
   LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
   LEFT JOIN m_voirie.an_voirie_gest g ON g.id_tronc = t.id_tronc
   LEFT JOIN m_voirie.an_voirie_circu c ON c.id_tronc = t.id_tronc;



ALTER TABLE m_voirie.geo_v_troncon_voirie
    OWNER TO create_sig;
COMMENT ON VIEW m_voirie.geo_v_troncon_voirie
    IS 'Vue éditable destinée à la modification des données relatives au troncon et à ses propriétés métiers de circulation et de gestion';

GRANT ALL ON TABLE m_voirie.geo_v_troncon_voirie TO sig_create;
GRANT SELECT ON TABLE m_voirie.geo_v_troncon_voirie TO sig_read;
GRANT ALL ON TABLE m_voirie.geo_v_troncon_voirie TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE m_voirie.geo_v_troncon_voirie TO sig_edit;


-- ################################################################# VUES DU PLAN DE VILLE DYNAMIQUE  ###############################################


-- View: r_plan.geo_v_plan_troncon

-- DROP VIEW r_plan.geo_v_plan_troncon;

CREATE OR REPLACE VIEW r_plan.geo_v_plan_troncon AS 
 SELECT t.id_tronc,t.insee_g,t.insee_d,a.type_tronc,a.hierarchie,a.franchiss,a.nb_voie,a.projet,a.fictif,c.type_circu,t.pente,t.geom
   FROM r_objet.geo_objet_troncon t
   LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
   LEFT JOIN m_voirie.an_voirie_circu c ON c.id_tronc = t.id_tronc
WHERE a.projet IS FALSE;


ALTER TABLE r_plan.geo_v_plan_troncon
    OWNER TO create_sig;
COMMENT ON VIEW r_plan.geo_v_plan_troncon
    IS 'Vue du plan dynamique destinée au dessin des tronçons';

GRANT ALL ON TABLE r_plan.geo_v_plan_troncon TO sig_create;
GRANT SELECT ON TABLE r_plan.geo_v_plan_troncon TO sig_read;
GRANT ALL ON TABLE r_plan.geo_v_plan_troncon TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_plan.geo_v_plan_troncon TO sig_edit;

  

-- View: r_plan.geo_v_plan_lib_voie

-- DROP VIEW r_plan.geo_v_plan_lib_voie;

CREATE OR REPLACE VIEW r_plan.geo_v_plan_lib_voie AS 
 SELECT t.id_tronc,t.id_voie_g,t.id_voie_d,vg.libvoie_c as libvoie_g,vd.libvoie_c as libvoie_c,t.insee_g,t.insee_d,t.noeud_d,t.noeud_f,a.type_tronc,a.hierarchie,a.franchiss,a.nb_voie,a.projet,g.statut_jur,g.num_statut,t.geom
   FROM r_objet.geo_objet_troncon t
   LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
   LEFT JOIN r_voie.an_voie vg ON vg.id_voie = t.id_voie_g
   LEFT JOIN r_voie.an_voie vd ON vd.id_voie = t.id_voie_d
   LEFT JOIN m_voirie.an_voirie_gest g ON g.id_tronc = t.id_tronc
WHERE a.projet IS FALSE AND (t.id_voie_g IS NOT NULL OR t.id_voie_d IS NOT NULL);


ALTER TABLE r_plan.geo_v_plan_lib_voie
    OWNER TO create_sig;
COMMENT ON VIEW r_plan.geo_v_plan_lib_voie
    IS 'Vue du plan dynamique destinée à l''étiquettage des noms des tronçons existants';

GRANT ALL ON TABLE r_plan.geo_v_plan_lib_voie TO sig_create;
GRANT SELECT ON TABLE r_plan.geo_v_plan_lib_voie TO sig_read;
GRANT ALL ON TABLE r_plan.geo_v_plan_lib_voie TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_plan.geo_v_plan_lib_voie TO sig_edit;
  
-- View: r_plan.geo_v_plan_lib_voie_arc

-- DROP VIEW r_plan.geo_v_plan_lib_voie_arc;

CREATE OR REPLACE VIEW r_plan.geo_v_plan_lib_voie_arc
 AS
 SELECT t.id_tronc,
    t.id_voie_g,
    t.id_voie_d,
    vg.libvoie_c AS libvoie_g,
    vd.libvoie_c,
    upper(vd.libvoie_c::text) AS libvoie_maj,
    t.insee_g,
    t.insee_d,
    t.noeud_d,
    t.noeud_f,
    a.type_tronc,
    a.hierarchie,
    a.franchiss,
    a.nb_voie,
    a.projet,
    g.statut_jur,
    g.num_statut,
    t.geom
   FROM r_objet.geo_objet_troncon t
     LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
     LEFT JOIN r_voie.an_voie vg ON vg.id_voie = t.id_voie_g
     LEFT JOIN r_voie.an_voie vd ON vd.id_voie = t.id_voie_d
     LEFT JOIN m_voirie.an_voirie_gest g ON g.id_tronc = t.id_tronc
  WHERE a.projet IS FALSE AND (t.id_voie_g IS NOT NULL OR t.id_voie_d IS NOT NULL OR g.num_statut IS NOT NULL) AND (t.insee_g::text = '60023'::text OR t.insee_g::text = '60067'::text OR t.insee_g::text = '60068'::text OR t.insee_g::text = '60070'::text OR t.insee_g::text = '60151'::text OR t.insee_g::text = '60156'::text OR t.insee_g::text = '60159'::text OR t.insee_g::text = '60323'::text OR t.insee_g::text = '60325'::text OR t.insee_g::text = '60326'::text OR t.insee_g::text = '60337'::text OR t.insee_g::text = '60338'::text OR t.insee_g::text = '60382'::text OR t.insee_g::text = '60402'::text OR t.insee_g::text = '60447'::text OR t.insee_g::text = '60578'::text OR t.insee_g::text = '60579'::text OR t.insee_g::text = '60597'::text OR t.insee_g::text = '60600'::text OR t.insee_g::text = '60665'::text OR t.insee_g::text = '60667'::text OR t.insee_g::text = '60674'::text OR t.insee_d::text = '60023'::text OR t.insee_d::text = '60067'::text OR t.insee_d::text = '60068'::text OR t.insee_d::text = '60070'::text OR t.insee_d::text = '60151'::text OR t.insee_d::text = '60156'::text OR t.insee_d::text = '60159'::text OR t.insee_d::text = '60323'::text OR t.insee_d::text = '60325'::text OR t.insee_d::text = '60326'::text OR t.insee_d::text = '60337'::text OR t.insee_d::text = '60338'::text OR t.insee_d::text = '60382'::text OR t.insee_d::text = '60402'::text OR t.insee_d::text = '60447'::text OR t.insee_d::text = '60578'::text OR t.insee_d::text = '60579'::text OR t.insee_d::text = '60597'::text OR t.insee_d::text = '60600'::text OR t.insee_d::text = '60665'::text OR t.insee_d::text = '60667'::text OR t.insee_d::text = '60674'::text);

ALTER TABLE r_plan.geo_v_plan_lib_voie_arc
    OWNER TO create_sig;
COMMENT ON VIEW r_plan.geo_v_plan_lib_voie_arc
    IS 'Vue du plan dynamique destinée à l''étiquettage des noms des tronçons existants filtré sur l''ARC';

GRANT ALL ON TABLE r_plan.geo_v_plan_lib_voie_arc TO sig_create;
GRANT SELECT ON TABLE r_plan.geo_v_plan_lib_voie_arc TO sig_read;
GRANT ALL ON TABLE r_plan.geo_v_plan_lib_voie_arc TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_plan.geo_v_plan_lib_voie_arc TO sig_edit;

-- View: r_plan.geo_v_plan_sens_uniq

-- DROP VIEW r_plan.geo_v_plan_sens_uniq;

CREATE OR REPLACE VIEW r_plan.geo_v_plan_sens_uniq AS 
 SELECT t.id_tronc,a.type_tronc,a.hierarchie,a.franchiss,a.nb_voie,a.projet,c.sens_circu,t.geom
   FROM r_objet.geo_objet_troncon t
   LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
   LEFT JOIN m_voirie.an_voirie_circu c ON c.id_tronc = t.id_tronc
WHERE a.projet IS false AND (c.sens_circu = '02' OR c.sens_circu = '03');


ALTER TABLE r_plan.geo_v_plan_sens_uniq
    OWNER TO create_sig;
COMMENT ON VIEW r_plan.geo_v_plan_sens_uniq
    IS 'Vue du plan dynamique destinée à la matérialisation des flèches pour les sens uniques';

GRANT ALL ON TABLE r_plan.geo_v_plan_sens_uniq TO sig_create;
GRANT SELECT ON TABLE r_plan.geo_v_plan_sens_uniq TO sig_read;
GRANT ALL ON TABLE r_plan.geo_v_plan_sens_uniq TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_plan.geo_v_plan_sens_uniq TO sig_edit;
  

-- View: r_plan.geo_v_plan_cartouche

-- DROP VIEW r_plan.geo_v_plan_cartouche;

CREATE OR REPLACE VIEW r_plan.geo_v_plan_cartouche AS 
 SELECT t.id_tronc,a.type_tronc,a.hierarchie,a.projet,g.statut_jur,g.num_statut,t.geom
   FROM r_objet.geo_objet_troncon t
   LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
   LEFT JOIN m_voirie.an_voirie_gest g ON g.id_tronc = t.id_tronc
WHERE a.projet IS false AND (g.statut_jur = '01' OR g.statut_jur = '02' OR g.statut_jur = '03');


ALTER TABLE r_plan.geo_v_plan_cartouche
    OWNER TO create_sig;
COMMENT ON VIEW r_plan.geo_v_plan_cartouche
    IS 'Vue du plan dynamique destinée à la matérialisation des cartouches pour les autoroutes, les routes nationales et départementales';

GRANT ALL ON TABLE r_plan.geo_v_plan_cartouche TO sig_create;
GRANT SELECT ON TABLE r_plan.geo_v_plan_cartouche TO sig_read;
GRANT ALL ON TABLE r_plan.geo_v_plan_cartouche TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE r_plan.geo_v_plan_cartouche TO sig_edit;



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### FONCTION TRIGGER - GEO_OBJET_TRONCON ###################################################

-- Function: r_objet.ft_m_geo_objet_troncon()

-- DROP FUNCTION r_objet.ft_m_geo_objet_troncon();

CREATE OR REPLACE FUNCTION r_objet.ft_m_geo_objet_troncon()
  RETURNS trigger AS
$BODY$

DECLARE v_id_tronc integer;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_id_tronc := nextval('r_objet.geo_objet_troncon_id_seq'::regclass);
INSERT INTO r_objet.geo_objet_troncon (id_tronc, id_voie_g, id_voie_d, insee_g, insee_d, noeud_d, noeud_f, pente, observ, src_geom, src_date, geom, src_tronc)
SELECT v_id_tronc,NEW.id_voie_g, NEW.id_voie_d, NEW.insee_g, NEW.insee_d, NEW.noeud_d, NEW.noeud_f, NEW.pente, NEW.observ,
CASE WHEN NEW.src_geom IS NULL THEN '00' ELSE NEW.src_geom END,
CASE WHEN NEW.src_date IS NULL THEN '0000' ELSE NEW.src_date END,
NEW.geom,
NEW.src_tronc;
NEW.id_tronc := v_id_tronc;
RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN
UPDATE
r_objet.geo_objet_troncon
SET
id_tronc=NEW.id_tronc,
id_voie_g=NEW.id_voie_g,
id_voie_d=NEW.id_voie_d,
insee_g=NEW.insee_g,
insee_d=NEW.insee_d,
noeud_d=NEW.noeud_d,
noeud_f=NEW.noeud_f,
pente=NEW.pente,
observ=NEW.observ,
src_geom=CASE WHEN NEW.src_geom IS NULL THEN '00' ELSE NEW.src_geom END,
src_date=CASE WHEN NEW.src_date IS NULL THEN '0000' ELSE NEW.src_date END,
date_maj=now(),
geom=NEW.geom,
src_tronc=NEW.src_tronc
WHERE r_objet.geo_objet_troncon.id_tronc = OLD.id_tronc;
RETURN NEW;

-- DELETE
ELSIF (TG_OP = 'DELETE') THEN
DELETE FROM r_objet.geo_objet_troncon where id_tronc = OLD.id_tronc;
RETURN OLD;

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION r_objet.ft_m_geo_objet_troncon()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION r_objet.ft_m_geo_objet_troncon() TO PUBLIC;
GRANT EXECUTE ON FUNCTION r_objet.ft_m_geo_objet_troncon() TO create_sig;
  
COMMENT ON FUNCTION r_objet.ft_m_geo_objet_troncon() IS 'Fonction trigger pour mise à jour de la classe objet troncon de voirie';



-- Trigger: r_objet.t_t1_geo_objet_troncon on m_voirie.geo_v_troncon_voirie

-- DROP TRIGGER r_objet.t_t1_geo_objet_troncon ON m_voirie.geo_v_troncon_voirie;

CREATE TRIGGER t_t1_geo_objet_troncon
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON m_voirie.geo_v_troncon_voirie
  FOR EACH ROW
  EXECUTE PROCEDURE r_objet.ft_m_geo_objet_troncon();



-- #################################################################### FONCTION TRIGGER - AN_TRONCON ###################################################

-- Function: r_voie.ft_m_an_troncon()

-- DROP FUNCTION r_voie.ft_m_an_troncon();

CREATE OR REPLACE FUNCTION r_voie.ft_m_an_troncon()
  RETURNS trigger AS
$BODY$

DECLARE v_id_tronc integer;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_id_tronc := currval('r_objet.geo_objet_troncon_id_seq'::regclass);
INSERT INTO r_voie.an_troncon (id_tronc, type_tronc, hierarchie, franchiss, nb_voie, projet, fictif)
SELECT v_id_tronc,
CASE WHEN NEW.type_tronc IS NULL THEN '00' ELSE NEW.type_tronc END,
CASE WHEN NEW.hierarchie IS NULL THEN '0' ELSE NEW.hierarchie END,
CASE WHEN NEW.franchiss IS NULL THEN '00' ELSE NEW.franchiss END,
NEW.nb_voie,
CASE WHEN NEW.projet IS NULL THEN 'f' ELSE NEW.projet END,
CASE WHEN NEW.fictif IS NULL THEN 'f' ELSE NEW.fictif END;
NEW.id_tronc := v_id_tronc;
RETURN NEW;

-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN
UPDATE
r_voie.an_troncon
SET
id_tronc=NEW.id_tronc,
type_tronc=CASE WHEN NEW.type_tronc IS NULL THEN '00' ELSE NEW.type_tronc END,
hierarchie=CASE WHEN NEW.hierarchie IS NULL THEN '0' ELSE NEW.hierarchie END,
franchiss=CASE WHEN NEW.franchiss IS NULL THEN '00' ELSE NEW.franchiss END,
nb_voie=NEW.nb_voie,
projet=CASE WHEN NEW.projet IS NULL THEN 'f' ELSE NEW.projet END,
fictif=CASE WHEN NEW.fictif IS NULL THEN 'f' ELSE NEW.fictif END,
date_maj=now()
WHERE r_voie.an_troncon.id_tronc = OLD.id_tronc;
RETURN NEW;

-- DELETE
ELSIF (TG_OP = 'DELETE') THEN
DELETE FROM r_voie.an_troncon where id_tronc = OLD.id_tronc;
RETURN OLD;

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION r_voie.ft_m_an_troncon()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION r_voie.ft_m_an_troncon() TO PUBLIC;
GRANT EXECUTE ON FUNCTION r_voie.ft_m_an_troncon() TO create_sig;

COMMENT ON FUNCTION r_voie.ft_m_an_troncon() IS 'Fonction trigger pour mise à jour de la classe alphanumérique de référence du troncon';



-- Trigger: m_voirie.t_t2_an_troncon on m_voirie.geo_v_troncon_voirie

-- DROP TRIGGER m_voirie.t_t2_an_troncon ON m_voirie.geo_v_troncon_voirie;

CREATE TRIGGER t_t2_an_troncon
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON m_voirie.geo_v_troncon_voirie
  FOR EACH ROW
  EXECUTE PROCEDURE r_voie.ft_m_an_troncon();

-- #################################################################### FONCTION TRIGGER - AN_TRONCON_H ###################################################

-- Function: m_voirie.ft_m_an_troncon_h()

-- DROP FUNCTION m_voirie.ft_m_an_troncon_h();

CREATE OR REPLACE FUNCTION m_voirie.ft_m_an_troncon_h()
  RETURNS trigger AS
$BODY$

BEGIN

-- les 2 anciens identifiants de voies sont identiques et mes 2 nouveaux sont identiques (mais différents des anciens), je stocke donc mes 2 anciens identifiants dans la table historique
IF new.h_troncon = true and old.id_voie_d = old.id_voie_g and new.id_voie_d = new.id_voie_g and old.id_voie_g <> new.id_voie_g and old.id_voie_d <> new.id_voie_d THEN

INSERT INTO r_voie.an_troncon_h (id_tronc, id_voie_g,id_voie_d, date_sai)
SELECT old.id_tronc,old.id_voie_g,old.id_voie_d,now();

END IF;

-- les 2 anciens identifiants de voies sont différents et seul le gauche change, je stocke donc l'ancien identifiant de gauche dans la table historique
IF new.h_troncon = true and old.id_voie_d <> old.id_voie_g and old.id_voie_g <> new.id_voie_g and old.id_voie_d = new.id_voie_d THEN

INSERT INTO r_voie.an_troncon_h (id_tronc, id_voie_g, date_sai)
SELECT old.id_tronc,old.id_voie_g,now();

END IF;

-- les 2 anciens identifiants de voies sont différents et seul le droite change, je stocke donc l'ancien identifiant de droite dans la table historique
IF new.h_troncon = true and old.id_voie_d <> old.id_voie_g and old.id_voie_d <> new.id_voie_d and old.id_voie_g = new.id_voie_g THEN

INSERT INTO r_voie.an_troncon_h (id_tronc, id_voie_d, date_sai)
SELECT old.id_tronc,old.id_voie_d,now();

END IF;

-- les 2 anciens identifiants de voies sont identiques et seul le gauche change, je stocke donc l'ancien identifiant de gauche dans la table historique
IF new.h_troncon = true and old.id_voie_d = old.id_voie_g and old.id_voie_g <> new.id_voie_g and old.id_voie_d = new.id_voie_d THEN

INSERT INTO r_voie.an_troncon_h (id_tronc, id_voie_g, date_sai)
SELECT old.id_tronc,old.id_voie_g,now();

END IF;

-- les 2 anciens identifiants de voies sont identiques et seul le droite change, je stocke donc l'ancien identifiant de droite dans la table historique
IF new.h_troncon = true and old.id_voie_d = old.id_voie_g and old.id_voie_d <> new.id_voie_d and old.id_voie_g = new.id_voie_g THEN

INSERT INTO r_voie.an_troncon_h (id_tronc, id_voie_d, date_sai)
SELECT old.id_tronc,old.id_voie_d,now();

END IF;

-- les 2 anciens identifiants de voies sont différents et les 2 nouveaux identifiants sont différents, je stocke donc les 2 anciens identifiant (gauche et droite) dans la table historique
IF new.h_troncon = true and old.id_voie_d <> old.id_voie_g and new.id_voie_d <> new.id_voie_g THEN

INSERT INTO r_voie.an_troncon_h (id_tronc, id_voie_g, id_voie_d, date_sai)
SELECT old.id_tronc,old.id_voie_g,old.id_voie_d,now();

END IF;

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION m_voirie.ft_m_an_troncon_h()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION m_voirie.ft_m_an_troncon_h() TO PUBLIC;
GRANT EXECUTE ON FUNCTION m_voirie.ft_m_an_troncon_h() TO create_sig;

COMMENT ON FUNCTION m_voirie.ft_m_an_troncon_h() IS 'Fonction trigger pour insertion de l''historisation des voies au tronçon dans la classe d''objet an_troncon_h';




-- Trigger: m_voirie.t_t3_an_troncon_h on m_voirie.geo_v_troncon_voirie

-- DROP TRIGGER m_voirie.t_t3_an_troncon_h ON m_voirie.geo_v_troncon_voirie;

CREATE TRIGGER t_t3_an_troncon_h
  INSTEAD OF UPDATE
  ON m_voirie.geo_v_troncon_voirie
  FOR EACH ROW
  EXECUTE PROCEDURE m_voirie.ft_m_an_troncon_h();



-- #################################################################### FONCTION TRIGGER - AN_VOIRIE_CIRCU ###################################################

-- Function: m_voirie.ft_m_an_voirie_circu()

-- DROP FUNCTION m_voirie.ft_m_an_voirie_circu();

CREATE OR REPLACE FUNCTION m_voirie.ft_m_an_voirie_circu()
  RETURNS trigger AS
$BODY$

DECLARE v_id_tronc integer;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_id_tronc := currval('r_objet.geo_objet_troncon_id_seq'::regclass);
INSERT INTO m_voirie.an_voirie_circu (id_tronc,type_circu, sens_circu, v_max, observ, c_circu, c_observ, date_ouv)
SELECT v_id_tronc,
CASE WHEN NEW.type_circu IS NULL THEN '00' ELSE NEW.type_circu END,
CASE WHEN NEW.sens_circu IS NULL THEN '00' ELSE NEW.sens_circu END,
CASE WHEN NEW.v_max IS NULL THEN '000' ELSE NEW.v_max END,
NEW.observ,

NEW.c_circu,
CASE 
WHEN NEW.c_observ like '%h:%' THEN replace(NEW.c_observ,'h:','H:')
WHEN NEW.c_observ like '%hauteur:%' THEN replace(NEW.c_observ,'hauteur:','H:')
WHEN NEW.c_observ like '%Hauteur:%' THEN replace(NEW.c_observ,'Hauteur:','H:')
WHEN NEW.c_observ like '%HAUTEUR:%' THEN replace(NEW.c_observ,'HAUTEUR:','H:')
WHEN NEW.c_observ like '%l:%' THEN replace(NEW.c_observ,'l:','L:')
WHEN NEW.c_observ like '%largeur:%' THEN replace(NEW.c_observ,'largeur:','L:')
WHEN NEW.c_observ like '%Largeur:%' THEN replace(NEW.c_observ,'Largeur:','L:')
WHEN NEW.c_observ like '%LARGEUR:%' THEN replace(NEW.c_observ,'LARGEUR:','L:')
WHEN NEW.c_observ like '%p:%' THEN replace(NEW.c_observ,'p:','P:')
WHEN NEW.c_observ like '%poids:%' THEN replace(NEW.c_observ,'poids:','P:')
WHEN NEW.c_observ like '%Poids:%' THEN replace(NEW.c_observ,'Poids:','P:')
WHEN NEW.c_observ like '%POIDS:%' THEN replace(NEW.c_observ,'POIDS:','P:')
WHEN NEW.c_observ like '%poid:%' THEN replace(NEW.c_observ,'poid:','P:')
WHEN NEW.c_observ like '%Poid:%' THEN replace(NEW.c_observ,'Poid:','P:')
WHEN NEW.c_observ like '%POID:%' THEN replace(NEW.c_observ,'POID:','P:')
WHEN NEW.c_observ like '%tv:%' THEN replace(NEW.c_observ,'tv:','Tv:')
WHEN NEW.c_observ like '%TV:%' THEN replace(NEW.c_observ,'TV:','Tv:')
WHEN NEW.c_observ like '%type de véhicule:%' THEN replace(NEW.c_observ,'type de véhicule:','Tv:')
WHEN NEW.c_observ like '%Type de véhicule:%' THEN replace(NEW.c_observ,'Type de véhicule:','Tv:')
WHEN NEW.c_observ like '%type de véhicules:%' THEN replace(NEW.c_observ,'type de véhicules:','Tv:')
WHEN NEW.c_observ like '%Type de véhicules:%' THEN replace(NEW.c_observ,'Type de véhicules:','Tv:')
WHEN NEW.c_observ like '%TYPE DE VEHICULE:%' THEN replace(NEW.c_observ,'TYPE DE VEHICULE:','Tv:')
WHEN NEW.c_observ like '%TYPE DE VEHICULES:%' THEN replace(NEW.c_observ,'TYPE DE VEHICULES:','Tv:')
WHEN NEW.c_observ like '%type véhicules:%' THEN replace(NEW.c_observ,'type véhicules:','Tv:')
WHEN NEW.c_observ like '%Type véhicules:%' THEN replace(NEW.c_observ,'Type véhicules:','Tv:')
WHEN NEW.c_observ like '%TYPE VEHICULE:%' THEN replace(NEW.c_observ,'TYPE VEHICULE:','Tv:')
WHEN NEW.c_observ like '%TYPE VEHICULES:%' THEN replace(NEW.c_observ,'TYPE VEHICULES:','Tv:')
WHEN NEW.c_observ like '%.%' THEN replace(NEW.c_observ,'.',',')
ELSE
NEW.c_observ
END
,

NEW.date_ouv
;
NEW.id_tronc := v_id_tronc;
RETURN NEW;

-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN
UPDATE
m_voirie.an_voirie_circu
SET
id_tronc=NEW.id_tronc,
type_circu=CASE WHEN NEW.type_circu IS NULL THEN '00' ELSE NEW.type_circu END,
sens_circu=CASE WHEN NEW.sens_circu IS NULL THEN '00' ELSE NEW.sens_circu END,
v_max=CASE WHEN NEW.v_max IS NULL THEN '000' ELSE NEW.v_max END,
observ=NEW.observ,
date_maj=now(),
c_circu=NEW.c_circu,
c_observ=
CASE 
WHEN NEW.c_observ like '%h:%' THEN replace(NEW.c_observ,'h:','H:')
WHEN NEW.c_observ like '%hauteur:%' THEN replace(NEW.c_observ,'hauteur:','H:')
WHEN NEW.c_observ like '%Hauteur:%' THEN replace(NEW.c_observ,'Hauteur:','H:')
WHEN NEW.c_observ like '%HAUTEUR:%' THEN replace(NEW.c_observ,'HAUTEUR:','H:')
WHEN NEW.c_observ like '%l:%' THEN replace(NEW.c_observ,'l:','L:')
WHEN NEW.c_observ like '%largeur:%' THEN replace(NEW.c_observ,'largeur:','L:')
WHEN NEW.c_observ like '%Largeur:%' THEN replace(NEW.c_observ,'Largeur:','L:')
WHEN NEW.c_observ like '%LARGEUR:%' THEN replace(NEW.c_observ,'LARGEUR:','L:')
WHEN NEW.c_observ like '%p:%' THEN replace(NEW.c_observ,'p:','P:')
WHEN NEW.c_observ like '%poids:%' THEN replace(NEW.c_observ,'poids:','P:')
WHEN NEW.c_observ like '%Poids:%' THEN replace(NEW.c_observ,'Poids:','P:')
WHEN NEW.c_observ like '%POIDS:%' THEN replace(NEW.c_observ,'POIDS:','P:')
WHEN NEW.c_observ like '%poid:%' THEN replace(NEW.c_observ,'poid:','P:')
WHEN NEW.c_observ like '%Poid:%' THEN replace(NEW.c_observ,'Poid:','P:')
WHEN NEW.c_observ like '%POID:%' THEN replace(NEW.c_observ,'POID:','P:')
WHEN NEW.c_observ like '%tv:%' THEN replace(NEW.c_observ,'tv:','Tv:')
WHEN NEW.c_observ like '%TV:%' THEN replace(NEW.c_observ,'TV:','Tv:')
WHEN NEW.c_observ like '%type de véhicule:%' THEN replace(NEW.c_observ,'type de véhicule:','Tv:')
WHEN NEW.c_observ like '%Type de véhicule:%' THEN replace(NEW.c_observ,'Type de véhicule:','Tv:')
WHEN NEW.c_observ like '%type de véhicules:%' THEN replace(NEW.c_observ,'type de véhicules:','Tv:')
WHEN NEW.c_observ like '%Type de véhicules:%' THEN replace(NEW.c_observ,'Type de véhicules:','Tv:')
WHEN NEW.c_observ like '%TYPE DE VEHICULE:%' THEN replace(NEW.c_observ,'TYPE DE VEHICULE:','Tv:')
WHEN NEW.c_observ like '%TYPE DE VEHICULES:%' THEN replace(NEW.c_observ,'TYPE DE VEHICULES:','Tv:')
WHEN NEW.c_observ like '%type véhicules:%' THEN replace(NEW.c_observ,'type véhicules:','Tv:')
WHEN NEW.c_observ like '%Type véhicules:%' THEN replace(NEW.c_observ,'Type véhicules:','Tv:')
WHEN NEW.c_observ like '%TYPE VEHICULE:%' THEN replace(NEW.c_observ,'TYPE VEHICULE:','Tv:')
WHEN NEW.c_observ like '%TYPE VEHICULES:%' THEN replace(NEW.c_observ,'TYPE VEHICULES:','Tv:')
WHEN NEW.c_observ like '%.%' THEN replace(NEW.c_observ,'.',',')
ELSE
NEW.c_observ
END
 ,
 
date_ouv=NEW.date_ouv
WHERE m_voirie.an_voirie_circu.id_tronc = OLD.id_tronc;
RETURN NEW;

-- DELETE
ELSIF (TG_OP = 'DELETE') THEN
DELETE FROM m_voirie.an_voirie_circu where id_tronc = OLD.id_tronc;
RETURN OLD;

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION m_voirie.ft_m_an_voirie_circu()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION m_voirie.ft_m_an_voirie_circu() TO PUBLIC;
GRANT EXECUTE ON FUNCTION m_voirie.ft_m_an_voirie_circu() TO create_sig;

COMMENT ON FUNCTION m_voirie.ft_m_an_voirie_circu() IS 'Fonction trigger pour mise à jour de la classe métier sur la circulation';



-- Trigger: m_voirie.t_t2_an_voirie_circu on m_voirie.geo_v_troncon_voirie

-- DROP TRIGGER m_voirie.t_t2_an_voirie_circu ON m_voirie.geo_v_troncon_voirie;

CREATE TRIGGER t_t2_an_voirie_circu
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON m_voirie.geo_v_troncon_voirie
  FOR EACH ROW
  EXECUTE PROCEDURE m_voirie.ft_m_an_voirie_circu();



-- #################################################################### FONCTION TRIGGER - AN_VOIRIE_GEST ###################################################

-- Function: m_voirie.ft_m_an_voirie_gest()

-- DROP FUNCTION m_voirie.ft_m_an_voirie_gest();

CREATE OR REPLACE FUNCTION m_voirie.ft_m_an_voirie_gest()
  RETURNS trigger AS
$BODY$

DECLARE v_id_tronc integer;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_id_tronc := currval('r_objet.geo_objet_troncon_id_seq'::regclass);
INSERT INTO m_voirie.an_voirie_gest (id_tronc, statut_jur, num_statut, gestion, doman, proprio, observ, date_rem)
SELECT v_id_tronc,
CASE WHEN NEW.statut_jur IS NULL THEN '00' ELSE NEW.statut_jur END,
NEW.num_statut,
CASE WHEN NEW.gestion IS NULL THEN '00' ELSE NEW.gestion END,
CASE WHEN NEW.doman IS NULL THEN '00' ELSE NEW.doman END,
CASE WHEN NEW.proprio IS NULL THEN '00' ELSE NEW.proprio END,
NEW.observ,
NEW.date_rem;
NEW.id_tronc := v_id_tronc;
RETURN NEW;

-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN
UPDATE
m_voirie.an_voirie_gest
SET
id_tronc=NEW.id_tronc,
statut_jur=CASE WHEN NEW.statut_jur IS NULL THEN '00' ELSE NEW.statut_jur END,
num_statut=NEW.num_statut,
gestion=CASE WHEN NEW.gestion IS NULL THEN '00' ELSE NEW.gestion END,
doman=CASE WHEN NEW.doman IS NULL THEN '00' ELSE NEW.doman END,
proprio=CASE WHEN NEW.proprio IS NULL THEN '00' ELSE NEW.proprio END,
observ=NEW.observ,
date_rem=NEW.date_rem,
date_maj=now()
WHERE m_voirie.an_voirie_gest.id_tronc = OLD.id_tronc;
RETURN NEW;

-- DELETE
ELSIF (TG_OP = 'DELETE') THEN
DELETE FROM m_voirie.an_voirie_gest where id_tronc = OLD.id_tronc;
RETURN OLD;

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION m_voirie.ft_m_an_voirie_gest()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION m_voirie.ft_m_an_voirie_gest() TO PUBLIC;
GRANT EXECUTE ON FUNCTION m_voirie.ft_m_an_voirie_gest() TO create_sig;

COMMENT ON FUNCTION m_voirie.ft_m_an_voirie_gest() IS 'Fonction trigger pour mise à jour de la classe métier sur la gestion de la voirie';




-- Trigger: m_voirie.t_t2_an_voirie_gest on m_voirie.geo_v_troncon_voirie

-- DROP TRIGGER m_voirie.t_t2_an_voirie_gest ON m_voirie.geo_v_troncon_voirie;

CREATE TRIGGER t_t2_an_voirie_gest
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON m_voirie.geo_v_troncon_voirie
  FOR EACH ROW
  EXECUTE PROCEDURE m_voirie.ft_m_an_voirie_gest();






-- #################################################################### FONCTION TRIGGER - INSEE_G/D / MAJ TRONCON ###################################################

-- Function: r_objet.ft_r_troncon_maj_insee_gd()

-- DROP FUNCTION r_objet.ft_r_troncon_maj_insee_gd();

CREATE OR REPLACE FUNCTION r_objet.ft_r_troncon_maj_insee_gd()
  RETURNS trigger AS
$BODY$BEGIN

IF NEW.insee_g IS NULL AND NEW.insee_d IS NULL THEN
SELECT INTO new.insee_g insee FROM r_osm.geo_v_osm_commune_oise WHERE st_intersects(new.geom,geom);
SELECT INTO new.insee_d insee FROM r_osm.geo_v_osm_commune_oise WHERE st_intersects(new.geom,geom);
RETURN NEW;
ELSEIF NEW.insee_g IS NULL AND NEW.insee_d IS NOT NULL THEN
SELECT INTO new.insee_g insee FROM r_osm.geo_v_osm_commune_oise WHERE st_intersects(new.geom,geom);
RETURN NEW;
ELSEIF NEW.insee_g IS NOT NULL AND NEW.insee_d IS NULL THEN
SELECT INTO new.insee_d insee FROM r_osm.geo_v_osm_commune_oise WHERE st_intersects(new.geom,geom);
RETURN NEW;
ELSEIF NEW.insee_g IS NOT NULL AND NEW.insee_d IS NOT NULL THEN
RETURN NEW;
END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION r_objet.ft_r_troncon_maj_insee_gd()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION r_objet.ft_r_troncon_maj_insee_gd() TO PUBLIC;
GRANT EXECUTE ON FUNCTION r_objet.ft_r_troncon_maj_insee_gd() TO create_sig;

COMMENT ON FUNCTION r_objet.ft_r_troncon_maj_insee_gd() IS 'Fonction dont l''objet est de recupérer par croisement géographique, le code insee de la commune à partir de la vue référence r_osm.geo_osm_commune_oise dans le cas où  l''utilisateur laisse les champs insee_g et d "null"';



-- #################################################################### TRIGGER - INSEE_G/D  ###################################################

-- Trigger: t_t3_maj_insee_gd on r_objet.geo_objet_troncon

-- DROP TRIGGER t_t3_maj_insee_gd ON r_objet.geo_objet_troncon;

CREATE TRIGGER t_t3_maj_insee_gd
  BEFORE INSERT OR UPDATE OF insee_g, insee_d, geom
  ON r_objet.geo_objet_troncon
  FOR EACH ROW
  EXECUTE PROCEDURE r_objet.ft_r_troncon_maj_insee_gd();


-- #################################################################### FONCTION TRIGGER - INSERT GEOM NOEUD PAR OPERATION SUR TRONCON ###################################################


-- Function: r_objet.ft_r_noeud_insert()

-- DROP FUNCTION r_objet.ft_r_noeud_insert();

CREATE OR REPLACE FUNCTION r_objet.ft_r_noeud_insert()
  RETURNS trigger AS
$BODY$

DECLARE v_noeud_d integer;
DECLARE v_noeud_f integer;

BEGIN
	-- si la table des noeuds ne contient pas le noeud de départ du tronçon alors insert un nouveau noeud si non on ne fait rien
	if (select count(*) from r_objet.geo_objet_noeud where st_contains(st_startpoint(new.geom),geom)) = 0 THEN
		v_noeud_d := nextval('r_objet.geo_objet_noeud_id_seq'::regclass);
		INSERT INTO r_objet.geo_objet_noeud (id_noeud,geom) SELECT v_noeud_d, st_startpoint(new.geom);
		new.noeud_d := v_noeud_d;
	ELSE
		new.noeud_d := (select id_noeud from r_objet.geo_objet_noeud where st_contains(st_startpoint(new.geom),geom) is true);
	END IF;
	-- si la table des noeuds ne contient pas le noeud de fin du tronçon alors insert un nouveau noeud si non on ne fait rien
	if (select count(*) from r_objet.geo_objet_noeud where st_contains(st_endpoint(new.geom),geom)) = 0 THEN
		v_noeud_f := nextval('r_objet.geo_objet_noeud_id_seq'::regclass);
		INSERT INTO r_objet.geo_objet_noeud (id_noeud,geom) SELECT v_noeud_f, st_endpoint(new.geom);
		new.noeud_f := v_noeud_f;
	ELSE
		new.noeud_f := (select id_noeud from r_objet.geo_objet_noeud where st_contains(st_endpoint(new.geom),geom) is true);
	END IF;
	
  return new ;

END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION r_objet.ft_r_noeud_insert()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION r_objet.ft_r_noeud_insert() TO PUBLIC;
GRANT EXECUTE ON FUNCTION r_objet.ft_r_noeud_insert() TO create_sig;

-- ** TRIGGER **
  
-- Trigger: t_t1_noeud_insert on r_objet.geo_objet_troncon

-- DROP TRIGGER t_t1_noeud_insert ON r_objet.geo_objet_troncon;

CREATE TRIGGER t_t1_noeud_insert
  BEFORE INSERT OR UPDATE OF geom
  ON r_objet.geo_objet_troncon
  FOR EACH ROW
  EXECUTE PROCEDURE r_objet.ft_r_noeud_insert();
COMMENT ON TRIGGER t_t1_noeud_insert ON r_objet.geo_objet_troncon IS 'Déclencheur s''activant avant l''insertion ou la mise à jour et permettant de créer les noeuds du tronçon uniquement si il n''existe pas de noeuds déjà saisies. La mise à jour d''un tronçon en géométrie implique la suppression du noeud n''appartenant plus à aucun tronçon et la création d''un nouveau noeud si il en existe aucun.
Ce déclencheur nécessite un enregistrement à chaque saisie ou mise à jour.';


-- #################################################################### FONCTION TRIGGER - SUP GEOM NOEUD PAR OPERATION SUR TRONCON ###################################################


-- Function: r_objet.ft_r_noeud_sup()

-- DROP FUNCTION r_objet.ft_r_noeud_sup();

CREATE OR REPLACE FUNCTION r_objet.ft_r_noeud_sup()
  RETURNS trigger AS
$BODY$

BEGIN
	-- si il n'y a aucun noeud dans la table des noeuds alors je supprime tout (ne sert que si il n'y a plus de tronçons dans la tables des tronçons)
        IF (SELECT count(*) FROM r_objet.geo_objet_troncon) = 0 THEN
		DELETE FROM r_objet.geo_objet_noeud;
	-- si il y a des noeuds alors
	ELSE
	-- suppression des noeuds qui ne font plus partie d'un noeud de début et de fin dans la table tronçon
	DELETE FROM r_objet.geo_objet_noeud where id_noeud not in (select noeud_d from r_objet.geo_objet_troncon) and id_noeud not in (select noeud_f from r_objet.geo_objet_troncon);
	END IF;

  return new ;

END;


$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION r_objet.ft_r_noeud_sup()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION r_objet.ft_r_noeud_sup() TO PUBLIC;
GRANT EXECUTE ON FUNCTION r_objet.ft_r_noeud_sup() TO create_sig;


-- ** TRIGGER **

-- Trigger: t_t2_noeud_sup on r_objet.geo_objet_troncon

-- DROP TRIGGER t_t2_noeud_sup ON r_objet.geo_objet_troncon;

CREATE TRIGGER t_t2_noeud_sup
  AFTER UPDATE OF geom OR DELETE
  ON r_objet.geo_objet_troncon
  FOR EACH ROW
  EXECUTE PROCEDURE r_objet.ft_r_noeud_sup();
COMMENT ON TRIGGER t_t2_noeud_sup ON r_objet.geo_objet_troncon IS 'Déclencheur s''activant après la suppression ou la mise à jour des géométries des tronçons et permettant de supprimer les noeuds n''étant plus lié (alphanumériquement) à un tronçon.
Ce déclencheur nécessite un enregistrement à chaque suppression ou mise à jour.';




-- #################################################################### TRIGGER - AN_VOIE rivoli  ###################################################

									   
-- FUNCTION: r_voie.ft_m_an_voie_gestion()

-- DROP FUNCTION r_voie.ft_m_an_voie_gestion();

CREATE FUNCTION r_voie.ft_m_an_voie_gestion()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

BEGIN

-- INSERT OR UPDATE
IF (TG_OP = 'INSERT') OR (TG_OP = 'UPDATE') THEN

-- le code RIVOLI doit être renseigné et pas à 0000 dans la classe an_voie
IF NEW.rivoli IS null OR NEW.rivoli = '0000' OR NEW.rivoli = '' THEN
RAISE EXCEPTION 'Code RIVOLI null ou égal à 0000. Veuillez corriger votre saisie.';
END IF;

-- si saisie d'un rivoli provisoire, doit correspondre au x +1
									   
IF NEW.rivoli <> OLD.rivoli THEN
IF NEW.rivoli like 'x%' THEN

IF NEW.rivoli <> 'x' || (SELECT max(substring(rivoli from 2 for 3))::integer +1 FROM r_voie.an_voie WHERE rivoli like 'x%' AND insee = NEW.insee) THEN
RAISE EXCEPTION 'Code RIVOLI non correct. Vous n''avez pas saisi le n° d''ordre correspondant';
END IF;
END IF;
END IF;

-- si doublon dans le code RIVOLI erreur
IF NEW.rivoli <> OLD.rivoli THEN
IF NEW.rivoli IN (SELECT rivoli FROM r_voie.an_voie WHERE insee = NEW.insee) THEN
RAISE EXCEPTION 'Vous saisissez un code RIVOLI déjà présent sur la commune. Veuillez vérifier votre saisie pour poursuivre.';
END IF;
END IF;

END IF;

RETURN NEW;

END;
$BODY$;

ALTER FUNCTION r_voie.ft_m_an_voie_gestion()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION r_voie.ft_m_an_voie_gestion() TO PUBLIC;
GRANT EXECUTE ON FUNCTION r_voie.ft_m_an_voie_gestion() TO create_sig;

COMMENT ON FUNCTION r_voie.ft_m_an_voie_gestion()
    IS 'Fonction trigger pour vérifier si la saisie des codes RIVOLI est correcte';
									   
									   
-- Trigger: t1_verif_rivoli

-- DROP TRIGGER t1_verif_rivoli ON r_voie.an_voie;

CREATE TRIGGER t1_verif_rivoli
    BEFORE INSERT OR UPDATE 
    ON r_voie.an_voie
    FOR EACH ROW
    EXECUTE PROCEDURE r_voie.ft_m_an_voie_gestion();									   
									   
-- Trigger: t2_date_maj on r_voie.an_voie

-- DROP TRIGGER t2_date_maj on r_voie.an_voie;

CREATE TRIGGER t2_date_maj
  BEFORE UPDATE
  ON r_voie.an_voie
  FOR EACH ROW
  EXECUTE PROCEDURE public.r_timestamp_maj();


				    
				    
  
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                             VUES APPLICATIVES                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- View: x_apps.xapps_an_voie

-- DROP VIEW x_apps.xapps_an_voie;

CREATE OR REPLACE VIEW x_apps.xapps_an_voie AS 
 SELECT v.id_voie,
    v.libvoie_c,
    c.commune
   FROM r_voie.an_voie v,
    r_osm.geo_osm_commune c
  WHERE v.insee = c.insee::bpchar;

ALTER TABLE x_apps.xapps_an_voie
    OWNER TO create_sig;
				    
COMMENT ON VIEW x_apps.xapps_an_voie
    IS 'Vue d''exploitation des libellés de voie par commune';

GRANT ALL ON TABLE x_apps.xapps_an_voie TO sig_create;
GRANT SELECT ON TABLE x_apps.xapps_an_voie TO sig_read;
GRANT ALL ON TABLE x_apps.xapps_an_voie TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE x_apps.xapps_an_voie TO sig_edit;


-- View: x_apps.xapps_geo_v_troncon_voirie

-- DROP MATERIALIZED VIEW x_apps.xapps_geo_vmr_troncon_voirie;

CREATE MATERIALIZED VIEW x_apps.xapps_geo_vmr_troncon_voirie
TABLESPACE pg_default
AS
 WITH req_v AS (
         SELECT t.id_tronc,
            t.id_voie_g AS id_voie,
            v_1.libvoie_c AS libvoie,
            v_1.date_lib,
            v_1.rivoli,
            t.insee_g AS insee,
            com.commune,
            t.noeud_d,
            t.noeud_f,
            ltb.valeur AS type_tronc,
            ltc.valeur AS hierarchie,
            ltd.valeur AS franchiss,
            a.nb_voie,
            a.projet,
            a.fictif,
            lte.valeur AS statut_jur,
            g.num_statut,
            ltg.valeur AS gestion,
            ltf.valeur AS doman,
            lth.valeur AS proprio,
            lti.valeur AS type_circu,
            ltj.valeur AS sens_circu,
            ltk.valeur AS v_max,
            (((
                CASE
                    WHEN c.c_circu::text ~~ '%10%'::text AND c.c_observ::text ~~ '%H:%'::text THEN ('Hauteur : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'H:'::text) + 2, "position"(c.c_observ::text, 'm'::text) - "position"(c.c_observ::text, 'H:'::text) - 1)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%10%'::text THEN 'Hauteur : non renseignée <br>'::text
                        ELSE ''::text
                    END
                END ||
                CASE
                    WHEN c.c_circu::text ~~ '%20%'::text AND c.c_observ::text ~~ '%L:%'::text THEN ('Largeur : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'L:'::text) + 2,
                    CASE
                        WHEN ("position"(c.c_observ::text, 'm'::text) - "position"(c.c_observ::text, 'L:'::text) - 1) < 0 THEN
                        CASE
                            WHEN "substring"(c.c_observ::text, "position"(c.c_observ::text, 'L:'::text) + 2, 4) ~~ '%,%'::text THEN 4
                            ELSE 2
                        END
                        ELSE "position"(c.c_observ::text, 'm'::text) - "position"(c.c_observ::text, 'L:'::text) - 1
                    END)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%20%'::text THEN 'Largeur : non renseignée <br>'::text
                        ELSE ''::text
                    END
                END) ||
                CASE
                    WHEN c.c_circu::text ~~ '%30%'::text AND c.c_observ::text ~~ '%P:%'::text THEN ('Poids : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'P:'::text) + 2, "position"(c.c_observ::text, 't'::text) - "position"(c.c_observ::text, 'P:'::text) - 1)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%30%'::text THEN 'Poids : non renseigné <br>'::text
                        ELSE ''::text
                    END
                END) ||
                CASE
                    WHEN c.c_circu::text ~~ '%40%'::text THEN 'Interdit aux transports de matières dangereuses'::text
                    ELSE ''::text
                END) ||
                CASE
                    WHEN c.c_circu::text ~~ '%50%'::text AND c.c_observ::text ~~ '%Tv:%'::text THEN ('Type de véhicule : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'Tv:'::text) + 3)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%50%'::text THEN 'Type de véhicule : non renseigné<br>'::text
                        ELSE ''::text
                    END
                END AS c_circu,
            c.c_observ,
            c.date_ouv,
            g.date_rem,
            t.pente,
            t.observ,
            lta.valeur AS src_geom,
            t.src_date,
            t.date_sai,
            t.date_maj,
            t.src_tronc,
            t.geom
           FROM r_objet.geo_objet_troncon t
             LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
             LEFT JOIN r_voie.an_voie v_1 ON v_1.id_voie = t.id_voie_g
             LEFT JOIN m_voirie.an_voirie_gest g ON g.id_tronc = t.id_tronc
             LEFT JOIN m_voirie.an_voirie_circu c ON c.id_tronc = t.id_tronc
             LEFT JOIN r_osm.geo_osm_commune com ON t.insee_g::text = com.insee::text
             LEFT JOIN r_objet.lt_src_geom lta ON lta.code::text = t.src_geom::text
             LEFT JOIN r_voie.lt_type_tronc ltb ON ltb.code::text = a.type_tronc::text
             LEFT JOIN r_voie.lt_hierarchie ltc ON ltc.code::text = a.hierarchie::text
             LEFT JOIN r_voie.lt_franchiss ltd ON ltd.code::text = a.franchiss::text
             LEFT JOIN m_voirie.lt_statut_jur lte ON lte.code::text = g.statut_jur::text
             LEFT JOIN m_voirie.lt_doman ltf ON ltf.code::text = g.doman::text
             LEFT JOIN m_voirie.lt_gestion ltg ON ltg.code::text = g.gestion::text
             LEFT JOIN m_voirie.lt_gestion lth ON lth.code::text = g.proprio::text
             LEFT JOIN m_voirie.lt_type_circu lti ON lti.code::text = c.type_circu::text
             LEFT JOIN m_voirie.lt_sens_circu ltj ON ltj.code::text = c.sens_circu::text
             LEFT JOIN m_voirie.lt_v_max ltk ON ltk.code::text = c.v_max::text
          WHERE t.insee_g::text = t.insee_d::text
        UNION ALL
         SELECT t.id_tronc,
            t.id_voie_g AS id_voie,
            v_1.libvoie_c AS libvoie,
            v_1.date_lib,
            v_1.rivoli,
            t.insee_g AS insee,
            com.commune,
            t.noeud_d,
            t.noeud_f,
            ltb.valeur AS type_tronc,
            ltc.valeur AS hierarchie,
            ltd.valeur AS franchiss,
            a.nb_voie,
            a.projet,
            a.fictif,
            lte.valeur AS statut_jur,
            g.num_statut,
            ltg.valeur AS gestion,
            ltf.valeur AS doman,
            lth.valeur AS proprio,
            lti.valeur AS type_circu,
            ltj.valeur AS sens_circu,
            ltk.valeur AS v_max,
            (((
                CASE
                    WHEN c.c_circu::text ~~ '%10%'::text AND c.c_observ::text ~~ '%H:%'::text THEN ('Hauteur : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'H:'::text) + 2, "position"(c.c_observ::text, 'm'::text) - "position"(c.c_observ::text, 'H:'::text) - 1)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%10%'::text THEN 'Hauteur : non renseignée <br>'::text
                        ELSE ''::text
                    END
                END ||
                CASE
                    WHEN c.c_circu::text ~~ '%20%'::text AND c.c_observ::text ~~ '%L:%'::text THEN ('Largeur : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'L:'::text) + 2,
                    CASE
                        WHEN ("position"(c.c_observ::text, 'm'::text) - "position"(c.c_observ::text, 'L:'::text) - 1) < 0 THEN
                        CASE
                            WHEN "substring"(c.c_observ::text, "position"(c.c_observ::text, 'L:'::text) + 2, 4) ~~ '%,%'::text THEN 4
                            ELSE 2
                        END
                        ELSE "position"(c.c_observ::text, 'm'::text) - "position"(c.c_observ::text, 'L:'::text) - 1
                    END)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%20%'::text THEN 'Largeur : non renseignée <br>'::text
                        ELSE ''::text
                    END
                END) ||
                CASE
                    WHEN c.c_circu::text ~~ '%30%'::text AND c.c_observ::text ~~ '%P:%'::text THEN ('Poids : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'P:'::text) + 2, "position"(c.c_observ::text, 't'::text) - "position"(c.c_observ::text, 'P:'::text) - 1)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%30%'::text THEN 'Poids : non renseigné <br>'::text
                        ELSE ''::text
                    END
                END) ||
                CASE
                    WHEN c.c_circu::text ~~ '%40%'::text THEN 'Interdit aux transports de matières dangereuses'::text
                    ELSE ''::text
                END) ||
                CASE
                    WHEN c.c_circu::text ~~ '%50%'::text AND c.c_observ::text ~~ '%Tv:%'::text THEN ('Type de véhicule : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'Tv:'::text) + 3)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%50%'::text THEN 'Type de véhicule : non renseigné<br>'::text
                        ELSE ''::text
                    END
                END AS c_circu,
            c.c_observ,
            c.date_ouv,
            g.date_rem,
            t.pente,
            t.observ,
            lta.valeur AS src_geom,
            t.src_date,
            t.date_sai,
            t.date_maj,
            t.src_tronc,
            t.geom
           FROM r_objet.geo_objet_troncon t
             LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
             LEFT JOIN r_voie.an_voie v_1 ON v_1.id_voie = t.id_voie_g
             LEFT JOIN m_voirie.an_voirie_gest g ON g.id_tronc = t.id_tronc
             LEFT JOIN m_voirie.an_voirie_circu c ON c.id_tronc = t.id_tronc
             LEFT JOIN r_osm.geo_osm_commune com ON t.insee_g::text = com.insee::text
             LEFT JOIN r_objet.lt_src_geom lta ON lta.code::text = t.src_geom::text
             LEFT JOIN r_voie.lt_type_tronc ltb ON ltb.code::text = a.type_tronc::text
             LEFT JOIN r_voie.lt_hierarchie ltc ON ltc.code::text = a.hierarchie::text
             LEFT JOIN r_voie.lt_franchiss ltd ON ltd.code::text = a.franchiss::text
             LEFT JOIN m_voirie.lt_statut_jur lte ON lte.code::text = g.statut_jur::text
             LEFT JOIN m_voirie.lt_doman ltf ON ltf.code::text = g.doman::text
             LEFT JOIN m_voirie.lt_gestion ltg ON ltg.code::text = g.gestion::text
             LEFT JOIN m_voirie.lt_gestion lth ON lth.code::text = g.proprio::text
             LEFT JOIN m_voirie.lt_type_circu lti ON lti.code::text = c.type_circu::text
             LEFT JOIN m_voirie.lt_sens_circu ltj ON ltj.code::text = c.sens_circu::text
             LEFT JOIN m_voirie.lt_v_max ltk ON ltk.code::text = c.v_max::text
          WHERE t.insee_g::text <> t.insee_d::text
        UNION ALL
         SELECT t.id_tronc,
            t.id_voie_d AS id_voie,
            v_1.libvoie_c AS libvoie,
            v_1.date_lib,
            v_1.rivoli,
            t.insee_d AS insee,
            com.commune,
            t.noeud_d,
            t.noeud_f,
            ltb.valeur AS type_tronc,
            ltc.valeur AS hierarchie,
            ltd.valeur AS franchiss,
            a.nb_voie,
            a.projet,
            a.fictif,
            lte.valeur AS statut_jur,
            g.num_statut,
            ltg.valeur AS gestion,
            ltf.valeur AS doman,
            lth.valeur AS proprio,
            lti.valeur AS type_circu,
            ltj.valeur AS sens_circu,
            ltk.valeur AS v_max,
            (((
                CASE
                    WHEN c.c_circu::text ~~ '%10%'::text AND c.c_observ::text ~~ '%H:%'::text THEN ('Hauteur : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'H:'::text) + 2, "position"(c.c_observ::text, 'm'::text) - "position"(c.c_observ::text, 'H:'::text) - 1)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%10%'::text THEN 'Hauteur : non renseignée <br>'::text
                        ELSE ''::text
                    END
                END ||
                CASE
                    WHEN c.c_circu::text ~~ '%20%'::text AND c.c_observ::text ~~ '%L:%'::text THEN ('Largeur : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'L:'::text) + 2,
                    CASE
                        WHEN ("position"(c.c_observ::text, 'm'::text) - "position"(c.c_observ::text, 'L:'::text) - 1) < 0 THEN
                        CASE
                            WHEN "substring"(c.c_observ::text, "position"(c.c_observ::text, 'L:'::text) + 2, 4) ~~ '%,%'::text THEN 4
                            ELSE 2
                        END
                        ELSE "position"(c.c_observ::text, 'm'::text) - "position"(c.c_observ::text, 'L:'::text) - 1
                    END)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%20%'::text THEN 'Largeur : non renseignée <br>'::text
                        ELSE ''::text
                    END
                END) ||
                CASE
                    WHEN c.c_circu::text ~~ '%30%'::text AND c.c_observ::text ~~ '%P:%'::text THEN ('Poids : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'P:'::text) + 2, "position"(c.c_observ::text, 't'::text) - "position"(c.c_observ::text, 'P:'::text) - 1)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%30%'::text THEN 'Poids : non renseigné <br>'::text
                        ELSE ''::text
                    END
                END) ||
                CASE
                    WHEN c.c_circu::text ~~ '%40%'::text THEN 'Interdit aux transports de matières dangereuses'::text
                    ELSE ''::text
                END) ||
                CASE
                    WHEN c.c_circu::text ~~ '%50%'::text AND c.c_observ::text ~~ '%Tv:%'::text THEN ('Type de véhicule : '::text || "substring"(c.c_observ::text, "position"(c.c_observ::text, 'Tv:'::text) + 3)) || '<br>'::text
                    ELSE
                    CASE
                        WHEN c.c_circu::text ~~ '%50%'::text THEN 'Type de véhicule : non renseigné<br>'::text
                        ELSE ''::text
                    END
                END AS c_circu,
            c.c_observ,
            c.date_ouv,
            g.date_rem,
            t.pente,
            t.observ,
            lta.valeur AS src_geom,
            t.src_date,
            t.date_sai,
            t.date_maj,
            t.src_tronc,
            t.geom
           FROM r_objet.geo_objet_troncon t
             LEFT JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
             LEFT JOIN r_voie.an_voie v_1 ON v_1.id_voie = t.id_voie_d
             LEFT JOIN m_voirie.an_voirie_gest g ON g.id_tronc = t.id_tronc
             LEFT JOIN m_voirie.an_voirie_circu c ON c.id_tronc = t.id_tronc
             LEFT JOIN r_osm.geo_osm_commune com ON t.insee_d::text = com.insee::text
             LEFT JOIN r_objet.lt_src_geom lta ON lta.code::text = t.src_geom::text
             LEFT JOIN r_voie.lt_type_tronc ltb ON ltb.code::text = a.type_tronc::text
             LEFT JOIN r_voie.lt_hierarchie ltc ON ltc.code::text = a.hierarchie::text
             LEFT JOIN r_voie.lt_franchiss ltd ON ltd.code::text = a.franchiss::text
             LEFT JOIN m_voirie.lt_statut_jur lte ON lte.code::text = g.statut_jur::text
             LEFT JOIN m_voirie.lt_doman ltf ON ltf.code::text = g.doman::text
             LEFT JOIN m_voirie.lt_gestion ltg ON ltg.code::text = g.gestion::text
             LEFT JOIN m_voirie.lt_gestion lth ON lth.code::text = g.proprio::text
             LEFT JOIN m_voirie.lt_type_circu lti ON lti.code::text = c.type_circu::text
             LEFT JOIN m_voirie.lt_sens_circu ltj ON ltj.code::text = c.sens_circu::text
             LEFT JOIN m_voirie.lt_v_max ltk ON ltk.code::text = c.v_max::text
          WHERE t.insee_g::text <> t.insee_d::text
        ), req_lv AS (
         SELECT xapps_geo_v_voie.gid,
            xapps_geo_v_voie.id_voie,
            xapps_geo_v_voie.long,
            xapps_geo_v_voie.libvoie_c
           FROM x_apps.xapps_geo_v_voie
        )
 SELECT row_number() OVER () AS gid,
    now() AS date_extract,
    req_v.id_tronc,
    req_v.id_voie,
    req_v.libvoie,
    req_v.date_lib,
    req_v.rivoli,
    req_v.insee,
    req_v.commune,
    req_v.noeud_d,
    req_v.noeud_f,
    req_v.type_tronc,
    req_v.hierarchie,
    req_v.franchiss,
    req_v.nb_voie,
    req_v.projet,
    req_v.fictif,
    req_v.statut_jur,
    req_v.num_statut,
    req_v.gestion,
    req_v.doman,
    req_v.proprio,
    req_v.type_circu,
    req_v.sens_circu,
    req_v.v_max,
    req_v.c_circu,
    req_v.c_observ,
    req_v.date_ouv,
    req_v.date_rem,
    req_v.pente,
    req_v.observ,
    req_v.src_geom,
    req_v.src_date,
    req_v.date_sai,
    req_v.date_maj,
    round(st_length(req_v.geom)::integer::numeric, 0)::integer AS long_troncon,
    req_v.src_tronc,
    v.libvoie_c,
    req_lv.long,
    req_v.geom
   FROM req_v
     LEFT JOIN req_lv ON req_v.id_voie = req_lv.id_voie
     LEFT JOIN r_voie.an_voie v ON v.id_voie = req_v.id_voie
  ORDER BY req_v.id_tronc
WITH DATA;

ALTER TABLE x_apps.xapps_geo_vmr_troncon_voirie
    OWNER TO create_sig;

COMMENT ON MATERIALIZED VIEW x_apps.xapps_geo_vmr_troncon_voirie
    IS 'Vue matérilaisée complète et décodée des données relatives au troncon et à ses propriétés métiers de circulation et de gestion, destinée à l''exploitation applicative (générateur d''apps). Cette vue est rafraîchie automatiquement toutes les nuits. Au besoin un rafraîchissement ponctuel est possible.';

GRANT SELECT ON TABLE x_apps.xapps_geo_vmr_troncon_voirie TO sig_create;
GRANT SELECT ON TABLE x_apps.xapps_geo_vmr_troncon_voirie TO sig_read;
GRANT SELECT ON TABLE x_apps.xapps_geo_vmr_troncon_voirie TO sig_edit;
GRANT SELECT ON TABLE x_apps.xapps_geo_vmr_troncon_voirie TO create_sig;

-- Materialized View: x_apps.xapps_geo_vmr_voie

-- DROP MATERIALIZED VIEW x_apps.xapps_geo_vmr_voie;

CREATE MATERIALIZED VIEW x_apps.xapps_geo_vmr_voie AS 
 WITH req_v AS (
         SELECT t.id_voie_g AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND t.id_voie_g = t.id_voie_d
        UNION ALL
         SELECT t.id_voie_g AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND t.id_voie_g <> t.id_voie_d
        UNION ALL
         SELECT t.id_voie_d AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND t.id_voie_g <> t.id_voie_d
        UNION ALL
         SELECT t.id_voie_d AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND t.id_voie_g IS NULL AND t.id_voie_d IS NULL
        ), req_nv AS (
         SELECT an_voie.insee,
            an_voie.id_voie,
            an_voie.libvoie_c
           FROM r_voie.an_voie
        ), req_l AS (
         SELECT t.id_voie_g AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND t.id_voie_g = t.id_voie_d AND tr.fictif = false
        UNION ALL
         SELECT t.id_voie_g AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND t.id_voie_g <> t.id_voie_d AND tr.fictif = false
        UNION ALL
         SELECT t.id_voie_d AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND t.id_voie_g <> t.id_voie_d AND tr.fictif = false
        UNION ALL
         SELECT t.id_voie_d AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND t.id_voie_g IS NULL AND t.id_voie_d IS NULL AND tr.fictif = false
        )
 SELECT row_number() OVER () AS gid,
    now() AS date_extract,
    req_v.id_voie,
    req_nv.insee,
    round(st_length(st_multi(st_union(req_l.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long,
    req_nv.libvoie_c,
    st_linemerge(st_multi(st_union(req_v.geom))::geometry(MultiLineString,2154)) AS geom
   FROM req_v
     LEFT JOIN req_nv ON req_v.id_voie = req_nv.id_voie
     LEFT JOIN req_l ON req_l.id_voie = req_v.id_voie
  WHERE req_v.id_voie IS NOT NULL
  GROUP BY req_v.id_voie, req_nv.libvoie_c, req_nv.insee
WITH DATA;

ALTER TABLE x_apps.xapps_geo_vmr_voie
    OWNER TO create_sig;

GRANT SELECT ON TABLE x_apps.xapps_geo_vmr_voie TO sig_create;
GRANT SELECT ON TABLE x_apps.xapps_geo_vmr_voie TO sig_read;
GRANT SELECT ON TABLE x_apps.xapps_geo_vmr_voie TO sig_edit;
GRANT SELECT ON TABLE x_apps.xapps_geo_vmr_voie TO create_sig;
							  
COMMENT ON MATERIALIZED VIEW x_apps.xapps_geo_vmr_voie
    IS 'Vue de synthèse des voies (agréagation des tronçons pour calcul) (générateur d''apps)
Cette vue est rafraichie toutes les nuits par une tache CRON sur le serveur sig-sgbd.';

-- Index: x_apps.idx_xapps_v_voie_id_voie

-- DROP INDEX x_apps.idx_xapps_v_voie_id_voie;

CREATE INDEX idx_xapps_v_voie_id_voie
  ON x_apps.xapps_geo_vmr_voie
  USING btree
  (id_voie);




-- View: x_apps.xapps_an_v_troncon

-- DROP MATERIALIZED VIEW x_apps.xapps_an_v_troncon;

CREATE MATERIALIZED VIEW x_apps.xapps_an_vmr_troncon
TABLESPACE pg_default
AS
 WITH req_v_com AS (
         SELECT geo_vm_osm_commune_apc.insee,
            geo_vm_osm_commune_apc.commune_m AS commune
           FROM r_osm.geo_vm_osm_commune_apc
        ), req_v_t1 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_t1
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.projet = false AND t.insee_g::text = a.insee::text AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text)
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_t2
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.projet = false AND t.insee_g::text = a.insee::text AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text)
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_t3
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.projet = false AND t.insee_d::text = a.insee::text AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text)
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_g00 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg001
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '00'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_g00 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg002
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '00'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_g00 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg003
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '00'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_g01 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg011
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '01'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_g01 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg012
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '01'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_g01 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg013
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '01'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_g02 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg021
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '02'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_g02 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg022
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '02'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_g02 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg023
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '02'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_g03 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg031
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '03'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_g03 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg032
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '03'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_g03 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg033
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '03'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_g04 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg041
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '04'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_g04 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg042
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '04'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_g04 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg043
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '04'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_g05 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg051
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '05'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_g05 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg052
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '05'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_g05 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg053
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '05'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_g06 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg061
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '06'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_g06 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg062
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '06'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_g06 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg063
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '06'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_g07 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg071
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '07'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_g07 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg072
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '07'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_g07 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg073
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '07'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_g99 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg991
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '99'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_g99 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg992
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '99'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_g99 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_tg993
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.gestion::text = '99'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_d00 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_td001
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.doman::text = '00'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_d00 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_td002
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.doman::text = '00'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_d00 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_td003
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.doman::text = '00'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_d01 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_td011
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.doman::text = '01'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_d01 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_td012
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.doman::text = '01'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_d01 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_td013
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.doman::text = '01'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_d02 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_td021
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.doman::text = '02'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_d02 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_td022
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.doman::text = '02'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_d02 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_td023
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.doman::text = '02'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s00 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts001
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '00'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s00 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts002
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '00'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s00 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts003
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '00'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s01 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts011
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '01'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s01 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts012
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '01'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s01 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts013
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '01'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s02 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts021
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '02'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s02 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts022
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '02'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s02 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts023
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '02'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s03 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts031
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '03'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s03 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts032
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '03'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s03 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts033
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '03'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s04 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts041
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '04'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s04 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts042
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '04'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s04 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts043
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '04'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s05 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts051
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '05'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s05 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts052
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '05'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s05 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts053
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '05'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s06 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts061
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '06'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s06 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts062
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '06'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s06 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts063
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '06'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s07 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts071
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '07'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s07 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts072
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '07'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s07 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts073
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '07'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s08 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts081
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '08'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s08 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts082
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '08'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s08 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts083
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '08'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s09 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts091
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '09'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s09 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts092
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '09'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s09 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts093
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '09'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s10 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts101
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '10'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s10 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts102
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '10'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s10 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts103
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '10'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s11 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts111
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '11'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s11 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts112
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '11'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s11 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts113
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '11'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s12 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts121
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '12'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s12 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts122
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '12'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s12 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts123
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '12'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        ), req_v_t1_s99 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts991
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text = t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '99'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t2_s99 AS (
         SELECT t.insee_g AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts992
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_g::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '99'::text
          GROUP BY t.insee_g
          ORDER BY t.insee_g
        ), req_v_t3_s99 AS (
         SELECT t.insee_d AS insee,
            round(st_length(st_multi(st_union(t.geom))::geometry(MultiLineString,2154))::integer::numeric, 0)::integer AS long_ts993
           FROM m_voirie.geo_v_troncon_voirie t,
            r_administratif.an_geo a
          WHERE t.insee_g::text <> t.insee_d::text AND t.insee_d::text = a.insee::text AND t.projet = false AND (a.epci::text = '200067965'::text OR a.epci::text = '246000897'::text OR a.epci::text = '246000749'::text) AND t.statut_jur::text = '99'::text
          GROUP BY t.insee_d
          ORDER BY t.insee_d
        )
 SELECT row_number() OVER () AS gid,
    now() AS date_extract,
    req_v_com.insee,
    req_v_com.commune,
        CASE
            WHEN req_v_t1.long_t1 IS NULL THEN 0
            ELSE req_v_t1.long_t1
        END +
        CASE
            WHEN req_v_t2.long_t2 IS NULL THEN 0
            ELSE req_v_t2.long_t2
        END +
        CASE
            WHEN req_v_t3.long_t3 IS NULL THEN 0
            ELSE req_v_t3.long_t3
        END AS long_t,
        CASE
            WHEN req_v_t1_g00.long_tg001 IS NULL THEN 0
            ELSE req_v_t1_g00.long_tg001
        END +
        CASE
            WHEN req_v_t2_g00.long_tg002 IS NULL THEN 0
            ELSE req_v_t2_g00.long_tg002
        END +
        CASE
            WHEN req_v_t3_g00.long_tg003 IS NULL THEN 0
            ELSE req_v_t3_g00.long_tg003
        END AS long_tg00,
        CASE
            WHEN req_v_t1_g01.long_tg011 IS NULL THEN 0
            ELSE req_v_t1_g01.long_tg011
        END +
        CASE
            WHEN req_v_t2_g01.long_tg012 IS NULL THEN 0
            ELSE req_v_t2_g01.long_tg012
        END +
        CASE
            WHEN req_v_t3_g01.long_tg013 IS NULL THEN 0
            ELSE req_v_t3_g01.long_tg013
        END AS long_tg01,
        CASE
            WHEN req_v_t1_g02.long_tg021 IS NULL THEN 0
            ELSE req_v_t1_g02.long_tg021
        END +
        CASE
            WHEN req_v_t2_g02.long_tg022 IS NULL THEN 0
            ELSE req_v_t2_g02.long_tg022
        END +
        CASE
            WHEN req_v_t3_g02.long_tg023 IS NULL THEN 0
            ELSE req_v_t3_g02.long_tg023
        END AS long_tg02,
        CASE
            WHEN req_v_t1_g03.long_tg031 IS NULL THEN 0
            ELSE req_v_t1_g03.long_tg031
        END +
        CASE
            WHEN req_v_t2_g03.long_tg032 IS NULL THEN 0
            ELSE req_v_t2_g03.long_tg032
        END +
        CASE
            WHEN req_v_t3_g03.long_tg033 IS NULL THEN 0
            ELSE req_v_t3_g03.long_tg033
        END AS long_tg03,
        CASE
            WHEN req_v_t1_g04.long_tg041 IS NULL THEN 0
            ELSE req_v_t1_g04.long_tg041
        END +
        CASE
            WHEN req_v_t2_g04.long_tg042 IS NULL THEN 0
            ELSE req_v_t2_g04.long_tg042
        END +
        CASE
            WHEN req_v_t3_g04.long_tg043 IS NULL THEN 0
            ELSE req_v_t3_g04.long_tg043
        END AS long_tg04,
        CASE
            WHEN req_v_t1_g05.long_tg051 IS NULL THEN 0
            ELSE req_v_t1_g05.long_tg051
        END +
        CASE
            WHEN req_v_t2_g05.long_tg052 IS NULL THEN 0
            ELSE req_v_t2_g05.long_tg052
        END +
        CASE
            WHEN req_v_t3_g05.long_tg053 IS NULL THEN 0
            ELSE req_v_t3_g05.long_tg053
        END AS long_tg05,
        CASE
            WHEN req_v_t1_g06.long_tg061 IS NULL THEN 0
            ELSE req_v_t1_g06.long_tg061
        END +
        CASE
            WHEN req_v_t2_g06.long_tg062 IS NULL THEN 0
            ELSE req_v_t2_g06.long_tg062
        END +
        CASE
            WHEN req_v_t3_g06.long_tg063 IS NULL THEN 0
            ELSE req_v_t3_g06.long_tg063
        END AS long_tg06,
        CASE
            WHEN req_v_t1_g07.long_tg071 IS NULL THEN 0
            ELSE req_v_t1_g07.long_tg071
        END +
        CASE
            WHEN req_v_t2_g07.long_tg072 IS NULL THEN 0
            ELSE req_v_t2_g07.long_tg072
        END +
        CASE
            WHEN req_v_t3_g07.long_tg073 IS NULL THEN 0
            ELSE req_v_t3_g07.long_tg073
        END AS long_tg07,
        CASE
            WHEN req_v_t1_g99.long_tg991 IS NULL THEN 0
            ELSE req_v_t1_g99.long_tg991
        END +
        CASE
            WHEN req_v_t2_g99.long_tg992 IS NULL THEN 0
            ELSE req_v_t2_g99.long_tg992
        END +
        CASE
            WHEN req_v_t3_g99.long_tg993 IS NULL THEN 0
            ELSE req_v_t3_g99.long_tg993
        END AS long_tg99,
        CASE
            WHEN req_v_t1_d00.long_td001 IS NULL THEN 0
            ELSE req_v_t1_d00.long_td001
        END +
        CASE
            WHEN req_v_t2_d00.long_td002 IS NULL THEN 0
            ELSE req_v_t2_d00.long_td002
        END +
        CASE
            WHEN req_v_t3_d00.long_td003 IS NULL THEN 0
            ELSE req_v_t3_d00.long_td003
        END AS long_td00,
        CASE
            WHEN req_v_t1_d01.long_td011 IS NULL THEN 0
            ELSE req_v_t1_d01.long_td011
        END +
        CASE
            WHEN req_v_t2_d01.long_td012 IS NULL THEN 0
            ELSE req_v_t2_d01.long_td012
        END +
        CASE
            WHEN req_v_t3_d01.long_td013 IS NULL THEN 0
            ELSE req_v_t3_d01.long_td013
        END AS long_td01,
        CASE
            WHEN req_v_t1_d02.long_td021 IS NULL THEN 0
            ELSE req_v_t1_d02.long_td021
        END +
        CASE
            WHEN req_v_t2_d02.long_td022 IS NULL THEN 0
            ELSE req_v_t2_d02.long_td022
        END +
        CASE
            WHEN req_v_t3_d02.long_td023 IS NULL THEN 0
            ELSE req_v_t3_d02.long_td023
        END AS long_td02,
        CASE
            WHEN req_v_t1_s00.long_ts001 IS NULL THEN 0
            ELSE req_v_t1_s00.long_ts001
        END +
        CASE
            WHEN req_v_t2_s00.long_ts002 IS NULL THEN 0
            ELSE req_v_t2_s00.long_ts002
        END +
        CASE
            WHEN req_v_t3_s00.long_ts003 IS NULL THEN 0
            ELSE req_v_t3_s00.long_ts003
        END AS long_ts00,
        CASE
            WHEN req_v_t1_s01.long_ts011 IS NULL THEN 0
            ELSE req_v_t1_s01.long_ts011
        END +
        CASE
            WHEN req_v_t2_s01.long_ts012 IS NULL THEN 0
            ELSE req_v_t2_s01.long_ts012
        END +
        CASE
            WHEN req_v_t3_s01.long_ts013 IS NULL THEN 0
            ELSE req_v_t3_s01.long_ts013
        END AS long_ts01,
        CASE
            WHEN req_v_t1_s02.long_ts021 IS NULL THEN 0
            ELSE req_v_t1_s02.long_ts021
        END +
        CASE
            WHEN req_v_t2_s02.long_ts022 IS NULL THEN 0
            ELSE req_v_t2_s02.long_ts022
        END +
        CASE
            WHEN req_v_t3_s02.long_ts023 IS NULL THEN 0
            ELSE req_v_t3_s02.long_ts023
        END AS long_ts02,
        CASE
            WHEN req_v_t1_s03.long_ts031 IS NULL THEN 0
            ELSE req_v_t1_s03.long_ts031
        END +
        CASE
            WHEN req_v_t2_s03.long_ts032 IS NULL THEN 0
            ELSE req_v_t2_s03.long_ts032
        END +
        CASE
            WHEN req_v_t3_s03.long_ts033 IS NULL THEN 0
            ELSE req_v_t3_s03.long_ts033
        END AS long_ts03,
        CASE
            WHEN req_v_t1_s04.long_ts041 IS NULL THEN 0
            ELSE req_v_t1_s04.long_ts041
        END +
        CASE
            WHEN req_v_t2_s04.long_ts042 IS NULL THEN 0
            ELSE req_v_t2_s04.long_ts042
        END +
        CASE
            WHEN req_v_t3_s04.long_ts043 IS NULL THEN 0
            ELSE req_v_t3_s04.long_ts043
        END AS long_ts04,
        CASE
            WHEN req_v_t1_s05.long_ts051 IS NULL THEN 0
            ELSE req_v_t1_s05.long_ts051
        END +
        CASE
            WHEN req_v_t2_s05.long_ts052 IS NULL THEN 0
            ELSE req_v_t2_s05.long_ts052
        END +
        CASE
            WHEN req_v_t3_s05.long_ts053 IS NULL THEN 0
            ELSE req_v_t3_s05.long_ts053
        END AS long_ts05,
        CASE
            WHEN req_v_t1_s06.long_ts061 IS NULL THEN 0
            ELSE req_v_t1_s06.long_ts061
        END +
        CASE
            WHEN req_v_t2_s06.long_ts062 IS NULL THEN 0
            ELSE req_v_t2_s06.long_ts062
        END +
        CASE
            WHEN req_v_t3_s06.long_ts063 IS NULL THEN 0
            ELSE req_v_t3_s06.long_ts063
        END AS long_ts06,
        CASE
            WHEN req_v_t1_s07.long_ts071 IS NULL THEN 0
            ELSE req_v_t1_s07.long_ts071
        END +
        CASE
            WHEN req_v_t2_s07.long_ts072 IS NULL THEN 0
            ELSE req_v_t2_s07.long_ts072
        END +
        CASE
            WHEN req_v_t3_s07.long_ts073 IS NULL THEN 0
            ELSE req_v_t3_s07.long_ts073
        END AS long_ts07,
        CASE
            WHEN req_v_t1_s08.long_ts081 IS NULL THEN 0
            ELSE req_v_t1_s08.long_ts081
        END +
        CASE
            WHEN req_v_t2_s08.long_ts082 IS NULL THEN 0
            ELSE req_v_t2_s08.long_ts082
        END +
        CASE
            WHEN req_v_t3_s08.long_ts083 IS NULL THEN 0
            ELSE req_v_t3_s08.long_ts083
        END AS long_ts08,
        CASE
            WHEN req_v_t1_s09.long_ts091 IS NULL THEN 0
            ELSE req_v_t1_s09.long_ts091
        END +
        CASE
            WHEN req_v_t2_s09.long_ts092 IS NULL THEN 0
            ELSE req_v_t2_s09.long_ts092
        END +
        CASE
            WHEN req_v_t3_s09.long_ts093 IS NULL THEN 0
            ELSE req_v_t3_s09.long_ts093
        END AS long_ts09,
        CASE
            WHEN req_v_t1_s10.long_ts101 IS NULL THEN 0
            ELSE req_v_t1_s10.long_ts101
        END +
        CASE
            WHEN req_v_t2_s10.long_ts102 IS NULL THEN 0
            ELSE req_v_t2_s10.long_ts102
        END +
        CASE
            WHEN req_v_t3_s10.long_ts103 IS NULL THEN 0
            ELSE req_v_t3_s10.long_ts103
        END AS long_ts10,
        CASE
            WHEN req_v_t1_s11.long_ts111 IS NULL THEN 0
            ELSE req_v_t1_s11.long_ts111
        END +
        CASE
            WHEN req_v_t2_s11.long_ts112 IS NULL THEN 0
            ELSE req_v_t2_s11.long_ts112
        END +
        CASE
            WHEN req_v_t3_s11.long_ts113 IS NULL THEN 0
            ELSE req_v_t3_s11.long_ts113
        END AS long_ts11,
        CASE
            WHEN req_v_t1_s12.long_ts121 IS NULL THEN 0
            ELSE req_v_t1_s12.long_ts121
        END +
        CASE
            WHEN req_v_t2_s12.long_ts122 IS NULL THEN 0
            ELSE req_v_t2_s12.long_ts122
        END +
        CASE
            WHEN req_v_t3_s12.long_ts123 IS NULL THEN 0
            ELSE req_v_t3_s12.long_ts123
        END AS long_ts12,
        CASE
            WHEN req_v_t1_s99.long_ts991 IS NULL THEN 0
            ELSE req_v_t1_s99.long_ts991
        END +
        CASE
            WHEN req_v_t2_s99.long_ts992 IS NULL THEN 0
            ELSE req_v_t2_s99.long_ts992
        END +
        CASE
            WHEN req_v_t3_s99.long_ts993 IS NULL THEN 0
            ELSE req_v_t3_s99.long_ts993
        END AS long_ts99
   FROM req_v_com
     LEFT JOIN req_v_t1 ON req_v_com.insee::text = req_v_t1.insee::text
     LEFT JOIN req_v_t2 ON req_v_com.insee::text = req_v_t2.insee::text
     LEFT JOIN req_v_t3 ON req_v_com.insee::text = req_v_t3.insee::text
     LEFT JOIN req_v_t1_g00 ON req_v_com.insee::text = req_v_t1_g00.insee::text
     LEFT JOIN req_v_t2_g00 ON req_v_com.insee::text = req_v_t2_g00.insee::text
     LEFT JOIN req_v_t3_g00 ON req_v_com.insee::text = req_v_t3_g00.insee::text
     LEFT JOIN req_v_t1_g01 ON req_v_com.insee::text = req_v_t1_g01.insee::text
     LEFT JOIN req_v_t2_g01 ON req_v_com.insee::text = req_v_t2_g01.insee::text
     LEFT JOIN req_v_t3_g01 ON req_v_com.insee::text = req_v_t3_g01.insee::text
     LEFT JOIN req_v_t1_g02 ON req_v_com.insee::text = req_v_t1_g02.insee::text
     LEFT JOIN req_v_t2_g02 ON req_v_com.insee::text = req_v_t2_g02.insee::text
     LEFT JOIN req_v_t3_g02 ON req_v_com.insee::text = req_v_t3_g02.insee::text
     LEFT JOIN req_v_t1_g03 ON req_v_com.insee::text = req_v_t1_g03.insee::text
     LEFT JOIN req_v_t2_g03 ON req_v_com.insee::text = req_v_t2_g03.insee::text
     LEFT JOIN req_v_t3_g03 ON req_v_com.insee::text = req_v_t3_g03.insee::text
     LEFT JOIN req_v_t1_g04 ON req_v_com.insee::text = req_v_t1_g04.insee::text
     LEFT JOIN req_v_t2_g04 ON req_v_com.insee::text = req_v_t2_g04.insee::text
     LEFT JOIN req_v_t3_g04 ON req_v_com.insee::text = req_v_t3_g04.insee::text
     LEFT JOIN req_v_t1_g05 ON req_v_com.insee::text = req_v_t1_g05.insee::text
     LEFT JOIN req_v_t2_g05 ON req_v_com.insee::text = req_v_t2_g05.insee::text
     LEFT JOIN req_v_t3_g05 ON req_v_com.insee::text = req_v_t3_g05.insee::text
     LEFT JOIN req_v_t1_g06 ON req_v_com.insee::text = req_v_t1_g06.insee::text
     LEFT JOIN req_v_t2_g06 ON req_v_com.insee::text = req_v_t2_g06.insee::text
     LEFT JOIN req_v_t3_g06 ON req_v_com.insee::text = req_v_t3_g06.insee::text
     LEFT JOIN req_v_t1_g07 ON req_v_com.insee::text = req_v_t1_g07.insee::text
     LEFT JOIN req_v_t2_g07 ON req_v_com.insee::text = req_v_t2_g07.insee::text
     LEFT JOIN req_v_t3_g07 ON req_v_com.insee::text = req_v_t3_g07.insee::text
     LEFT JOIN req_v_t1_g99 ON req_v_com.insee::text = req_v_t1_g99.insee::text
     LEFT JOIN req_v_t2_g99 ON req_v_com.insee::text = req_v_t2_g99.insee::text
     LEFT JOIN req_v_t3_g99 ON req_v_com.insee::text = req_v_t3_g99.insee::text
     LEFT JOIN req_v_t1_d00 ON req_v_com.insee::text = req_v_t1_d00.insee::text
     LEFT JOIN req_v_t2_d00 ON req_v_com.insee::text = req_v_t2_d00.insee::text
     LEFT JOIN req_v_t3_d00 ON req_v_com.insee::text = req_v_t3_d00.insee::text
     LEFT JOIN req_v_t1_d01 ON req_v_com.insee::text = req_v_t1_d01.insee::text
     LEFT JOIN req_v_t2_d01 ON req_v_com.insee::text = req_v_t2_d01.insee::text
     LEFT JOIN req_v_t3_d01 ON req_v_com.insee::text = req_v_t3_d01.insee::text
     LEFT JOIN req_v_t1_d02 ON req_v_com.insee::text = req_v_t1_d02.insee::text
     LEFT JOIN req_v_t2_d02 ON req_v_com.insee::text = req_v_t2_d02.insee::text
     LEFT JOIN req_v_t3_d02 ON req_v_com.insee::text = req_v_t3_d02.insee::text
     LEFT JOIN req_v_t1_s00 ON req_v_com.insee::text = req_v_t1_s00.insee::text
     LEFT JOIN req_v_t2_s00 ON req_v_com.insee::text = req_v_t2_s00.insee::text
     LEFT JOIN req_v_t3_s00 ON req_v_com.insee::text = req_v_t3_s00.insee::text
     LEFT JOIN req_v_t1_s01 ON req_v_com.insee::text = req_v_t1_s01.insee::text
     LEFT JOIN req_v_t2_s01 ON req_v_com.insee::text = req_v_t2_s01.insee::text
     LEFT JOIN req_v_t3_s01 ON req_v_com.insee::text = req_v_t3_s01.insee::text
     LEFT JOIN req_v_t1_s02 ON req_v_com.insee::text = req_v_t1_s02.insee::text
     LEFT JOIN req_v_t2_s02 ON req_v_com.insee::text = req_v_t2_s02.insee::text
     LEFT JOIN req_v_t3_s02 ON req_v_com.insee::text = req_v_t3_s02.insee::text
     LEFT JOIN req_v_t1_s03 ON req_v_com.insee::text = req_v_t1_s03.insee::text
     LEFT JOIN req_v_t2_s03 ON req_v_com.insee::text = req_v_t2_s03.insee::text
     LEFT JOIN req_v_t3_s03 ON req_v_com.insee::text = req_v_t3_s03.insee::text
     LEFT JOIN req_v_t1_s04 ON req_v_com.insee::text = req_v_t1_s04.insee::text
     LEFT JOIN req_v_t2_s04 ON req_v_com.insee::text = req_v_t2_s04.insee::text
     LEFT JOIN req_v_t3_s04 ON req_v_com.insee::text = req_v_t3_s04.insee::text
     LEFT JOIN req_v_t1_s05 ON req_v_com.insee::text = req_v_t1_s05.insee::text
     LEFT JOIN req_v_t2_s05 ON req_v_com.insee::text = req_v_t2_s05.insee::text
     LEFT JOIN req_v_t3_s05 ON req_v_com.insee::text = req_v_t3_s05.insee::text
     LEFT JOIN req_v_t1_s06 ON req_v_com.insee::text = req_v_t1_s06.insee::text
     LEFT JOIN req_v_t2_s06 ON req_v_com.insee::text = req_v_t2_s06.insee::text
     LEFT JOIN req_v_t3_s06 ON req_v_com.insee::text = req_v_t3_s06.insee::text
     LEFT JOIN req_v_t1_s07 ON req_v_com.insee::text = req_v_t1_s07.insee::text
     LEFT JOIN req_v_t2_s07 ON req_v_com.insee::text = req_v_t2_s07.insee::text
     LEFT JOIN req_v_t3_s07 ON req_v_com.insee::text = req_v_t3_s07.insee::text
     LEFT JOIN req_v_t1_s08 ON req_v_com.insee::text = req_v_t1_s08.insee::text
     LEFT JOIN req_v_t2_s08 ON req_v_com.insee::text = req_v_t2_s08.insee::text
     LEFT JOIN req_v_t3_s08 ON req_v_com.insee::text = req_v_t3_s08.insee::text
     LEFT JOIN req_v_t1_s09 ON req_v_com.insee::text = req_v_t1_s09.insee::text
     LEFT JOIN req_v_t2_s09 ON req_v_com.insee::text = req_v_t2_s09.insee::text
     LEFT JOIN req_v_t3_s09 ON req_v_com.insee::text = req_v_t3_s09.insee::text
     LEFT JOIN req_v_t1_s10 ON req_v_com.insee::text = req_v_t1_s10.insee::text
     LEFT JOIN req_v_t2_s10 ON req_v_com.insee::text = req_v_t2_s10.insee::text
     LEFT JOIN req_v_t3_s10 ON req_v_com.insee::text = req_v_t3_s10.insee::text
     LEFT JOIN req_v_t1_s11 ON req_v_com.insee::text = req_v_t1_s11.insee::text
     LEFT JOIN req_v_t2_s11 ON req_v_com.insee::text = req_v_t2_s11.insee::text
     LEFT JOIN req_v_t3_s11 ON req_v_com.insee::text = req_v_t3_s11.insee::text
     LEFT JOIN req_v_t1_s12 ON req_v_com.insee::text = req_v_t1_s12.insee::text
     LEFT JOIN req_v_t2_s12 ON req_v_com.insee::text = req_v_t2_s12.insee::text
     LEFT JOIN req_v_t3_s12 ON req_v_com.insee::text = req_v_t3_s12.insee::text
     LEFT JOIN req_v_t1_s99 ON req_v_com.insee::text = req_v_t1_s99.insee::text
     LEFT JOIN req_v_t2_s99 ON req_v_com.insee::text = req_v_t2_s99.insee::text
     LEFT JOIN req_v_t3_s99 ON req_v_com.insee::text = req_v_t3_s99.insee::text
WITH DATA;

ALTER TABLE x_apps.xapps_an_vmr_troncon
    OWNER TO create_sig;

COMMENT ON MATERIALIZED VIEW x_apps.xapps_an_vmr_troncon
    IS 'Vue non géographiques des tronçons (agrégation des tronçons pour statistique à la commune) (générateur d''apps)
Cette vue matérialisée est rafraichit toutes les jours via un fichier batch sur la VM sig-sgbd.';

GRANT SELECT ON TABLE x_apps.xapps_an_vmr_troncon TO sig_create;
GRANT SELECT ON TABLE x_apps.xapps_an_vmr_troncon TO sig_read;
GRANT SELECT ON TABLE x_apps.xapps_an_vmr_troncon TO sig_edit;
GRANT SELECT ON TABLE x_apps.xapps_an_vmr_troncon TO create_sig;

-- View: x_apps.xapps_an_v_troncon_h

-- DROP VIEW x_apps.xapps_an_v_troncon_h;

CREATE OR REPLACE VIEW x_apps.xapps_an_v_troncon_h AS 
SELECT 
    t.id_tronc,
        CASE
            WHEN t.id_voie_g = t.id_voie_d THEN v1.libvoie_c::text
            WHEN t.id_voie_g IS NOT NULL THEN v1.libvoie_c::text || '(commune de '::text || c1.libgeo::text || ')'
            WHEN t.id_voie_d IS NOT NULL THEN v2.libvoie_c::text || '(commune de '::text || c2.libgeo::text  || ')'
            ELSE NULL::text
        END AS troncon_h,
    v1.date_lib,
    t.date_sai
FROM 
	r_voie.an_troncon_h t
LEFT JOIN 
	r_voie.an_voie v1 ON v1.id_voie = t.id_voie_g
LEFT JOIN
	r_voie.an_voie v2 ON v2.id_voie = t.id_voie_d
LEFT JOIN
	r_administratif.an_geo c1 ON c1.insee = v1.insee
LEFT JOIN
	r_administratif.an_geo c2 ON c2.insee = v2.insee
;

ALTER TABLE x_apps.xapps_an_v_troncon_h
    OWNER TO create_sig;
COMMENT ON VIEW x_apps.xapps_an_v_troncon_h
    IS 'Vue d''exploitation permettant de lister l''historique des dénominations de voies au tronçon (intégration dans la fiche tronçon dans l''application GEO RVA';

GRANT ALL ON TABLE x_apps.xapps_an_v_troncon_h TO sig_create;
GRANT SELECT ON TABLE x_apps.xapps_an_v_troncon_h TO sig_read;
GRANT ALL ON TABLE x_apps.xapps_an_v_troncon_h TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE x_apps.xapps_an_v_troncon_h TO sig_edit;
				     
				     
COMMENT ON VIEW x_apps.xapps_an_v_troncon_h
  IS 'Vue d''exploitation permettant de lister l''historique des dénominations de voies au tronçon (intégration dans la fiche tronçon dans l''application GEO RVA';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                             VUES OPEN DATA                                                                   ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- en attente


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      BAC A SABLE                                                             ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
  
-- TRUNCATE TABLE r_objet.geo_objet_troncon, r_objet.geo_objet_noeud, r_voie.an_troncon, r_voie.an_voie, m_voirie.an_voirie_gest, m_voirie.an_voirie_circu CASCADE;

-- ALTER TABLE r_objet.geo_objet_troncon DROP CONSTRAINT noeud_d_fkey;
-- ALTER TABLE r_objet.geo_objet_troncon DROP CONSTRAINT noeud_f_fkey;
-- ALTER TABLE r_voie.an_troncon DROP CONSTRAINT an_tronc_id_tronc_fkey;
-- ALTER TABLE m_voirie.an_voirie_circu DROP CONSTRAINT an_voirie_circu_id_tronc_fkey;
-- ALTER TABLE m_voirie.an_voirie_gest DROP CONSTRAINT an_voirie_gest_id_tronc_fkey;
-- ALTER TABLE r_objet.geo_objet_troncon DROP CONSTRAINT id_voie_g_fkey;
-- ALTER TABLE r_objet.geo_objet_troncon DROP CONSTRAINT id_voie_d_fkey;
-- ALTER TABLE r_objet.geo_objet_noeud DROP CONSTRAINT id_voie_fkey;

-- ALTER TABLE r_objet.geo_objet_troncon DISABLE TRIGGER noeud_insert ;
-- ALTER TABLE r_objet.geo_objet_troncon DISABLE TRIGGER noeud_sup;
-- ALTER TABLE r_objet.geo_objet_troncon DISABLE TRIGGER t_maj_insee_gd;
-- ALTER TABLE r_voie.an_voie DISABLE TRIGGER t_date_maj;


--ALTER TABLE r_objet.geo_objet_troncon
--  ADD CONSTRAINT noeud_d_fkey FOREIGN KEY (noeud_d)
--      REFERENCES r_objet.geo_objet_noeud (id_noeud) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;
      
--ALTER TABLE r_objet.geo_objet_troncon
--  ADD CONSTRAINT noeud_f_fkey FOREIGN KEY (noeud_f)
--      REFERENCES r_objet.geo_objet_noeud (id_noeud) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;

--ALTER TABLE r_voie.an_troncon
--  ADD CONSTRAINT an_tronc_id_tronc_fkey FOREIGN KEY (id_tronc)
--      REFERENCES r_objet.geo_objet_troncon (id_tronc) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;

--ALTER TABLE m_voirie.an_voirie_circu
--  ADD CONSTRAINT an_voirie_circu_id_tronc_fkey FOREIGN KEY (id_tronc)
--      REFERENCES r_objet.geo_objet_troncon (id_tronc) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;

--ALTER TABLE m_voirie.an_voirie_gest
--  ADD CONSTRAINT an_voirie_gest_id_tronc_fkey FOREIGN KEY (id_tronc)
--      REFERENCES r_objet.geo_objet_troncon (id_tronc) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;

--ALTER TABLE r_objet.geo_objet_troncon
--  ADD CONSTRAINT id_voie_g_fkey FOREIGN KEY (id_voie_g)
--      REFERENCES r_voie.an_voie (id_voie) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;

--ALTER TABLE r_objet.geo_objet_troncon
--  ADD CONSTRAINT id_voie_d_fkey FOREIGN KEY (id_voie_d)
--      REFERENCES r_voie.an_voie (id_voie) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;

--ALTER TABLE r_objet.geo_objet_noeud
--  ADD CONSTRAINT id_voie_fkey FOREIGN KEY (id_voie)
--      REFERENCES r_voie.an_voie (id_voie) MATCH SIMPLE
--      ON UPDATE CASCADE ON DELETE CASCADE;

-- ALTER TABLE r_objet.geo_objet_troncon ENABLE TRIGGER noeud_insert ;
-- ALTER TABLE r_objet.geo_objet_troncon ENABLE TRIGGER noeud_sup;
-- ALTER TABLE r_objet.geo_objet_troncon ENABLE TRIGGER t_maj_insee_gd;
-- ALTER TABLE r_voie.an_voie ENABLE TRIGGER t_date_maj;

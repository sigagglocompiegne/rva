
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      DROP                                                                    ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      SCHEMA                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

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


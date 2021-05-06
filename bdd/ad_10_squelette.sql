/*ADRESSE V1.0*/
/*Creation du squelette de la structure des données (tables, séquences, triggers,...) */
/*ad_10_SQUELETTE.sql */
/*PostGIS*/
/*GeoCompiegnois - http://geo.compiegnois.fr/ */
/*Auteur : Grégory Bodet */

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                 SCHEMA                                                                       ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

--DROP SCHEMA IF EXISTS r_adresse;

DROP SEQUENCE IF EXISTS r_objet.geo_objet_pt_adresse_id_seq;

DROP TABLE IF EXISTS r_objet.geo_objet_pt_adresse;
DROP TABLE IF EXISTS r_adresse.an_adresse;
DROP TABLE IF EXISTS r_adresse.an_adresse_h;
DROP TABLE IF EXISTS r_adresse.an_adresse_info;
DROP TABLE IF EXISTS r_objet.lt_position;
DROP TABLE IF EXISTS r_adresse.lt_groupee;
DROP TABLE IF EXISTS r_adresse.lt_secondaire;
DROP TABLE IF EXISTS r_adresse.lt_src_adr;
DROP TABLE IF EXISTS r_adresse.lt_diag_adr;
DROP TABLE IF EXISTS r_adresse.lt_qual_adr;
DROP TABLE IF EXISTS r_adresse.lt_dest_adr;
DROP TABLE IF EXISTS r_adresse.lt_etat_adr;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                 SCHEMA                                                                         ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- Schema: r_adresse

-- DROP SCHEMA r_adresse;

CREATE SCHEMA r_adresse
  AUTHORIZATION sig_create;

COMMENT ON SCHEMA r_adresse
  IS 'Référentiel Base Adresse Locale (BAL)';
  
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      REF OBJET                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### OBJET point_adresse #################################################################  
  
-- Sequence: r_objet.geo_objet_pt_adresse_id_seq

-- DROP SEQUENCE r_objet.geo_objet_pt_adresse_id_seq;

CREATE SEQUENCE r_objet.geo_objet_pt_adresse_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE r_objet.geo_objet_pt_adresse_id_seq
    OWNER TO create_sig;

ALTER TABLE r_objet.geo_objet_pt_adresse ALTER COLUMN id_adresse SET DEFAULT nextval('r_objet.geo_objet_pt_adresse_id_seq'::regclass);
  
-- Table: r_objet.geo_objet_pt_adresse

-- DROP TABLE r_objet.geo_objet_pt_adresse;

CREATE TABLE r_objet.geo_objet_pt_adresse
(
    id_adresse bigint NOT NULL DEFAULT nextval('r_objet.geo_objet_pt_adresse_id_seq'::regclass),
    id_voie bigint,
    id_tronc bigint,
    "position" character varying(2) COLLATE pg_catalog."default" NOT NULL,
    x_l93 numeric(8,2) NOT NULL,
    y_l93 numeric(9,2) NOT NULL,
    src_geom character varying(2) COLLATE pg_catalog."default" NOT NULL DEFAULT '00'::bpchar,
    src_date character varying(4) COLLATE pg_catalog."default" NOT NULL DEFAULT '0000'::bpchar,
    date_sai timestamp without time zone NOT NULL DEFAULT now(),
    date_maj timestamp without time zone,
    geom geometry(Point,2154),
    CONSTRAINT geo_objet_adresse_pkey PRIMARY KEY (id_adresse),
    CONSTRAINT geo_objet_adresse_id_tronc_fkey FOREIGN KEY (id_tronc)
        REFERENCES r_objet.geo_objet_troncon (id_tronc) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT geo_objet_adresse_lt_position_fkey FOREIGN KEY ("position")
        REFERENCES r_objet.lt_position (code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    CONSTRAINT geo_objet_adresse_lt_src_geom_fkey FOREIGN KEY (src_geom)
        REFERENCES r_objet.lt_src_geom (code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE SET NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE r_objet.geo_objet_pt_adresse
    OWNER to create_sig;

COMMENT ON TABLE r_objet.geo_objet_pt_adresse
    IS 'Classe décrivant la position d''une adresse';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.id_adresse
    IS 'Identifiant unique de l''objet point adresse';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.id_voie
    IS 'Identifiant unique de l''objet voie';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.id_tronc
    IS 'Identifiant unique de l''objet troncon';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse."position"
    IS 'Type de position du point adresse';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.x_l93
    IS 'Coordonnée X en mètre';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.y_l93
    IS 'Coordonnée Y en mètre';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.src_geom
    IS 'Référentiel de saisie';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.src_date
    IS 'Année du millésime du référentiel de saisie';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.date_sai
    IS 'Horodatage de l''intégration en base de l''objet';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.date_maj
    IS 'Horodatage de la mise à jour en base de l''objet';

COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.geom
    IS 'Géomètrie ponctuelle de l''objet';
-- Index: geo_objet_adresse_geom_idx

-- DROP INDEX r_objet.geo_objet_adresse_geom_idx;

CREATE INDEX geo_objet_adresse_geom_idx
    ON r_objet.geo_objet_pt_adresse USING gist
    (geom)
    TABLESPACE pg_default;




-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      REF ADRESSE                                                             ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### an_adresse ###################################################################

-- Table: r_adresse.an_adresse

-- DROP TABLE r_adresse.an_adresse;

CREATE TABLE r_adresse.an_adresse
(
  id_adresse bigint NOT NULL, -- Identifiant unique de l'objet point adresse
  numero character varying(10), -- Numéro de l'adresse
  repet character varying(10), -- Indice de répétition de l'adresse
  complement character varying(80), -- Complément d'adresse
  etiquette character varying(10), -- Etiquette
  angle integer, -- Angle de l'écriture exprimé en degré, par rapport à l'horizontale, dans le sens trigonométrique
  observ character varying(254), -- Observations
  src_adr character varying(2) NOT NULL DEFAULT '00' ::bpchar, -- Origine de l'adresse
  diag_adr character varying(2) NOT NULL DEFAULT '00' ::bpchar,-- Diagnostic qualité de l'adresse
  qual_adr character varying(1) DEFAULT '0',-- Indice de qualité simplifié de l'adresse
  verif_base boolean DEFAULT false, -- Champ informant si l'adresse a été vérifié par rapport aux erreurs de bases (n°, tronçon, voie, correspondance BAN)....
  ld_compl character varying(80), -- Nom du lieu-dit historique ou complémentaire
    
  CONSTRAINT an_adresse_pkey PRIMARY KEY (id_adresse)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.an_adresse
    OWNER to create_sig;

COMMENT ON TABLE r_adresse.an_adresse
  IS 'Table alphanumérique des adresses';
COMMENT ON COLUMN r_adresse.an_adresse.id_adresse IS 'Identifiant unique de l''objet point adresse';
COMMENT ON COLUMN r_adresse.an_adresse.numero IS 'Numéro de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.repet IS 'Indice de répétition de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.complement IS 'Complément d''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.etiquette IS 'Etiquette';
COMMENT ON COLUMN r_adresse.an_adresse.angle IS 'Angle de l''écriture exprimé en degré, par rapport à l''horizontale, dans le sens trigonométrique';
COMMENT ON COLUMN r_adresse.an_adresse.observ IS 'Observations';
COMMENT ON COLUMN r_adresse.an_adresse.src_adr IS 'Origine de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.diag_adr IS 'Diagnostic qualité de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.qual_adr IS 'Indice de qualité simplifié de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.verif_base IS 'Champ informant si l''adresse a été vérifié par rapport aux erreurs de bases (n°, tronçon, voie, correspondance BAN).
Par défaut à non.';
COMMENT ON COLUMN r_adresse.an_adresse.ld_compl
    IS 'Nom du lieu-dit historique ou complémentaire';
    

-- #################################################################### an_adresse_h ###################################################################

-- Sequence: r_adresse.an_adresse_h_id_seq

-- DROP SEQUENCE r_adresse.an_adresse_h_id_seq;

CREATE SEQUENCE r_adresse.an_adresse_h_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE r_adresse.an_adresse_h_id_seq
    OWNER TO create_sig;


-- Table: r_adresse.an_adresse_h

-- DROP TABLE r_adresse.an_adresse_h;

CREATE TABLE r_adresse.an_adresse_h
(
  id bigint NOT NULL DEFAULT nextval('r_adresse.an_adresse_h_id_seq'::regclass), -- Identifiant unique de l'historisation
  id_adresse bigint NOT NULL, -- Identifiant unique de l'objet point adresse
  id_voie integer,-- identifiant unique de la voie
  numero character varying(10), -- Numéro de l'adresse
  repet character varying(10), -- Indice de répétition de l'adresse
  complement character varying(80), -- Complément d'adresse
  etiquette character varying(10), -- Etiquette
  angle integer, -- Angle de l'écriture exprimé en degré, par rapport à l'horizontale, dans le sens trigonométrique
  codepostal character varying(5), -- Code postal de l'adresse
  commune character varying(100), -- Libellé de la commune
  date_arr timestamp without time zone, -- Date de l'arrêté de numérotation remplaçant le numéro historisé ici présent
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Date de saisie de l'information dans la base
  CONSTRAINT an_adresse_h_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.an_adresse_h
    OWNER to create_sig;

COMMENT ON TABLE r_adresse.an_adresse_h
  IS 'Table alphanumérique des historisations des adresses suite à une renumérotation';
COMMENT ON COLUMN r_adresse.an_adresse_h.id IS 'Identifiant unique de l''historisation';
COMMENT ON COLUMN r_adresse.an_adresse_h.id_adresse IS 'Identifiant unique de l''objet point adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.id_voie IS 'Identifiant unique de la voie';
COMMENT ON COLUMN r_adresse.an_adresse_h.numero IS 'Numéro de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.repet IS 'Indice de répétition de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.complement IS 'Complément d''adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.etiquette IS 'Etiquette';
COMMENT ON COLUMN r_adresse.an_adresse_h.angle IS 'Angle de l''écriture exprimé en degré, par rapport à l''horizontale, dans le sens trigonométrique';
COMMENT ON COLUMN r_adresse.an_adresse_h.codepostal IS 'Code postal de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.commune IS 'Libellé de la commune';
COMMENT ON COLUMN r_adresse.an_adresse_h.date_arr IS 'Date de l''arrêté de numérotation remplaçant le numéro historisé ici présent';
COMMENT ON COLUMN r_adresse.an_adresse_h.date_sai IS 'Date de saisie de l''information dans la base';



-- #################################################################### an_adresse_info ###################################################################

-- Table: r_adresse.an_adresse_info

-- DROP TABLE r_adresse.an_adresse_info;

CREATE TABLE r_adresse.an_adresse_info
(
  id_adresse bigint NOT NULL, -- Identifiant unique de l'objet point adresse
  dest_adr character varying(2) NOT NULL DEFAULT '00', -- Destination de l'adresse (habitation, commerce, ...)
  etat_adr character varying(2) NOT NULL DEFAULT '00', -- Etat de la construction à l'adresse (non commencé, en cours, achevé, muré, supprimé ...)
  refcad character varying(254), -- Référence(s) cadastrale(s)
  nb_log integer, -- Nombre de logements
  pc character varying(30), -- Numéro du permis de construire  
  groupee character varying(1) NOT NULL DEFAULT '0', -- Adresse groupée (O/N)
  secondaire character varying(1) NOT NULL DEFAULT '0', -- Adresse d'un accès secondaire (O/N)
  id_ext1 character varying(80), -- Identifiant d''une adresse dans une base externe (1) pour appariemment
  id_ext2 character varying(80), -- Identifiant d''une adresse dans une base externe (2) pour appariemment
  insee_cd character varying(5), -- code Insee de la commune déléguée (en cas de fusion de commune)
  nom_cd character varying(80), -- Libellé de la commune déléguée (en cas de fusion de commune)
  CONSTRAINT an_adresse_info_pkey PRIMARY KEY (id_adresse)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.an_adresse_info
    OWNER to create_sig;

COMMENT ON TABLE r_adresse.an_adresse_info
  IS 'Table alphanumérique des informations complémentaires des adresses';
COMMENT ON COLUMN r_adresse.an_adresse_info.id_adresse IS 'Identifiant unique de l''objet point adresse';
COMMENT ON COLUMN r_adresse.an_adresse_info.dest_adr IS 'Destination de l''adresse (habitation, commerce, ...)';
COMMENT ON COLUMN r_adresse.an_adresse_info.etat_adr IS 'Etat de la construction à l''adresse (non commencé, en cours, achevé, muré, supprimé ...)';
COMMENT ON COLUMN r_adresse.an_adresse_info.refcad IS 'Référence(s) cadastrale(s)';
COMMENT ON COLUMN r_adresse.an_adresse_info.pc IS 'Numéro du permis de construire';
COMMENT ON COLUMN r_adresse.an_adresse_info.nb_log IS 'Nombre de logements';
COMMENT ON COLUMN r_adresse.an_adresse_info.groupee IS 'Adresse groupée (O/N)';
COMMENT ON COLUMN r_adresse.an_adresse_info.secondaire IS 'Adresse d''un accès secondaire (O/N)';
COMMENT ON COLUMN r_adresse.an_adresse_info.id_ext1 IS 'Identifiant d''une adresse dans une base externe (1) pour appariemment';
COMMENT ON COLUMN r_adresse.an_adresse_info.id_ext2 IS 'Identifiant d''une adresse dans une base externe (2) pour appariemment';
COMMENT ON COLUMN r_adresse.an_adresse_info.insee_cd IS 'code Insee de la commune déléguée (en cas de fusion de commune)';
COMMENT ON COLUMN r_adresse.an_adresse_info.nom_cd IS 'Libellé de la commune déléguée (en cas de fusion de commune)';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- ################################################################# Domaine valeur - position  ###############################################

-- Table: r_objet.lt_position

-- DROP TABLE r_objet.lt_position;

CREATE TABLE r_objet.lt_position
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au type de position de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au type de position de l'adresse
  definition character varying(254) NOT NULL, -- Définition de la liste énumérée relative au type de position de l'adresse
  inspire character varying(80) NOT NULL, -- Equivalence INSPIRE LocatorDesignatorTypeValue relative au type de position de l'adresse
  CONSTRAINT lt_position_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_objet.lt_position
    OWNER to create_sig;

COMMENT ON TABLE r_objet.lt_position
  IS 'Code permettant de décrire le type de position de l''adresse';
COMMENT ON COLUMN r_objet.lt_position.code IS 'Code de la liste énumérée relative au type de position de l''adresse';
COMMENT ON COLUMN r_objet.lt_position.valeur IS 'Valeur de la liste énumérée relative au type de position de l''adresse';
COMMENT ON COLUMN r_objet.lt_position.definition IS 'Définition de la liste énumérée relative au type de position de l''adresse';
COMMENT ON COLUMN r_objet.lt_position.inspire IS 'Equivalence INSPIRE LocatorDesignatorTypeValue relative au type de position de l''adresse';

INSERT INTO r_objet.lt_position(
            code, valeur, definition, inspire)
    VALUES
    ('01','Délivrance postale','Identifie un point de délivrance postale','Postal delivery'),
    ('02','Entrée','Identifie l''entrée principale d''un bâtiment ou un portail','Entrance'),
    ('03','Bâtiment','Identifie un bâtiment ou une partie de bâtiment','Building'),
    ('04','Cage d''escalier','Identifie une cage d''escalier en temps normal à l''intérieur d''un bâtiment','Staircase indentifier'),
    ('05','Logement','Identifie un logement ou une pièce à l''intérieur d''un bâtiment','Unit identifier'),
    ('06','Parcelle','Identifie une parcelle cadastrale','Parcel'),
    ('07','Segment','Position dérivée du segment de la voie de rattachement','Segment'),
    ('08','Service technique','Identifie un point d''accès à un local technique (eau, électricité, gaz ...)','Utility service'),
    ('00','Non renseigné','*','*');


-- ################################################################# Domaine valeur - groupee  ###############################################

-- Table: r_adresse.lt_groupee

-- DROP TABLE r_adresse.lt_groupee;

CREATE TABLE r_adresse.lt_groupee
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à l'indice de qualité de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à l'indice de qualité de l'adresse
  CONSTRAINT lt_groupee_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_groupee
    OWNER to create_sig;


COMMENT ON TABLE r_adresse.lt_groupee
  IS 'Code permettant de définir si une adresse est groupée ou non';
COMMENT ON COLUMN r_adresse.lt_groupee.code IS 'Code de la liste énumérée relative à une adresse groupée ou non';
COMMENT ON COLUMN r_adresse.lt_groupee.valeur IS 'Valeur de la liste énumérée relative à une adresse groupée ou non';

INSERT INTO r_adresse.lt_groupee(
            code, valeur)
    VALUES
    ('1','Oui'),
    ('2','Non'),
    ('0','Non renseigné');

    
-- ################################################################# Domaine valeur - secondaire  ###############################################

-- Table: r_adresse.lt_secondaire

-- DROP TABLE r_adresse.lt_secondaire;

CREATE TABLE r_adresse.lt_secondaire
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à l'indice de qualité de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à l'indice de qualité de l'adresse
  CONSTRAINT lt_secondaire_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_secondaire
    OWNER to create_sig;


COMMENT ON TABLE r_adresse.lt_secondaire
  IS 'Code permettant de définir si une adresse est un accès secondaire';
COMMENT ON COLUMN r_adresse.lt_secondaire.code IS 'Code de la liste énumérée relative à une adresse d''un accès secondaire ou non';
COMMENT ON COLUMN r_adresse.lt_secondaire.valeur IS 'Valeur de la liste énumérée relative à une adresse d''un accès secondaire ou non';

INSERT INTO r_adresse.lt_secondaire(
            code, valeur)
    VALUES
    ('1','Oui'),
    ('2','Non'),
    ('0','Non renseigné');       

    
-- ################################################################# Domaine valeur - src_adr  ###############################################

-- Table: r_adresse.lt_src_adr

-- DROP TABLE r_adresse.lt_src_adr;

CREATE TABLE r_adresse.lt_src_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au type de position de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au type de position de l'adresse
  CONSTRAINT lt_src_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_src_adr
    OWNER to create_sig;

COMMENT ON TABLE r_adresse.lt_src_adr
  IS 'Code permettant de décrire l''origine de l''adresse';
COMMENT ON COLUMN r_adresse.lt_src_adr.code IS 'Code de la liste énumérée relative à la source de l''origine de l''adresse';
COMMENT ON COLUMN r_adresse.lt_src_adr.valeur IS 'Valeur de la liste énumérée relative à la source de l''origine de l''adresse';

INSERT INTO r_adresse.lt_src_adr(
            code, valeur)
    VALUES
    ('01','Cadastre'),
    ('02','OSM'),
    ('03','BAN'),
    ('04','Intercommunalité'),
    ('05','Commune'),
    ('99','Autre'),
    ('00','Non renseigné');


-- ################################################################# Domaine valeur - diag_adr  ###############################################

-- Table: r_adresse.lt_diag_adr

-- DROP TABLE r_adresse.lt_diag_adr;

CREATE TABLE r_adresse.lt_diag_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au diagnostic qualité de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au diagnostic qualité de l'adresse
  CONSTRAINT lt_diag_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_diag_adr
    OWNER to create_sig;


COMMENT ON TABLE r_adresse.lt_diag_adr
  IS 'Code permettant de décrire un diagnostic qualité d''une adresse';
COMMENT ON COLUMN r_adresse.lt_diag_adr.code IS 'Code de la liste énumérée relative au diagnostic qualité de l''adresse';
COMMENT ON COLUMN r_adresse.lt_diag_adr.valeur IS 'Valeur de la liste énumérée relative au diagnostic qualité de l''adresse';

INSERT INTO r_adresse.lt_diag_adr(
            code, valeur)
    VALUES
    ('11','Adresse conforme'),
    ('12','Adresse supprimée'),
    ('20','Adresse à améliorer (position, usage, dégrouper ...)'),
    ('21','Adresse à améliorer (position)'),
    ('22','Adresse à améliorer (usage)'),
    ('23','Adresse à améliorer (dégrouper)'),
    ('24','Adresse à améliorer (logement)'),        
    ('25','Adresse à améliorer (état)'),
    ('31','Adresse non attribuée (projet)'),
    ('32','Adresse non numérotée'),
    ('33','Adresse à confirmer (existence, numéro ...)'),           
    ('99','Autre'),
    ('00','Non renseigné');
    
    

-- ################################################################# Domaine valeur - qual_adr  ###############################################

-- Table: r_adresse.lt_qual_adr

-- DROP TABLE r_adresse.lt_qual_adr;

CREATE TABLE r_adresse.lt_qual_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à l'indice de qualité simplifié de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à l'indice de qualité simplifié de l'adresse
  CONSTRAINT lt_qual_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_qual_adr
    OWNER to create_sig;


COMMENT ON TABLE r_adresse.lt_qual_adr
  IS 'Code permettant de décrire un indice de qualité simplifié d''une adresse';
COMMENT ON COLUMN r_adresse.lt_qual_adr.code IS 'Code de la liste énumérée relative à l''indice de qualité simplifié de l''adresse';
COMMENT ON COLUMN r_adresse.lt_qual_adr.valeur IS 'Valeur de la liste énumérée relative à à l''indice de qualité simplifié de l''adresse';

INSERT INTO r_adresse.lt_qual_adr(
            code, valeur)
    VALUES
    ('1','Bon'),
    ('2','Moyen'),
    ('3','Mauvais'),
    ('9','Autre'),
    ('0','Non renseigné');


-- ################################################################# Domaine valeur - src_geom  ###############################################

-- Type d'énumération urbanisé et présent dans le schéma r_objet
-- Voir table r_objet.lt_src_geom



-- ################################################################# Domaine valeur - destination  ###############################################

-- Table: r_adresse.lt_dest_adr

-- DROP TABLE r_adresse.lt_dest_adr;

CREATE TABLE r_adresse.lt_dest_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à la destination de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la destination de l'adresse
  definition character varying(254) NOT NULL, -- Définition de la liste énumérée relative à la destination de l'adresse
  CONSTRAINT lt_dest_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_dest_adr
    OWNER to create_sig;


COMMENT ON TABLE r_adresse.lt_dest_adr
  IS 'Code permettant de décrire la destination de l''adresse';
COMMENT ON COLUMN r_adresse.lt_dest_adr.code IS 'Code de la liste énumérée relative à la destination de l''adresse';
COMMENT ON COLUMN r_adresse.lt_dest_adr.valeur IS 'Valeur de la liste énumérée relative à la destination de l''adresse';
COMMENT ON COLUMN r_adresse.lt_dest_adr.definition IS 'Définition de la liste énumérée relative à la destination de l''adresse';

INSERT INTO r_adresse.lt_dest_adr(
            code, valeur, definition)
    VALUES
    ('01','Habitation','Appartement, maison ...'),
    ('02','Etablissement','Commerce, entreprise ...'),
    ('03','Equipement urbain','Stade, piscine ...'),
    ('04','Communauté','Maison de retraite, internat, gendarmerie, ...'),
    ('05','Habitation + Etablissement','Logements et commerces à la même adresse'),
    ('99','Autre','Parking, garage privés ...'),
    ('00','Non renseigné','*');


-- ################################################################# Domaine valeur - Etat de la construction  ###############################################

-- Table: r_adresse.lt_etat_adr

-- DROP TABLE r_adresse.lt_etat_adr;

CREATE TABLE r_adresse.lt_etat_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à l'état de la construction à l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à l'état de la construction à l'adresse
  definition character varying(254) NOT NULL, -- Définition de la liste énumérée relative à l'état de la construction à l'adresse
  CONSTRAINT lt_etat_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_etat_adr
    OWNER to create_sig;


COMMENT ON TABLE r_adresse.lt_etat_adr
  IS 'Code permettant de décrire l''état de la construction à l''adresse';
COMMENT ON COLUMN r_adresse.lt_etat_adr.code IS 'Code de la liste énumérée relative à l''état de la construction à l''adresse';
COMMENT ON COLUMN r_adresse.lt_etat_adr.valeur IS 'Valeur de la liste énumérée relative à l''état de la construction à l''adresse';
COMMENT ON COLUMN r_adresse.lt_etat_adr.definition IS 'Définition de la liste énumérée relative à l''état de la construction à l''adresse';

INSERT INTO r_adresse.lt_etat_adr(
            code, valeur, definition)
    VALUES
    ('01','Non commencé','Construction à l''état de projet'),
    ('02','En cours','Construction en cours'),
    ('03','Achevé','Construction à l''état d''occupation viable'),
    ('04','Muré','Construction murée, en ruine'),
    ('05','Supprimé','Construction détruite'),
    ('99','Autre','Autre état'),
    ('00','Non renseigné','*');
    

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        FKEY                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Foreign Key: r_objet.geo_objet_pt_adresse_id_tronc_fkey

-- ALTER TABLE r_objet.geo_objet_pt_adresse DROP CONSTRAINT geo_objet_adresse_id_tronc_fkey;

ALTER TABLE r_objet.geo_objet_pt_adresse
  ADD CONSTRAINT geo_objet_adresse_id_tronc_fkey FOREIGN KEY (id_tronc)
      REFERENCES r_objet.geo_objet_troncon (id_tronc) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- Foreign Key: r_objet.geo_objet_pt_adresse_id_voie_fkey

-- ALTER TABLE r_objet.geo_objet_pt_adresse DROP CONSTRAINT geo_objet_adresse_id_voie_fkey;

ALTER TABLE r_objet.geo_objet_pt_adresse
  ADD CONSTRAINT geo_objet_adresse_id_voie_fkey FOREIGN KEY (id_voie)
      REFERENCES r_voie.an_voie (id_voie) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;
      
-- Foreign Key: r_adresse.an_adresse_id_adresse_fkey

-- ALTER TABLE r_adresse.an_adresse DROP CONSTRAINT an_adresse_id_adresse_fkey;

ALTER TABLE r_adresse.an_adresse
  ADD CONSTRAINT an_adresse_id_adresse_fkey FOREIGN KEY (id_adresse)
      REFERENCES r_objet.geo_objet_pt_adresse (id_adresse) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

-- Foreign Key: r_adresse.an_adresse_info_id_adresse_fkey

-- ALTER TABLE r_adresse.an_adresse_info DROP CONSTRAINT an_adresse_info_id_adresse_fkey;

ALTER TABLE r_adresse.an_adresse_info
  ADD CONSTRAINT an_adresse_id_adresse_info_fkey FOREIGN KEY (id_adresse)
      REFERENCES r_objet.geo_objet_pt_adresse (id_adresse) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

-- ### an_adresse   
      
-- Foreign Key: r_adresse.an_adresse_lt_src_adr_fkey

-- ALTER TABLE r_adresse.an_adresse DROP CONSTRAINT an_adresse_lt_src_adr_fkey;

ALTER TABLE r_adresse.an_adresse
  ADD CONSTRAINT an_adresse_lt_src_adr_fkey FOREIGN KEY (src_adr)
      REFERENCES r_adresse.lt_src_adr (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;    


-- Foreign Key: r_adresse.an_adresse_lt_diag_adr_fkey

-- ALTER TABLE r_adresse.an_adresse DROP CONSTRAINT an_adresse_lt_diag_adr_fkey;

ALTER TABLE r_adresse.an_adresse
  ADD CONSTRAINT an_adresse_lt_diag_adr_fkey FOREIGN KEY (diag_adr)
      REFERENCES r_adresse.lt_diag_adr (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;


-- Foreign Key: r_adresse.an_adresse_lt_qual_adr_fkey

-- ALTER TABLE r_adresse.an_adresse DROP CONSTRAINT an_adresse_lt_qual_adr_fkey;

ALTER TABLE r_adresse.an_adresse
  ADD CONSTRAINT an_adresse_lt_qual_adr_fkey FOREIGN KEY (qual_adr)
      REFERENCES r_adresse.lt_qual_adr (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- ### geo_adresse    

-- Foreign Key: r_objet.lt_src_geom_fkey

-- ALTER TABLE r_objet.geo_objet_pt_adresse DROP CONSTRAINT geo_objet_adresse_lt_src_geom_fkey;

ALTER TABLE r_objet.geo_objet_pt_adresse
  ADD CONSTRAINT geo_objet_adresse_lt_src_geom_fkey FOREIGN KEY (src_geom)
      REFERENCES r_objet.lt_src_geom (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;


-- Foreign Key: r_objet.lt_position_fkey

-- ALTER TABLE r_objet.geo_objet_pt_adresse DROP CONSTRAINT geo_objet_adresse_lt_position_fkey;

ALTER TABLE r_objet.geo_objet_pt_adresse
  ADD CONSTRAINT geo_objet_adresse_lt_position_fkey FOREIGN KEY (position)
      REFERENCES r_objet.lt_position (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- ### an_adresse_info

-- Foreign Key: r_adresse.an_adresse_info_lt_groupee_fkey

-- ALTER TABLE r_adresse.an_adresse_info DROP CONSTRAINT an_adresse_info_lt_groupee_fkey;

ALTER TABLE r_adresse.an_adresse_info
  ADD CONSTRAINT an_adresse_lt_groupee_fkey FOREIGN KEY (groupee)
      REFERENCES r_adresse.lt_groupee (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;  

-- Foreign Key: r_adresse.an_adresse_info_lt_secondaire_fkey

-- ALTER TABLE r_adresse.an_adresse_info DROP CONSTRAINT an_adresse_info_lt_secondaire_fkey;

ALTER TABLE r_adresse.an_adresse_info
  ADD CONSTRAINT an_adresse_lt_secondaire_fkey FOREIGN KEY (secondaire)
      REFERENCES r_adresse.lt_secondaire (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;  

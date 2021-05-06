/*SIGNALEMENT ADRESSE-VOIE V1.0*/
/*Creation du squelette de la structure des données (tables, séquences, triggers,...) */
/*sign_10_SQUELETTE.sql */
/*PostGIS*/
/*GeoCompiegnois - http://geo.compiegnois.fr/ */
/*Auteur : Grégory Bodet */

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     DROP                                                                     ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- DROP SCHEMA IF EXISTS m_signalement CASCADE;

DROP TABLE IF EXISTS m_signalement.geo_rva_signal;
DROP TABLE IF EXISTS m_signalement.an_rva_signal_media;
DROP TABLE IF EXISTS m_signalement.lt_type_rva;
DROP TABLE IF EXISTS m_signalement.lt_nat_signal;
DROP TABLE IF EXISTS m_signalement.lt_acte_admin;
DROP TABLE IF EXISTS m_signalement.lt_traite_sig;

DROP SEQUENCE IF EXISTS m_signalement.geo_rva_signal_id_seq;
DROP SEQUENCE IF EXISTS m_signalement.an_rva_signal_media_gid_seq;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                     SCHEMA                                                                   ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


CREATE SCHEMA m_signalement
    AUTHORIZATION create_sig;

COMMENT ON SCHEMA m_signalement
    IS 'Schéma contenant les différentes tables gérant les signalements';

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      REF OBJET                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### OBJET rva_signalement #################################################################  
  
-- Table: m_signalement.geo_rva_signal

-- DROP TABLE m_signalement.geo_rva_signal;

CREATE TABLE m_signalement.geo_rva_signal
(
  id_signal bigint NOT NULL, -- Identifiant unique de l'objet de signalement
  insee character varying(5) NOT NULL, -- Code INSEE de la commune
  commune character varying(80) NOT NULL,-- Nom de la commune
  type_rva character varying(1) NOT NULL,-- Type de référentiel voie/adresse concerné par un signalement
  nat_signal character varying(1) NOT NULL,-- Nature du signalement
  acte_admin character varying(1) NOT NULL,-- Indication de la présence ou non d'un document administratif  
  observ character varying(254), -- Commentaire texte libre pour décrire le signalement
  op_sai character varying(254), -- Nom du contributeur
  mail character varying(254), -- Adresse mail de contact du contributeur 
  traite_sig character varying(1) NOT NULL,-- Indication de l'état du traitement du signalement par le service SIG 
  c_circu character varying(50),-- Contraintes de circulation
  c_observ character varying(1000),-- Complément sur les contraintes de circulation
  v_max character varying(3), -- Contrainte de vitesse
  x_l93 numeric(8,2) NOT NULL, -- Coordonnée X en mètre
  y_l93 numeric(9,2) NOT NULL, -- Coordonnée Y en mètre
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Horodatage de l'intégration en base de l'objet   
  date_maj timestamp without time zone, -- Horodatage de la mise à jour en base de l'objet
  geom geometry(Point,2154), -- Géométrie point de l'objet

  CONSTRAINT geo_rva_signal_pkey PRIMARY KEY (id_signal)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_signalement.geo_rva_signal
  OWNER TO sig_create;


COMMENT ON TABLE public.geo_rva_signal
  IS 'Donnée de signalement sur le réferentiel local voie et adresse (rva)';
COMMENT ON COLUMN m_signalement.geo_rva_signal.id_signal IS 'Identifiant unique de l''objet de signalement';
COMMENT ON COLUMN m_signalement.geo_rva_signal.insee IS 'Code INSEE de la commune';
COMMENT ON COLUMN m_signalement.geo_rva_signal.commune IS 'Nom de la commune';
COMMENT ON COLUMN m_signalement.geo_rva_signal.type_rva IS 'Type de référentiel voie/adresse concerné par un signalement';
COMMENT ON COLUMN m_signalement.geo_rva_signal.nat_signal IS 'Nature du signalement';
COMMENT ON COLUMN m_signalement.geo_rva_signal.acte_admin IS 'Indication de la présence ou non d''un document administratif';
COMMENT ON COLUMN m_signalement.geo_rva_signal.observ IS 'Commentaire texte libre pour décrire le signalement';
COMMENT ON COLUMN m_signalement.geo_rva_signal.op_sai IS 'Nom du contributeur';
COMMENT ON COLUMN m_signalement.geo_rva_signal.mail IS 'Adresse mail de contact du contributeur';
COMMENT ON COLUMN m_signalement.geo_rva_signal.traite_sig IS 'Indication de l''état du traitement du signalement par le service SIG';
COMMENT ON COLUMN m_signalement.geo_rva_signal.c_circu IS 'Contraintes de circulation';
COMMENT ON COLUMN m_signalement.geo_rva_signal.c_observ IS 'Complément sur les contraintes de circulation';
COMMENT ON COLUMN m_signalement.geo_rva_signal.v_max IS 'Contrainte de vitesse';
COMMENT ON COLUMN m_signalement.geo_rva_signal.x_l93 IS 'Coordonnée X en mètre';
COMMENT ON COLUMN m_signalement.geo_rva_signal.y_l93 IS 'Coordonnée Y en mètre';
COMMENT ON COLUMN m_signalement.geo_rva_signal.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN m_signalement.geo_rva_signal.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN m_signalement.geo_rva_signal.geom IS 'Géomètrie ponctuelle de l''objet';

-- Index: m_signalement.geo_rva_signal_geom

-- DROP INDEX m_signalement.geo_rva_signal_geom;

CREATE INDEX sidx_geo_rva_signal_geom
  ON m_signalement.geo_rva_signal
  USING gist
  (geom);

-- Sequence: public.geo_rva_signal_id_seq

-- DROP SEQUENCE public.geo_rva_signal_id_seq;

CREATE SEQUENCE m_signalement.geo_rva_signal_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE m_signalement.geo_rva_signal_id_seq
  OWNER TO sig_create;

ALTER TABLE m_signalement.geo_rva_signal ALTER COLUMN id_signal SET DEFAULT nextval('m_signalement.geo_rva_signal_id_seq'::regclass);


-- #################################################################### OBJET rva_signal_media #################################################################  

-- Table: m_signalement.an_rva_signal_media

-- DROP TABLE m_signalement.an_rva_signal_media;

CREATE TABLE m_signalement.an_rva_signal_media
(
  id_signal bigint NOT NULL, -- Identifiant du signalement
  media bytea, -- Champ média
  miniature bytea, -- Champ miniature
  n_fichier text, -- Nom du fichier
  t_fichier text -- Type de média

)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_signalement.an_rva_signal_media
  OWNER TO sig_create;


COMMENT ON TABLE m_signalement.an_rva_signal_media
  IS 'Table documentaire liée au signalements sur le référentiel local voie et adresse (rva)';
  
COMMENT ON COLUMN m_signalement.an_rva_signal_media.id_signal IS 'Identifiant du signalement';
COMMENT ON COLUMN m_signalement.an_rva_signal_media.media IS 'Champ média';
COMMENT ON COLUMN m_signalement.an_rva_signal_media.miniature IS 'Champ miniature';
COMMENT ON COLUMN m_signalement.an_rva_signal_media.n_fichier IS 'Nom du fichier';
COMMENT ON COLUMN m_signalement.an_rva_signal_media.t_fichier IS 'Type de média';


-- SEQUENCE: m_signalement.an_rva_signal_media_gid_seq

-- DROP SEQUENCE m_signalement.an_rva_signal_media_gid_seq;

CREATE SEQUENCE m_signalement.an_rva_signal_media_gid_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE m_signalement.an_rva_signal_media_gid_seq
    OWNER TO create_sig;



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- ################################################################# Domaine valeur - type_rva  ###############################################

-- Table: m_signalement.lt_type_rva

-- DROP TABLE m_signalement.lt_type_rva;

CREATE TABLE m_signalement.lt_type_rva
(
  code character varying(1) NOT NULL, -- Code de la liste énumérée relative au type de référentiel voie/adresse concerné par un signalement
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au type de référentiel voie/adresse concerné par un signalement
  CONSTRAINT lt_type_rva_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_signalement.lt_type_rva
  OWNER TO sig_çreate;

COMMENT ON TABLE m_signalement.lt_type_rva
  IS 'Code permettant de décrire le type de référentiel voie/adresse concerné par un signalement';
  
COMMENT ON COLUMN m_signalement.lt_type_rva.code IS 'Code de la liste énumérée relative au type de référentiel voie/adresse concerné par un signalement';
COMMENT ON COLUMN m_signalement.lt_type_rva.valeur IS 'Valeur de la liste énumérée relative au type de référentiel voie/adresse concerné par un signalement';

INSERT INTO m_signalement.lt_type_rva(
            code, valeur)
    VALUES
    ('1','Adresse'),
    ('2','Voie'),
    ('9','Autre'),
    ('0','Non renseigné');

-- ################################################################# Domaine valeur - nat_signal  ###############################################

-- Table: m_signalement.lt_nat_signal

-- DROP TABLE m_signalement.lt_nat_signal;

CREATE TABLE m_signalement.lt_nat_signal
(
  code character varying(1) NOT NULL, -- Code de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  CONSTRAINT lt_nat_signal_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_signalement.lt_nat_signal
  OWNER TO sig_create;

COMMENT ON TABLE m_signalement.lt_nat_signal
  IS 'Code permettant de décrire la nature du signalement sur le référentiel voie/adresse';
  
COMMENT ON COLUMN m_signalement.lt_nat_signal.code IS 'Code de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse';
COMMENT ON COLUMN m_signalement.lt_nat_signal.valeur IS 'Valeur de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse';

INSERT INTO m_signalement.lt_nat_signal(
            code, valeur)
    VALUES
    ('1','Création'),
    ('2','Modification'),
    ('3','Suppression'),
    ('4','Modification du libellé de la voie'),
    ('5','Modification du numéro de voirie'),
    ('6','Ajout d''un élément liée à la chaussée (contrainte de circulation, année d''ouverture, ...'),
    ('9','Autre'),
    ('0','Non renseigné');

-- ################################################################# Domaine valeur - acte_admin  ###############################################

-- Table: m_signalement.lt_acte_admin

-- DROP TABLE m_signalement.lt_acte_admin;

CREATE TABLE m_signalement.lt_acte_admin
(
  code character varying(1) NOT NULL, -- Code de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  CONSTRAINT lt_acte_admin_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_signalement.lt_acte_admin
  OWNER TO sig_create;

COMMENT ON TABLE m_signalement.lt_acte_admin
  IS 'Code permettant de décrire la présence ou non d''un acte administratif lié au signalement';
  
COMMENT ON COLUMN m_signalement.lt_acte_admin.code IS 'Code de la liste énumérée relative à la présence ou non d''un acte administratif lié au signalement';
COMMENT ON COLUMN m_signalement.lt_acte_admin.valeur IS 'Valeur de la liste énumérée relative à la présence ou non d''un acte administratif lié au signalement';

INSERT INTO m_signalement.lt_acte_admin(
            code, valeur)
    VALUES
    ('1','Oui'),
    ('2','Non'),
    ('0','Non renseigné');   


-- ################################################################# Domaine valeur - traite_sig  ###############################################

-- Table: m_signalement.lt_traite_sig

-- DROP TABLE m_signalement.lt_traite_sig;

CREATE TABLE m_signalement.lt_traite_sig
(
  code character varying(1) NOT NULL, -- Code de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  CONSTRAINT lt_traite_sig_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE m_signalement.lt_traite_sig
  OWNER TO sig_create;

COMMENT ON TABLE m_signalement.lt_traite_sig
  IS 'Code permettant de décrire l''état du traitement du signalement par le service SIG';
  
COMMENT ON COLUMN m_signalement.lt_traite_sig.code IS 'Code de la liste énumérée relative à l''état du traitement du signalement par le service SIG';
COMMENT ON COLUMN m_signalement.lt_traite_sig.valeur IS 'Valeur de la liste énumérée relative à l''état du traitement du signalement par le service SIG';

INSERT INTO m_signalement.lt_traite_sig(
            code, valeur)
    VALUES
    ('1','Oui'),
    ('2','Non'),
    ('0','Non renseigné');   

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        FKEY                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Foreign Key: m_signalement.lt_type_rva_fkey

-- ALTER TABLE m_signalement.geo_rva_signal DROP CONSTRAINT lt_type_rva_fkey;

ALTER TABLE m_signalement.geo_rva_signal
  ADD CONSTRAINT geo_rva_signal_lt_type_rva_fkey FOREIGN KEY (type_rva)
      REFERENCES m_signalement.lt_type_rva (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- Foreign Key: m_signalement.lt_nat_signal_fkey

-- ALTER TABLE m_signalement.geo_rva_signal DROP CONSTRAINT lt_nat_signal_fkey;

ALTER TABLE m_signalement.geo_rva_signal
  ADD CONSTRAINT geo_rva_signal_lt_nat_signal_fkey FOREIGN KEY (nat_signal)
      REFERENCES m_signalement.lt_nat_signal (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;
      
-- Foreign Key: m_signalement.lt_acte_admin_fkey

-- ALTER TABLE m_signalement.geo_rva_signal DROP CONSTRAINT lt_acte_admin_fkey;

ALTER TABLE m_signalement.geo_rva_signal
  ADD CONSTRAINT geo_rva_signal_lt_acte_admin_fkey FOREIGN KEY (acte_admin)
      REFERENCES m_signalement.lt_acte_admin (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- Foreign Key: m_signalement.lt_traite_sig_fkey

-- ALTER TABLE m_signalement.geo_rva_signal DROP CONSTRAINT lt_traite_sig_fkey;

ALTER TABLE m_signalement.geo_rva_signal
  ADD CONSTRAINT geo_rva_signal_lt_traite_sig_fkey FOREIGN KEY (traite_sig)
      REFERENCES m_signalement.lt_traite_sig (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

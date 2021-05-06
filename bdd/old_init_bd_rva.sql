-- #################################################################### SUIVI CODE SQL ####################################################################

-- 2017/01/12 : FV / initialisation du code pour une donnée de signalement sur le Référentiel des Voies et Adresses (RVA)
-- 2018/03/20 : GB / Intégration des modifications suite au groupe de travail RVA du 13 mars 2018
-- 2018/08/07 : GB / Intégration des nouveaux rôles de connexionss et leurs privilèges
-- 2020/09/23 : GB / Modification de la gestion des suppression des signalements (possible à partir de la vue de gestion à travers le projet QGIS mais pas à travers l'application WEB)

-- gestion documentaire contrainte sous GEO
  
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      REF OBJET                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### OBJET rva_signalement #################################################################  
  
-- Table: public.geo_rva_signal

-- DROP TABLE public.geo_rva_signal;

CREATE TABLE public.geo_rva_signal
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
ALTER TABLE public.geo_rva_signal
  OWNER TO sig_create;
GRANT ALL ON TABLE public.geo_rva_signal TO sig_create;
GRANT SELECT ON TABLE public.geo_rva_signal TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.geo_rva_signal TO edit_sig;

COMMENT ON TABLE public.geo_rva_signal
  IS 'Donnée de signalement sur le réferentiel local voie et adresse (rva)';
COMMENT ON COLUMN public.geo_rva_signal.id_signal IS 'Identifiant unique de l''objet de signalement';
COMMENT ON COLUMN public.geo_rva_signal.insee IS 'Code INSEE de la commune';
COMMENT ON COLUMN public.geo_rva_signal.commune IS 'Nom de la commune';
COMMENT ON COLUMN public.geo_rva_signal.type_rva IS 'Type de référentiel voie/adresse concerné par un signalement';
COMMENT ON COLUMN public.geo_rva_signal.nat_signal IS 'Nature du signalement';
COMMENT ON COLUMN public.geo_rva_signal.acte_admin IS 'Indication de la présence ou non d''un document administratif';
COMMENT ON COLUMN public.geo_rva_signal.observ IS 'Commentaire texte libre pour décrire le signalement';
COMMENT ON COLUMN public.geo_rva_signal.op_sai IS 'Nom du contributeur';
COMMENT ON COLUMN public.geo_rva_signal.mail IS 'Adresse mail de contact du contributeur';
COMMENT ON COLUMN public.geo_rva_signal.traite_sig IS 'Indication de l''état du traitement du signalement par le service SIG';
COMMENT ON COLUMN public.geo_rva_signal.c_circu IS 'Contraintes de circulation';
COMMENT ON COLUMN public.geo_rva_signal.c_observ IS 'Complément sur les contraintes de circulation';
COMMENT ON COLUMN public.geo_rva_signal.v_max IS 'Contrainte de vitesse';
COMMENT ON COLUMN public.geo_rva_signal.x_l93 IS 'Coordonnée X en mètre';
COMMENT ON COLUMN public.geo_rva_signal.y_l93 IS 'Coordonnée Y en mètre';
COMMENT ON COLUMN public.geo_rva_signal.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN public.geo_rva_signal.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN public.geo_rva_signal.geom IS 'Géomètrie ponctuelle de l''objet';

-- Index: public.geo_rva_signal_geom

-- DROP INDEX public.geo_rva_signal_geom;

CREATE INDEX sidx_geo_rva_signal_geom
  ON public.geo_rva_signal
  USING gist
  (geom);

-- Sequence: public.geo_rva_signal_id_seq

-- DROP SEQUENCE public.geo_rva_signal_id_seq;

CREATE SEQUENCE public.geo_rva_signal_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE public.geo_rva_signal_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE public.geo_rva_signal_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE public.geo_rva_signal_id_seq TO public;


ALTER TABLE public.geo_rva_signal ALTER COLUMN id_signal SET DEFAULT nextval('public.geo_rva_signal_id_seq'::regclass);


-- #################################################################### OBJET rva_signal_media #################################################################  

-- Table: public.an_rva_signal_media

-- DROP TABLE public.an_rva_signal_media;

CREATE TABLE public.an_rva_signal_media
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
ALTER TABLE public.an_rva_signal_media
  OWNER TO sig_create;
GRANT ALL ON TABLE public.an_rva_signal_media TO sig_create;
GRANT SELECT ON TABLE public.an_rva_signal_media TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.an_rva_signal_media TO edit_sig;

COMMENT ON TABLE public.an_rva_signal_media
  IS 'Table documentaire liée au signalements sur le référentiel local voie et adresse (rva)';
COMMENT ON COLUMN public.an_rva_signal_media.id_signal IS 'Identifiant du signalement';
COMMENT ON COLUMN public.an_rva_signal_media.media IS 'Champ média';
COMMENT ON COLUMN public.an_rva_signal_media.miniature IS 'Champ miniature';
COMMENT ON COLUMN public.an_rva_signal_media.n_fichier IS 'Nom du fichier';
COMMENT ON COLUMN public.an_rva_signal_media.t_fichier IS 'Type de média';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- ################################################################# Domaine valeur - type_rva  ###############################################

-- Table: public.lt_type_rva

-- DROP TABLE public.lt_type_rva;

CREATE TABLE public.lt_type_rva
(
  code character varying(1) NOT NULL, -- Code de la liste énumérée relative au type de référentiel voie/adresse concerné par un signalement
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au type de référentiel voie/adresse concerné par un signalement
  CONSTRAINT lt_type_rva_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lt_type_rva
  OWNER TO sig_çreate;
GRANT ALL ON TABLE public.lt_type_rva TO sig_create;
GRANT SELECT ON TABLE public.lt_type_rva TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.lt_type_rva TO edit_sig;

COMMENT ON TABLE public.lt_type_rva
  IS 'Code permettant de décrire le type de référentiel voie/adresse concerné par un signalement';
COMMENT ON COLUMN public.lt_type_rva.code IS 'Code de la liste énumérée relative au type de référentiel voie/adresse concerné par un signalement';
COMMENT ON COLUMN public.lt_type_rva.valeur IS 'Valeur de la liste énumérée relative au type de référentiel voie/adresse concerné par un signalement';

INSERT INTO public.lt_type_rva(
            code, valeur)
    VALUES
    ('1','Adresse'),
    ('2','Voie'),
    ('9','Autre'),
    ('0','Non renseigné');

-- ################################################################# Domaine valeur - nat_signal  ###############################################

-- Table: public.lt_nat_signal

-- DROP TABLE public.lt_nat_signal;

CREATE TABLE public.lt_nat_signal
(
  code character varying(1) NOT NULL, -- Code de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  CONSTRAINT lt_nat_signal_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lt_nat_signal
  OWNER TO sig_create;
GRANT ALL ON TABLE public.lt_nat_signal TO sig_create;
GRANT SELECT ON TABLE public.lt_nat_signal TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.lt_nat_signal TO edit_sig;

COMMENT ON TABLE public.lt_nat_signal
  IS 'Code permettant de décrire la nature du signalement sur le référentiel voie/adresse';
COMMENT ON COLUMN public.lt_nat_signal.code IS 'Code de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse';
COMMENT ON COLUMN public.lt_nat_signal.valeur IS 'Valeur de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse';

INSERT INTO public.lt_nat_signal(
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

-- Table: public.lt_acte_admin

-- DROP TABLE public.lt_acte_admin;

CREATE TABLE public.lt_acte_admin
(
  code character varying(1) NOT NULL, -- Code de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  CONSTRAINT lt_acte_admin_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lt_acte_admin
  OWNER TO sig_create;
GRANT ALL ON TABLE public.lt_acte_admin TO sig_create;
GRANT SELECT ON TABLE public.lt_acte_admin TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.lt_acte_admin TO edit_sig;

COMMENT ON TABLE public.lt_acte_admin
  IS 'Code permettant de décrire la présence ou non d''un acte administratif lié au signalement';
COMMENT ON COLUMN public.lt_acte_admin.code IS 'Code de la liste énumérée relative à la présence ou non d''un acte administratif lié au signalement';
COMMENT ON COLUMN public.lt_acte_admin.valeur IS 'Valeur de la liste énumérée relative à la présence ou non d''un acte administratif lié au signalement';

INSERT INTO public.lt_acte_admin(
            code, valeur)
    VALUES
    ('1','Oui'),
    ('2','Non'),
    ('0','Non renseigné');   


-- ################################################################# Domaine valeur - traite_sig  ###############################################

-- Table: public.lt_traite_sig

-- DROP TABLE public.lt_traite_sig;

CREATE TABLE public.lt_traite_sig
(
  code character varying(1) NOT NULL, -- Code de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la nature du signalement sur le référentiel voie/adresse
  CONSTRAINT lt_traite_sig_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.lt_traite_sig
  OWNER TO sig_create;
GRANT ALL ON TABLE public.lt_traite_sig TO sig_create;
GRANT SELECT ON TABLE public.lt_traite_sig TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.lt_traite_sig TO edit_sig;

COMMENT ON TABLE public.lt_traite_sig
  IS 'Code permettant de décrire l''état du traitement du signalement par le service SIG';
COMMENT ON COLUMN public.lt_traite_sig.code IS 'Code de la liste énumérée relative à l''état du traitement du signalement par le service SIG';
COMMENT ON COLUMN public.lt_traite_sig.valeur IS 'Valeur de la liste énumérée relative à l''état du traitement du signalement par le service SIG';

INSERT INTO public.lt_traite_sig(
            code, valeur)
    VALUES
    ('1','Oui'),
    ('2','Non'),
    ('0','Non renseigné');   


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- View: public.geo_v_rva_signal

-- DROP VIEW public.geo_v_rva_signal;

CREATE OR REPLACE VIEW public.geo_v_rva_signal AS 
 SELECT s.id_signal,
    s.insee,
    s.commune,
    s.type_rva,
    s.nat_signal,
    s.acte_admin,
    string_agg(((m.n_fichier || chr(10)) || 'http://geo.compiegnois.fr/documents/metiers/rva/signalement/'::text) || m.media, chr(10)) AS document,
    s.observ,
    s.op_sai,
    s.mail,
    s.traite_sig,
    s.x_l93,
    s.y_l93,
    s.date_sai,
    s.date_maj,
    s.geom
   FROM geo_rva_signal s
     LEFT JOIN an_rva_signal_media m ON s.id_signal = m.id
  GROUP BY s.id_signal, s.insee, s.commune, s.type_rva, s.nat_signal, s.acte_admin, s.observ, s.op_sai, s.mail, s.traite_sig, s.x_l93, s.y_l93, s.date_sai, s.date_maj, s.geom;

ALTER TABLE public.geo_v_rva_signal
GRANT ALL ON TABLE public.geo_v_rva_signal TO sig_create;
GRANT SELECT ON TABLE public.geo_v_rva_signal TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE public.geo_v_rva_signal TO edit_sig;
                                                                                                                                  
COMMENT ON VIEW public.geo_v_rva_signal
  IS 'Vue géographique éditable pour l''intégration des signalements dans la base de voies et adresses';





-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        FKEY                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Foreign Key: public.lt_type_rva_fkey

-- ALTER TABLE public.geo_rva_signal DROP CONSTRAINT lt_type_rva_fkey;

ALTER TABLE public.geo_rva_signal
  ADD CONSTRAINT geo_rva_signal_lt_type_rva_fkey FOREIGN KEY (type_rva)
      REFERENCES public.lt_type_rva (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- Foreign Key: public.lt_nat_signal_fkey

-- ALTER TABLE public.geo_rva_signal DROP CONSTRAINT lt_nat_signal_fkey;

ALTER TABLE public.geo_rva_signal
  ADD CONSTRAINT geo_rva_signal_lt_nat_signal_fkey FOREIGN KEY (nat_signal)
      REFERENCES public.lt_nat_signal (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;
      
-- Foreign Key: public.lt_acte_admin_fkey

-- ALTER TABLE public.geo_rva_signal DROP CONSTRAINT lt_acte_admin_fkey;

ALTER TABLE public.geo_rva_signal
  ADD CONSTRAINT geo_rva_signal_lt_acte_admin_fkey FOREIGN KEY (acte_admin)
      REFERENCES public.lt_acte_admin (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- Foreign Key: public.lt_traite_sig_fkey

-- ALTER TABLE public.geo_rva_signal DROP CONSTRAINT lt_traite_sig_fkey;

ALTER TABLE public.geo_rva_signal
  ADD CONSTRAINT geo_rva_signal_lt_traite_sig_fkey FOREIGN KEY (traite_sig)
      REFERENCES public.lt_traite_sig (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### FONCTION TRIGGER - GEO_RVA_SIGNALEMENT ###################################################

-- Function: public.ft_geo_rva_signal()

-- DROP FUNCTION public.ft_geo_rva_signal();

CREATE OR REPLACE FUNCTION public.ft_geo_rva_signal()
  RETURNS trigger AS
$BODY$

DECLARE v_id_signal integer;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

NEW.insee :=(SELECT geo_osm_commune.insee AS insee FROM r_osm.geo_osm_commune WHERE st_intersects(new.geom,r_osm.geo_osm_commune.geom) = true); 
NEW.commune :=(SELECT geo_osm_commune.commune AS commune FROM r_osm.geo_osm_commune WHERE st_intersects(new.geom,r_osm.geo_osm_commune.geom) = true);
NEW.traite_sig ='2';
NEW.x_l93=ST_X(new.geom);
NEW.y_l93=ST_Y(new.geom);
NEW.date_sai=now();
NEW.date_maj = NULL;

RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

NEW.insee=(SELECT geo_osm_commune.insee AS insee FROM r_osm.geo_osm_commune WHERE st_intersects(new.geom,r_osm.geo_osm_commune.geom) = true);
NEW.commune=(SELECT geo_osm_commune.commune AS commune FROM r_osm.geo_osm_commune WHERE st_intersects(new.geom,r_osm.geo_osm_commune.geom) = true);
NEW.x_l93=ST_X(new.geom);
NEW.y_l93=ST_Y(new.geom);
NEW.date_sai=OLD.date_sai;
NEW.date_maj=now();

RETURN NEW;

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.ft_geo_rva_signal()
  OWNER TO sig_create;
GRANT EXECUTE ON FUNCTION public.ft_geo_rva_signal() TO public;
GRANT EXECUTE ON FUNCTION public.ft_geo_rva_signal() TO sig_create;
GRANT EXECUTE ON FUNCTION public.ft_geo_rva_signal() TO create_sig;
                                                                                                                     
                                                                                                                                  
COMMENT ON FUNCTION public.ft_geo_rva_signal() IS 'Fonction trigger pour mise à jour de la donnée de signalement du référentiel voie/adresse';



-- Trigger: public.t_geo_rva_signal on public.geo_rva_signal

-- DROP TRIGGER public.t_geo_rva_signal ON public.geo_rva_signal;

CREATE TRIGGER t_geo_rva_signal
  BEFORE INSERT OR UPDATE
  ON public.geo_rva_signal
  FOR EACH ROW
  EXECUTE PROCEDURE public.ft_geo_rva_signal();


                                                                                                                                  -- FUNCTION: m_signalement.ft_m_geo_v_rva_signal_traite()

-- DROP FUNCTION m_signalement.ft_m_geo_v_rva_signal_traite();

CREATE OR REPLACE FUNCTION m_signalement.ft_m_geo_v_rva_signal_traite()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

BEGIN

IF (TG_OP = 'UPDATE') THEN
	UPDATE m_signalement.geo_rva_signal SET traite_sig = new.traite_sig WHERE id_signal = new.id_signal;
END IF;

IF (TG_OP = 'DELETE') THEN

DELETE FROM m_signalement.geo_rva_signal WHERE id_signal = old.id_signal;

END IF;


	return new;
END

$BODY$;

ALTER FUNCTION m_signalement.ft_m_geo_v_rva_signal_traite()
    OWNER TO sig_create;

GRANT EXECUTE ON FUNCTION m_signalement.ft_m_geo_v_rva_signal_traite() TO sig_create;

GRANT EXECUTE ON FUNCTION m_signalement.ft_m_geo_v_rva_signal_traite() TO PUBLIC;

GRANT EXECUTE ON FUNCTION m_signalement.ft_m_geo_v_rva_signal_traite() TO create_sig;



-- Trigger: t_t1_geo_v_rva_signal_traite

DROP TRIGGER t_t1_geo_v_rva_signal_traite ON m_signalement.geo_v_rva_signal;

CREATE TRIGGER t_t1_geo_v_rva_signal_traite
    INSTEAD OF UPDATE OR DELETE
    ON m_signalement.geo_v_rva_signal
    FOR EACH ROW
    EXECUTE PROCEDURE m_signalement.ft_m_geo_v_rva_signal_traite();
                                                                                                                                  

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      BAC A SABLE                                                             ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
  
-- TRUNCATE TABLE public.geo_rva_signal, public.an_rva_signal_media, public.lt_type_rva, public.lt_nat_signal, public.lt_acte_admin, public.lt_traite_sig CASCADE;
-- ALTER SEQUENCE public.geo_rva_signal_id_seq RESTART WITH 1;





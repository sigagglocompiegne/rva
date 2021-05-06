/*VOIE V1.0*/
/*Creation des vues et triggers nécessaires à la gestion via l'application web-métier */
/*voie_20_VUES_GESTION.sql */
/*PostGIS*/
/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Grégory Bodet*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                 DROP                                                                         ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

DROP VIEW IF EXISTS r_voie.geo_v_troncon_voie;
DROP VIEW IF EXISTS m_voirie.geo_v_troncon_voirie;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                              VUES DE GESTION                                                                 ###
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

CREATE OR REPLACE FUNCTION r_voie.ft_m_an_voie_gestion()
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

-- si saisie d'un rivoli existant

IF NEW.rivoli like 'x%' THEN

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


				    
				 


/*VOIE V1.0*/
/*Creation des vues nécessaires à l'application web-métier */
/*voie_21_VUES_XAPPS.sql */
/*PostGIS*/
/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Grégory Bodet */

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                 DROP                                                                         ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

DROP VIEW IF EXISTS ;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                     VUES APPLICATIVES                                                                        ###
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

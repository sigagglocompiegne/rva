/*SIGNALEMENT VOIE ET ADRESSE V1.0*/
/*Creation des vues et triggers nécessaires à la gestion via l'application web-métier */
/*sign_20_VUES_GESTION.sql */
/*PostGIS*/
/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Grégory Bodet*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                 DROP                                                                         ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

DROP VIEW IF EXISTS m_signalement.geo_v_rva_signal;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- View: m_signalement.geo_v_rva_signal

-- DROP VIEW m_signalement.geo_v_rva_signal;

CREATE OR REPLACE VIEW m_signalement.geo_v_rva_signal AS 
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

ALTER TABLE m_signalement.geo_v_rva_signal
                                                                                                                                  
COMMENT ON VIEW m_signalement.geo_v_rva_signal
  IS 'Vue géographique éditable pour l''intégration des signalements dans la base de voies et adresses';

                                                                                                                                  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### FONCTION TRIGGER - GEO_RVA_SIGNALEMENT ###################################################

-- Function: m_signalement.ft_geo_rva_signal()

-- DROP FUNCTION m_signalement.ft_geo_rva_signal();

CREATE OR REPLACE FUNCTION m_signalement.ft_m_geo_rva_signal()
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
ALTER FUNCTION m_signalement.ft_m_geo_rva_signal()
  OWNER TO sig_create;
                                                                                                                    
                                                                                                                                  
COMMENT ON FUNCTION m_signalement.ft_geo_rva_signal() IS 'Fonction trigger pour mise à jour de la donnée de signalement du référentiel voie/adresse';



-- Trigger: m_signalement.t_geo_rva_signal on m_signalement.geo_rva_signal

-- DROP TRIGGER m_signalement.t_geo_rva_signal ON m_signalement.geo_rva_signal;

CREATE TRIGGER t_geo_rva_signal
  BEFORE INSERT OR UPDATE
  ON m_signalement.geo_rva_signal
  FOR EACH ROW
  EXECUTE PROCEDURE m_signalement.ft_geo_rva_signal();


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


-- Trigger: t_t1_geo_v_rva_signal_traite

DROP TRIGGER t_t1_geo_v_rva_signal_traite ON m_signalement.geo_v_rva_signal;

CREATE TRIGGER t_t1_geo_v_rva_signal_traite
    INSTEAD OF UPDATE OR DELETE
    ON m_signalement.geo_v_rva_signal
    FOR EACH ROW
    EXECUTE PROCEDURE m_signalement.ft_m_geo_v_rva_signal_traite();

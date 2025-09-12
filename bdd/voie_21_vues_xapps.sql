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

DROP VIEW IF EXISTS r_plan.geo_v_plan_troncon;
DROP VIEW IF EXISTS r_plan.geo_v_plan_lib_voie;
DROP VIEW IF EXISTS r_plan.geo_v_plan_lib_voie_arc;
DROP VIEW IF EXISTS r_plan.geo_v_plan_sens_uniq;
DROP VIEW IF EXISTS r_plan.geo_v_plan_cartouche;
DROP VIEW IF EXISTS x_apps.xapps_an_voie;
DROP VIEW IF EXISTS x_apps.xapps_geo_vmr_troncon_voirie;
DROP VIEW IF EXISTS x_apps.xapps_geo_vmr_voie;
DROP VIEW IF EXISTS x_apps.xapps_an_vmr_troncon;
DROP VIEW IF EXISTS xapps_an_v_troncon_h;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                     VUES APPLICATIVES                                                                        ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


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

-- r_voie.xapps_geo_vmr_voie source
drop MATERIALIZED VIEW if exists r_voie.xapps_geo_vmr_voie;
CREATE MATERIALIZED VIEW r_voie.xapps_geo_vmr_voie
TABLESPACE pg_default
AS WITH req_v AS (
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
          WHERE t.id_tronc = tr.id_tronc AND (t.id_voie_g <> t.id_voie_d OR t.id_voie_d IS NULL) AND tr.fictif = false
        UNION ALL
         SELECT t.id_voie_d AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND (t.id_voie_g <> t.id_voie_d OR t.id_voie_g IS NULL) AND tr.fictif = false
        UNION ALL
         SELECT t.id_voie_d AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND t.id_voie_g IS NULL AND t.id_voie_d IS NULL AND tr.fictif = false
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
          WHERE t.id_tronc = tr.id_tronc AND (t.id_voie_g <> t.id_voie_d OR t.id_voie_d IS NULL) AND tr.fictif = false
        UNION ALL
         SELECT t.id_voie_d AS id_voie,
            t.geom
           FROM r_objet.geo_objet_troncon t,
            r_voie.an_troncon tr
          WHERE t.id_tronc = tr.id_tronc AND (t.id_voie_g <> t.id_voie_d OR t.id_voie_g IS NULL) AND tr.fictif = false
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
UNION ALL
 SELECT row_number() OVER () AS gid,
    now() AS date_extract,
    geo_v_adresse.id_voie,
    geo_v_adresse.insee,
    0 AS long,
    geo_v_adresse.libvoie_c,
    geo_v_adresse.geom
   FROM r_adresse.geo_v_adresse
  WHERE geo_v_adresse.numero::text = '99999'::text AND geo_v_adresse.libvoie_c IS NOT null and
 ( geo_v_adresse.id_voie not in (select id_voie_d from r_objet.geo_objet_troncon where id_voie_d is not null) or
   geo_v_adresse.id_voie not in (select id_voie_g from r_objet.geo_objet_troncon where id_voie_g is not null))

  WITH DATA;



-- View indexes:
CREATE INDEX xapps_geo_vmr_voie_idvoie_idx ON r_voie.xapps_geo_vmr_voie USING btree (id_voie);
CREATE INDEX xapps_geo_vmr_voie_libvoie_c_idx ON r_voie.xapps_geo_vmr_voie USING btree (libvoie_c);


COMMENT ON MATERIALIZED VIEW r_voie.xapps_geo_vmr_voie IS 'Vue de synthèse des voies (agréagation des tronçons pour calcul, hors tronçon fictif) (générateur d''apps)
Cette vue est rafraichie toutes les nuits par une tache CRON sur le serveur sig-sgbd20.';



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


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                             VUES OPEN DATA                                                                   ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- la vue x_apps.xapps_geo_vmr_voie est utilisée dans un WorkFlow FME pour générer les exports OpenData (cf documentation de la base de données)

-- ################################################################# VUE FULL DECODEE  ###############################################

--drop view if exists r_voie.geo_v_troncon_voie_full_decode;
CREATE OR REPLACE VIEW r_voie.geo_v_troncon_voie_full_decode
AS

SELECT t.id_tronc,
    t.id_voie_g,
    t.id_voie_d,
    vg.libvoie_c AS libvoie_g,
    vg.rivoli AS rivoli_g,
    vg.id_ban_toponyme AS id_ban_toponyme_g,
    vd.libvoie_c AS libvoie_d,
    vd.rivoli AS rivoli_d,
    vd.id_ban_toponyme AS id_ban_toponyme_d,
    t.insee_g,
    t.insee_d,
    t.noeud_d,
    t.noeud_f,
    t.src_tronc,
    a.type_tronc,
    tt.valeur as type_tronc_v,
    a.hierarchie,
    h.valeur as hierarchie_v,
    a.franchiss,
    f.valeur as franchiss_v,
    a.nb_voie,
    a.projet,
    a.fictif,
    
    c.type_circu,
    tc.valeur as type_circu_v,
    c.sens_circu,
    sc.valeur as sens_circu_v,
    c.v_max,
    vc.valeur as v_max_v,
    c.src_circu,
    c.c_circu,
	case when c.c_circu = '{"00"}' then 'Non renseigné' else '' end 
    ||
    case when c.c_circu like '%10%' then 'Hauteur' else '' end 
    ||
    case when c.c_circu like '%,"20"%' then ', Largeur' else case when c.c_circu like '%20%' then 'Largeur' else '' end end
    ||
    case when c.c_circu like '%,"30"%' then ', Poids' else case when c.c_circu like '%30%' then 'Poids' else '' end end
    ||
    case when c.c_circu like '%,"40"%' then ', Marchandises dangereurses' else case when c.c_circu like '%40%' then 'Marchandises dangereurses' else '' end end
    ||
	case when c.c_circu like '%,"50"}' then ', Type de véhicules' else case when c.c_circu like '%50%' then 'Type de véhicules' else '' end end
    as c_circu_v,  
    c.c_observ,
    c.date_ouv,
    
    g.statut_jur,
    sj.valeur as statut_jur_v,
    g.num_statut,
    g.gestion,
    gt.valeur as gestion_v,
    g.doman,
      dt.valeur as doman_v,
    g.proprio,
    pt.valeur as proprio_v,
    g.src_gest,
    g.date_rem,
    
    t.pente,
    t.observ,
    t.src_geom,
    src.valeur as src_geom_v,
    t.src_date,
    t.date_sai,
    t.date_maj,
    t.geom
   FROM r_objet.geo_objet_troncon t
     left JOIN r_voie.an_troncon a ON a.id_tronc = t.id_tronc
     join r_voie.lt_type_tronc tt on tt.code = a.type_tronc
     join r_voie.lt_hierarchie h on h.code = a.hierarchie
     join r_voie.lt_franchiss f on f.code = a.franchiss
     LEFT JOIN r_voie.an_voie vg ON vg.id_voie = t.id_voie_g
     LEFT JOIN r_voie.an_voie vd ON vd.id_voie = t.id_voie_d
     left JOIN m_voirie.an_voirie_circu c ON c.id_tronc = t.id_tronc
     left JOIN m_voirie.an_voirie_gest g ON g.id_tronc = t.id_tronc
     join m_voirie.lt_type_circu tc on tc.code = c.type_circu
     join m_voirie.lt_sens_circu sc on sc.code = c.sens_circu
     join m_voirie.lt_v_max vc on vc.code = c.v_max
     join m_voirie.lt_statut_jur sj on sj.code = g.statut_jur
     join m_voirie.lt_gestion gt on gt.code = g.gestion
     join m_voirie.lt_doman dt on dt.code = g.doman
     join m_voirie.lt_gestion pt on pt.code = g.proprio
     join r_objet.lt_src_geom src on src.code = t.src_geom
     
   where t.insee_g in 
         ('60023','60067','60068','60070','60151','60156','60159','60323','60325','60326','60337','60338','60382','60402','60447','60578','60579','60597','60600','60665','60667','60674',
         '60024','60036','60040','60078','60125','60149','60152','60210','60223','60229','60254','60284','60308','60318','60369','60424','60441','60531','60540',
         '60025','60032','60064','60072','60145','60167','60171','60184','60188','60305','60324','60438','60445','60491','60534','60569','60572','60593','60641','60647',
         '60043','60119','60147','60150','60368','60373','60378','60392','60423','60492','60501','60537','60582','60636','60642','60654')
         or
         t.insee_d in 
         ('60023','60067','60068','60070','60151','60156','60159','60323','60325','60326','60337','60338','60382','60402','60447','60578','60579','60597','60600','60665','60667','60674',
         '60024','60036','60040','60078','60125','60149','60152','60210','60223','60229','60254','60284','60308','60318','60369','60424','60441','60531','60540',
         '60025','60032','60064','60072','60145','60167','60171','60184','60188','60305','60324','60438','60445','60491','60534','60569','60572','60593','60641','60647',
         '60043','60119','60147','60150','60368','60373','60378','60392','60423','60492','60501','60537','60582','60636','60642','60654')
     ;

COMMENT ON VIEW r_voie.geo_v_troncon_voie_full_decode 
IS 'Vue de synthèse de la base de voie uniquement sur les communes du Grand Compiégnois, avec tous les attributs métiers codés et décodés';


    

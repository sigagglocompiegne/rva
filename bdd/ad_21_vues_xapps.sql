/*ADRESSE V1.0*/
/*Creation des vues nécessaires à l'application web-métier */
/*ad_21_VUES_XAPPS.sql */
/*PostGIS*/
/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Grégory Bodet */

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                 DROP                                                                         ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

DROP VIEW IF EXISTS r_adresse.an_v_adresse_commune;
DROP VIEW IF EXISTS r_adresse.an_v_adresse_bal_epci;
DROP VIEW IF EXISTS x_apps.xapps_geo_vmr_adresse;
DROP VIEW IF EXISTS x_apps.xapps_an_v_adresse_h;
DROP VIEW IF EXISTS x_opendata.xopendata_an_v_bal_12;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                            VUES APPLICATIVES                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- View: r_adresse.an_v_adresse_commune

-- DROP VIEW r_adresse.an_v_adresse_commune;

CREATE OR REPLACE VIEW r_adresse.an_v_adresse_commune
 AS
 SELECT c.insee,
    c.commune,
    count(a.*) AS nbr_bal
   FROM x_apps.xapps_geo_vmr_adresse a
     LEFT JOIN r_osm.geo_osm_commune c ON a.insee = c.insee::bpchar
  GROUP BY c.insee, c.commune
  ORDER BY c.insee, c.commune;

ALTER TABLE r_adresse.an_v_adresse_commune
    OWNER TO create_sig;
COMMENT ON VIEW r_adresse.an_v_adresse_commune
    IS 'Vue d''exploitation permettant de compter le nombre d''enregistrement d''adresse par commune';

-- View: r_adresse.an_v_adresse_bal_epci

-- DROP VIEW r_adresse.an_v_adresse_bal_epci;

CREATE OR REPLACE VIEW r_adresse.an_v_adresse_bal_epci
 AS
 SELECT g.lib_epci,
    count(a.*) AS nbr_bal
   FROM x_apps.xapps_geo_vmr_adresse a
     LEFT JOIN r_administratif.an_geo g ON a.insee = g.insee::bpchar
  GROUP BY g.lib_epci
  ORDER BY g.lib_epci;

ALTER TABLE r_adresse.an_v_adresse_bal_epci
    OWNER TO create_sig;
COMMENT ON VIEW r_adresse.an_v_adresse_bal_epci
    IS 'Vue d''exploitation permettant de compter le nombre d''enregistrement d''adresse par epci de la BAL';



-- View: x_apps.xapps_geo_vmr_adresse

-- DROP MATERIALIZED VIEW x_apps.xapps_geo_vmr_adresse;

CREATE MATERIALIZED VIEW x_apps.xapps_geo_vmr_adresse
TABLESPACE pg_default
AS
 WITH req_a AS (
         SELECT p.id_adresse,
            p.id_voie,
            p.id_tronc,
            a.numero,
            a.repet,
            a.complement,
            a.ld_compl,
            a.etiquette,
            a.angle,
            v.libvoie_c,
            v.insee,
            v.mot_dir,
            v.libvoie_a,
            k.codepostal,
            c.commune,
            v.rivoli,
            v.rivoli_cle,
            lta.valeur AS "position",
            ltb.valeur AS dest_adr,
            ltc.valeur AS etat_adr,
            i.refcad,
            i.nb_log,
            i.pc,
            ltd.valeur AS groupee,
            lte.valeur AS secondaire,
            ltf.valeur AS src_adr,
            ltg.valeur AS src_geom,
            p.src_date,
            p.date_sai,
            p.date_maj,
            a.observ,
            lth.valeur AS diag_adr,
            lti.valeur AS qual_adr,
            i.id_ext1,
            i.id_ext2,
            i.insee_cd,
            i.nom_cd,
            p.x_l93,
            p.y_l93,
            st_x(st_transform(p.geom, 4326)) AS long,
            st_y(st_transform(p.geom, 4326)) AS lat,
            a.verif_base,
            p.geom
           FROM r_objet.geo_objet_pt_adresse p
             LEFT JOIN r_adresse.an_adresse a ON a.id_adresse = p.id_adresse
             LEFT JOIN r_adresse.an_adresse_info i ON i.id_adresse = p.id_adresse
             LEFT JOIN r_voie.an_voie v ON v.id_voie = p.id_voie
             LEFT JOIN r_administratif.lk_insee_codepostal k ON v.insee = k.insee::bpchar
             LEFT JOIN r_osm.geo_osm_commune c ON v.insee = c.insee::bpchar
             LEFT JOIN r_objet.lt_position lta ON lta.code::text = p."position"::text
             LEFT JOIN r_adresse.lt_dest_adr ltb ON ltb.code::text = i.dest_adr::text
             LEFT JOIN r_adresse.lt_etat_adr ltc ON ltc.code::text = i.etat_adr::text
             LEFT JOIN r_adresse.lt_groupee ltd ON ltd.code::text = i.groupee::text
             LEFT JOIN r_adresse.lt_secondaire lte ON lte.code::text = i.secondaire::text
             LEFT JOIN r_adresse.lt_src_adr ltf ON ltf.code::text = a.src_adr::text
             LEFT JOIN r_objet.lt_src_geom ltg ON ltg.code::text = p.src_geom::text
             LEFT JOIN r_adresse.lt_diag_adr lth ON lth.code::text = a.diag_adr::text
             LEFT JOIN r_adresse.lt_qual_adr lti ON lti.code::text = a.qual_adr::text
        ), req_ah AS (
         SELECT ah.id,
            ah.id_adresse,
            ((((((ah.numero::text ||
                CASE
                    WHEN ah.repet IS NULL OR ah.repet::text = ''::text THEN ''::character varying
                    ELSE ah.repet
                END::text) || ' '::text) || v.libvoie_c::text) || ' '::text) || ah.codepostal::text) || ' '::text) || ah.commune::text AS adresse_h,
            ((ah.numero::text ||
                CASE
                    WHEN ah.repet IS NOT NULL THEN ah.repet
                    ELSE ''::character varying
                END::text) || ' '::text) || v.libvoie_c::text AS adresse_h1
           FROM r_adresse.an_adresse_h ah
             LEFT JOIN r_voie.an_voie v ON v.id_voie = ah.id_voie
             JOIN ( SELECT an_adresse_h.id_adresse,
                    max(an_adresse_h.date_sai) AS date_sai
                   FROM r_adresse.an_adresse_h
                  GROUP BY an_adresse_h.id_adresse) b_1 ON ah.id_adresse = b_1.id_adresse AND ah.date_sai = b_1.date_sai
        )
 SELECT req_a.id_adresse,
    req_a.id_voie,
    req_a.id_tronc,
    req_a.numero,
    req_a.repet,
    req_a.complement,
    req_a.ld_compl,
    req_a.etiquette,
    req_a.angle,
    req_a.libvoie_c,
    req_a.insee,
    req_a.mot_dir,
    req_a.libvoie_a,
    req_a.codepostal,
    req_a.commune,
    req_a.rivoli,
    req_a.rivoli_cle,
    req_a."position",
    req_a.dest_adr,
    req_a.etat_adr,
    req_a.refcad,
    req_a.nb_log,
    req_a.pc,
    req_a.groupee,
    req_a.secondaire,
    req_a.src_adr,
    req_a.src_geom,
    req_a.src_date,
    req_a.date_sai,
    req_a.date_maj,
    req_a.observ,
    req_a.diag_adr,
    req_a.qual_adr,
    req_a.id_ext1,
    req_a.id_ext2,
    req_a.insee_cd,
    req_a.nom_cd,
    req_a.x_l93,
    req_a.y_l93,
    req_a.long,
    req_a.lat,
    req_a.verif_base,
    req_a.geom,
    req_ah.adresse_h,
    req_ah.adresse_h1
   FROM req_a
     LEFT JOIN req_ah ON req_a.id_adresse = req_ah.id_adresse
WITH DATA;

ALTER TABLE x_apps.xapps_geo_vmr_adresse
    OWNER TO sig_create;

COMMENT ON MATERIALIZED VIEW x_apps.xapps_geo_vmr_adresse
    IS 'Vue complète et décodée des adresses destinée à l''exploitation applicative (générateur d''apps)
Cette vue est rafraichie après toutes modifications de la vue de gestion geo_v_adresse';

CREATE INDEX idx_xapps_geo_vmr_adresse_id_adresse
    ON x_apps.xapps_geo_vmr_adresse USING btree
    (id_adresse)
    TABLESPACE pg_default;


-- View: x_apps.xapps_an_v_adresse_h

-- DROP VIEW x_apps.xapps_an_v_adresse_h;

CREATE OR REPLACE VIEW x_apps.xapps_an_v_adresse_h AS 
SELECT 
	a.id,a.id_adresse,
        a.numero || CASE WHEN (repet is null or repet ='') THEN '' ELSE repet END || ' ' || v.libvoie_c  || ' ' || a.codepostal || ' ' || a.commune
	as adresse_h
	,a.date_arr, a.date_sai
FROM 
	r_adresse.an_adresse_h a
LEFT JOIN 
	r_voie.an_voie v ON a.id_voie = v.id_voie;

ALTER TABLE x_apps.xapps_an_v_adresse_h
  OWNER TO sig_create;

									      
COMMENT ON VIEW x_apps.xapps_an_v_adresse_h
  IS 'Vue d''exploitation permettant de lister l''historique des adresses (intégration dans la fiche adresse dans l''application GEO RVA';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                             VUES OPEN DATA                                                                   ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- View: x_opendata.xopendata_an_v_bal_12

-- DROP VIEW x_opendata.xopendata_an_v_bal_12;

CREATE OR REPLACE VIEW x_opendata.xopendata_an_v_bal_12
 AS
 SELECT ''::character varying AS uid_adresse,
    lower(
        CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text))
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3)))))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(a.complement::text, ' '::text, ''::text)))))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END) AS cle_interop,
    v.insee::character varying(5) AS commune_insee,
    c.commune AS commune_nom,
    af.insee_cd AS commune_deleguee_insee,
    af.nom_cd AS commune_deleguee_nom,
    btrim(v.libvoie_c::text)::character varying(100) AS voie_nom,
    a.ld_compl AS lieudit_complement_nom,
    a.numero,
        CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN NULL::text
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN lower(btrim("left"(a.repet::text, 3)))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN lower(btrim(replace(a.complement::text, ' '::text, ''::text)))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN lower(btrim(concat("left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text))))
            ELSE NULL::text
        END::character varying AS suffixe,
    lt_p.valeur AS "position",
    p.x_l93 AS x,
    p.y_l93 AS y,
    st_x(st_transform(p.geom, 4326))::numeric(8,7) AS long,
    st_y(st_transform(p.geom, 4326))::numeric(9,7) AS lat,
    ''::character varying AS cad_parcelles,
        CASE
            WHEN "left"(c.commune::text, 1) = ANY (ARRAY['A'::text, 'E'::text, 'I'::text, 'O'::text, 'U'::text, 'Y'::text, 'H'::text, 'É'::text]) THEN 'Commune d'''::text || c.commune::text
            ELSE 'Commune de '::text || c.commune::text
        END::character varying AS source,
        CASE
            WHEN p.date_maj IS NULL THEN to_char(date(p.date_sai)::timestamp with time zone, 'YYYY-MM-DD'::text)
            ELSE to_char(date(p.date_maj)::timestamp with time zone, 'YYYY-MM-DD'::text)
        END::character varying(10) AS date_der_maj
   FROM r_objet.geo_objet_pt_adresse p
     LEFT JOIN r_adresse.an_adresse a ON a.id_adresse = p.id_adresse
     LEFT JOIN r_adresse.an_adresse_info af ON af.id_adresse = p.id_adresse
     LEFT JOIN r_objet.lt_position lt_p ON lt_p.code::text = p."position"::text
     LEFT JOIN r_voie.an_voie v ON v.id_voie = p.id_voie
     LEFT JOIN r_osm.geo_osm_commune c ON v.insee = c.insee::bpchar
  WHERE (a.diag_adr::text = '11'::text OR "left"(a.diag_adr::text, 1) = '2'::text) AND a.diag_adr::text <> '31'::text AND a.diag_adr::text <> '32'::text AND a.numero::text <> '00000'::text
  ORDER BY (
        CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text))
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3)))))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(a.complement::text, ' '::text, ''::text)))))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END);

ALTER TABLE x_opendata.xopendata_an_v_bal_12
    OWNER TO create_sig;
COMMENT ON VIEW x_opendata.xopendata_an_v_bal_12
    IS 'Vue alphanumérique simplifiée des adresses au format d''échange BAL Standard 1.2';




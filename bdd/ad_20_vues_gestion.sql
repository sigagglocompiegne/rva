-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- View: r_adresse.geo_v_adresse

-- DROP VIEW r_adresse.geo_v_adresse;

CREATE OR REPLACE VIEW r_adresse.geo_v_adresse
 AS
 SELECT p.id_adresse,
    false AS adresse_h,
    ''::character varying(10) AS date_arr,
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
    k.codepostal,
    c.commune,
    v.rivoli,
    v.rivoli_cle,
    p."position",
    i.dest_adr,
    i.etat_adr,
    i.refcad,
    i.nb_log,
    i.pc,
    i.groupee,
    i.secondaire,
    i.insee_cd,
    i.nom_cd,
    a.src_adr,
    p.src_geom,
    p.src_date,
    p.date_sai,
    p.date_maj,
    a.observ,
    a.diag_adr,
    a.qual_adr,
    i.id_ext1,
    i.id_ext2,
    p.x_l93,
    p.y_l93,
    a.verif_base,
    p.geom
   FROM r_objet.geo_objet_pt_adresse p
     LEFT JOIN r_adresse.an_adresse a ON a.id_adresse = p.id_adresse
     LEFT JOIN r_adresse.an_adresse_info i ON i.id_adresse = p.id_adresse
     LEFT JOIN r_voie.an_voie v ON v.id_voie = p.id_voie
     LEFT JOIN r_administratif.lk_insee_codepostal k ON v.insee = k.insee::bpchar
     LEFT JOIN r_osm.geo_osm_commune c ON v.insee = c.insee::bpchar;

ALTER TABLE r_adresse.geo_v_adresse
    OWNER TO create_sig;
COMMENT ON VIEW r_adresse.geo_v_adresse
    IS 'Vue éditable destinée à la modification des données relatives aux adresses';


COMMENT ON TRIGGER t_t3_geo_v_adresse_vmr ON r_adresse.geo_v_adresse
    IS 'Fonction trigger déclenchée à chaque intervention sur la vue des adresses permettant de rafraichir la vue matérialisée des adresses visibles dans les différentes applications.';



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

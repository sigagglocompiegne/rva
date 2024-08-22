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
 SELECT t.id_tronc,t.id_voie_g,t.id_voie_d, vg.libvoie_c as libvoie_g, vg.rivoli as rivoli_g, vd.libvoie_c as libvoie_d, vd.rivoli as rivoli_d, t.insee_g,t.insee_d,t.noeud_d,
	t.noeud_f,t.src_tronc,a.type_tronc,a.hierarchie,a.franchiss,a.nb_voie,a.projet,a.fictif,t.pente,t.observ, t.src_geom, t.src_date, t.geom
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
        g.num_statut,g.gestion,g.doman,g.proprio,g.date_rem,c.type_circu,c.sens_circu,c.c_circu,c.c_observ,c.date_ouv,c.v_max,t.pente,t.observ, t.src_geom, t.src_date, t.src_tronc, false as ign_s,
	t.geom
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

-- #################################################################### FONCTION TRIGGER - ft_m_signal_ign ###################################################
-- DROP FUNCTION m_voirie.ft_m_signal_ign();

CREATE OR REPLACE FUNCTION m_voirie.ft_m_signal_ign()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

DECLARE v_id_tronc integer;
DECLARE v_trace text;	


BEGIN


	
-- GESTION DES TRACES DANS LE CAS D'UNE SUPPRESSION D'UN TRONCON
IF (TG_OP = 'DELETE') THEN 	

-- uniquement pour des voies avec un statut juridique hors département, national, autoroute
if old.statut_jur in ('00','04','05','06','07','08','09','10','11','12','99','ZZ')
-- filtre sur les micros tronçons éventuellement supprimés, max 50m
-- uniquement pour les communes du GéoCompiégnois
and
(
old.insee_g IN ('60023','60067','60068','60070','60151','60156','60159','60323','60325','60326','60337','60338','60382','60402',
				'60447','60578','60579','60597','60600','60665','60667','60674',
				'60024','60036','60040','60078','60125','60149','60152','60210','60223','60229','60254','60284','60308','60318',
				'60369','60424','60441','60531','60540',
				'60025','60032','60064','60072','60145','60167','60171','60184','60188','60305','60324','60438','60445','60491',
				'60534','60569','60572','60593','60641','60647',
				'60043','60119','60147','60150','60368','60373','60378','60392','60423','60492','60501','60537','60582','60636',
				'60642','60654')
OR
old.insee_d IN ('60023','60067','60068','60070','60151','60156','60159','60323','60325','60326','60337','60338','60382','60402',
				'60447','60578','60579','60597','60600','60665','60667','60674',
				'60024','60036','60040','60078','60125','60149','60152','60210','60223','60229','60254','60284','60308','60318',
				'60369','60424','60441','60531','60540',
				'60025','60032','60064','60072','60145','60167','60171','60184','60188','60305','60324','60438','60445','60491',
				'60534','60569','60572','60593','60641','60647',
				'60043','60119','60147','60150','60368','60373','60378','60392','60423','60492','60501','60537','60582','60636',
				'60642','60654')
)


 then

insert into m_signalement.an_log_ign_signalement_send 
(gid, id_tronc,date_modif, type_ope, geom, qualif_sign, att_liste, date_ouv, type_tronc, type_tronc_v, libvoie_g, libvoie_d,
sens_circu, sens_circu_v, nb_voie, projet, hierarchie, hierarchie_v, date_maj, insee_d, insee_g, franchiss, franchiss_v,
statut_jur_v, num_statut, src_geom_v, src_tronc, type_circu_v) values
(
nextval('m_signalement.an_log_ign_signalement_send_gid_seq'::regclass),
old.id_tronc,
now(),
'DELETE',
old.geom,
'Suppression d''un tronçon de voies',
null,
old.date_ouv,
old.type_tronc,
(select valeur from r_voie.lt_type_tronc where code = old.type_tronc),
(select libvoie_c from r_voie.an_voie where id_voie = old.id_voie_g),
(select libvoie_c from r_voie.an_voie where id_voie = old.id_voie_d),
old.sens_circu,
(select valeur from m_voirie.lt_sens_circu where code = old.sens_circu),
old.nb_voie,
old.projet,
old.hierarchie,
(select valeur from r_voie.lt_hierarchie where code = old.hierarchie),
now(),
old.insee_d,
old.insee_g,
case 
	when old.franchiss not in ('01','03') then null else old.franchiss 
END,
case 
	when old.franchiss not in ('01','03') then null else 
	(select valeur from r_voie.lt_franchiss where code = old.franchiss)
END,
(select valeur from m_voirie.lt_statut_jur where code = old.statut_jur),
old.num_statut,
(select valeur from r_objet.lt_src_geom where code = old.src_geom),
old.src_tronc,
(select valeur from m_voirie.lt_type_circu where code = old.type_circu)
);
end if;

end if;

/**** GESTION DES TRACES DANS LE CAS D'UNE INSERTION DE TRONCON ****/	

IF (TG_OP = 'INSERT') THEN 	
IF new.ign_s = false THEN
-- alimentation du fichier trace pour l'envoie des signalements à l'IGN depuis les modification sur la base de voie
-- localisation de la table des traces (m_signalement.an_log_ign_signalement_send)
-- uniquement pour des voies avec un statut juridique hors département, national, autoroute

if new.statut_jur in ('00','04','05','06','07','08','09','10','11','12','99','ZZ')

-- et pas les tronçons issus d'un découpage (gérer dans un trigger after sur le fichier de trace)
-- uniquement pour les communes du GéoCompiégnois
and
(
new.insee_g IN ('60023','60067','60068','60070','60151','60156','60159','60323','60325','60326','60337','60338','60382','60402',
				'60447','60578','60579','60597','60600','60665','60667','60674',
				'60024','60036','60040','60078','60125','60149','60152','60210','60223','60229','60254','60284','60308','60318',
				'60369','60424','60441','60531','60540',
				'60025','60032','60064','60072','60145','60167','60171','60184','60188','60305','60324','60438','60445','60491',
				'60534','60569','60572','60593','60641','60647',
				'60043','60119','60147','60150','60368','60373','60378','60392','60423','60492','60501','60537','60582','60636',
				'60642','60654')
OR
new.insee_d IN ('60023','60067','60068','60070','60151','60156','60159','60323','60325','60326','60337','60338','60382','60402',
				'60447','60578','60579','60597','60600','60665','60667','60674',
				'60024','60036','60040','60078','60125','60149','60152','60210','60223','60229','60254','60284','60308','60318',
				'60369','60424','60441','60531','60540',
				'60025','60032','60064','60072','60145','60167','60171','60184','60188','60305','60324','60438','60445','60491',
				'60534','60569','60572','60593','60641','60647',
				'60043','60119','60147','60150','60368','60373','60378','60392','60423','60492','60501','60537','60582','60636',
				'60642','60654')
)
 then

v_id_tronc := currval('r_objet.geo_objet_troncon_id_seq'::regclass);

insert into m_signalement.an_log_ign_signalement_send 
(gid, id_tronc,date_modif, type_ope, geom, qualif_sign, att_liste, date_ouv, type_tronc, type_tronc_v, libvoie_g, libvoie_d,
sens_circu, sens_circu_v, nb_voie, projet, hierarchie, hierarchie_v, date_maj, insee_d, insee_g, franchiss, franchiss_v,
statut_jur_v, num_statut, src_geom_v, src_tronc, type_circu_v) values
(
nextval('m_signalement.an_log_ign_signalement_send_gid_seq'::regclass),
v_id_tronc,
now(),
'INSERT',
new.geom,
'Ajout d''un tronçon de voies',
case when new.date_ouv is not null then 'date_ouv ' else '' end || 
case when new.type_tronc <> '00' then ' type_tronc type_tronc_v ' else '' end ||
case when new.id_voie_g is not null then ' libvoie_g ' else '' end ||
case when new.id_voie_d is not null then ' libvoie_d ' else '' end ||
case when new.sens_circu in ('01','02','03') then ' sens_circu sens_circu_v' else '' end ||
case when new.nb_voie is not null or new.nb_voie <> 0 then ' nb_voie ' else '' end ||
case when new.projet = true then ' projet ' else '' end ||
case when new.franchiss in ('01','03') then ' franchiss franchiss_v ' else '' end ||
case when new.statut_jur in ('04','05','06','10','11','12') then ' statut_jur_v ' else '' end ||
case when new.num_statut <> '' and new.statut_jur in ('04','05','06','10','11','12') then ' num_statut ' else '' end
,
new.date_ouv,
new.type_tronc,
(select valeur from r_voie.lt_type_tronc where code = NEW.type_tronc),
(select libvoie_c from r_voie.an_voie where id_voie = NEW.id_voie_g),
(select libvoie_c from r_voie.an_voie where id_voie = NEW.id_voie_d),
new.sens_circu,
(select valeur from m_voirie.lt_sens_circu where code = new.sens_circu),
new.nb_voie,
new.projet,
new.hierarchie,
(select valeur from r_voie.lt_hierarchie where code = new.hierarchie),
now(),
new.insee_d,
new.insee_g,
case 
	when new.franchiss not in ('01','03') then null else new.franchiss 
END,
case 
	when new.franchiss not in ('01','03') then null else 
	(select valeur from r_voie.lt_franchiss where code = new.franchiss)
END,
(select valeur from m_voirie.lt_statut_jur where code = new.statut_jur),
new.num_statut,
(select valeur from r_objet.lt_src_geom where code = new.src_geom),
new.src_tronc,
(select valeur from m_voirie.lt_type_circu where code = new.type_circu)
);
end if;

end if;

end if;
/**** GESTION DES TRACES DANS LE CAS D'UNE MODIFICATION DE TRONCON ****/

IF (TG_OP = 'UPDATE') THEN 	

IF new.ign_s = false THEN
-- alimentation du fichier trace pour l'envoie des signalements à l'IGN depuis les modification sur la base de voie
-- localisation de la table des traces (m_signalement.an_log_ign_signalement_send)

--raise exception 'trace --> %', ST_HausdorffDistance(old.geom, new.geom);
/*
v_trace := (
(with
				req_o as
					(
					SELECT (dp).path[1] As index, (dp).geom As wktnode
					FROM 
						(SELECT ST_DumpPoints(old.geom) AS dp
        				) As req 
 					),
 				req_m as
					(   
					SELECT (dp).path[1] As index, (dp).geom As wktnode
					FROM 
						(SELECT ST_DumpPoints(new.geom) AS dp 
   						) As req
					)
				select 
				max(st_distance(o.wktnode,m.wktnode))
				from
				req_o o, req_m m
				where o.index = m.index 
				)
);

raise exception 'trace --> %', v_trace;
*/
-- j'intègre une mise à jour uniquement si un tronçon est modifié en géométrie (géométrie différente et des écarts de points supérieure à 6m) ou un attribut de signalement est modifié
-- cette restriction d'écart de 6m s'applique pour éviter d'envoyer à l'IGN des signalements modificatifs de géométrie pour de l'afficnage de tracé.

--raise exception 'trace --> %', round(st_length(st_intersection(old.geom, st_envelope(new.geom)))::decimal,2) || '-' || round(st_length(new.geom)::decimal,2) ;
if ((st_equals(new.geom,old.geom) is false
				and
				-- ici test de comparaison des points entre le nouveau et l'ancien tronçon pour calculer les écarts
				ST_HausdorffDistance(old.geom, new.geom) > 6
				-- la gestion des découpes de tronçon est gérée dans la table de trace avec un after insert
				
				)
				or (new.date_ouv <> old.date_ouv or (new.date_ouv is not null and old.date_ouv is null) or (new.date_ouv is null and old.date_ouv is not null))
				or new.type_tronc <> old.type_tronc or (new.id_voie_g <> old.id_voie_g or (new.id_voie_g is not null and old.id_voie_g is null) or (new.id_voie_g is null and old.id_voie_g is not null)) 
				or new.id_voie_d <> old.id_voie_d or (new.id_voie_d <> old.id_voie_d or (new.id_voie_d is not null and old.id_voie_d is null) or (new.id_voie_d is null and old.id_voie_d is not null)) 
				or new.sens_circu <> old.sens_circu -- à revoir car 00 ou ZZ 
				or (new.nb_voie <> old.nb_voie or (new.nb_voie is not null and old.nb_voie is null) or (new.nb_voie is null and old.nb_voie is not null)) 
				or new.projet <> old.projet or new.franchiss <> old.franchiss -- à revoir car que pont et pn
				or new.statut_jur <> old.statut_jur or 
				(new.num_statut <> old.num_statut or (new.num_statut is not null and old.num_statut is null) or 
				(new.num_statut is null and old.num_statut is not null)) 
				) 
				and 
				-- uniquement pour des voies avec un statut juridique hors département, national, autoroute
				new.statut_jur in ('00','04','05','06','07','08','09','10','11','12','ZZ','99')
				-- uniquement pour les communes du GéoCompiégnois
				and
				(
				new.insee_g IN ('60023','60067','60068','60070','60151','60156','60159','60323','60325','60326','60337','60338','60382','60402',
				'60447','60578','60579','60597','60600','60665','60667','60674',
				'60024','60036','60040','60078','60125','60149','60152','60210','60223','60229','60254','60284','60308','60318',
				'60369','60424','60441','60531','60540',
				'60025','60032','60064','60072','60145','60167','60171','60184','60188','60305','60324','60438','60445','60491',
				'60534','60569','60572','60593','60641','60647',
				'60043','60119','60147','60150','60368','60373','60378','60392','60423','60492','60501','60537','60582','60636',
				'60642','60654')
				OR
				new.insee_d IN ('60023','60067','60068','60070','60151','60156','60159','60323','60325','60326','60337','60338','60382','60402',
				'60447','60578','60579','60597','60600','60665','60667','60674',
				'60024','60036','60040','60078','60125','60149','60152','60210','60223','60229','60254','60284','60308','60318',
				'60369','60424','60441','60531','60540',
				'60025','60032','60064','60072','60145','60167','60171','60184','60188','60305','60324','60438','60445','60491',
				'60534','60569','60572','60593','60641','60647',
				'60043','60119','60147','60150','60368','60373','60378','60392','60423','60492','60501','60537','60582','60636',
				'60642','60654')
				)

				THEN

insert into m_signalement.an_log_ign_signalement_send 
(gid, id_tronc,date_modif, type_ope, geom, qualif_sign, att_liste, date_ouv, type_tronc, type_tronc_v, libvoie_g, libvoie_d,
sens_circu, sens_circu_v, nb_voie, projet, hierarchie, hierarchie_v, date_maj, insee_d, insee_g, franchiss, franchiss_v,
statut_jur_v, num_statut, src_geom_v, src_tronc, type_circu_v) values
(
nextval('m_signalement.an_log_ign_signalement_send_gid_seq'::regclass),
old.id_tronc,
now(),
'UPDATE',
-- je teste si new.geom <> old.geom pour intégrer la bonne géométrie à envoyer
case when st_equals(new.geom,old.geom) = true then old.geom else new.geom end,
-- je teste si geom <> et/ou attribut différent pour qualifier le signalement (description)
case 
	when st_equals(new.geom,old.geom) is false and 
				(
				(new.date_ouv <> old.date_ouv or (new.date_ouv is not null and old.date_ouv is null) or (new.date_ouv is null and old.date_ouv is not null))
				or
				new.type_tronc <> old.type_tronc
				or
				(new.id_voie_g <> old.id_voie_g or (new.id_voie_g is not null and old.id_voie_g is null) or (new.id_voie_g is null and old.id_voie_g is not null))
				or
				(new.id_voie_d <> old.id_voie_d or (new.id_voie_d is not null and old.id_voie_d is null) or (new.id_voie_d is null and old.id_voie_d is not null))
				or
				(new.sens_circu <> old.sens_circu and (new.sens_circu in ('01','03') or old.sens_circu in ('01','03')))
				or 
				(new.nb_voie <> old.nb_voie or (new.nb_voie is not null and old.nb_voie is null) or (new.nb_voie is null and old.nb_voie is not null))
				or 
				new.projet <> old.projet
				or 
				(new.franchiss <> old.franchiss and (new.franchiss in ('01','02','03') or old.franchiss in ('01','02','03')))
				or
				new.statut_jur <> old.statut_jur
				or 
				(new.num_statut <> old.num_statut or (new.num_statut is not null and old.num_statut is null) or (new.num_statut is null and old.num_statut is not null))
				) 
		then 'Mise à jour de la géométrie et d''au moins un attribut de signalement'
		
    when st_equals(new.geom,old.geom) is false and 
    			(
    			(new.date_ouv = old.date_ouv or (new.date_ouv is null and old.date_ouv is null))
				and
				new.type_tronc = old.type_tronc
				and
				(new.id_voie_g = old.id_voie_g or (new.id_voie_g is null and old.id_voie_g is null))
				and
				(new.id_voie_d = old.id_voie_d or (new.id_voie_d is null and old.id_voie_d is null))
				and
				new.sens_circu = old.sens_circu
				and 
				(new.nb_voie = old.nb_voie or (new.nb_voie is null and old.nb_voie is null))
				and 
				new.projet = old.projet
				and 
				new.franchiss = old.franchiss
				and
				new.statut_jur = old.statut_jur
				and 
				(new.num_statut = old.num_statut or (new.num_statut is null and old.num_statut is null))
				)
        then 'Mise à jour de la géométrie'
    else 'Mise à jour d''au moins un attribut de signalement'
end,
case when (new.date_ouv <> old.date_ouv or (new.date_ouv is not null and old.date_ouv is null) or (new.date_ouv is null and old.date_ouv is not null)) then 'date_ouv ' else '' end || 
case when new.type_tronc <> old.type_tronc then ' type_tronc type_tronc_v ' else '' end ||
case when (new.id_voie_g <> old.id_voie_g or (new.id_voie_g is null and old.id_voie_g is not null) or (new.id_voie_g is not null and old.id_voie_g is null)) then ' libvoie_g ' else '' end ||
case when (new.id_voie_d <> old.id_voie_d or (new.id_voie_d is null and old.id_voie_d is not null) or (new.id_voie_d is not null and old.id_voie_d is null)) then ' libvoie_d ' else '' end ||
case when new.sens_circu <> old.sens_circu and (new.sens_circu in ('01','03') or old.sens_circu in ('01','03')) then ' sens_circu sens_circu_v' else '' end ||
case when (new.nb_voie <> old.nb_voie or (new.nb_voie is null and old.nb_voie is not null) or (new.nb_voie is not null and old.nb_voie is null)) then ' nb_voie ' else '' end ||
case when new.projet <> old.projet then ' projet ' else '' end ||
case when new.franchiss <> old.franchiss and (new.franchiss in ('01','02','03') or old.franchiss in ('01','02','03')) then ' franchiss franchiss_v ' else '' end ||
case when new.statut_jur <> old.statut_jur then ' statut_jur_v ' else '' end ||
case when (new.num_statut <> old.num_statut or (new.num_statut is null and old.num_statut is not null) or (new.num_statut is not null and old.num_statut is null)) then ' num_statut ' else '' end
,
new.date_ouv,
new.type_tronc,
(select valeur from r_voie.lt_type_tronc where code = NEW.type_tronc),
(select libvoie_c from r_voie.an_voie where id_voie = NEW.id_voie_g),
(select libvoie_c from r_voie.an_voie where id_voie = NEW.id_voie_d),
new.sens_circu,
(select valeur from m_voirie.lt_sens_circu where code = new.sens_circu),
new.nb_voie,
new.projet,
new.hierarchie,
(select valeur from r_voie.lt_hierarchie where code = new.hierarchie),
now(),
new.insee_d,
new.insee_g,
case 
	when new.franchiss not in ('01','03') then null else new.franchiss 
END,
case 
	when new.franchiss not in ('01','03') then null else 
	(select valeur from r_voie.lt_franchiss where code = new.franchiss)
END,
(select valeur from m_voirie.lt_statut_jur where code = new.statut_jur),
new.num_statut,
(select valeur from r_objet.lt_src_geom where code = new.src_geom),
new.src_tronc,
(select valeur from m_voirie.lt_type_circu where code = new.type_circu)
);

end if;

end if;

end if;

RETURN NEW;

END;
$function$
;

COMMENT ON FUNCTION m_voirie.ft_m_signal_ign() IS 'Fonction trigger permettant d''alimenter le fichier de trace de la base de voies pour le traitement et l''envoi des signalements à l''IGN';

-- Permissions

ALTER FUNCTION m_voirie.ft_m_signal_ign() OWNER TO create_sig;
GRANT ALL ON FUNCTION m_voirie.ft_m_signal_ign() TO public;
GRANT ALL ON FUNCTION m_voirie.ft_m_signal_ign() TO create_sig;


-- #################################################################### FONCTION TRIGGER - ft_m_controle_saisie ###################################################
-- DROP FUNCTION m_voirie.ft_m_controle_saisie();

CREATE OR REPLACE FUNCTION m_voirie.ft_m_controle_saisie()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN

-- insee obligatoire
if new.insee_g is null or new.insee_d is null or new.insee_g = '' or new.insee_d = '' then 
	raise exception 'Vous devez saisir le code insee gauche et droite de la commune<br><br>';
end if;

-- mauvais code insee
if new.insee_g not in (select distinct insee_g from r_objet.geo_objet_troncon) then
	raise exception 'Vous devez saisir un code insee gauche existant dans la table des tronçons<br><br>';
end if;
if new.insee_d not in (select distinct insee_d from r_objet.geo_objet_troncon) then
	raise exception 'Vous devez saisir un code insee droite existant dans la table des tronçons<br><br>';
end if;

/*
-- contrôle spatiale
if new.insee_g = new.insee_d then
if new.insee_g not in (select c.insee from r_osm.geo_osm_commune c where st_intersects(new.geom,c.geom) is true) then
	raise exception 'Votre tronçon est saisie dans une autre commune que celle indiquée à gauche <br><br>';
end if;
if new.insee_d not in (select c.insee from r_osm.geo_osm_commune c where st_intersects(new.geom,c.geom) is true) then
	raise exception 'Votre tronçon est saisie dans une autre commune que celle indiquée à droite <br><br>';
end if;
end if;
*/
-- idvoie existe dans la commune
if new.id_voie_g is not null then
if new.id_voie_g not in (select id_voie from r_voie.an_voie where insee = new.insee_g) then 
	raise exception 'L''identifiant gauche de voie n''existe pas pour la commune indiquée<br><br>';
end if;
end if;
if new.id_voie_d is not null then
if new.id_voie_d not in (select id_voie from r_voie.an_voie where insee = new.insee_d) then 
	raise exception 'L''identifiant droit de voie n''existe pas pour la commune indiquée<br><br>';
end if;
end if;
-- type de tronçon
-- si voie cyclable = circulation cyclable
-- si tronçon de type cyclable à dominante cyclable
if new.type_tronc = '21' and new.type_circu NOT IN ('02','05') then 
	raise exception 'Un tronçon de type "Voie cyclable" ne peut qu''être cyclable ou mixte à dominante cyclable en type de circulation<br><br>';
end if;
if new.type_tronc = '20' and new.type_circu <> '05' then 
	raise exception 'Un tronçon de type "Tronçon de type cyclable" ne peut qu''être "Mixte à dominante cyclable" en type de circulation<br><br>';
end if;

-- voie verte, voie cyclable, à dominante cyclable et statut voie verte
if new.statut_jur = '12' and (new.type_tronc <> '21' or new.type_circu <> '05') then 
	raise exception 'Une voie verte est un tronçon de type cyclable et circulation à dominante cyclable<br><br>';
end if;

-- piste cyclable, voie cyclable, cyclable et statut piste cyclable
if new.statut_jur = '11' and (new.type_tronc <> '21' or new.type_circu <> '02') then 
	raise exception 'Une piste cyclable est un tronçon de type cyclable et circulation cyclable<br><br>';
end if;


-- statut juridique
-- si type de tronçon voie cyclable, statut = piste ou voie verte
if new.type_tronc = '21' and new.statut_jur not in ('11','12') then 
	raise exception 'Un tronçon de type "Voie cyclable" ne peut qu''être une "Piste Cyclable" ou une "Voie Verte" en statut juridique<br><br>';
end if;

-- statut juridique et domanialité
-- si domaine public par de propriétaire et inversement
if new.doman = '01' and new.proprio <> 'ZZ' then 
	raise exception 'Un tronçon en domaine public ne peut pas avoir de propriétaire<br><br>';	
end if;
if new.doman = '02' and new.proprio = 'ZZ' then 
	raise exception 'Un tronçon en domaine privé doit avoir un type propriétaire renseigné<br><br>';	
end if;

-- si gestionnaire privé, domaine privé et propriétaire
if new.gestion = '07' and (new.doman <> '02' or new.proprio = 'ZZ') then 
	raise exception 'Un tronçon en gestion privée, doit être en domaine privé et avoir un type propriétaire renseigné<br><br>';	
end if;

-- si statut voie communale, domanialité par privé ni gestionnaire ni proprio
if new.statut_jur IN ('02','03','05') and (new.doman ='02' or new.proprio ='07' or new.gestion ='07') then 
	raise exception 'Un statut voie communale ne peut pas être en domaine privé, ni gestionnaire privé, ni propriétaire privé<br><br>';	
end if;


RETURN NEW;

END;
$function$
;

COMMENT ON FUNCTION m_voirie.ft_m_controle_saisie() IS 'Fonction trigger pour la gestion des contrôles de saisies des tronçons de voie';


create trigger t_t0_controle_saisie instead of
insert
    or
update
    on
    m_voirie.geo_v_troncon_voirie for each row execute procedure m_voirie.ft_m_controle_saisie();
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


				    
				 


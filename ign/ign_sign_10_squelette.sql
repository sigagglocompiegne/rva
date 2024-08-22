/*IGN SIGNALEMENT BASE DE VOIES V1.0*/
/*Creation du squelette de la structure des données (tables, séquences, triggers,...) */
/*ign_sign_10_SQUELETTE.sql */
/*PostGIS*/
/*GeoCompiegnois - http://geo.compiegnois.fr/ */
/*Auteur : Grégory Bodet */

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      SCHEMA                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

--CREATE SCHEMA m_signalement AUTHORIZATION create_sig;

--COMMENT ON SCHEMA m_signalement IS 'Schéma contenant les différentes tables gérant les signalements';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      SEQUENCE                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- m_signalement.an_log_ign_signalement_send_gid_seq definition

-- DROP SEQUENCE m_signalement.an_log_ign_signalement_send_gid_seq;

CREATE SEQUENCE m_signalement.an_log_ign_signalement_send_gid_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	NO CYCLE;

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TABLE                                                                   ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- ############################################################# an_log_ign_signalement_send ########################################################## 

-- m_signalement.an_log_ign_signalement_send definition

-- Drop table

-- DROP TABLE m_signalement.an_log_ign_signalement_send;

CREATE TABLE m_signalement.an_log_ign_signalement_send (
	gid bigserial NOT NULL DEFAULT nextval('m_signalement.an_log_ign_signalement_send_gid_seq'::regclass), -- Identifiant unique de chaque changement intervenu sur un tronçon
	id_tronc int8 NOT NULL, -- identifiant du tronçon
	date_modif timestamp NOT NULL, -- Date du changement effectué en base
	type_ope text NOT NULL, -- Type d'opération effectuée
	geom public.geometry(linestring, 2154) NOT NULL, -- Géométrie du tronçon à envoyer avec le signalement
	qualif_sign text NOT NULL, -- Qualification du signalement, sera envoyé comme description
	att_liste text NULL, -- Liste des attributs ayant subi une modification de sa valeur
	date_ouv varchar(4) NULL, -- Valeur de la date d'ouverture envoyée avec le signalement
	type_tronc varchar(2) NULL, -- Code du type de tronçon envoyée avec le signalement
	type_tronc_v text NULL, -- Valeur du type de tronçon envoyée avec le signalement
	libvoie_g text NULL, -- Libellé de voie gauche envoyée avec le signalement
	libvoie_d text NULL, -- Libellé de voie droite envoyée avec le signalement
	sens_circu varchar(2) NULL, -- Code du sens de circulation envoyée avec le signalement
	sens_circu_v text NULL, -- Valeur du sens de circulation envoyée avec le signalement
	nb_voie int2 NULL, -- Nombre de voie envoyée avec le signalement
	projet bool NOT NULL, -- Information du tronçon en projet ou non envoyée avec le signalement
	hierarchie varchar(1) NULL, -- Code de hiérarchie envoyée avec le signalement
	hierarchie_v text NULL, -- Valeur de la hiérarchie du tronçon envoyée avec le signalement
	date_maj timestamp NOT NULL, -- Date de saisie ou de mise à jour du tronçon envoyée avec le signalement
	insee_d varchar(5) NULL, -- Code insee droite envoyée avec le signalement
	insee_g varchar(5) NULL, -- Code insee gaiche envoyée avec le signalement
	franchiss varchar(2) NULL, -- Code de franchissement envoyée avec le signalement
	franchiss_v text NULL, -- Valeur du code de franchissement envoyée avec le signalement
	statut_jur_v text NULL, -- Valeur du statut juridique envoyée avec le signalement
	num_statut varchar(10) NULL, -- Numéro de statut de la voie envoyée avec le signalement
	src_geom_v text NULL, -- Valeur du référentiel géographique utilisé pour la saisie envoyée avec le signalement
	src_tronc text NULL, -- Valeur de la source d'information à l'origine du tracé envoyée avec le signalement
	type_circu_v text NULL, -- Valeur du type de circulation envoyée avec le signalement
	CONSTRAINT an_log_ign_signalement_send_pkey UNIQUE (gid)
);
CREATE INDEX an_log_ign_signalement_send_geom_idx ON m_signalement.an_log_ign_signalement_send USING gist (geom);
COMMENT ON TABLE m_signalement.an_log_ign_signalement_send IS 'Fichier de trace de la base de voie pour envoi à l''IGN. Ce fichier est alimenté automatiquement par une fonction sur la vue de gestion des tronçons (m_voirie.geo_v_troncon_voie)';

-- Column comments

COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.gid IS 'Identifiant unique de chaque changement intervenu sur un tronçon';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.id_tronc IS 'identifiant du tronçon';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.date_modif IS 'Date du changement effectué en base';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.type_ope IS 'Type d''opération effectuée';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.geom IS 'Géométrie du tronçon à envoyer avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.qualif_sign IS 'Qualification du signalement, sera envoyé comme description';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.att_liste IS 'Liste des attributs ayant subi une modification de sa valeur';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.date_ouv IS 'Valeur de la date d''ouverture envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.type_tronc IS 'Code du type de tronçon envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.type_tronc_v IS 'Valeur du type de tronçon envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.libvoie_g IS 'Libellé de voie gauche envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.libvoie_d IS 'Libellé de voie droite envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.sens_circu IS 'Code du sens de circulation envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.sens_circu_v IS 'Valeur du sens de circulation envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.nb_voie IS 'Nombre de voie envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.projet IS 'Information du tronçon en projet ou non envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.hierarchie IS 'Code de hiérarchie envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.hierarchie_v IS 'Valeur de la hiérarchie du tronçon envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.date_maj IS 'Date de saisie ou de mise à jour du tronçon envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.insee_d IS 'Code insee droite envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.insee_g IS 'Code insee gaiche envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.franchiss IS 'Code de franchissement envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.franchiss_v IS 'Valeur du code de franchissement envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.statut_jur_v IS 'Valeur du statut juridique envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.num_statut IS 'Numéro de statut de la voie envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.src_geom_v IS 'Valeur du référentiel géographique utilisé pour la saisie envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.src_tronc IS 'Valeur de la source d''information à l''origine du tracé envoyée avec le signalement';
COMMENT ON COLUMN m_signalement.an_log_ign_signalement_send.type_circu_v IS 'Valeur du type de circulation envoyée avec le signalement';

-- function trigger

-- DROP FUNCTION m_signalement.ft_m_signal_ign_after();

CREATE OR REPLACE FUNCTION m_signalement.ft_m_signal_ign_after()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

BEGIN

--raise exception

DELETE FROM m_signalement.an_log_ign_signalement_send
where gid IN
((
with
req_d as
(
select gid,type_ope, date_modif from m_signalement.an_log_ign_signalement_send
where gid = (select max(gid) from m_signalement.an_log_ign_signalement_send)
),
req_ad as
(
select gid,type_ope, date_modif from m_signalement.an_log_ign_signalement_send 
where gid = (select max(gid)-1 from m_signalement.an_log_ign_signalement_send)
)
select
ad.gid

from
req_ad ad , req_d d
where extract(epoch from (ad.date_modif::timestamp - d.date_modif::timestamp)) < 1
and ad.type_ope = 'UPDATE' and d.type_ope = 'INSERT'
)
union all
(
with
req_d as
(
select gid,type_ope, date_modif from m_signalement.an_log_ign_signalement_send
where gid = (select max(gid) from m_signalement.an_log_ign_signalement_send)
),
req_ad as
(
select gid,type_ope, date_modif from m_signalement.an_log_ign_signalement_send 
where gid = (select max(gid)-1 from m_signalement.an_log_ign_signalement_send)
)
select
d.gid

from
req_ad ad , req_d d
where extract(epoch from (ad.date_modif::timestamp - d.date_modif::timestamp)) < 1
and ad.type_ope = 'UPDATE' and d.type_ope = 'INSERT'
));

return old;

END;
$function$
;

COMMENT ON FUNCTION m_signalement.ft_m_signal_ign_after() IS 'Fonction trigger gérant le cas des tronçons découpés (suppression de l''update/insert)';


-- Table Triggers

create trigger t_t0_sign_ign_after after
insert
    on
    m_signalement.an_log_ign_signalement_send for each row execute procedure m_signalement.ft_m_signal_ign_after();

-- ############################################################# an_log_ign_signalement_send ########################################################## 

-- m_signalement.geo_ign_signalement_upload definition

-- Drop table

-- DROP TABLE m_signalement.geo_ign_signalement_upload;

CREATE TABLE m_signalement.geo_ign_signalement_upload (
	signalement_id int8 NULL,
	groupe_id int2 NULL, -- Identifiant du groupe de l'espace collaboratif
	groupe text NULL, -- Groupe d'appartenance
	groupe_description text NULL, -- Description du groupe d'appartenance
	auteur text NULL, -- Auteur du signalement
	insee varchar NULL, -- Code Insee de la commune
	commune text NULL, -- Libellé de la commune
	dep varchar NULL, -- Code du département
	departement text NULL, -- Département
	commentaire text NULL, -- Commentaire de la personne ayant fait le signalement
	theme text NULL, -- Thème du signalement (ici ROUTE)
	attributs text NULL, -- sans objet
	fichier_attache text NULL, -- Fichier lié
	date_creation date NULL, -- Date de création du signelement
	date_modif date NULL, -- Date de modification du signalement
	date_cloture date NULL, -- Date de cloture du signalement
	statut varchar NULL, -- Etat d'avancement du traitement du signalement au niveau de l'IGN
	reponse text NULL, -- Réponse au signalement
	croquis_xml text NULL, -- Contenue du croquis au format XML
	croquis text NULL, -- Contenu json du croquis
	traite_sig bool DEFAULT false NULL, -- Information du traitement du signalement par le service SIG
	geom public.geometry(point, 2154) NULL, -- Géométrie du signalement (point)
	geom1 public.geometry(multilinestring, 2154) NULL, -- Géométrie du croquis (ligne)
	geom2 public.geometry(multipoint, 2154) NULL, -- Géométrie du croquis (point)
	CONSTRAINT geo_ign_signalement_upload_pkey UNIQUE (signalement_id)
);
CREATE INDEX geo_ign_signalement_upload_geom_1720425985587 ON m_signalement.geo_ign_signalement_upload USING gist (geom);
COMMENT ON TABLE m_signalement.geo_ign_signalement_upload IS 'Information des signalements de l''espace collaboratif de l''IGN';

-- Column comments

COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.groupe_id IS 'Identifiant du groupe de l''espace collaboratif';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.groupe IS 'Groupe d''appartenance';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.groupe_description IS 'Description du groupe d''appartenance';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.auteur IS 'Auteur du signalement';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.insee IS 'Code Insee de la commune';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.commune IS 'Libellé de la commune';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.dep IS 'Code du département';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.departement IS 'Département';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.commentaire IS 'Commentaire de la personne ayant fait le signalement';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.theme IS 'Thème du signalement (ici ROUTE)';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.attributs IS 'sans objet';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.fichier_attache IS 'Fichier lié';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.date_creation IS 'Date de création du signelement';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.date_modif IS 'Date de modification du signalement';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.date_cloture IS 'Date de cloture du signalement';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.statut IS 'Etat d''avancement du traitement du signalement au niveau de l''IGN';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.reponse IS 'Réponse au signalement';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.croquis_xml IS 'Contenue du croquis au format XML';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.croquis IS 'Contenu json du croquis';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.traite_sig IS 'Information du traitement du signalement par le service SIG';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.geom IS 'Géométrie du signalement (point)';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.geom1 IS 'Géométrie du croquis (ligne)';
COMMENT ON COLUMN m_signalement.geo_ign_signalement_upload.geom2 IS 'Géométrie du croquis (point)';

-- Table Triggers

create trigger t_t1_signal_rva before
update
    of traite_sig on
    m_signalement.geo_ign_signalement_upload for each row execute procedure m_signalement.ft_m_signal_rva();


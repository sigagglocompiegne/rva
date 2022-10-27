/*ADRESSE V1.0*/
/*Creation des vues et triggers nécessaires à la gestion via l'application web-métier */
/*ad_20_VUES_GESTION.sql */
/*PostGIS*/
/* GeoCompiegnois - http://geo.compiegnois.fr/ */
/* Auteur : Grégory Bodet*/

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                 DROP                                                                         ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

DROP VIEW IF EXISTS r_adresse.geo_v_adresse;


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                              VUES DE GESTION                                                                 ###
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


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                              TRIGGER ET FONCTION                                                             ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### TRIGGER - XY_L93  ###################################################

-- Trigger: t_t2_xy_l93 on r_objet.geo_objet_pt_adresse

-- DROP TRIGGER t_t2_xy_l93 on r_objet.geo_objet_pt_adresse;

CREATE TRIGGER t_t2_xy_l93
  BEFORE INSERT OR UPDATE OF x_l93,y_l93,geom
  ON r_objet.geo_objet_pt_adresse
  FOR EACH ROW
  EXECUTE PROCEDURE public.ft_r_xy_l93();
  
  
-- #################################################################### TRIGGER - date_maj  ###################################################

-- Trigger: t_t1_date_maj on r_objet.geo_objet_pt_adresse

-- DROP TRIGGER t_t1_date_maj on r_objet.geo_objet_pt_adresse;

CREATE TRIGGER t_t1_date_maj
  BEFORE UPDATE
  ON r_objet.geo_objet_pt_adresse
  FOR EACH ROW
  EXECUTE PROCEDURE public.ft_r_timestamp_maj();
  

-- #################################################################### FONCTION TRIGGER - ft_m_an_adresse_h ###################################################

-- Function: r_adresse.ft_m_an_adresse_h()

-- DROP FUNCTION r_adresse.ft_m_an_adresse_h();

CREATE OR REPLACE FUNCTION r_adresse.ft_m_an_adresse_h()
  RETURNS trigger AS
$BODY$

BEGIN

IF new.adresse_h = true THEN

INSERT INTO r_adresse.an_adresse_h (id_adresse, id_voie, numero,repet, complement, etiquette,codepostal,commune,date_arr,date_sai)
SELECT old.id_adresse,old.id_voie,old.numero,old.repet,old.complement, old.etiquette,old.codepostal,old.commune, to_date(new.date_arr,'YYYY-MM-DD'),now();


END IF;

RETURN NEW;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION r_adresse.ft_m_an_adresse_h()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse_h() TO PUBLIC;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse_h() TO create_sig;
		  
COMMENT ON FUNCTION r_adresse.ft_m_an_adresse_h() IS 'Fonction trigger pour insertion de l''historisation des adresses dans la classe d''objet an_adresse_h';



-- #################################################################### FONCTION TRIGGER - ft_m_geo_adresse_gestion ###################################################

-- FUNCTION: r_adresse.ft_m_geo_adresse_gestion()

-- DROP FUNCTION r_adresse.ft_m_geo_adresse_gestion();

CREATE OR REPLACE FUNCTION r_adresse.ft_m_geo_adresse_gestion()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE v_id_adresse integer;
DECLARE v_cle_interop text;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

-- récupération de l'identiant adresse dans une variable
v_id_adresse := nextval('r_objet.geo_objet_pt_adresse_id_seq'::regclass);

-- verification des doublons des adresses conformes avant

v_cle_interop := 
(
lower(
        CASE
            WHEN lower(NEW.repet) IS NULL AND NEW.complement IS NULL THEN concat((SELECT insee FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', (SELECT rivoli FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', lpad(NEW.numero::text, 5, '0'::text))
            WHEN lower(NEW.repet) IS NOT NULL AND NEW.complement IS NULL THEN concat((SELECT insee FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', (SELECT rivoli FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', lpad(NEW.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(lower(NEW.repet)::text, 3)))))
            WHEN lower(NEW.repet) IS NULL AND NEW.complement IS NOT NULL THEN concat((SELECT insee FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', (SELECT rivoli FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', lpad(NEW.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(NEW.complement::text, ' '::text, ''::text)))))
            WHEN lower(NEW.repet) IS NOT NULL AND NEW.complement IS NOT NULL THEN concat((SELECT insee FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', (SELECT rivoli FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', lpad(NEW.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(lower(NEW.repet)::text, 3), '_', replace(NEW.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END)
);

IF (NEW.diag_adr = '11'::text OR left(NEW.diag_adr, 1) = '2') AND

(SELECT COUNT(*)
		  FROM r_objet.geo_objet_pt_adresse p
     LEFT JOIN r_adresse.an_adresse a ON a.id_adresse = p.id_adresse
     LEFT JOIN r_adresse.an_adresse_info af ON af.id_adresse = p.id_adresse
     LEFT JOIN r_objet.lt_position lt_p ON lt_p.code::text = p."position"::text
     LEFT JOIN r_voie.an_voie v ON v.id_voie = p.id_voie
     LEFT JOIN r_osm.geo_osm_commune c ON v.insee = c.insee::bpchar
  WHERE 
  
  lower(
        CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text))
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3)))))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(a.complement::text, ' '::text, ''::text)))))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END
  ) = v_cle_interop) > 0
		 THEN
RAISE EXCEPTION USING MESSAGE = 'Cette adresse "conforme" existe déjà dans la base de données avec cette clé : ' || v_cle_interop  ;
END IF;


IF NEW.diag_adr = '32' AND NEW.numero IS NOT NULL AND NEW.numero <> '00000' THEN
RAISE EXCEPTION USING MESSAGE = 'Vous ne pouvez pas indiquer une adresse non numérotée et saisir un numéro.'  ;
END IF;

IF NEW.diag_adr IN ('11','20','21','22','23','24','25','33') AND (NEW.numero IS NULL OR NEW.numero = '00000' OR NEW.numero = '') THEN
RAISE EXCEPTION USING MESSAGE = 'Vous ne pouvez pas indiquer une adresse conforme qui soit non numérotée.'  ;
END IF;

IF NEW.groupee = '1' AND NEW.diag_adr NOT IN ('20','23','33') THEN
RAISE EXCEPTION USING MESSAGE = 'Vous ne pouvez pas indiquer une adresse groupée sans indiquer dans la qualité qu''elle est à dégrouper ou à confirmer' ;
END IF;

IF (NEW.groupee = '2' or NEW.groupee = '0') AND NEW.diag_adr = '23' THEN
RAISE EXCEPTION USING MESSAGE = 'Vous ne pouvez pas indiquer une qualité d''adresse dégroupée sans indiquer la valeur "oui" en adresse groupée' ;
END IF;

-- insertion dans la classe des objets
INSERT INTO r_objet.geo_objet_pt_adresse (id_adresse, id_voie, id_tronc, position, x_l93, y_l93, src_geom, src_date, date_sai, date_maj, geom)
SELECT v_id_adresse,
NEW.id_voie,
NEW.id_tronc,
CASE WHEN NEW.position IS NULL THEN '00' ELSE NEW.position END,
NEW.x_l93,
NEW.y_l93,
CASE WHEN NEW.src_geom IS NULL THEN '00' ELSE NEW.src_geom END,
CASE WHEN NEW.src_date IS NULL THEN '0000' ELSE NEW.src_date END,
CASE WHEN NEW.date_sai IS NULL THEN now() ELSE now() END,
NEW.date_maj,
NEW.geom;

-- insertion dans la classe des adresses

-- le champ numéro doit contenir uniquement des n°
IF RTRIM(new.numero, '0123456789') <> '' THEN
RAISE EXCEPTION 'Vous devez saisir uniquement des numéros dans le champ NUMERO';
END IF;

-- le champ numéro doit être identique + repet à l'étiquette
IF (new.numero <> '00000' AND new.numero <> '99999') THEN
IF (new.numero || CASE 
	WHEN new.repet is null THEN ''  
	WHEN new.repet = 'bis' THEN 'B' 
	WHEN new.repet = 'ter' THEN 'T'
	WHEN new.repet = 'quater' THEN 'Q'
	WHEN new.repet = 'quinquies' THEN 'C'
        WHEN new.repet = 'quinter' THEN 'Q'
	WHEN (new.repet = 'a' or new.repet = 'b' or new.repet = 'c'
	or new.repet = 'd' or new.repet = 'e' or new.repet = 'f'
	or new.repet = 'g' or new.repet = 'h' or new.repet = 'i'
	or new.repet = 'j') THEN upper(new.repet)
	ELSE new.repet 
	END) <> (CASE WHEN new.etiquette IS NULL THEN '0' ELSE new.etiquette END) THEN
RAISE EXCEPTION 'Le champ d''étiquette n''est pas cohérent avec le numéro et l''indice de répétition';
END IF;
END IF;

INSERT INTO r_adresse.an_adresse (id_adresse, numero, repet, complement, etiquette, angle, observ, src_adr, diag_adr, qual_adr,verif_base,ld_compl)
SELECT v_id_adresse,
NEW.numero,
LOWER(NEW.repet),
NEW.complement,
UPPER(REPLACE(REPLACE(REPLACE(REPLACE((NEW.etiquette),'bis','B'),'ter','T'),'quater','Q'),'quinquies','C')),
CASE WHEN NEW.angle BETWEEN 90 AND 179 THEN NEW.angle + 180 WHEN NEW.angle BETWEEN 181 AND 270 THEN NEW.angle - 180 WHEN NEW.angle = 180 THEN 0 WHEN NEW.angle < 0 THEN NEW.angle + 360 ELSE NEW.angle END,
NEW.observ,
CASE WHEN NEW.src_adr IS NULL THEN '00' ELSE NEW.src_adr END,
CASE WHEN NEW.diag_adr IS NULL THEN '00' ELSE NEW.diag_adr END,
CASE WHEN NEW.diag_adr IS NULL THEN '0' ELSE LEFT(NEW.diag_adr,1) END,
false,
NEW.ld_compl;

-- insertion dans la classe des adresses informations

INSERT INTO r_adresse.an_adresse_info (id_adresse, dest_adr, etat_adr, nb_log, pc, groupee, secondaire, id_ext1, id_ext2,insee_cd,nom_cd)
SELECT v_id_adresse, 
CASE WHEN NEW.dest_adr IS NULL THEN '00' ELSE NEW.dest_adr END,
CASE WHEN NEW.etat_adr IS NULL THEN '00' ELSE NEW.etat_adr END,
NEW.nb_log,
UPPER(NEW.pc),
CASE WHEN NEW.groupee IS NULL THEN '0' ELSE NEW.groupee END,
CASE WHEN NEW.secondaire IS NULL THEN '0' ELSE NEW.secondaire END,
NEW.id_ext1,
NEW.id_ext2,
NEW.insee_cd,
NEW.nom_cd;

RETURN NEW;

-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

-- verification des doublons des adresses conformes avant si des changements de n° ....
IF NEW.repet <> OLD.repet OR NEW.complement <> OLD.complement OR NEW.id_voie <> OLD.id_voie OR NEW.numero <> OLD.numero OR NEW.diag_adr <> OLD.diag_adr THEN

v_cle_interop := 
(
lower(
        CASE
            WHEN lower(NEW.repet) IS NULL AND NEW.complement IS NULL THEN concat((SELECT insee FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', (SELECT rivoli FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', lpad(NEW.numero::text, 5, '0'::text))
            WHEN lower(NEW.repet) IS NOT NULL AND NEW.complement IS NULL THEN concat((SELECT insee FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', (SELECT rivoli FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', lpad(NEW.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(lower(NEW.repet)::text, 3)))))
            WHEN lower(NEW.repet) IS NULL AND NEW.complement IS NOT NULL THEN concat((SELECT insee FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', (SELECT rivoli FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', lpad(NEW.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(NEW.complement::text, ' '::text, ''::text)))))
            WHEN lower(NEW.repet) IS NOT NULL AND NEW.complement IS NOT NULL THEN concat((SELECT insee FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', (SELECT rivoli FROM r_voie.an_voie WHERE id_voie = NEW.id_voie), '_', lpad(NEW.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(lower(NEW.repet)::text, 3), '_', replace(NEW.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END)
);

IF (NEW.diag_adr = '11'::text OR left(NEW.diag_adr, 1) = '2') AND

(SELECT COUNT(*)
		  FROM r_objet.geo_objet_pt_adresse p
     LEFT JOIN r_adresse.an_adresse a ON a.id_adresse = p.id_adresse
     LEFT JOIN r_adresse.an_adresse_info af ON af.id_adresse = p.id_adresse
     LEFT JOIN r_objet.lt_position lt_p ON lt_p.code::text = p."position"::text
     LEFT JOIN r_voie.an_voie v ON v.id_voie = p.id_voie
     LEFT JOIN r_osm.geo_osm_commune c ON v.insee = c.insee::bpchar
  WHERE 
  
  lower(
        CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text))
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3)))))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(a.complement::text, ' '::text, ''::text)))))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END
  ) = v_cle_interop) > 1
		 THEN
RAISE EXCEPTION USING MESSAGE = 'Cette adresse "conforme" existe déjà dans la base de données avec cette clé : ' || v_cle_interop  ;
END IF;
END IF;


IF NEW.diag_adr = '32' AND NEW.numero IS NOT NULL AND NEW.numero <> '00000' THEN
RAISE EXCEPTION USING MESSAGE = 'Vous ne pouvez pas indiquer une adresse non numérotée et saisir un numéro.'  ;
END IF;

IF NEW.diag_adr IN ('11','20','21','22','23','24','25','33') AND (NEW.numero IS NULL OR NEW.numero = '00000' OR NEW.numero = '') THEN
RAISE EXCEPTION USING MESSAGE = 'Vous ne pouvez pas indiquer une adresse conforme qui soit non numérotée.'  ;
END IF;

IF NEW.groupee = '1' AND NEW.diag_adr NOT IN ('20','23','33') THEN
RAISE EXCEPTION USING MESSAGE = 'Vous ne pouvez pas indiquer une adresse groupée sans indiquer dans la qualité qu''elle est à dégrouper' ;
END IF;

IF (NEW.groupee = '2' or NEW.groupee = '0') AND NEW.diag_adr = '23' THEN
RAISE EXCEPTION USING MESSAGE = 'Vous ne pouvez pas indiquer une qualité d''adresse dégroupée sans indiquer la valeur "oui" en adresse groupée' ;
END IF;

-- mise à jour de la classe des objets
UPDATE
r_objet.geo_objet_pt_adresse
SET
id_voie=NEW.id_voie,
id_tronc=NEW.id_tronc,
position=NEW.position,
x_l93=NEW.x_l93,
y_l93=NEW.y_l93,
src_geom=CASE WHEN NEW.src_geom IS NULL THEN '00' ELSE NEW.src_geom END,
src_date=CASE WHEN NEW.src_date IS NULL THEN '0000' ELSE NEW.src_date END,
date_sai=OLD.date_sai,
date_maj=now(),
geom=NEW.geom
WHERE id_adresse = NEW.id_adresse;

-- mise à jour de la classe des adresses

-- le champ numéro doit contenir uniquement des n°
IF RTRIM(new.numero, '0123456789') <> '' THEN
RAISE EXCEPTION 'Vous devez saisir uniquement des numéros dans le champ NUMERO';
END IF;

-- le champ numéro doit être identique + repet à l'étiquette
IF (new.numero <> '00000' AND new.numero <> '99999') THEN
IF (new.numero || CASE
	WHEN new.repet is null THEN ''  
	WHEN new.repet = 'bis' THEN 'B' 
	WHEN new.repet = 'ter' THEN 'T'
	WHEN new.repet = 'quater' THEN 'Q'
	WHEN new.repet = 'quinques' THEN 'C'
        WHEN new.repet = 'quinter' THEN 'Q'
	ELSE upper(new.repet)
	END) <> new.etiquette THEN
RAISE EXCEPTION 'Le champ d''étiquette n''est pas cohérent avec le numéro et l''indice de répétition';
END IF;
END IF;

UPDATE
r_adresse.an_adresse
SET
numero=NEW.numero,
repet=LOWER(NEW.repet),
complement=NEW.complement,
etiquette=UPPER(REPLACE(REPLACE(REPLACE(REPLACE((NEW.etiquette),'bis','B'),'ter','T'),'quater','Q'),'quinquies','C')),
angle=CASE WHEN NEW.angle BETWEEN 90 AND 179 THEN NEW.angle + 180 WHEN NEW.angle BETWEEN 181 AND 270 THEN NEW.angle - 180 WHEN NEW.angle = 180 THEN 0 WHEN NEW.angle < 0 THEN NEW.angle + 360 ELSE NEW.angle END,
verif_base=NEW.verif_base,
observ=NEW.observ,
src_adr=CASE WHEN NEW.src_adr IS NULL THEN '00' ELSE NEW.src_adr END,
diag_adr=CASE WHEN NEW.diag_adr IS NULL THEN '00' ELSE NEW.diag_adr END,
qual_adr=CASE WHEN NEW.diag_adr IS NULL THEN '0' ELSE LEFT(NEW.diag_adr,1) END,
ld_compl = NEW.ld_compl                                                                              
WHERE id_adresse = NEW.id_adresse;

-- mise à jour de la classe des adresses informations

UPDATE
r_adresse.an_adresse_info
SET
dest_adr=CASE WHEN NEW.dest_adr IS NULL THEN '00' ELSE NEW.dest_adr END,
etat_adr=CASE WHEN NEW.etat_adr IS NULL THEN '00' ELSE NEW.etat_adr END,
nb_log=NEW.nb_log,
pc=UPPER(NEW.pc),
groupee=CASE WHEN NEW.groupee IS NULL THEN '0' ELSE NEW.groupee END,
secondaire=CASE WHEN NEW.secondaire IS NULL THEN '0' ELSE NEW.secondaire END,
id_ext1=NEW.id_ext1,
id_ext2=NEW.id_ext2,
insee_cd=NEW.insee_cd,
nom_cd=NEW.nom_cd
WHERE id_adresse = NEW.id_adresse;

RETURN NEW;

--DELETE
ELSIF (TG_OP = 'DELETE') THEN

IF (SELECT count(*) FROM m_economie.lk_adresseetablissement WHERE idadresse = OLD.id_adresse) >= 1 THEN
RAISE EXCEPTION 'Vous ne pouvez pas supprimer un point d''adresse rattaché à un établissement. Contactez l''administrateur SIG.';
END IF;

DELETE FROM r_objet.geo_objet_pt_adresse where id_adresse = OLD.id_adresse;
DELETE FROM r_adresse.an_adresse where id_adresse = OLD.id_adresse;
DELETE FROM r_adresse.an_adresse_info where id_adresse = OLD.id_adresse;
RETURN OLD;

END IF;

END;
$BODY$;

ALTER FUNCTION r_adresse.ft_m_geo_adresse_gestion()
    OWNER TO create_sig;


COMMENT ON FUNCTION r_adresse.ft_m_geo_adresse_gestion()
    IS 'Fonction trigger pour gérer l''insertion et la mise à jour des données adresse';





-- #################################################################### FONCTION TRIGGER - ft_m_geo_v_adresse_vmr ###################################################

-- FUNCTION: r_adresse.ft_m_geo_v_adresse_vmr()

-- DROP FUNCTION r_adresse.ft_m_geo_v_adresse_vmr();

CREATE FUNCTION r_adresse.ft_m_geo_v_adresse_vmr()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

BEGIN
-- rafraichissement de la vue matérialisée des adresses visibles dans les applications
REFRESH MATERIALIZED VIEW x_apps.xapps_geo_vmr_adresse;

return new;

END;

$BODY$;

ALTER FUNCTION r_adresse.ft_m_geo_v_adresse_vmr()
    OWNER TO create_sig;

COMMENT ON FUNCTION r_adresse.ft_m_geo_v_adresse_vmr()
    IS 'Fonction permettant de rafraichir la vue matérialisée des adresses visibles dans les différentes applications.';

CREATE TRIGGER t_t3_geo_v_adresse_vmr
    INSTEAD OF INSERT OR DELETE OR UPDATE 
    ON r_adresse.geo_v_adresse
    FOR EACH ROW
    EXECUTE PROCEDURE r_adresse.ft_m_geo_v_adresse_vmr();


-- FUNCTION: r_adresse.ft_m_adresse_repetcomplement_null()

-- DROP FUNCTION r_adresse.ft_m_adresse_repetcomplement_null();

CREATE FUNCTION r_adresse.ft_m_adresse_repetcomplement_null()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

begin

 -- gestion des valeurs '' mise à jour une insertion
 update r_adresse.an_adresse set repet = null where repet = '';        
 update r_adresse.an_adresse set complement = null where complement = '';
 update r_adresse.an_adresse set ld_compl = null where ld_compl = '';

	return new; 
end;

$BODY$;

ALTER FUNCTION r_adresse.ft_m_adresse_repetcomplement_null()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION r_adresse.ft_m_adresse_repetcomplement_null() TO PUBLIC;

GRANT EXECUTE ON FUNCTION r_adresse.ft_m_adresse_repetcomplement_null() TO create_sig;

COMMENT ON FUNCTION r_adresse.ft_m_adresse_repetcomplement_null()
    IS 'Fonction forçant le champ à null quand insertion ou mise à jour des attributs repet ou complement ''''';


-- Trigger: t_t1_repetcomplement_null

-- DROP TRIGGER t_t1_repetcomplement_null ON r_adresse.an_adresse;

CREATE TRIGGER t_t1_repetcomplement_null
    AFTER INSERT OR UPDATE 
    ON r_adresse.an_adresse
    FOR EACH ROW
    EXECUTE PROCEDURE r_adresse.ft_m_adresse_repetcomplement_null();
		     
-- #################################################################### FONCTION TRIGGER - ft_m_adresse_insert_update ###################################################

-- FUNCTION: r_adresse.ft_m_adresse_insert_update()

-- DROP FUNCTION r_adresse.ft_m_adresse_insert_update();

CREATE FUNCTION r_adresse.ft_m_adresse_insert_update()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

BEGIN

-- contrôle sur la saisie de la section cadastrale et le numéro de parcelle (longueur)
IF length(NEW.ccosec) <> 2 OR length(NEW.dnupla) <> 4 THEN
RAISE EXCEPTION USING MESSAGE = 'La section doit être codée sur 2 caractères et la parcelle sur 4 caractères. Vérifiez votre saisie et recommencer.';
END IF;

-- contrôle sur la saisie de la section cadastrale (positionnement du 0)
IF (right(NEW.ccosec,1) = '0' OR NEW.ccosec = '00') THEN
RAISE EXCEPTION USING MESSAGE = 'Une section ne peut pas être composée d''une lettre suivie d''un 0, n''y être composée d''un double 0. Corrigez votre saisie et validez.';
END IF;

-- si le point d'adresse est bien sur la même commune
IF (NEW.commune_autre_insee IS NULL or NEW.commune_autre_insee = '') THEN
NEW.idu := '600' || (SELECT right(o.insee,3) FROM r_osm.geo_vm_osm_commune_apc o, r_objet.geo_objet_pt_adresse p 
					 WHERE st_intersects(o.geom,p.geom) IS TRUE AND p.id_adresse = NEW.id_adresse) || '000' || upper(NEW.ccosec) || NEW.dnupla;
ELSE
NEW.idu := '600' || right(NEW.commune_autre_insee,3) || '000' || upper(NEW.ccosec) || NEW.dnupla;
END IF;

NEW.ccosec := upper(NEW.ccosec);

	RETURN NEW; 
	
END;

$BODY$;

ALTER FUNCTION r_adresse.ft_m_adresse_insert_update()
    OWNER TO create_sig;


COMMENT ON FUNCTION r_adresse.ft_m_adresse_insert_update()
    IS 'Fonction générant automatiquement l''identifiant nationale parcelle ou IDU à partir des informations fournies de section cadastrale, parcelle, et sur la commune contenant le point d''adresse';

		     
-- Trigger: t_t1_an_adresse_cad_idu

-- DROP TRIGGER t_t1_an_adresse_cad_idu ON r_adresse.an_adresse_cad;

CREATE TRIGGER t_t1_an_adresse_cad_idu
    BEFORE INSERT OR UPDATE 
    ON r_adresse.an_adresse_cad
    FOR EACH ROW
    EXECUTE PROCEDURE r_adresse.ft_m_adresse_insert_update();
    
-- #################################################################### FONCTION TRIGGER - ft_m_adresse_repetcomplement_null ###################################################

-- FUNCTION: r_adresse.ft_m_adresse_repetcomplement_null()

-- DROP FUNCTION r_adresse.ft_m_adresse_repetcomplement_null();

CREATE FUNCTION r_adresse.ft_m_adresse_repetcomplement_null()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

begin

 -- gestion des valeurs '' mise à jour une insertion
 update r_adresse.an_adresse set repet = null where repet = '';        
 update r_adresse.an_adresse set complement = null where complement = '';
 update r_adresse.an_adresse set ld_compl = null where ld_compl = '';

	return new; 
end;

$BODY$;

ALTER FUNCTION r_adresse.ft_m_adresse_repetcomplement_null()
    OWNER TO create_sig;

COMMENT ON FUNCTION r_adresse.ft_m_adresse_repetcomplement_null()
    IS 'Fonction forçant le champ à null quand insertion ou mise à jour des attributs repet ou complement ''''';

-- Trigger: t_t1_repetcomplement_null

-- DROP TRIGGER t_t1_repetcomplement_null ON r_adresse.an_adresse;

CREATE TRIGGER t_t1_repetcomplement_null
    AFTER INSERT OR UPDATE 
    ON r_adresse.an_adresse
    FOR EACH ROW
    EXECUTE PROCEDURE r_adresse.ft_m_adresse_repetcomplement_null();

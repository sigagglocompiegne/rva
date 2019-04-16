-- #################################################################### SUIVI CODE SQL ####################################################################

-- 2016/05/20 : FV / initialisation du code avec comme point de départ le format d'échange BAL 1.1 de l'AITF
-- 2016/11/09 : FV / clé interop, ajout "0" précédent le numéro de l'adresse pour atteindre 5 caractères
-- 2016/11/09 : FV / v_bal, attribut "position" décodé ; gestion ok de construction de la cle_interop, suffixe, date_der_maj
-- 2016/12/14 : FV / ajout champ src_adr pour indiquer l'origine de l'adresse + domaine de valeur, modif trigger, vues gestion / export BAL-BAN etc..
-- 2016/12/14 : FV / correctif longueur champ varchar(2) pour src_geom au lieu de varchar(5)
-- 2017/01/10 : FV / ajout attribut qualité (qualadr) avec domaines de valeur associés 
-- 2017/02/03 : FV / modification longueur chaine de caractère pour le complément adresse C30->C80
-- 2017/03/28 : FV / ajout attribut adresse groupée (groupee), accès secondaire (secondaire), diagnostic (diag_adr) et domaine de valeur lié
-- 2017/04/05 : FV / création d'une vue openadresse pour la communication extérieure (fichiers ou flux)
-- 2017/04/05 : FV / création d'une table an_adresse_info destinée à ajouter des informations complémentaires aux adresses (destination, nb logement, parcelle, id_externe ...)
-- 2017/04/06 : FV / mise en place de controleurs de saisie (minuscule, majuscule ...) pour plusieurs attributs dans les triggers
-- 2017/04/11 : FV / mise en production, correctifs mineurs
-- 2017/04/12 : FV / passage v1 suite à intégration des restrictions des vues d'export geo_v_openadresse et an_v_bal aux adresses "fiables"
-- 2017/04/19 : FV / erreur controleur saisie indice de répétition en minuscule. correction du trigger
-- 2017/05/16 : FV / ajout vue alphanumérique d'exploitation pour compter le nombre d'enregistrement par commune
-- 2017/06/08 : FV / modification des triggers pour remplacer le terme érroné "quinter" par "quinquies"
-- 2017/07/11 : FV / ajout d'un champ de vérification
-- 2017/07/20 : FV / modif pour interdire la suppression des données (triggers, droits)
-- 2017/07/21 : FV / contrainte applicative de qgis pour l'étiquetage adresse. modif trigger sur an_adresse afin d'avoir un controleur de saisie de l'angle. les valeurs comprisent entre 90 et 180° se voient ajouter +180°
-- 2017/07/21 : FV / création d'une vue adresse "décodée" pour l'exploitation applicative
-- 2018/03/16 : GB/  Modification des liens des vues applicatives vers le schéma x_apps et x_opendata
-- 2018/03/16 : GB / Intégration de l'attribut mot directeur dans la vue applicative Apps locales et Grand Public des adresses
-- 2018/03/20 : GB / Intégration des modifications suite au groupe de travail RVA du 13 mars 2018
--		-- historisation des adresses : création d'une classe d'objet an_adresse_h contenant les atrributs suivants :id, id_adresse,numero, repet,complement, etiquette, angle, date_arr, date_sai
--		-- mise à jour dans la vue de saisie pour indiquer une éventuelle mise en historique
--		-- création d'un trigger sur la vuede saisie des adresses pour gérer l'intégration dans la table historique
--		-- création de bloc pour séparer les vues de gestion, applicatives et open data
-- 2018/04/12 : GB / Intégration des modifications sur les vues applicatives pour l'affichage côté utilisateur dans GEO
-- 2018/08/07 : GB / Insertion des nouveaux rôles de connexion et leurs privilèges
-- 2019/04/16 : GB / Nouveau trigger sur la vue geo_v_adresse pour la gestion de la remontée des établissements au local si le pt d'adresse bouge

-- ***** pour les voies sans adresses (ex lieu dit), le numéro prend la valeur "99999"
-- ToDo

-- voir pour attribut pour urlfic 'certif numérotation' ou lien vers table média
-- voir pour l'historisation (garde t-on les anciennes adresses???)
-- gérer à terme le uid_adresse pour échange BAL/BAN etc ...
-- voir pour gérer les filiations d'adresse (mère>filles en fonction notamment des positions)
-- voir auto contact etiquette adresse
-- voir si il faut placer la clé interop au niveau vue exploitation ou la raccrocher aux données
-- voir dev nécessaire pour la gestion des voies non adressées
 

-- #################################################################### SCHEMA  ####################################################################

-- Schema: r_adresse

-- DROP SCHEMA r_adresse;

CREATE SCHEMA r_adresse
  AUTHORIZATION sig_create;

GRANT USAGE ON SCHEMA r_adresse TO edit_sig;
GRANT ALL ON SCHEMA r_adresse TO sig_create;
GRANT ALL ON SCHEMA r_adresse TO create_sig;
GRANT USAGE ON SCHEMA r_adresse TO read_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_adresse
GRANT ALL ON TABLES TO create_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_adresse
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLES TO edit_sig;
ALTER DEFAULT PRIVILEGES IN SCHEMA r_adresse
GRANT SELECT ON TABLES TO read_sig;

COMMENT ON SCHEMA r_adresse
  IS 'Référentiel Base Adresse Locale (BAL)';
  
  
-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      REF OBJET                                                               ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### OBJET point_adresse #################################################################  
  
-- Table: r_objet.geo_objet_pt_adresse

-- DROP TABLE r_objet.geo_objet_pt_adresse;

CREATE TABLE r_objet.geo_objet_pt_adresse
(
  id_adresse bigint NOT NULL, -- Identifiant unique de l'objet point adresse
  id_voie bigint, -- Identifiant unique de l'objet voie
  id_tronc bigint, -- Identifiant unique de l'objet troncon
  position character varying(2) NOT NULL,-- Type de position du point adresse  
  x_l93 numeric(8,2) NOT NULL, -- Coordonnée X en mètre
  y_l93 numeric(9,2) NOT NULL, -- Coordonnée Y en mètre
  src_geom character varying(2) NOT NULL DEFAULT '00' ::bpchar, -- Référentiel de saisie
  src_date character varying(4) NOT NULL DEFAULT '0000' ::bpchar, -- Année du millésime du référentiel de saisie
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Horodatage de l'intégration en base de l'objet   
  date_maj timestamp without time zone, -- Horodatage de la mise à jour en base de l'objet
  geom geometry(Point,2154), -- Géométrie point de l'objet

  CONSTRAINT geo_objet_adresse_pkey PRIMARY KEY (id_adresse)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_objet.geo_objet_pt_adresse
  OWNER TO sig_create;
GRANT ALL ON TABLE r_objet.geo_objet_pt_adresse TO sig_create;
GRANT SELECT ON TABLE r_objet.geo_objet_pt_adresse TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_objet.geo_objet_pt_adresse TO edit_sig;


COMMENT ON TABLE r_objet.geo_objet_pt_adresse
  IS 'Classe décrivant la position d''une adresse';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.id_adresse IS 'Identifiant unique de l''objet point adresse';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.id_voie IS 'Identifiant unique de l''objet voie';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.id_tronc IS 'Identifiant unique de l''objet troncon';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.position IS 'Type de position du point adresse';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.x_l93 IS 'Coordonnée X en mètre';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.y_l93 IS 'Coordonnée Y en mètre';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.src_geom IS 'Référentiel de saisie';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.src_date IS 'Année du millésime du référentiel de saisie';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.date_sai IS 'Horodatage de l''intégration en base de l''objet';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.date_maj IS 'Horodatage de la mise à jour en base de l''objet';
COMMENT ON COLUMN r_objet.geo_objet_pt_adresse.geom IS 'Géomètrie ponctuelle de l''objet';

-- Index: r_objet.geo_objet_pt_adresse_geom

-- DROP INDEX r_objet.geo_objet_pt_adresse_geom;

CREATE INDEX sidx_geo_objet_adresse_geom
  ON r_objet.geo_objet_pt_adresse
  USING gist
  (geom);

-- Sequence: r_objet.geo_objet_pt_adresse_id_seq

-- DROP SEQUENCE r_objet.geo_objet_pt_adresse_id_seq;

CREATE SEQUENCE r_objet.geo_objet_pt_adresse_id_seq
  INCREMENT 1
  MINVALUE 0
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE r_objet.geo_objet_pt_adresse_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE r_objet.geo_objet_pt_adresse_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE r_objet.geo_objet_pt_adresse_id_seq TO public;

ALTER TABLE r_objet.geo_objet_pt_adresse ALTER COLUMN id_adresse SET DEFAULT nextval('r_objet.geo_objet_pt_adresse_id_seq'::regclass);





-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      REF ADRESSE                                                             ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### an_adresse ###################################################################

-- Table: r_adresse.an_adresse

-- DROP TABLE r_adresse.an_adresse;

CREATE TABLE r_adresse.an_adresse
(
  id_adresse bigint NOT NULL, -- Identifiant unique de l'objet point adresse
  numero character varying(10), -- Numéro de l'adresse
  repet character varying(10), -- Indice de répétition de l'adresse
  complement character varying(80), -- Complément d'adresse
  etiquette character varying(10), -- Etiquette
  angle integer, -- Angle de l'écriture exprimé en degré, par rapport à l'horizontale, dans le sens trigonométrique
  observ character varying(254), -- Observations
  src_adr character varying(2) NOT NULL DEFAULT '00' ::bpchar, -- Origine de l'adresse
  diag_adr character varying(2) NOT NULL DEFAULT '00' ::bpchar,-- Diagnostic qualité de l'adresse
  qual_adr character varying(1) DEFAULT '0',-- Indice de qualité simplifié de l'adresse
  verif_base boolean DEFAULT false, -- Champ informant si l'adresse a été vérifié par rapport aux erreurs de bases (n°, tronçon, voie, correspondance BAN)....

    
  CONSTRAINT an_adresse_pkey PRIMARY KEY (id_adresse)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.an_adresse
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.an_adresse TO sig_create;
GRANT SELECT ON TABLE r_adresse.an_adresse TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.an_adresse TO edit_sig;

COMMENT ON TABLE r_adresse.an_adresse
  IS 'Table alphanumérique des adresses';
COMMENT ON COLUMN r_adresse.an_adresse.id_adresse IS 'Identifiant unique de l''objet point adresse';
COMMENT ON COLUMN r_adresse.an_adresse.numero IS 'Numéro de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.repet IS 'Indice de répétition de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.complement IS 'Complément d''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.etiquette IS 'Etiquette';
COMMENT ON COLUMN r_adresse.an_adresse.angle IS 'Angle de l''écriture exprimé en degré, par rapport à l''horizontale, dans le sens trigonométrique';
COMMENT ON COLUMN r_adresse.an_adresse.observ IS 'Observations';
COMMENT ON COLUMN r_adresse.an_adresse.src_adr IS 'Origine de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.diag_adr IS 'Diagnostic qualité de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.qual_adr IS 'Indice de qualité simplifié de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse.verif_base IS 'Champ informant si l''adresse a été vérifié par rapport aux erreurs de bases (n°, tronçon, voie, correspondance BAN).
Par défaut à non.';

-- #################################################################### an_adresse_h ###################################################################

-- Sequence: r_adresse.an_adresse_h_id_seq

-- DROP SEQUENCE r_adresse.an_adresse_h_id_seq;

CREATE SEQUENCE r_adresse.an_adresse_h_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER SEQUENCE r_adresse.an_adresse_h_id_seq
  OWNER TO sig_create;
GRANT ALL ON SEQUENCE r_adresse.an_adresse_h_id_seq TO sig_create;
GRANT SELECT, USAGE ON SEQUENCE r_adresse.an_adresse_h_id_seq TO public;


-- Table: r_adresse.an_adresse_h

-- DROP TABLE r_adresse.an_adresse_h;

CREATE TABLE r_adresse.an_adresse_h
(
  id bigint NOT NULL DEFAULT nextval('r_adresse.an_adresse_h_id_seq'::regclass), -- Identifiant unique de l'historisation
  id_adresse bigint NOT NULL, -- Identifiant unique de l'objet point adresse
  id_voie integer,-- identifiant unique de la voie
  numero character varying(10), -- Numéro de l'adresse
  repet character varying(10), -- Indice de répétition de l'adresse
  complement character varying(80), -- Complément d'adresse
  etiquette character varying(10), -- Etiquette
  angle integer, -- Angle de l'écriture exprimé en degré, par rapport à l'horizontale, dans le sens trigonométrique
  codepostal character varying(5), -- Code postal de l'adresse
  commune character varying(100), -- Libellé de la commune
  date_arr timestamp without time zone, -- Date de l'arrêté de numérotation remplaçant le numéro historisé ici présent
  date_sai timestamp without time zone NOT NULL DEFAULT now(), -- Date de saisie de l'information dans la base
  CONSTRAINT an_adresse_h_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.an_adresse_h
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.an_adresse_h TO sig_create;
GRANT SELECT ON TABLE r_adresse.an_adresse_h TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.an_adresse_h TO edit_sig;

COMMENT ON TABLE r_adresse.an_adresse_h
  IS 'Table alphanumérique des historisations des adresses suite à une renumérotation';
COMMENT ON COLUMN r_adresse.an_adresse_h.id IS 'Identifiant unique de l''historisation';
COMMENT ON COLUMN r_adresse.an_adresse_h.id_adresse IS 'Identifiant unique de l''objet point adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.id_voie IS 'Identifiant unique de la voie';
COMMENT ON COLUMN r_adresse.an_adresse_h.numero IS 'Numéro de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.repet IS 'Indice de répétition de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.complement IS 'Complément d''adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.etiquette IS 'Etiquette';
COMMENT ON COLUMN r_adresse.an_adresse_h.angle IS 'Angle de l''écriture exprimé en degré, par rapport à l''horizontale, dans le sens trigonométrique';
COMMENT ON COLUMN r_adresse.an_adresse_h.codepostal IS 'Code postal de l''adresse';
COMMENT ON COLUMN r_adresse.an_adresse_h.commune IS 'Libellé de la commune';
COMMENT ON COLUMN r_adresse.an_adresse_h.date_arr IS 'Date de l''arrêté de numérotation remplaçant le numéro historisé ici présent';
COMMENT ON COLUMN r_adresse.an_adresse_h.date_sai IS 'Date de saisie de l''information dans la base';



-- #################################################################### an_adresse_info ###################################################################

-- Table: r_adresse.an_adresse_info

-- DROP TABLE r_adresse.an_adresse_info;

CREATE TABLE r_adresse.an_adresse_info
(
  id_adresse bigint NOT NULL, -- Identifiant unique de l'objet point adresse
  dest_adr character varying(2) NOT NULL DEFAULT '00', -- Destination de l'adresse (habitation, commerce, ...)
  etat_adr character varying(2) NOT NULL DEFAULT '00', -- Etat de la construction à l'adresse (non commencé, en cours, achevé, muré, supprimé ...)
  refcad character varying(254), -- Référence(s) cadastrale(s)
  nb_log integer, -- Nombre de logements
  pc character varying(30), -- Numéro du permis de construire  
  groupee character varying(1) NOT NULL DEFAULT '0', -- Adresse groupée (O/N)
  secondaire character varying(1) NOT NULL DEFAULT '0', -- Adresse d'un accès secondaire (O/N)
  id_ext1 character varying(80), -- Identifiant d''une adresse dans une base externe (1) pour appariemment
  id_ext2 character varying(80), -- Identifiant d''une adresse dans une base externe (2) pour appariemment
    
  CONSTRAINT an_adresse_info_pkey PRIMARY KEY (id_adresse)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.an_adresse_info
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.an_adresse_info TO sig_create;
GRANT SELECT ON TABLE r_adresse.an_adresse_info TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.an_adresse_info TO edit_sig;

COMMENT ON TABLE r_adresse.an_adresse_info
  IS 'Table alphanumérique des informations complémentaires des adresses';
COMMENT ON COLUMN r_adresse.an_adresse_info.id_adresse IS 'Identifiant unique de l''objet point adresse';
COMMENT ON COLUMN r_adresse.an_adresse_info.dest_adr IS 'Destination de l''adresse (habitation, commerce, ...)';
COMMENT ON COLUMN r_adresse.an_adresse_info.etat_adr IS 'Etat de la construction à l''adresse (non commencé, en cours, achevé, muré, supprimé ...)';
COMMENT ON COLUMN r_adresse.an_adresse_info.refcad IS 'Référence(s) cadastrale(s)';
COMMENT ON COLUMN r_adresse.an_adresse_info.pc IS 'Numéro du permis de construire';
COMMENT ON COLUMN r_adresse.an_adresse_info.nb_log IS 'Nombre de logements';
COMMENT ON COLUMN r_adresse.an_adresse_info.groupee IS 'Adresse groupée (O/N)';
COMMENT ON COLUMN r_adresse.an_adresse_info.secondaire IS 'Adresse d''un accès secondaire (O/N)';
COMMENT ON COLUMN r_adresse.an_adresse_info.id_ext1 IS 'Identifiant d''une adresse dans une base externe (1) pour appariemment';
COMMENT ON COLUMN r_adresse.an_adresse_info.id_ext2 IS 'Identifiant d''une adresse dans une base externe (2) pour appariemment';



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                DOMAINES DE VALEURS                                                           ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- ################################################################# Domaine valeur - position  ###############################################

-- Table: r_objet.lt_position

-- DROP TABLE r_objet.lt_position;

CREATE TABLE r_objet.lt_position
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au type de position de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au type de position de l'adresse
  definition character varying(254) NOT NULL, -- Définition de la liste énumérée relative au type de position de l'adresse
  inspire character varying(80) NOT NULL, -- Equivalence INSPIRE LocatorDesignatorTypeValue relative au type de position de l'adresse
  CONSTRAINT lt_position_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_objet.lt_position
  OWNER TO sig_create;
GRANT ALL ON TABLE r_objet.lt_position TO sig_create;
GRANT SELECT ON TABLE r_objet.lt_position TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_objet.lt_position TO edit_sig;

COMMENT ON TABLE r_objet.lt_position
  IS 'Code permettant de décrire le type de position de l''adresse';
COMMENT ON COLUMN r_objet.lt_position.code IS 'Code de la liste énumérée relative au type de position de l''adresse';
COMMENT ON COLUMN r_objet.lt_position.valeur IS 'Valeur de la liste énumérée relative au type de position de l''adresse';
COMMENT ON COLUMN r_objet.lt_position.definition IS 'Définition de la liste énumérée relative au type de position de l''adresse';
COMMENT ON COLUMN r_objet.lt_position.inspire IS 'Equivalence INSPIRE LocatorDesignatorTypeValue relative au type de position de l''adresse';

INSERT INTO r_objet.lt_position(
            code, valeur, definition, inspire)
    VALUES
    ('01','Délivrance postale','Identifie un point de délivrance postale','Postal delivery'),
    ('02','Entrée','Identifie l''entrée principale d''un bâtiment ou un portail','Entrance'),
    ('03','Bâtiment','Identifie un bâtiment ou une partie de bâtiment','Building'),
    ('04','Cage d''escalier','Identifie une cage d''escalier en temps normal à l''intérieur d''un bâtiment','Staircase indentifier'),
    ('05','Logement','Identifie un logement ou une pièce à l''intérieur d''un bâtiment','Unit identifier'),
    ('06','Parcelle','Identifie une parcelle cadastrale','Parcel'),
    ('07','Segment','Position dérivée du segment de la voie de rattachement','Segment'),
    ('08','Service technique','Identifie un point d''accès à un local technique (eau, électricité, gaz ...)','Utility service'),
    ('00','Non renseigné','*','*');


-- ################################################################# Domaine valeur - groupee  ###############################################

-- Table: r_adresse.lt_groupee

-- DROP TABLE r_adresse.lt_groupee;

CREATE TABLE r_adresse.lt_groupee
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à l'indice de qualité de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à l'indice de qualité de l'adresse
  CONSTRAINT lt_groupee_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_groupee
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.lt_groupee TO sig_create;
GRANT SELECT ON TABLE r_adresse.lt_groupee TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.lt_groupee TO edit_sig;

COMMENT ON TABLE r_adresse.lt_groupee
  IS 'Code permettant de définir si une adresse est groupée ou non';
COMMENT ON COLUMN r_adresse.lt_groupee.code IS 'Code de la liste énumérée relative à une adresse groupée ou non';
COMMENT ON COLUMN r_adresse.lt_groupee.valeur IS 'Valeur de la liste énumérée relative à une adresse groupée ou non';

INSERT INTO r_adresse.lt_groupee(
            code, valeur)
    VALUES
    ('1','Oui'),
    ('2','Non'),
    ('0','Non renseigné');

    
-- ################################################################# Domaine valeur - secondaire  ###############################################

-- Table: r_adresse.lt_secondaire

-- DROP TABLE r_adresse.lt_secondaire;

CREATE TABLE r_adresse.lt_secondaire
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à l'indice de qualité de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à l'indice de qualité de l'adresse
  CONSTRAINT lt_secondaire_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_secondaire
OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.lt_secondaire TO sig_create;
GRANT SELECT ON TABLE r_adresse.lt_secondaire TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.lt_secondaire TO edit_sig;

COMMENT ON TABLE r_adresse.lt_secondaire
  IS 'Code permettant de définir si une adresse est un accès secondaire';
COMMENT ON COLUMN r_adresse.lt_secondaire.code IS 'Code de la liste énumérée relative à une adresse d''un accès secondaire ou non';
COMMENT ON COLUMN r_adresse.lt_secondaire.valeur IS 'Valeur de la liste énumérée relative à une adresse d''un accès secondaire ou non';

INSERT INTO r_adresse.lt_secondaire(
            code, valeur)
    VALUES
    ('1','Oui'),
    ('2','Non'),
    ('0','Non renseigné');       

    
-- ################################################################# Domaine valeur - src_adr  ###############################################

-- Table: r_adresse.lt_src_adr

-- DROP TABLE r_adresse.lt_src_adr;

CREATE TABLE r_adresse.lt_src_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au type de position de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au type de position de l'adresse
  CONSTRAINT lt_src_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_src_adr
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.lt_src_adr TO sig_create;
GRANT SELECT ON TABLE r_adresse.lt_src_adr TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.lt_src_adr TO edit_sig;

COMMENT ON TABLE r_adresse.lt_src_adr
  IS 'Code permettant de décrire l''origine de l''adresse';
COMMENT ON COLUMN r_adresse.lt_src_adr.code IS 'Code de la liste énumérée relative à la source de l''origine de l''adresse';
COMMENT ON COLUMN r_adresse.lt_src_adr.valeur IS 'Valeur de la liste énumérée relative à la source de l''origine de l''adresse';

INSERT INTO r_adresse.lt_src_adr(
            code, valeur)
    VALUES
    ('01','Cadastre'),
    ('02','OSM'),
    ('03','BAN'),
    ('04','Intercommunalité'),
    ('05','Commune'),
    ('99','Autre'),
    ('00','Non renseigné');


-- ################################################################# Domaine valeur - diag_adr  ###############################################

-- Table: r_adresse.lt_diag_adr

-- DROP TABLE r_adresse.lt_diag_adr;

CREATE TABLE r_adresse.lt_diag_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative au diagnostic qualité de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative au diagnostic qualité de l'adresse
  CONSTRAINT lt_diag_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_diag_adr
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.lt_diag_adr TO sig_create;
GRANT SELECT ON TABLE r_adresse.lt_diag_adr TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.lt_diag_adr TO edit_sig;

COMMENT ON TABLE r_adresse.lt_diag_adr
  IS 'Code permettant de décrire un diagnostic qualité d''une adresse';
COMMENT ON COLUMN r_adresse.lt_diag_adr.code IS 'Code de la liste énumérée relative au diagnostic qualité de l''adresse';
COMMENT ON COLUMN r_adresse.lt_diag_adr.valeur IS 'Valeur de la liste énumérée relative au diagnostic qualité de l''adresse';

INSERT INTO r_adresse.lt_diag_adr(
            code, valeur)
    VALUES
    ('11','Adresse conforme'),
    ('12','Adresse supprimée'),
    ('20','Adresse à améliorer (position, usage, dégrouper ...)'),
    ('21','Adresse à améliorer (position)'),
    ('22','Adresse à améliorer (usage)'),
    ('23','Adresse à améliorer (dégrouper)'),
    ('24','Adresse à améliorer (logement)'),        
    ('25','Adresse à améliorer (état)'),
    ('31','Adresse non attribuée (projet)'),
    ('32','Adresse non numérotée'),
    ('33','Adresse à confirmer (existence, numéro ...)'),           
    ('99','Autre'),
    ('00','Non renseigné');
    
    

-- ################################################################# Domaine valeur - qual_adr  ###############################################

-- Table: r_adresse.lt_qual_adr

-- DROP TABLE r_adresse.lt_qual_adr;

CREATE TABLE r_adresse.lt_qual_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à l'indice de qualité simplifié de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à l'indice de qualité simplifié de l'adresse
  CONSTRAINT lt_qual_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_qual_adr
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.lt_qual_adr TO sig_create;
GRANT SELECT ON TABLE r_adresse.lt_qual_adr TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.lt_qual_adr TO edit_sig;

COMMENT ON TABLE r_adresse.lt_qual_adr
  IS 'Code permettant de décrire un indice de qualité simplifié d''une adresse';
COMMENT ON COLUMN r_adresse.lt_qual_adr.code IS 'Code de la liste énumérée relative à l''indice de qualité simplifié de l''adresse';
COMMENT ON COLUMN r_adresse.lt_qual_adr.valeur IS 'Valeur de la liste énumérée relative à à l''indice de qualité simplifié de l''adresse';

INSERT INTO r_adresse.lt_qual_adr(
            code, valeur)
    VALUES
    ('1','Bon'),
    ('2','Moyen'),
    ('3','Mauvais'),
    ('9','Autre'),
    ('0','Non renseigné');


-- ################################################################# Domaine valeur - src_geom  ###############################################

-- Type d'énumération urbanisé et présent dans le schéma r_objet
-- Voir table r_objet.lt_src_geom



-- ################################################################# Domaine valeur - destination  ###############################################

-- Table: r_adresse.lt_dest_adr

-- DROP TABLE r_adresse.lt_dest_adr;

CREATE TABLE r_adresse.lt_dest_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à la destination de l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à la destination de l'adresse
  definition character varying(254) NOT NULL, -- Définition de la liste énumérée relative à la destination de l'adresse
  CONSTRAINT lt_dest_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_dest_adr
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.lt_dest_adr TO sig_create;
GRANT SELECT ON TABLE r_adresse.lt_dest_adr TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.lt_dest_adr TO edit_sig;

COMMENT ON TABLE r_adresse.lt_dest_adr
  IS 'Code permettant de décrire la destination de l''adresse';
COMMENT ON COLUMN r_adresse.lt_dest_adr.code IS 'Code de la liste énumérée relative à la destination de l''adresse';
COMMENT ON COLUMN r_adresse.lt_dest_adr.valeur IS 'Valeur de la liste énumérée relative à la destination de l''adresse';
COMMENT ON COLUMN r_adresse.lt_dest_adr.definition IS 'Définition de la liste énumérée relative à la destination de l''adresse';

INSERT INTO r_adresse.lt_dest_adr(
            code, valeur, definition)
    VALUES
    ('01','Habitation','Appartement, maison ...'),
    ('02','Etablissement','Commerce, entreprise ...'),
    ('03','Equipement urbain','Stade, piscine ...'),
    ('04','Communauté','Maison de retraite, internat, gendarmerie, ...'),
    ('05','Habitation + Etablissement','Logements et commerces à la même adresse'),
    ('99','Autre','Parking, garage privés ...'),
    ('00','Non renseigné','*');


-- ################################################################# Domaine valeur - Etat de la construction  ###############################################

-- Table: r_adresse.lt_etat_adr

-- DROP TABLE r_adresse.lt_etat_adr;

CREATE TABLE r_adresse.lt_etat_adr
(
  code character varying(2) NOT NULL, -- Code de la liste énumérée relative à l'état de la construction à l'adresse
  valeur character varying(80) NOT NULL, -- Valeur de la liste énumérée relative à l'état de la construction à l'adresse
  definition character varying(254) NOT NULL, -- Définition de la liste énumérée relative à l'état de la construction à l'adresse
  CONSTRAINT lt_etat_adr_pkey PRIMARY KEY (code)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE r_adresse.lt_etat_adr
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.lt_etat_adr TO sig_create;
GRANT SELECT ON TABLE r_adresse.lt_etat_adr TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.lt_etat_adr TO edit_sig;

COMMENT ON TABLE r_adresse.lt_etat_adr
  IS 'Code permettant de décrire l''état de la construction à l''adresse';
COMMENT ON COLUMN r_adresse.lt_etat_adr.code IS 'Code de la liste énumérée relative à l''état de la construction à l''adresse';
COMMENT ON COLUMN r_adresse.lt_etat_adr.valeur IS 'Valeur de la liste énumérée relative à l''état de la construction à l''adresse';
COMMENT ON COLUMN r_adresse.lt_etat_adr.definition IS 'Définition de la liste énumérée relative à l''état de la construction à l''adresse';

INSERT INTO r_adresse.lt_etat_adr(
            code, valeur, definition)
    VALUES
    ('01','Non commencé','Construction à l''état de projet'),
    ('02','En cours','Construction en cours'),
    ('03','Achevé','Construction à l''état d''occupation viable'),
    ('04','Muré','Construction murée, en ruine'),
    ('05','Supprimé','Construction détruite'),
    ('99','Autre','Autre état'),
    ('00','Non renseigné','*');
    

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        FKEY                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- Foreign Key: r_objet.geo_objet_pt_adresse_id_tronc_fkey

-- ALTER TABLE r_objet.geo_objet_pt_adresse DROP CONSTRAINT geo_objet_adresse_id_tronc_fkey;

ALTER TABLE r_objet.geo_objet_pt_adresse
  ADD CONSTRAINT geo_objet_adresse_id_tronc_fkey FOREIGN KEY (id_tronc)
      REFERENCES r_objet.geo_objet_troncon (id_tronc) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- Foreign Key: r_objet.geo_objet_pt_adresse_id_voie_fkey

-- ALTER TABLE r_objet.geo_objet_pt_adresse DROP CONSTRAINT geo_objet_adresse_id_voie_fkey;

ALTER TABLE r_objet.geo_objet_pt_adresse
  ADD CONSTRAINT geo_objet_adresse_id_voie_fkey FOREIGN KEY (id_voie)
      REFERENCES r_voie.an_voie (id_voie) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;
      
-- Foreign Key: r_adresse.an_adresse_id_adresse_fkey

-- ALTER TABLE r_adresse.an_adresse DROP CONSTRAINT an_adresse_id_adresse_fkey;

ALTER TABLE r_adresse.an_adresse
  ADD CONSTRAINT an_adresse_id_adresse_fkey FOREIGN KEY (id_adresse)
      REFERENCES r_objet.geo_objet_pt_adresse (id_adresse) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

-- Foreign Key: r_adresse.an_adresse_info_id_adresse_fkey

-- ALTER TABLE r_adresse.an_adresse_info DROP CONSTRAINT an_adresse_info_id_adresse_fkey;

ALTER TABLE r_adresse.an_adresse_info
  ADD CONSTRAINT an_adresse_id_adresse_info_fkey FOREIGN KEY (id_adresse)
      REFERENCES r_objet.geo_objet_pt_adresse (id_adresse) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

-- ### an_adresse   
      
-- Foreign Key: r_adresse.an_adresse_lt_src_adr_fkey

-- ALTER TABLE r_adresse.an_adresse DROP CONSTRAINT an_adresse_lt_src_adr_fkey;

ALTER TABLE r_adresse.an_adresse
  ADD CONSTRAINT an_adresse_lt_src_adr_fkey FOREIGN KEY (src_adr)
      REFERENCES r_adresse.lt_src_adr (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;    


-- Foreign Key: r_adresse.an_adresse_lt_diag_adr_fkey

-- ALTER TABLE r_adresse.an_adresse DROP CONSTRAINT an_adresse_lt_diag_adr_fkey;

ALTER TABLE r_adresse.an_adresse
  ADD CONSTRAINT an_adresse_lt_diag_adr_fkey FOREIGN KEY (diag_adr)
      REFERENCES r_adresse.lt_diag_adr (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;


-- Foreign Key: r_adresse.an_adresse_lt_qual_adr_fkey

-- ALTER TABLE r_adresse.an_adresse DROP CONSTRAINT an_adresse_lt_qual_adr_fkey;

ALTER TABLE r_adresse.an_adresse
  ADD CONSTRAINT an_adresse_lt_qual_adr_fkey FOREIGN KEY (qual_adr)
      REFERENCES r_adresse.lt_qual_adr (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- ### geo_adresse    

-- Foreign Key: r_objet.lt_src_geom_fkey

-- ALTER TABLE r_objet.geo_objet_pt_adresse DROP CONSTRAINT geo_objet_adresse_lt_src_geom_fkey;

ALTER TABLE r_objet.geo_objet_pt_adresse
  ADD CONSTRAINT geo_objet_adresse_lt_src_geom_fkey FOREIGN KEY (src_geom)
      REFERENCES r_objet.lt_src_geom (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;


-- Foreign Key: r_objet.lt_position_fkey

-- ALTER TABLE r_objet.geo_objet_pt_adresse DROP CONSTRAINT geo_objet_adresse_lt_position_fkey;

ALTER TABLE r_objet.geo_objet_pt_adresse
  ADD CONSTRAINT geo_objet_adresse_lt_position_fkey FOREIGN KEY (position)
      REFERENCES r_objet.lt_position (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;

-- ### an_adresse_info

-- Foreign Key: r_adresse.an_adresse_info_lt_groupee_fkey

-- ALTER TABLE r_adresse.an_adresse_info DROP CONSTRAINT an_adresse_info_lt_groupee_fkey;

ALTER TABLE r_adresse.an_adresse_info
  ADD CONSTRAINT an_adresse_lt_groupee_fkey FOREIGN KEY (groupee)
      REFERENCES r_adresse.lt_groupee (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;  

-- Foreign Key: r_adresse.an_adresse_info_lt_secondaire_fkey

-- ALTER TABLE r_adresse.an_adresse_info DROP CONSTRAINT an_adresse_info_lt_secondaire_fkey;

ALTER TABLE r_adresse.an_adresse_info
  ADD CONSTRAINT an_adresse_lt_secondaire_fkey FOREIGN KEY (secondaire)
      REFERENCES r_adresse.lt_secondaire (code) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE SET NULL;  


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        VUES                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- View: r_adresse.geo_v_adresse

-- DROP VIEW r_adresse.geo_v_adresse;

CREATE OR REPLACE VIEW r_adresse.geo_v_adresse AS 
 SELECT 
 p.id_adresse,
 false::boolean as adresse_h,
 ''::character varying(10) as date_arr,
 p.id_voie,
 p.id_tronc,
 a.numero,
 a.repet,
 a.complement,
 a.etiquette,
 a.angle,
 v.libvoie_c,
 v.insee,
 k.codepostal,
 c.commune,
 v.rivoli,
 v.rivoli_cle,
 p.position,
 i.dest_adr,
 i.etat_adr,
 i.refcad,
 i.nb_log,
 i.pc,
 i.groupee,
 i.secondaire,
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
   LEFT JOIN r_administratif.lk_insee_codepostal as k ON v.insee = k.insee
   LEFT JOIN r_osm.geo_osm_commune as c ON v.insee = c.insee;


ALTER TABLE r_adresse.geo_v_adresse
  OWNER TO sig_create;
GRANT ALL ON TABLE r_adresse.geo_v_adresse TO sig_create;
GRANT SELECT ON TABLE r_adresse.geo_v_adresse TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.geo_v_adresse TO edit_sig;

COMMENT ON VIEW r_adresse.geo_v_adresse
  IS 'Vue éditable destinée à la modification des données relatives aux adresses';



-- View: x_opendata.xopendata_an_v_bal

-- DROP VIEW x_opendata.xopendata_an_v_bal;

CREATE OR REPLACE VIEW x_opendata.xopendata_an_v_bal AS 
 SELECT
        lower(CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text))
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3)))))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(a.complement::text, ' '::text, ''::text)))))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END) AS cle_interop,
    p.id_adresse AS uid_adresse,
    v.libvoie_c AS voie_nom,
    a.numero,
        CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN NULL::text
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN lower(btrim("left"(a.repet::text, 3)))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN lower(btrim(replace(a.complement::text, ' '::text, ''::text)))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN lower(btrim(concat("left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text))))
            ELSE NULL::text
        END AS suffixe,
    c.commune AS commune_nom,
    lt_p.valeur AS "position",
    p.x_l93 AS x,
    p.y_l93 AS y,
    st_x(st_transform(p.geom, 4326)) AS long,
    st_y(st_transform(p.geom, 4326)) AS lat,
    lt_a.valeur AS source,
        CASE
            WHEN p.date_maj IS NULL THEN to_char(date(p.date_sai),'YYYY-MM-DD')
            ELSE to_char(date(p.date_maj),'YYYY-MM-DD')
        END AS date_der_maj
   FROM r_objet.geo_objet_pt_adresse p
     LEFT JOIN r_adresse.an_adresse a ON a.id_adresse = p.id_adresse
     LEFT JOIN r_adresse.lt_src_adr lt_a ON lt_a.code::text = a.src_adr::text
     LEFT JOIN r_objet.lt_position lt_p ON lt_p.code::text = p."position"::text
     LEFT JOIN r_voie.an_voie v ON v.id_voie = p.id_voie
     LEFT JOIN r_osm.geo_osm_commune c ON v.insee = c.insee::bpchar
  WHERE (a.diag_adr::text = '11'::text OR "left"(a.diag_adr::text, 1) = '2'::text) AND a.diag_adr::text <> '31'::text AND a.diag_adr::text <> '32'::text AND a.numero <> '00000'
  ORDER BY 
        CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text))
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3)))))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(a.complement::text, ' '::text, ''::text)))))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_', v.rivoli, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END;

ALTER TABLE x_opendata.xopendata_an_v_bal
  OWNER TO sig_create;
GRANT ALL ON TABLE x_opendata.xopendata_an_v_bal TO sig_create;
GRANT SELECT ON TABLE x_opendata.xopendata_an_v_bal TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE x_opendata.xopendata_an_v_bal TO edit_sig;

COMMENT ON VIEW x_opendata.xopendata_an_v_bal
  IS 'Vue alphanumérique simplifiée des adresses au format d''échange BAL';


-- View: r_adresse.an_v_adresse_commune

-- DROP VIEW r_adresse.an_v_adresse_commune; 

CREATE OR REPLACE VIEW r_adresse.an_v_adresse_commune AS
SELECT a.insee,c.commune,COUNT(*) as nombre
FROM r_adresse.geo_v_adresse a
LEFT JOIN r_osm.geo_osm_commune c ON a.insee = c.insee::bpchar
GROUP BY a.insee, c.commune
ORDER BY a.insee, c.commune;

ALTER TABLE r_adresse.an_v_adresse_commune
  OWNER TO sig_create;      
GRANT ALL ON TABLE r_adresse.an_v_adresse_commune TO sig_create;
GRANT SELECT ON TABLE r_adresse.an_v_adresse_commune TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_adresse.an_v_adresse_commune TO edit_sig;

COMMENT ON VIEW r_adresse.an_v_adresse_commune
  IS 'Vue d''exploitation permettant de compter le nombre d''enregistrement d''adresse par commune';



-- View: r_voie.an_v_voie_adr_rivoli_null

-- DROP VIEW r_voie.an_v_voie_adr_rivoli_null;

CREATE OR REPLACE VIEW r_voie.an_v_voie_adr_rivoli_null AS 
SELECT v.id_voie,v.libvoie_c,v.insee,v.rivoli,v.rivoli_cle,v.observ,v.src_voie,v.date_sai,v.date_maj
FROM r_voie.an_voie as v
   INNER JOIN r_objet.geo_objet_pt_adresse p ON p.id_voie = v.id_voie      
WHERE v.rivoli IS NULL
ORDER BY insee;

ALTER TABLE r_voie.an_v_voie_adr_rivoli_null
  OWNER TO sig_create;  
GRANT ALL ON TABLE r_voie.an_v_voie_adr_rivoli_null TO sig_create;
GRANT SELECT ON TABLE r_voie.an_v_voie_adr_rivoli_null TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_voie.an_v_voie_adr_rivoli_null TO edit_sig;

COMMENT ON VIEW r_voie.an_v_voie_adr_rivoli_null
  IS 'Vue d''exploitation permettant d''identifier les voies adressées sans code RIVOLI';
  

-- View: r_voie.an_v_voie_rivoli_null

-- DROP VIEW r_voie.an_v_voie_rivoli_null;

CREATE OR REPLACE VIEW r_voie.an_v_voie_rivoli_null AS 
SELECT v.id_voie,v.libvoie_c,v.insee,v.rivoli,v.rivoli_cle,v.observ,v.src_voie,v.date_sai,v.date_maj
FROM r_voie.an_voie as v   
WHERE v.rivoli IS NULL
ORDER BY insee;

ALTER TABLE r_voie.an_v_voie_rivoli_null
  OWNER TO sig_create;
GRANT ALL ON TABLE r_voie.an_v_voie_rivoli_null TO sig_create;
GRANT SELECT ON TABLE r_voie.an_v_voie_rivoli_null TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE r_voie.an_v_voie_rivoli_null TO edit_sig;

COMMENT ON VIEW r_voie.an_v_voie_rivoli_null
  IS 'Vue d''exploitation permettant d''identifier les voies sans code RIVOLI';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                             VUES APPLICATIVES                                                                ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- View: x_apps.xapps_geo_vmr_adresse

-- DROP VIEW x_apps.xapps_geo_vmr_adresse;

CREATE MATERIALIZED VIEW x_apps.xapps_geo_vmr_adresse AS 
 WITH req_a AS (
         SELECT p.id_adresse,
            p.id_voie,
            p.id_tronc,
            a.numero,
            a.repet,
            a.complement,
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

ALTER TABLE x_apps.xapps_geo_v_adresse
  OWNER TO sig_create;
GRANT ALL ON TABLE x_apps.xapps_geo_v_adresse TO sig_create;
GRANT SELECT ON TABLE x_apps.xapps_geo_v_adresse TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE x_apps.xapps_geo_v_adresse TO edit_sig;
									      
COMMENT ON MATERIALIZED VIEW x_apps.xapps_geo_vmr_adresse
  IS 'Vue complète et décodée des adresses destinée à l''exploitation applicative (générateur d''apps)';


-- View: x_apps_public.xappspublic_geo_v_adresse

-- DROP VIEW x_apps_public.xappspublic_geo_v_adresse;

CREATE OR REPLACE VIEW x_apps_public.xappspublic_geo_v_adresse AS 
 SELECT 
 p.id_adresse,
 p.id_voie,
 p.id_tronc,
 a.numero,
 a.repet,
 a.complement,
 a.etiquette,
 a.angle,
 v.libvoie_c,
  v.mot_dir,
 v.insee,
 k.codepostal,
 c.commune,
 v.rivoli,
 v.rivoli_cle,
 lta.valeur as position,
 ltb.valeur as dest_adr,
 ltc.valeur as etat_adr,
 i.refcad,
 i.nb_log,
 i.pc,
 ltd.valeur as groupee,
 lte.valeur as secondaire,
 ltf.valeur as src_adr,
 ltg.valeur as src_geom,
 p.src_date,
 p.date_sai,
 p.date_maj,
 a.observ,
 lth.valeur as diag_adr,
 lti.valeur as qual_adr,
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
   LEFT JOIN r_administratif.lk_insee_codepostal as k ON v.insee = k.insee
   LEFT JOIN r_osm.geo_osm_commune c ON v.insee = c.insee
   LEFT JOIN r_objet.lt_position lta ON lta.code = p.position
   LEFT JOIN r_adresse.lt_dest_adr ltb ON ltb.code = i.dest_adr
   LEFT JOIN r_adresse.lt_etat_adr ltc ON ltc.code = i.etat_adr
   LEFT JOIN r_adresse.lt_groupee ltd ON ltd.code = i.groupee
   LEFT JOIN r_adresse.lt_secondaire lte ON lte.code = i.secondaire
   LEFT JOIN r_adresse.lt_src_adr ltf ON ltf.code = a.src_adr
   LEFT JOIN r_objet.lt_src_geom ltg ON ltg.code = p.src_geom
   LEFT JOIN r_adresse.lt_diag_adr lth ON lth.code = a.diag_adr
   LEFT JOIN r_adresse.lt_qual_adr lti ON lti.code = a.qual_adr;


ALTER TABLE x_apps_public.xappspublic_geo_v_adresse
  OWNER TO sig_create;
GRANT ALL ON TABLE x_apps_public.xappspublic_geo_v_adresse TO sig_create;
GRANT SELECT ON TABLE x_apps_public.xappspublic_geo_v_adresse TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE x_apps_public.xappspublic_geo_v_adresse TO edit_sig;
									      
COMMENT ON VIEW x_apps_public.xappspublic_geo_v_adresse
  IS 'Vue complète et décodée des adresses destinée à l''exploitation applicative (générateur d''apps Grand public)';

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
GRANT ALL ON TABLE x_apps.xapps_an_v_adresse_h TO sig_create;
GRANT SELECT ON TABLE x_apps.xapps_an_v_adresse_h TO read_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE x_apps.xapps_an_v_adresse_h TO edit_sig;
									      
COMMENT ON VIEW x_apps.xapps_an_v_adresse_h
  IS 'Vue d''exploitation permettant de lister l''historique des adresses (intégration dans la fiche adresse dans l''application GEO RVA';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                             VUES OPEN DATA                                                                   ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################

-- View: x_opendata.xopendata_geo_v_openadresse

-- DROP VIEW x_opendata.xopendata_geo_v_openadresse;

CREATE OR REPLACE VIEW x_opendata.xopendata_geo_v_openadresse AS 
 SELECT
        CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN concat(v.insee, '_',
            CASE
                WHEN v.rivoli IS NULL THEN '0000'::bpchar
                ELSE v.rivoli
            END, '_', lpad(a.numero::text, 5, '0'::text))
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN concat(v.insee, '_',
            CASE
                WHEN v.rivoli IS NULL THEN '0000'::bpchar
                ELSE v.rivoli
            END, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3)))))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_',
            CASE
                WHEN v.rivoli IS NULL THEN '0000'::bpchar
                ELSE v.rivoli
            END, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(a.complement::text, ' '::text, ''::text)))))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_',
            CASE
                WHEN v.rivoli IS NULL THEN '0000'::bpchar
                ELSE v.rivoli
            END, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END AS cle_interop,
    p.id_adresse AS uid_adresse,
    a.numero,
    a.repet,
    a.complement,
    v.libvoie_c AS voie,
    c.commune,
    v.insee,
    k.codepostal,
    v.rivoli,
    lt_p.valeur AS "position",
    p.x_l93 AS x,
    p.y_l93 AS y,
    st_x(st_transform(p.geom, 4326)) AS long,
    st_y(st_transform(p.geom, 4326)) AS lat,
    a.etiquette,
    a.angle,
    lt_a.valeur AS source,
        CASE
            WHEN p.date_maj IS NULL THEN date(p.date_sai)
            ELSE date(p.date_maj)
        END AS date_der_maj,
    p.geom
   FROM r_objet.geo_objet_pt_adresse p
     LEFT JOIN r_adresse.an_adresse a ON a.id_adresse = p.id_adresse
     LEFT JOIN r_adresse.lt_src_adr lt_a ON lt_a.code::text = a.src_adr::text
     LEFT JOIN r_objet.lt_position lt_p ON lt_p.code::text = p."position"::text
     LEFT JOIN r_voie.an_voie v ON v.id_voie = p.id_voie
     LEFT JOIN r_osm.geo_osm_commune c ON v.insee = c.insee::bpchar
     LEFT JOIN r_administratif.lk_insee_codepostal k ON v.insee = k.insee::bpchar
  WHERE a.diag_adr::text = '11'::text OR "left"(a.diag_adr::text, 1) = '2'::text OR a.diag_adr::text = '32'::text
  ORDER BY
        CASE
            WHEN a.repet IS NULL AND a.complement IS NULL THEN concat(v.insee, '_',
            CASE
                WHEN v.rivoli IS NULL THEN '0000'::bpchar
                ELSE v.rivoli
            END, '_', lpad(a.numero::text, 5, '0'::text))
            WHEN a.repet IS NOT NULL AND a.complement IS NULL THEN concat(v.insee, '_',
            CASE
                WHEN v.rivoli IS NULL THEN '0000'::bpchar
                ELSE v.rivoli
            END, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3)))))
            WHEN a.repet IS NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_',
            CASE
                WHEN v.rivoli IS NULL THEN '0000'::bpchar
                ELSE v.rivoli
            END, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', replace(a.complement::text, ' '::text, ''::text)))))
            WHEN a.repet IS NOT NULL AND a.complement IS NOT NULL THEN concat(v.insee, '_',
            CASE
                WHEN v.rivoli IS NULL THEN '0000'::bpchar
                ELSE v.rivoli
            END, '_', lpad(a.numero::text, 5, '0'::text), lower(btrim(concat('_', "left"(a.repet::text, 3), '_', replace(a.complement::text, ' '::text, ''::text)))))
            ELSE NULL::text
        END;

ALTER TABLE x_opendata.xopendata_geo_v_openadresse
  OWNER TO sig_create;
GRANT ALL ON TABLE x_opendata.xopendata_geo_v_openadresse TO sig_create;
GRANT ALL ON TABLE x_opendata.xopendata_geo_v_openadresse TO create_sig;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE x_opendata.xopendata_geo_v_openadresse TO edit_sig;
GRANT SELECT ON TABLE x_opendata.xopendata_geo_v_openadresse TO read_sig;
COMMENT ON VIEW x_opendata.xopendata_geo_v_openadresse
  IS 'Vue destinée à la communication extérieure des données relatives aux adresses. Exclusion des adresses supprimées, non attribuées pour projet ou à confirmer';


-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      TRIGGER                                                                 ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################



-- #################################################################### FONCTION TRIGGER - GEO_OBJET_PT_ADRESSE ###################################################

-- Function: r_objet.ft_m_geo_objet_pt_adresse()

-- DROP FUNCTION r_objet.ft_m_geo_objet_pt_adresse();

CREATE OR REPLACE FUNCTION r_objet.ft_m_geo_objet_pt_adresse()
  RETURNS trigger AS
$BODY$

DECLARE v_id_adresse integer;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_id_adresse := nextval('r_objet.geo_objet_pt_adresse_id_seq'::regclass);
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
--NEW.id_adresse := v_id_adresse;
RETURN NEW;


-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN
UPDATE
r_objet.geo_objet_pt_adresse
SET
id_adresse=NEW.id_adresse,
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
WHERE r_objet.geo_objet_pt_adresse.id_adresse = OLD.id_adresse;
RETURN NEW;

-- DELETE
-- ELSIF (TG_OP = 'DELETE') THEN
-- DELETE FROM r_objet.geo_objet_pt_adresse where id_adresse = OLD.id_adresse;
-- RETURN OLD;

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION r_objet.ft_m_geo_objet_pt_adresse()
  OWNER TO sig_create;
GRANT EXECUTE ON FUNCTION r_objet.ft_m_geo_objet_pt_adresse() TO public;
GRANT EXECUTE ON FUNCTION r_objet.ft_m_geo_objet_pt_adresse() TO sig_create;
GRANT EXECUTE ON FUNCTION r_objet.ft_m_geo_objet_pt_adresse() TO create_sig;

		  
COMMENT ON FUNCTION r_objet.ft_m_geo_objet_pt_adresse() IS 'Fonction trigger pour mise à jour de la classe objet point adresse';



-- Trigger: r_objet.t_t1_geo_objet_pt_adresse on r_adresse.geo_v_adresse

-- DROP TRIGGER r_objet.t_t1_geo_objet_pt_adresse ON r_adresse.geo_v_adresse;

CREATE TRIGGER t_t1_geo_objet_pt_adresse
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON r_adresse.geo_v_adresse
  FOR EACH ROW
  EXECUTE PROCEDURE r_objet.ft_m_geo_objet_pt_adresse();



-- #################################################################### FONCTION TRIGGER - AN_ADRESSE ###################################################

-- Function: r_adresse.ft_m_an_adresse()

-- DROP FUNCTION r_adresse.ft_m_an_adresse();

CREATE OR REPLACE FUNCTION r_adresse.ft_m_an_adresse()
  RETURNS trigger AS
$BODY$

DECLARE v_id_adresse integer;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

-- gestion des erreurs relevés dans le formatage des données BAL par des exceptions (remontées dans QGIS)
-- le code RIVOLI doit être renseigné (par défaut mettre 0000 dans la table des noms de voies)
IF (SELECT rivoli FROM r_voie.an_voie WHERE id_voie = new.id_voie) is null THEN
RAISE EXCEPTION 'Code RIVOLI non présent. Mettre ''0000'' dans le champ RIVOLI dans la table des noms de voies si le code RIVOLI n''existe pas';
END IF;

-- le champ numéro doit contenir uniquement des n°
IF RTRIM(new.numero, '0123456789') <> '' THEN
RAISE EXCEPTION 'Vous devez saisir uniquement des numéros dans le champ NUMERO';
END IF;

-- le champ numéro doit être identique + repet à l'étiquette
IF (new.numero || CASE WHEN new.repet is null THEN '' ELSE new.repet END) <> new.etiquette THEN
RAISE EXCEPTION 'Le champ d''étiquette n''est pas cohérent avec le numéro et l''indice de répétition';
END IF;

v_id_adresse := currval('r_objet.geo_objet_pt_adresse_id_seq'::regclass);
INSERT INTO r_adresse.an_adresse (id_adresse, numero, repet, complement, etiquette, angle, observ, src_adr, diag_adr, qual_adr)
SELECT v_id_adresse,
NEW.numero,
LOWER(NEW.repet),
NEW.complement,
UPPER(REPLACE(REPLACE(REPLACE(REPLACE((NEW.etiquette),'bis','B'),'ter','T'),'quater','Q'),'quinquies','C')),
CASE WHEN NEW.angle BETWEEN 90 AND 179 THEN NEW.angle + 180 WHEN NEW.angle BETWEEN 181 AND 270 THEN NEW.angle - 180 WHEN NEW.angle = 180 THEN 0 WHEN NEW.angle < 0 THEN NEW.angle + 360 ELSE NEW.angle END,
NEW.observ,
CASE WHEN NEW.src_adr IS NULL THEN '00' ELSE NEW.src_adr END,
CASE WHEN NEW.diag_adr IS NULL THEN '00' ELSE NEW.diag_adr END,
CASE WHEN NEW.diag_adr IS NULL THEN '0' ELSE LEFT(NEW.diag_adr,1) END;
--NEW.id_adresse := v_id_adresse;

RETURN NEW;

-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN

-- gestion des erreurs relevés dans le formatage des données BAL par des exceptions (remontées dans QGIS)
-- le code RIVOLI doit être renseigné (par défaut mettre 0000 dans la table des noms de voies)
IF new.rivoli is null THEN
RAISE EXCEPTION 'Code RIVOLI non présent. Mettre ''0000'' dans le champ RIVOLI dans la table des noms de voies si le code RIVOLI n''existe pas';
END IF;

-- le champ numéro doit contenir uniquement des n°
IF RTRIM(new.numero, '0123456789') <> '' THEN
RAISE EXCEPTION 'Vous devez saisir uniquement des numéros dans le champ NUMERO';
END IF;

-- le champ numéro doit être identique + repet à l'étiquette
IF (new.numero || CASE WHEN new.repet is null THEN '' ELSE new.repet END) <> new.etiquette THEN
RAISE EXCEPTION 'Le champ d''étiquette n''est pas cohérent avec le numéro et l''indice de répétition';
END IF;

UPDATE
r_adresse.an_adresse
SET
id_adresse=NEW.id_adresse,
numero=NEW.numero,
repet=LOWER(NEW.repet),
complement=NEW.complement,
etiquette=UPPER(REPLACE(REPLACE(REPLACE(REPLACE((NEW.etiquette),'bis','B'),'ter','T'),'quater','Q'),'quinquies','C')),
angle=CASE WHEN NEW.angle BETWEEN 90 AND 179 THEN NEW.angle + 180 WHEN NEW.angle BETWEEN 181 AND 270 THEN NEW.angle - 180 WHEN NEW.angle = 180 THEN 0 WHEN NEW.angle < 0 THEN NEW.angle + 360 ELSE NEW.angle END,
verif_base=NEW.verif_base,
observ=NEW.observ,
src_adr=CASE WHEN NEW.src_adr IS NULL THEN '00' ELSE NEW.src_adr END,
diag_adr=CASE WHEN NEW.diag_adr IS NULL THEN '00' ELSE NEW.diag_adr END,
qual_adr=CASE WHEN NEW.diag_adr IS NULL THEN '0' ELSE LEFT(NEW.diag_adr,1) END
                                                                              
WHERE r_adresse.an_adresse.id_adresse = OLD.id_adresse;
RETURN NEW;

-- fonction supprimee depuis la vue
/*
-- DELETE
ELSIF (TG_OP = 'DELETE') THEN
DELETE FROM r_adresse.an_adresse where id_adresse = OLD.id_adresse;
RETURN OLD;
*/

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION r_adresse.ft_m_an_adresse()
  OWNER TO sig_create;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse() TO public;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse() TO sig_create;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse() TO create_sig;
COMMENT ON FUNCTION r_adresse.ft_m_an_adresse() IS 'Fonction trigger pour mise à jour de la classe alphanumérique de référence de l''adresse';

-- ### trigger an_adresse

-- Trigger: r_adresse.t_t2_an_adresse on r_adresse.geo_v_adresse

-- DROP TRIGGER r_adresse.t_t2_an_adresse ON r_adresse.geo_v_adresse;

CREATE TRIGGER t_t2_an_adresse
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON r_adresse.geo_v_adresse
  FOR EACH ROW
  EXECUTE PROCEDURE r_adresse.ft_m_an_adresse();



-- #################################################################### FONCTION TRIGGER - AN_ADRESSE_INFO ###################################################

-- Function: r_adresse.ft_m_an_adresse_info()

-- DROP FUNCTION r_adresse.ft_m_an_adresse_info();

CREATE OR REPLACE FUNCTION r_adresse.ft_m_an_adresse_info()
  RETURNS trigger AS
$BODY$

DECLARE v_id_adresse integer;

BEGIN

-- INSERT
IF (TG_OP = 'INSERT') THEN

v_id_adresse := currval('r_objet.geo_objet_pt_adresse_id_seq'::regclass);
INSERT INTO r_adresse.an_adresse_info (id_adresse, dest_adr, etat_adr, refcad, nb_log, pc, groupee, secondaire, id_ext1, id_ext2)
SELECT v_id_adresse, 
CASE WHEN NEW.dest_adr IS NULL THEN '00' ELSE NEW.dest_adr END,
CASE WHEN NEW.etat_adr IS NULL THEN '00' ELSE NEW.etat_adr END,
UPPER(REPLACE(REPLACE(REPLACE(REPLACE((NEW.refcad),'-',';'),',',';'),'/',';'),'\',';')),
NEW.nb_log,
UPPER(NEW.pc),
CASE WHEN NEW.groupee IS NULL THEN '0' ELSE NEW.groupee END,
CASE WHEN NEW.secondaire IS NULL THEN '0' ELSE NEW.secondaire END,
NEW.id_ext1,
NEW.id_ext2;
NEW.id_adresse := v_id_adresse;
RETURN NEW;

-- UPDATE
ELSIF (TG_OP = 'UPDATE') THEN
UPDATE
r_adresse.an_adresse_info
SET
id_adresse=NEW.id_adresse,
dest_adr=CASE WHEN NEW.dest_adr IS NULL THEN '00' ELSE NEW.dest_adr END,
etat_adr=CASE WHEN NEW.etat_adr IS NULL THEN '00' ELSE NEW.etat_adr END,
refcad=UPPER(REPLACE(REPLACE(REPLACE(REPLACE((NEW.refcad),'-',';'),',',';'),'/',';'),'\',';')),
nb_log=NEW.nb_log,
pc=UPPER(NEW.pc),
groupee=CASE WHEN NEW.groupee IS NULL THEN '0' ELSE NEW.groupee END,
secondaire=CASE WHEN NEW.secondaire IS NULL THEN '0' ELSE NEW.secondaire END,
id_ext1=NEW.id_ext1,
id_ext2=NEW.id_ext2

WHERE r_adresse.an_adresse_info.id_adresse = OLD.id_adresse;
RETURN NEW;

-- fonction supprimee depuis la vue
/*
-- DELETE
ELSIF (TG_OP = 'DELETE') THEN
DELETE FROM r_adresse.an_adresse_info where id_adresse = OLD.id_adresse;
RETURN OLD;
*/

END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION r_adresse.ft_m_an_adresse_info()
  OWNER TO sig_create;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse_info() TO public;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse_info() TO sig_create;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse_info() TO create_sig;
COMMENT ON FUNCTION r_adresse.ft_m_an_adresse_info() IS 'Fonction trigger pour mise à jour de la classe alphanumérique de complément de l''adresse';


-- ### trigger an_adresse_info

-- Trigger: r_adresse.t_t3_an_adresse_info on r_adresse.geo_v_adresse

-- DROP TRIGGER r_adresse.t_t2_an_adresse ON r_adresse.geo_v_adresse;

CREATE TRIGGER t_t3_an_adresse_info
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON r_adresse.geo_v_adresse
  FOR EACH ROW                                                                                                                                                                       
  EXECUTE PROCEDURE r_adresse.ft_m_an_adresse_info();






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
  

-- #################################################################### FONCTION TRIGGER - an_adresse_h ###################################################

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
  OWNER TO sig_create;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse_h() TO public;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse_h() TO sig_create;
GRANT EXECUTE ON FUNCTION r_adresse.ft_m_an_adresse_h() TO create_sig;
		  
COMMENT ON FUNCTION r_adresse.ft_m_an_adresse_h() IS 'Fonction trigger pour insertion de l''historisation des adresses dans la classe d''objet an_adresse_h';




-- Trigger: r_adresse.t_t4_an_adresse_h on r_adresse.geo_v_adresse

-- DROP TRIGGER r_adresse.t_t4_an_adresse_h ON r_adresse.geo_v_adresse;

CREATE TRIGGER t_t4_an_adresse_h
  INSTEAD OF UPDATE
  ON r_adresse.geo_v_adresse
  FOR EACH ROW
  EXECUTE PROCEDURE r_adresse.ft_m_an_adresse_h();

-- #################################################################### FONCTION TRIGGER - local / etablissement ###################################################

-- Function: m_economie.ft_m_geo_objet_pt_adresse_local()

-- DROP FUNCTION m_economie.ft_m_geo_objet_pt_adresse_local();

CREATE OR REPLACE FUNCTION m_economie.ft_m_geo_objet_pt_adresse_local()
  RETURNS trigger AS
$BODY$


DECLARE v_idgeolf integer;
BEGIN

IF ST_Equals(new.geom,old.geom) = false THEN

	-- gestion des intégrations des liens entre local/lot foncier eco lors d'une création ou d'un déplacement d'adresse

	-- si mon adresse déplacée est dans un local spécifique (geo_sa_local) alors qu'avant non, alors j'intègre dans la table de relation 
	IF 
		(
			(SELECT count(*) FROM m_economie.geo_sa_local l , r_adresse.geo_v_adresse a
			WHERE st_intersects(l.geom,new.geom)) > 0 
		AND 
			(SELECT count(*) FROM m_economie.geo_sa_local l , r_adresse.geo_v_adresse a
			WHERE st_intersects(l.geom,old.geom)) = 0
		)
	THEN
		INSERT INTO m_economie.lk_localsiret (idgeoloc,siret)
		SELECT DISTINCT l.idgeoloc,lk.siret FROM m_economie.geo_sa_local l , r_adresse.geo_v_adresse a , m_economie.lk_adresseetablissement lk
		WHERE st_intersects(l.geom,new.geom) AND a.id_adresse = lk.idadresse AND a.id_adresse=new.id_adresse;

	-- rafraichissement de la vue matérialisée des adresses qui sert à la vue matérialisée d'après
	REFRESH MATERIALIZED VIEW x_apps.xapps_geo_vmr_adresse;
	-- rafraichissement de la vue matérialisée
	REFRESH MATERIALIZED VIEW x_apps.xapps_geo_vmr_etab_api;

	END IF;

	-- si mon adresse déplacée est dans un lot foncier éco alors qu'avant non, alors j'intègre dans la table de relation 
	IF 
		(
			(SELECT count(*) FROM r_objet.geo_objet_fon_lot l ,r_adresse.geo_v_adresse a
			WHERE st_intersects(l.geom,new.geom) AND l.l_voca='20') > 0
		AND
			(SELECT count(*) FROM r_objet.geo_objet_fon_lot l ,r_adresse.geo_v_adresse a
			WHERE st_intersects(l.geom,old.geom) AND l.l_voca='20') = 0
		)
	THEN
		INSERT INTO m_economie.lk_localsiret (idgeoloc,siret)
		SELECT DISTINCT l.idgeolf,lk.siret FROM r_objet.geo_objet_fon_lot l , r_adresse.geo_v_adresse a , m_economie.lk_adresseetablissement lk
		WHERE st_intersects(l.geom,new.geom) AND a.id_adresse = lk.idadresse AND a.id_adresse=new.id_adresse;

	-- rafraichissement de la vue matérialisée des adresses qui sert à la vue matérialisée d'après
	REFRESH MATERIALIZED VIEW x_apps.xapps_geo_vmr_adresse;
	-- rafraichissement de la vue matérialisée
	REFRESH MATERIALIZED VIEW x_apps.xapps_geo_vmr_etab_api;

	END IF;

	-- si mon adresse déplacée est dans un lot foncier éco et qu'avant oui, alors j'intègre dans la table de relation 
	IF 
		(
			(SELECT count(*) FROM r_objet.geo_objet_fon_lot l ,r_adresse.geo_v_adresse a
			WHERE st_intersects(l.geom,new.geom) AND l.l_voca='20') > 0
		AND
			(SELECT count(*) FROM r_objet.geo_objet_fon_lot l ,r_adresse.geo_v_adresse a
			WHERE st_intersects(l.geom,old.geom) AND l.l_voca='20') > 0
		)
	THEN
		DELETE FROM m_economie.lk_localsiret where siret=
		(SELECT DISTINCT lk.siret FROM r_objet.geo_objet_fon_lot l , r_adresse.geo_v_adresse a , m_economie.lk_adresseetablissement lk
		WHERE st_intersects(l.geom,new.geom) AND a.id_adresse = lk.idadresse AND a.id_adresse=new.id_adresse)

		 and idgeoloc=
		 (
		SELECT DISTINCT l.idgeolf FROM r_objet.geo_objet_fon_lot l , r_adresse.geo_v_adresse a , m_economie.lk_adresseetablissement lk
		WHERE st_intersects(l.geom,old.geom) AND a.id_adresse = lk.idadresse AND a.id_adresse=new.id_adresse
		 );
		INSERT INTO m_economie.lk_localsiret (idgeoloc,siret)
		SELECT DISTINCT l.idgeolf,lk.siret FROM r_objet.geo_objet_fon_lot l , r_adresse.geo_v_adresse a , m_economie.lk_adresseetablissement lk
		WHERE st_intersects(l.geom,new.geom) AND a.id_adresse = lk.idadresse AND a.id_adresse=new.id_adresse;

	-- rafraichissement de la vue matérialisée des adresses qui sert à la vue matérialisée d'après
	REFRESH MATERIALIZED VIEW x_apps.xapps_geo_vmr_adresse;
	-- rafraichissement de la vue matérialisée
	REFRESH MATERIALIZED VIEW x_apps.xapps_geo_vmr_etab_api;

	END IF;

END IF;


RETURN NEW;
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION m_economie.ft_m_geo_objet_pt_adresse_local()
  OWNER TO sig_create;
GRANT EXECUTE ON FUNCTION m_economie.ft_m_geo_objet_pt_adresse_local() TO public;
GRANT EXECUTE ON FUNCTION m_economie.ft_m_geo_objet_pt_adresse_local() TO sig_create;
GRANT EXECUTE ON FUNCTION m_economie.ft_m_geo_objet_pt_adresse_local() TO create_sig;
COMMENT ON FUNCTION m_economie.ft_m_geo_objet_pt_adresse_local() IS 'Fonction dont l''objet de rechercher les établissements dans le local ou dans les lots fonciers si celui-ci croise une adresse qui aurait été déplacé ou créer et de les intégrer dans la table lk_localsiret';
 
-- Trigger: t_t5_geo_objet_pt_adresse_local on r_adresse.geo_v_adresse

-- DROP TRIGGER t_t5_geo_objet_pt_adresse_local ON r_adresse.geo_v_adresse;

CREATE TRIGGER t_t5_geo_objet_pt_adresse_local
  INSTEAD OF INSERT OR UPDATE
  ON r_adresse.geo_v_adresse
  FOR EACH ROW
  EXECUTE PROCEDURE m_economie.ft_m_geo_objet_pt_adresse_local();



-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                      BAC A SABLE                                                             ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################
  
-- TRUNCATE TABLE r_objet.geo_objet_pt_adresse, r_adresse.an_adresse, r_adresse.an_adresse_info CASCADE;
-- ALTER SEQUENCE r_objet.geo_objet_pt_adresse_id_seq RESTART WITH 1;





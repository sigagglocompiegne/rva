/*Voie et Adresse V1.0*/
/*Creation droits sur l'ensemble des objets */
/*99_GRANT.sql */
/*PostGIS*/
/*GeoCompiegnois - http://geo.compiegnois.fr/ */
/*Auteur : Grégory Bodet */

-- ICI SONT PRESENTES LES DROITS DE MANIERES GENERIQUES COMME ILS DOIVENT ETRE INTEGRES POUR CHAQUE CLASSE D'OBJETS. SI DES PARTICULARITES SONT
-- INTRODUITES ELLES SONT DETAILLEES CI-DESSOUS

-- ####################################################################################################################################################
-- ###                                                                                                                                              ###
-- ###                                                                        GRANT                                                                  ###
-- ###                                                                                                                                              ###
-- ####################################################################################################################################################


-- #################################################################### SEQUENCE  ####################################################################

ALTER SEQUENCE [schema].[sequence]
    OWNER TO create_sig;

GRANT ALL ON SEQUENCE [schema].[sequence] TO create_sig;
    
-- #################################################################### DOMAINE DE VALEUR  ####################################################################

ALTER TABLE [schema].[table]
    OWNER to create_sig;

GRANT ALL ON TABLE [schema].[table] TO sig_create;
GRANT SELECT ON TABLE [schema].[table] TO sig_read;
GRANT ALL ON TABLE [schema].[table] TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE [schema].[table] TO sig_edit;

-- #################################################################### CLASSE D'OBJET ####################################################################


ALTER TABLE [schema].[table]
    OWNER to create_sig;

GRANT ALL ON TABLE [schema].[table] TO sig_create;
GRANT SELECT ON TABLE [schema].[table] TO sig_read;
GRANT ALL ON TABLE [schema].[table] TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE [schema].[table] TO sig_edit;


-- ########################################################### FONCTION  ####################################################################

ALTER FUNCTION [schema].[fonction]()
    OWNER TO create_sig;

GRANT EXECUTE ON FUNCTION [schema].[fonction]() TO PUBLIC;
GRANT EXECUTE ON FUNCTION [schema].[fonction]() TO create_sig;


-- ########################################################### VUE DE GESTION  ####################################################################

ALTER TABLE [schema].[vue]
OWNER TO create_sig;

GRANT ALL ON TABLE [schema].[vue] TO sig_create;
GRANT SELECT ON TABLE [schema].[vue] TO sig_read;
GRANT ALL ON TABLE [schema].[vue] TO create_sig;
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE [schema].[vue] TO sig_edit;


-- ########################################################### VUE APPLICATIVE ou OPEN DATA ####################################################################

ALTER TABLE [schema].[vue]
    OWNER TO create_sig;

GRANT SELECT ON TABLE [schema].[vue] TO sig_create;
GRANT SELECT ON TABLE [schema].[vue] TO sig_read;
GRANT SELECT ON TABLE [schema].[vue] TO sig_edit;
GRANT SELECT ON TABLE [schema].[vue] TO create_sig;



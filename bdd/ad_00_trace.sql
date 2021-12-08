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
-- 2019/06/18 : GB / Adaptation trigger sur la vue geo_v_adresse suite bug opérationnel sur les zones d'activité
-- 2019/12/09 : GB / Adaptation trigger de contrôle saisie adresse sur égalité numéro + repet et étiquette
-- 2019/12/13 : GB / Adaptation trigger de contrôle saisie adresse sur égalité numéro + repet et étiquette
-- 2020/01/27 : GB / Intégration d'un trigger pour mettre à jour les '' en null dans la table an_adresse
-- 2020/10/02 : GB / Modification de la fonction gérant l'insertion des données adresses dans le RAISE EXCEPTION liée à l'IDVOIE non connu et au CODE RIVOLI absent
-- 2020/10/12 : GB / Adaptation du trigger pour insertion danbs la table an_adresse au niveau du contrôle entre le n° et l'étiquette (exclusion des n° 00000 et 99999 pour le contrôle)
-- 2020/10/16 : GB / Intégration d'un trigger pour mise à jour automatique de la vue matérialisée des adresses accessibles dans les différentes applicatifs
-- 2021/02/05 : GB / Intégration des adaptations structurelles et fonctionnelles dues au format d'échange BAL version 1.2 (3 attributs complémentaires + modification de la vue export OpenData)
-- 2021/03/15 : GB / Modification des droits
-- 2021/03/15 : GB / Suppression des vues relevant les adresses sans CODE RIVOLI suite standard BAL 1.2 affectant un RIVOLI temporaire
-- 2021/05/06 : GB / Intégration d'un contrôle sur les adresses conformes pour éviter les doublons d'adresse à la saisie (modification de la fonction trigger de contrôle ft_m_geo_adresse_gestion())
-- 2021/09/13 : GB / Gestion des références cadastrales multiples pour export au format BAL (création d'une sous-classe an_adresse_cad, avec relation 0..n dans QGIS et GEO)
--              GB / Modification de l'export OpenData pour intégrer l'attribut cadastre_parcelles (0 ou n valeurs séparées par un |) et intégration de l'attribut certification_commune (avec valeur forcée à 1) pour la remontée à ETALAB
-- 2021/09/14 : GB / Intégration dans le trigger de gestion à la saisie et mise à jour des références cadastres (sur an_adresse_cad) d'un controle sur la saisie des sections et n° de parcelles
-- 2021/09/24 : GB / Modification de l'export BAL dans la clé d'interopérabilité (suppression du complément et modification du suffixe) et ajout des adresses numérotées à vérifier comme non certifiées
-- 2021/10/12 : GB / Correction fonction trigger sur contrôle adresse non numéroté avec 00000 en n° et sdans étiquette (exception sans erreur ici)
-- 2021/12/07 : GB / Création d'une vue d'export pour le nouveau standard BAL 1.3 avec ajout permis de l'export des adresses codé 99999 (voies et lieux-dits sans adresse)
-- 2021/12/08 : GB / Modification trigger gestion des adresses (ajout d'un contrôle sur la suppressio impossible d'un point d'adresse relié à un établissement

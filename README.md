![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Prescriptions spécifiques (locales) pour la gestion des adresses et des voies

Spécification du fichier d’échange relatif aux données concernant le référentiel des adresses (base adresse locale ou BAL) et des voies sur le Pays Compiégnois et gérées par l'Agglomération de la Région de Compiègne. Il existe également un format d'échange des données adresses au niveau national pour la diffusion de celles-ci. La BAL, à l'échelle du Pays Compiégnois, est ainsi diffusée dans ce format d'échange et alimente la base adresse nationale (BAN). 

- [Lire la documentation du standard](gabarit/livrables.md)
- Script d'initialisation de la base de données des adresses
  * [Suivi des modifications](bdd/ad_00_trace.sql)
  * [Création  de la structure initiale](bdd/ad_10_squelette.sql)
  * [Création des vues de gestion](bdd/ad_20_vues_gestion.sql)
  * [Création des vues applicatives](bdd/ad_21_vues_xapps.sql)
  * [Création des privilèges](bdd/99_grant.sql)
- Script d'initialisation de la base de données des voies
  * [Suivi des modifications](bdd/voie_00_trace.sql)
  * [Création  de la structure initiale](bdd/voie_10_squelette.sql)
  * [Création des vues de gestion](bdd/voie_20_vues_gestion.sql)
  * [Création des vues applicatives](bdd/voie_21_vues_xapps.sql)
  * [Création des privilèges](bdd/99_grant.sql)
- Script d'initialisation de la base de données des signalements
  * [Suivi des modifications](bdd/sign_00_trace.sql)
  * [Création  de la structure initiale](bdd/sign_10_squelette.sql)
  * [Création des vues de gestion](bdd/sign_20_vues_gestion.sql)
  * [Création des vues applicatives](bdd/sign_21_vues_xapps.sql)
  * [Création des privilèges](bdd/99_grant.sql) 
- [Documentation d'administration de la base Adresse](bdd/doc_admin_bd_adresse.md) 
- [Documentation d'administration de la base Voie](bdd/doc_admin_bd_voie.md) 
- [Documentation d'administration de l'application](app/doc_admin_app_rva.md)
- [Documentation utilisateur de l'application](app/doc_user_app_rva.md)
- [Règles de saisies des voies](gabarit/livrables.md)
- Règles de saisies des adresses(à venir)
- Signalements IGN - Base de voies
  * [Suivi des modifications](ign/ign_sign_00_trace.sql)
  * [Création de la structure initiale](ign/ign_sign_10_squelette.sql)
  * [Documentation d'administration de la base de signalement](ign/doc_admin_ign_sign.md)
  
## Contexte

L’ARC est engagée dans un plan de modernisation numérique pour l’exercice de ses missions de services publics. L’objectif poursuivi vise à permettre à la collectivité de se doter d’outil d’aide à la décision et d’optimiser l’organisation de ses services. Ces objectifs se déclinent avec la mise en place d’outils informatiques adaptés au quotidien des services et le nécessaire retour auprès de la collectivité, des informations (données) produites et gérées par ses prestataires. 

L’ARC privilégie donc une organisation dans laquelle l’Interface Homme Machine (IHM) du métier assure l’alimentation d’un entrepôt de données territoriales. Cette stratégie « agile » permet de répondre au plus près des besoins des services dans une trajectoire soutenable assurant à la fois une bonne maitrise des flux d’information et un temps d’acculturation au sein de l’organisation.

## Voir aussi

- [GitHub du Validateur de fichier au format d'échange "Base Adresse Locale"](https://github.com/etalab/bal)
- [Validateur en ligne du format BAL](https://adresse.data.gouv.fr/bases-locales/validateur)
- [Ressources nationales (dont spécification du format d'échange BAL version 1.4)](https://aitf-sig-topo.github.io/voies-adresses/#format-bal)
- [Documentation de l'API BAL de la BaseAdresseNationale](https://doc.adresse.data.gouv.fr/naviguer-sur-le-site/les-api)
- [Paramétrage de l'API de dépôt Mes Adresses pour FME](https://github.com/sigagglocompiegne/rva/blob/master/api/doc_api_balc_fme.md)
- [Gestion des signalements sur "Mes adresses" via l'API "Mes signalements" pour FME](https://github.com/sigagglocompiegne/rva/blob/master/api/doc_api_sign_fme.md)


## Jeu de données consolidé

Retrouvez bientôt un jeu de données sur les adresses à l'échelle de chaque EPCI du Grand Compiégnois sur le catalogue GéoCompiégnois.



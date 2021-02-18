![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Prescriptions spécifiques (locales) pour la gestion des adresses et des voies

(x) en cours de rédaction

Spécification du fichier d’échange relatif aux données concernant le référentiel des adresses (base adresse locale ou BAL) et des voies sur le Pays Compiégnois et gérées par l'Agglomération de la Région de Compiègne. Il existe également un format d'échange des données adresses au niveau national pour la diffusion de celles-ci. La BAL, à l'échelle du Pays Compiégnois, est ainsi diffusée dans ce format d'échange et alimente la base adresse nationale (BAN). 

- [Lire la documentation du standard local de la base des adresses locales et des voies](gabarit/livrables.md)
- Script d'initialisation de la base de données 
  * [Script d'initialisation de la base de données Adresse](bdd/init_bd_adresse.sql) 
  * [Script d'initialisation de la base de données Voie](bdd/init_bd_voie.sql) 
  * [Script d'initialisation des signalements Voies et Adresses](bdd/init_bd_rva.sql) 
- [Documentation d'administration de la base Adresse](bdd/doc_admin_bd_adresse.md) 
- [Documentation d'administration de la base Voie](bdd/doc_admin_bd_voie.md) 
- [Documentation d'administration de l'application](app/doc_admin_app_rva.md)
- [Documentation utilisateur de l'application](app/doc_user_app_rva.md)

## Contexte

L’ARC est engagée dans un plan de modernisation numérique pour l’exercice de ses missions de services publics. L’objectif poursuivi vise à permettre à la collectivité de se doter d’outil d’aide à la décision et d’optimiser l’organisation de ses services. Ces objectifs se déclinent avec la mise en place d’outils informatiques adaptés au quotidien des services et le nécessaire retour auprès de la collectivité, des informations (données) produites et gérées par ses prestataires. 

L’ARC privilégie donc une organisation dans laquelle l’Interface Homme Machine (IHM) du métier assure l’alimentation d’un entrepôt de données territoriales. Cette stratégie « agile » permet de répondre au plus près des besoins des services dans une trajectoire soutenable assurant à la fois une bonne maitrise des flux d’information et un temps d’acculturation au sein de l’organisation.

## Voir aussi

- [GitHub du Validateur de fichier au format d'échange "Base Adresse Locale"](https://github.com/etalab/bal)
- [Validateur en ligne du format BAL](https://adresse.data.gouv.fr/bases-locales/validateur)
- [Ressources nationales (dont spécification du format d'échange BAL version 1.2)](https://aitf-sig-topo.github.io/voies-adresses/)


## Jeu de données consolidé

Vous pouvez retrouver un jeu de données à l'échelle du Pays Compiégnois au standard BAL 1.1 sur le catalogue GéoCompiégnois en cliquant [ici](https://geo.compiegnois.fr/geonetwork/srv/fre/catalog.search#/metadata/e6397bad-6f3d-4999-9280-307c32b8d969).



![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Paramétrage de l'API BALC pour FME #

## Principe

L'alimentation de la BaseAdresseLocale évolue et permet à présent de téléverser les fichiers communaux au format BAL via une API. L'Agglomération de la Région de Compiègne, signataire de la [charte "Base Adresse Locale"](https://geo.compiegnois.fr/portail/index.php/2021/05/30/adresse-le-compiegnois-sur-la-bonne-voie/), diffuse quotidiennement les informations certifiées des communes du Pays Compiégnois. 

Le service SIG qui utilise déjà l'ETL FME de la société "Safe Software" pour l'ensemble de ces traitements, a paramétré un projet pour utiliser cette API.

## Changelog

 * 20/09/2021 : Version 0.1 - téléversement d'un fichier commune au format BAL 1.2 dans la BaseAdresseLocale via l'API

## Paramétrage

Cette première version est une version béta permettant le téléversement d'un seul fichier BAL commune à la fois. Il sera amélioré pour automatiser un versement de lots de communes. La version de FME utilisée est la 2021.1.1.0.

Les paramètres passés dans le traitement sont tous issus de la [documentation de l'API BALC de la BaseAdresseNationale](https://github.com/etalab/ban-api-depot/wiki/Documentation).

#### A - Création de paramètres publiés

Certains valeurs peuvent être paramétrées au lancement du traitement FME pour faciliter le processus de téléversement. Vous devez créer 3 paramètres publiés :
 - Commune : cet attribut contiendra le code Insee de la commune à téléverser
 - Taille : cet attribut contiendra la taille du fichier à téléverser en octet (une amélioration sera apportée au projet pour automatiser la récupération de la taille du fichier)
 - Jeton : cet attribut contiendra votre clé jeton fournit par la BAL

#### B - Création de la chaîne de traitement

 **1 : Initié un `Creator`** qui permettra le lancement du traitement
 
 ![creator](img/creator.png)
 
 
 **2 : Paramétrer un HttpCaller** pour lancer la 1er requête nommée `REVISION`
 
 ![creator](img/httpcaller.png)
 
 ![creator](img/httpcaller_para.png)
 
 Paramètres à indiquer dans ce transformer :
 
![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) https://plateforme.adresse.data.gouv.fr/api-depot-demo/communes/$(Commune)/revisions

L'attribut `$(Commune)` correspond au paramètre publié Commune contenant le code Insee de celle-ci.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **POST**

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) Nom **Authorization:** et Valeur **Token $(Jeton)**

L'attribut `$(Jeton)` correspond au paramètre publié Jeton contenant la clé fournie par la BAL (ici nous saisirons donc la clé de démonstration dans un premier temps).
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_4.png) **Specify Upload Body**
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_5.png) (ouvrir l'éditeur de texte et copier le code ci-dessous)
 
 `{
  "context": {
    "nomComplet": "[votre nom]",
    "organisation": "[organisme]", 
    "extras": {
      "internal_id": ""
    }
  }
}`

 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_6.png) **JSON (application/json)**
 
 Laisser les autres paramètres par défaut. L'attribut de réponse `_response_body` sera utilisé dans la suite du traitement et correspond au code de retour de l'API.
 
  **3 : Récupération de l'attribut `_ID` dans la requête de réponse de `REVISION`** pour lancer la 2nd requête nommée `TELEVERSEMENT`
  
  

## Voir aussi

- Téléchargement du projet FME (vierge) (à venir)

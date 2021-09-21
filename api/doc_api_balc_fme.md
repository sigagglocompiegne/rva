![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Paramétrage de l'API BAL pour FME #

## Principe

L'alimentation de la BaseAdresseLocale évolue et permet à présent de téléverser les fichiers communaux au format BAL via une API. L'Agglomération de la Région de Compiègne, signataire de la [charte "Base Adresse Locale"](https://geo.compiegnois.fr/portail/index.php/2021/05/30/adresse-le-compiegnois-sur-la-bonne-voie/), diffuse quotidiennement les informations certifiées des communes du Pays Compiégnois. 

Le service SIG qui utilise déjà l'ETL FME de la société "Safe Software" pour l'ensemble de ces traitements, a paramétré un projet pour utiliser cette API.

## Changelog

 * 20/09/2021 : Version 0.1 - téléversement d'un fichier commune au format BAL 1.2 dans la BaseAdresseLocale via l'API

## Paramétrage

Cette première version est une version béta permettant le téléversement d'un seul fichier BAL commune à la fois. Il sera amélioré pour automatiser un versement de lots de communes. La version de FME utilisée est la 2021.1.1.0.

Les paramètres passés dans le traitement sont tous issus de la [documentation de l'API BAL de la BaseAdresseNationale](https://github.com/etalab/ban-api-depot/wiki/Documentation).

### A - Création de paramètres publiés

Certains valeurs peuvent être paramétrées au lancement du traitement FME pour faciliter le processus de téléversement. Vous devez créer 3 paramètres publiés :
 - Commune : cet attribut contiendra le code Insee de la commune à téléverser
 - Taille : cet attribut contiendra la taille du fichier à téléverser en octet (une amélioration sera apportée au projet pour automatiser la récupération de la taille du fichier)
 - Jeton : cet attribut contiendra votre clé jeton fournit par la BAL

### B - Création de la chaîne de traitement

#### 1 - Initié un `Creator` qui permettra le lancement du traitement
 
 ![creator](img/creator.png)
 
 
#### 2 - Paramétrer un HttpCaller pour lancer la 1er requête nommée `REVISION`
 
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
 
#### 3 - Récupération de l'attribut `_ID` dans la requête de réponse de `REVISION` pour lancer la 2nd requête nommée `TELEVERSEMENT`
  
La réponse de l'API s'effectue au format JSON, il faut donc récupérer les différents attributs utiles pour la suite du traitement et notamment l'`_ID`.

 - Extraction des attributs JSON avec le transformer `JSONFragmenter`

 ![creator](img/jsonfragmenter.png)
 
  Paramètres à indiquer dans ce transformer :
 
 ![creator](img/jsonfragmenter_para.png)
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) **Attribut JSON**
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **_response_body**
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) **json[*]**
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_4.png) **JSON**
 
  - Conserver uniquement l'attribut `_ID` avec un simple transformer `Tester`

 ![creator](img/tester_televerse.png)
 
 L'attribut `json_index` liste l'ensemble des attributs de la requête de réponse. Il suffit de filter avec le nom `_id` pour récupérer en sortie uniquement la valeur de celui-ci dans l'attribut `_response_body`.

#### 4 - Paramétrer un HttpCaller pour lancer la 2nd requête nommée `TELEVERSEMENT`
 
![creator](img/httpcaller_2_para.png)
 
 Paramètres à indiquer dans ce transformer :
 
![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) https://plateforme.adresse.data.gouv.fr/api-depot-demo/revisions/@Value(_response_body)/files/bal

L'attribut `@Value(_response_body)` contient la valeur de l'ID récupérée précédemment et à passer dans cette requête.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **PUT**

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) Nom **Content-Length:** et Valeur **($Taille)** + Nom **Content-MD5:** et Valeur  **1234567890abcdedf1234567890abcdedf**

L'attribut `$(Taille)` correspond au paramètre publié Taille contenant la taille du fichier téléversé en octet.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_4.png) Nom **Authorization:** et Valeur **Token $(Jeton)**

L'attribut `$(Jeton)` correspond au paramètre publié Jeton contenant la clé fournie par la BAL (ici nous saisirons donc la clé de démonstration dans un premier temps).
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_5.png) **Envoyer à partir d'un fichier**
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_6.png) (indiquer le chemin de votre fichier BAL au format csv). Dans le chemin d'accès au fichier vous pouvez intégrer la paramètre publié ($Commune) si vos fichiers contiennent le code insee (ex: `c:\temp\$(Commune)_bal.csv`)


 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_6.png) **text/csv**
 
 Laisser les autres paramètres par défaut. L'attribut de réponse `_response_body` sera utilisé dans la suite du traitement et correspond au code de retour de l'API.

#### 5 - Récupération de l'attribut `revisionId` dans la requête de réponse de `TELEVERSEMENT` pour lancer la 3ème requête nommée `VALIDATION`
  
La réponse de l'API s'effectue au format JSON, il faut donc récupérer les différents attributs utiles pour la suite du traitement et notamment `revisionId`.

 - Extraction des attributs JSON avec le transformer `JSONFragmenter`

Reprendre la méthode indiquée au point **3**.
 
  - Conserver uniquement l'attribut `revisionId` avec un simple transformer `Tester`
 
Reprendre la méthode indiquée au point **3**.

 L'attribut `json_index` liste l'ensemble des attributs de la requête de réponse. Il suffit de filter avec le nom `revisionId` pour récupérer en sortie uniquement la valeur de celui-ci dans l'attribut `_response_body`.

#### 6 - Paramétrer un HttpCaller pour lancer la 3ème requête nommée `VALIDATION`
 
![creator](img/httpcaller_3_para.png)
 
 Paramètres à indiquer dans ce transformer :
 
![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) https://plateforme.adresse.data.gouv.fr/api-depot-demo/revisions/@Value(_response_body)/compute

L'attribut `@Value(_response_body)` contient la valeur de l'ID récupérée précédemment et à passer dans cette requête.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **POST**

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) Nom **Authorization:** et Valeur **Token $(Jeton)**

L'attribut `$(Jeton)` correspond au paramètre publié Jeton contenant la clé fournie par la BAL (ici nous saisirons donc la clé de démonstration dans un premier temps).
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_4.png) Les paramètres de la précédente requête peuvent être gardée par défaut (pas d'incidence sur la requête)
 
Laisser les autres paramètres par défaut. L'attribut de réponse `_response_body` sera utilisé dans la suite du traitement et correspond au code de retour de l'API.

#### 7 - Récupération de l'attribut `_id` dans la requête de réponse de `VALIDATION` pour lancer la 4ème requête nommée `PUBLICATION`
  
La réponse de l'API s'effectue au format JSON, il faut donc récupérer les différents attributs utiles pour la suite du traitement et notamment l'`_id`.

 - Extraction des attributs JSON avec le transformer `JSONFragmenter`

Reprendre la méthode indiquée au point **3**.
 
  - Conserver uniquement l'attribut `revisionId` avec un simple transformer `Tester`
 
Reprendre la méthode indiquée au point **3**.

 L'attribut `json_index` liste l'ensemble des attributs de la requête de réponse. Il suffit de filter avec le nom `_id` pour récupérer en sortie uniquement la valeur de celui-ci dans l'attribut `_response_body`.

#### 7 - Paramétrer un HttpCaller pour lancer la 4ème requête nommée `PUBLICATION`
 
![creator](img/httpcaller_3_para.png)
 
 Paramètres à indiquer dans ce transformer :
 
![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) https://plateforme.adresse.data.gouv.fr/api-depot-demo/revisions/@Value(_response_body)/publish

L'attribut `@Value(_response_body)` contient la valeur de l'ID récupérée précédemment et à passer dans cette requête.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **POST**

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) Nom **Authorization:** et Valeur **Token $(Jeton)**

L'attribut `$(Jeton)` correspond au paramètre publié Jeton contenant la clé fournie par la BAL (ici nous saisirons donc la clé de démonstration dans un premier temps).
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_4.png) Les paramètres de la précédente requête peuvent être gardée par défaut (pas d'incidence sur la requête)
 
Laisser les autres paramètres par défaut. L'attribut de réponse `_response_body` sera utilisé dans la suite du traitement et correspond au code de retour de l'API.

#### 8 - Lancement du traitement

Pour lancer le traitement, cliquer sur

 ![creator](img/fme_execut.png)
 
et dans la boîte de dialogue saisir les paramètres publiés nécessaires au traitement

 ![creator](img/fme_execut_variable_apibal.png)

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) Code Insee de la commune à téléverser

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) Taille du fichier en octet

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) Votre clé jeton

#### 9 - Les résultats obtenus

Il est possible de lire les réponses renvoyées par l'API après chaque `HttpCaller` en cliquant sur ![creator](img/fme_result.png) après la fin du traitement. Cela peut-être utile si la requête est rejetée via le port de sortie `Rejected`.

Exemple des résultats après chaque requête non rejetée :

`REVISION` : 

`{"_id":"614992bfe1d1f2602d7acf37","codeCommune":"60032","context":{"nomComplet":"Service SIG","organisation":"Agglomération de la Région de Compiègne","extras":{"internal_id":""}},"validation":{"valid":true,"errors":[]},"client":{"nom":"Compiègne"},"status":"published","ready":null,"createdAt":"2021-09-21T08:07:27.919Z","updatedAt":"2021-09-21T08:07:28.738Z","publishedAt":"2021-09-21T08:07:28.738Z","current":true}`

`TELEVERSEMENT` : 

`{"_id":"614992c0e1d1f2602d7acf38","revisionId":"614992bfe1d1f2602d7acf37","name":null,"type":"bal","size":54851,"hash":"398708668d44bcfb7d94f7ee74e0f9d0dfe0e6d25a921e01b21f394e20b84a81","createdAt":"2021-09-21T08:07:28.179Z"}`

`VALIDATION` : 

`{"_id":"614992bfe1d1f2602d7acf37","codeCommune":"60032","context":{"nomComplet":"Service SIG","organisation":"Agglomération de la Région de Compiègne","extras":{"internal_id":""}},"validation":{"valid":true,"errors":[]},"client":{"nom":"Compiègne"},"status":"pending","ready":true,"createdAt":"2021-09-21T08:07:27.919Z","updatedAt":"2021-09-21T08:07:28.484Z","publishedAt":null}`


`PUBLICATION` : 

`{"_id":"614992bfe1d1f2602d7acf37","codeCommune":"60032","context":{"nomComplet":"Service SIG","organisation":"Agglomération de la Région de Compiègne","extras":{"internal_id":""}},"validation":{"valid":true,"errors":[]},"client":{"nom":"Compiègne"},"status":"published","ready":null,"createdAt":"2021-09-21T08:07:27.919Z","updatedAt":"2021-09-21T08:07:28.738Z","publishedAt":"2021-09-21T08:07:28.738Z","current":true}`

#### 10 - Récupération des informations de la BAL

la [documentation de l'API BAL de la BaseAdresseNationale](https://github.com/etalab/ban-api-depot/wiki/Documentation) indique qu'il est possible d'interroger la BAL en mode libre par des requêtes `GET`.

Sur le même principe que les requêtes de téléversement, il est possible d'utiliser le transformer `HttpCaller` pour cela.

![creator](img/httpcaller_get.png) 

## Voir aussi

- Téléchargement du projet FME (vierge) (à venir)

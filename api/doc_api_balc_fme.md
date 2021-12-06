![picto](https://github.com/sigagglocompiegne/orga_gest_igeo/blob/master/doc/img/geocompiegnois_2020_reduit_v2.png)

# Paramétrage de l'API BAL pour FME #

## Principe

L'alimentation de la BaseAdresseLocale évolue et permet à présent de téléverser les fichiers communaux au format BAL via une API. L'Agglomération de la Région de Compiègne, signataire de la [charte "Base Adresse Locale"](https://geo.compiegnois.fr/portail/index.php/2021/05/30/adresse-le-compiegnois-sur-la-bonne-voie/), diffuse quotidiennement les informations certifiées de ces communes ainsi que celles de deux autres EPCI également signataires de la charte, à savoir la Communauté de Communes de la Plaine d'Estrées et la Communauté de Communes des Lisières de l'Oise. 

Le service SIG qui utilise déjà l'ETL FME de la société "Safe Software" pour l'ensemble de ces traitements, a paramétré un projet pour utiliser cette API.

Contact : sig@agglo-compiegne.fr

## Changelog

 * --/12/2021 : Version 1.2 (en cours de dévelopement)  - téléversement d'un lot de données communal au format BAL 1.3 dans l'API de dépôt BAL avec vérification d'une BAL existante et vérification des mises à jour
 * 06/12/2021 : Version 1.1 - téléversement d'un lot de données communal au format BAL 1.3 dans l'API de dépôt BAL avec vérification des mises à jour
 * 21/09/2021 : Version 1 - téléversement d'un fichier ou d'un lot de données communal au format BAL 1.2 dans l'API de démo BAL
 
## Gabarit

- [Téléchargement du projet FME version 1.1 - traitement par lot](https://geo.compiegnois.fr/documents/metiers/rva/API_BAL_LOT_FME_v11_github.zip)

## Paramétrage

Cette version 1.1 est une version permettant le téléversement en masse de x communes avec une vérification des dates de mises à jour dans l'API de dépôt de la BAL. La version de FME utilisée est la 2021.1.1.0.

Les paramètres passés dans le traitement sont tous issus de la [documentation de l'API BAL de la BaseAdresseNationale](https://github.com/etalab/ban-api-depot/wiki/Documentation).

#### 1 - Création du fichier de configuration

Afin de téléverser un lot de communes dans l'API BAL, nous avons choisi de créer un fichier Excel contenant la liste des communes à téléverser. Ce fichier est à intégrer comme une donnée source au début du traitement. Ce fichier peut contenir une ou plusieurs communes.

Exemple de structuration du fichier Excel de configuration :

|insee|commune|jeton|epci|
|:---|:---|:---|:---|
|60159|Compiègne|[jeton fournit par la BAL]|ARC|
|60325|Jaux|[jeton fournit par la BAL]|ARC|

**ATTENTION** : si vous utilisez une autre clé pour la référence de vos communes comme le code SIREN, qui est également référencé dans vos fichiers BAL de commune, vous devez remplacer l'attribut insee par siren dans le fichier de conf. Ce remplacement devra être réalisé également dans les paramètres du traitement ci-dessous. Un attribut EPCI a été ajouté uniquement pour la gestion du fichier Excel dans le cas d'un traitement multiple d'EPCI. Cet attribut permet de trier les communes pour y copier les jetons plus facilement.


### 2 - Création de la chaîne de traitement

#### 2.1 - Insérer le fichier de conf comme `Données sources`

![creator](img/fme_donnees_sources.png)

Ensuite sélectionner le format Excel et indiquer le lieu de votre fichier.

![creator](img/fme_fichier_source_com.png)

Votre fichier de configuration est en début de chaîne.
 
#### 2.2 - Vérification d'une BAL existante (disponible pour la version 1.2 en cours de développement)

Ce contrôle permet de vérifier l'existance d'une BAL publiée par un autre organisme. En cas de retour positif de l'API de dépôt, la ou les communes en question sortent du traitement pour ne pas être téléversées. En effet, le fonctionnement de l'API suprimerait la BAL publiée par un autre organisme. Si le cas se présente, une investigation devra être réalisée pour déterminer l'origine de la publication par l'utilisateur.

#### 2.3 - Vérification d'une mise à jour d'adresse

**Pour un versement initial via l'API de dépôt, vous devez désactiver ce traitement et relier directement le point 2.1 au point 2.4 dans le Workflow. Une fois cette initialisation réalisée, vous pouvez réactiver ce traitement.**

Ce contrôle permet de sélectionner uniquement les communes dont au moins une adresse a été modifiée ou ajoutée pour être téléversées dans l'API de dépôt. Le fonctionnement de l'API de dépôt créant une historisation à chaque versionnement, ce filtre évite de surcharger la base nationale en données non modifiées.

![creator](img/fme_verif_maj.png)

Le transformers `DatabaseJoiner` est utilisé pour récupérer les données existantes (au format BAL) dans une base de données, avant d'être comparée à la date du jour. Il doit être paramétré en fonction de l'infrastructure de données de l'utilisateur. 
 
#### 2.4 - Paramétrer un HttpCaller pour lancer la 1er requête nommée `REVISION`
 
 ![creator](img/httpcaller.png)
 
 ![creator](img/httpcaller_para.png)
 
 Paramètres à indiquer dans ce transformer :
 
![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) https://plateforme.adresse.data.gouv.fr/api-depot-demo/communes/@Value(insee)/revisions

L'attribut `@Value(insee)` correspond au code insee de la commune à téléverser et présent dans le fichier de conf.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **POST**

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) Nom **Authorization:** et Valeur **Token @Value(jeton)**

L'attribut `@Value(jeton)` correspond au jeton contenant la clé fournie par la BAL et indiqué dans le fichier de conf pour chaque commune (ici nous saisirons donc la clé de démonstration dans un premier temps).
 
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
 
#### 2.5 - Récupération de l'attribut `_ID` dans la requête de réponse de `REVISION` pour lancer la 2nd requête nommée `TELEVERSEMENT`
  
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

#### 2.6 - Paramétrer un HttpCaller pour lancer la 2nd requête nommée `TELEVERSEMENT`
 
![creator](img/httpcaller_2_para.png)
 
 Paramètres à indiquer dans ce transformer :
 
![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) https://plateforme.adresse.data.gouv.fr/api-depot-demo/revisions/@Value(_response_body)/files/bal

L'attribut `@Value(_response_body)` contient la valeur de l'ID récupérée précédemment et à passer dans cette requête.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **PUT**

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) Nom **Content-MD5:** et Valeur  **1234567890abcdedf1234567890abcdedf**

L'attribut de la taille en octet du fichier n'a pas été intégré dans ce traitement (optionnel dans l'API).

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_4.png) Nom **Authorization:** et Valeur **Token @Value(jeton)**

L'attribut `@Value(jeton)` correspond au jeton contenant la clé fournie par la BAL et indiqué dans le fichier de conf pour chaque commune (ici nous saisirons donc la clé de démonstration dans un premier temps).
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_5.png) **Envoyer à partir d'un fichier**
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_6.png) (indiquer le chemin de votre fichier BAL au format csv). Dans le chemin d'accès au fichier intégrer le code insee présent dans le fichier de conf `@Value(insee)` car vos fichiers doivent contenir ce code (ex: `c:\temp\@Value(insee)_bal.csv`)

 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_6.png) **text/csv**
 
 Laisser les autres paramètres par défaut. L'attribut de réponse `_response_body` sera utilisé dans la suite du traitement et correspond au code de retour de l'API.

#### 2.7 - Récupération de l'attribut `revisionId` dans la requête de réponse de `TELEVERSEMENT` pour lancer la 3ème requête nommée `VALIDATION`
  
La réponse de l'API s'effectue au format JSON, il faut donc récupérer les différents attributs utiles pour la suite du traitement et notamment `revisionId`.

 - Extraction des attributs JSON avec le transformer `JSONFragmenter`

Reprendre la méthode indiquée au point **3**.
 
  - Conserver uniquement l'attribut `revisionId` avec un simple transformer `Tester`
 
Reprendre la méthode indiquée au point **3**.

 L'attribut `json_index` liste l'ensemble des attributs de la requête de réponse. Il suffit de filter avec le nom `revisionId` pour récupérer en sortie uniquement la valeur de celui-ci dans l'attribut `_response_body`.

#### 2.8 - Paramétrer un HttpCaller pour lancer la 3ème requête nommée `VALIDATION`
 
![creator](img/httpcaller_3_para.png)
 
 Paramètres à indiquer dans ce transformer :
 
![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) https://plateforme.adresse.data.gouv.fr/api-depot-demo/revisions/@Value(_response_body)/compute

L'attribut `@Value(_response_body)` contient la valeur de l'ID récupérée précédemment et à passer dans cette requête.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **POST**

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) Nom **Authorization:** et Valeur **Token @Value(jeton)**

L'attribut `@Value(jeton)` correspond au jeton contenant la clé fournie par la BAL et indiqué dans le fichier de conf pour chaque commune (ici nous saisirons donc la clé de démonstration dans un premier temps).
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_4.png) Les paramètres de la précédente requête peuvent être gardée par défaut (pas d'incidence sur la requête)
 
Laisser les autres paramètres par défaut. L'attribut de réponse `_response_body` sera utilisé dans la suite du traitement et correspond au code de retour de l'API.

#### 2.9 - Récupération de l'attribut `_id` dans la requête de réponse de `VALIDATION` pour lancer la 4ème requête nommée `PUBLICATION`
  
La réponse de l'API s'effectue au format JSON, il faut donc récupérer les différents attributs utiles pour la suite du traitement et notamment l'`_id`.

 - Extraction des attributs JSON avec le transformer `JSONFragmenter`

Reprendre la méthode indiquée au point **3**.
 
  - Conserver uniquement l'attribut `revisionId` avec un simple transformer `Tester`
 
Reprendre la méthode indiquée au point **3**.

 L'attribut `json_index` liste l'ensemble des attributs de la requête de réponse. Il suffit de filter avec le nom `_id` pour récupérer en sortie uniquement la valeur de celui-ci dans l'attribut `_response_body`.

#### 2.10 - Paramétrer un HttpCaller pour lancer la 4ème requête nommée `PUBLICATION`
 
![creator](img/httpcaller_3_para.png)
 
 Paramètres à indiquer dans ce transformer :
 
![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) https://plateforme.adresse.data.gouv.fr/api-depot-demo/revisions/@Value(_response_body)/publish

L'attribut `@Value(_response_body)` contient la valeur de l'ID récupérée précédemment et à passer dans cette requête.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **POST**

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_3.png) Nom **Authorization:** et Valeur **Token @Value(jeton)**

L'attribut `@Value(jeton)` correspond au jeton contenant la clé fournie par la BAL et indiqué dans le fichier de conf pour chaque commune (ici nous saisirons donc la clé de démonstration dans un premier temps).
 
 ![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_4.png) Les paramètres de la précédente requête peuvent être gardée par défaut (pas d'incidence sur la requête)
 
Laisser les autres paramètres par défaut. L'attribut de réponse `_response_body` sera utilisé dans la suite du traitement et correspond au code de retour de l'API.

#### 2.11 - Lancement du traitement

Pour lancer le traitement, cliquer sur

 ![creator](img/fme_execut.png)
 

## B - Exploitation

#### 1 - Les résultats obtenus

Il est possible de lire les réponses renvoyées par l'API après chaque `HttpCaller` en cliquant sur ![creator](img/fme_result.png) après la fin du traitement. Cela peut-être utile si la requête est rejetée via le port de sortie `Rejected`.

#### 2 - Récupération des informations de la BAL

La [documentation de l'API BAL de la BaseAdresseNationale](https://github.com/etalab/ban-api-depot/wiki/Documentation) indique qu'il est possible d'interroger la BAL en mode libre par des requêtes `GET`.

Sur le même principe que les requêtes de téléversement, il est possible d'utiliser le transformer `HttpCaller` pour cela. Ce transformer peut-être insérer à la suite de la requête `PUBLICATION`.

![creator](img/httpcaller_get2.png) 

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_1.png) https://plateforme.adresse.data.gouv.fr/api-depot-demo/communes/@Value(insee)/revisions

Cette requête renvoie toutes les révisions. Pour récupérer la version courante utilisez cette requête `https://plateforme.adresse.data.gouv.fr/api-depot/communes/@Value(insee)/current-revision`.

L'attribut `@Value(insee)` correspond au code insee de la commune téléversée.

![picto](https://github.com/sigagglocompiegne/orga_proc_igeo/blob/main/img/tuto_2.png) **GET**

En cliquant sur ![creator](img/fme_result.png), après la fin du traitement, vous pouvez consulter le retour de l'API. Ce retour contient toutes les révisions effectuées sur la commune interrogée.



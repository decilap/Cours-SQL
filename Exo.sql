
-- I- Requêtage simple : 

-- I.1- Requêtage simple

-- Afficher les 10 premiers éléments de la table Produit triés par leur prix unitaire
SELECT * 
FROM foody.produit 
ORDER BY PrixUnit 
DESC LIMIT 10;

-- Afficher les trois produits les plus chers
SELECT * 
FROM foody.produit 
ORDER BY PrixUnit 
DESC LIMIT 3

-- I.2- Restriction

-- Lister les clients français installés à Paris dont le numéro de fax n'est pas renseigné
SELECT * 
FROM foody.client 
WHERE Fax IS NULL
AND Ville = "Paris";

-- 2.Lister les clients français, allemands et canadiens
SELECT * 
FROM foody.Client
WHERE Pays 
IN ("France", "Canada", "Germany");


-- 3.Lister les clients dont le nom de société contient "restaurant
SELECT * 
FROM foody.client 
WHERE Societe 
LIKE '%restaurant%';



-- I.3- Projection

-- Lister les descriptions des catégories de produits (table Categorie)
SELECT DISTINCT Description, NomCateg 
FROM foody.Categorie;

-- 2. Lister les différents pays et villes des clients, le tout trié par ordre alphabétique croissant du pays et décroissant de la ville
SELECT DISTINCT Pays, Ville 
FROM foody.Client 
ORDER BY Pays Desc, Ville;

-- 3. Lister les fournisseurs français, en affichant uniquement le nom, le contact et la ville, triés par ville
SELECT Societe, Contact, Ville 
FROM foody.Fournisseur 
ORDER BY Ville DESC 
WHERE Pays = "France";

-- 4. Lister les produits (nom en majuscule et référence) du fournisseur n° 8 dont le prix unitaire est entre 10 et 100 euros, en renommant les attributs pour que ça soit explicite
SELECT RefProd, upper(NomProd) 
FROM foody.Produit p 
WHERE p.NoFour = 8 
AND p.PrixUnit BETWEEN 10 AND 100;

-- II- Calculs et Fonctions :

-- II.1 - Calculs arithmétiques

-- La table DetailsCommande contient l'ensemble des lignes d'achat de chaque commande. 
-- Calculer, pour la commande numéro 10251, pour chaque produit acheté dans celle-ci, 
-- Le montant de la ligne d'achat en incluant la remise (stockée en proportion dans la table). 
-- Afficher donc (dans une même requête) :

SELECT dc.PrixUnit, Remise, Qte, 
(dc.PrixUnit - (dc.PrixUnit * dc.Remise)) * dc.Qte MPayer,
(dc.PrixUnit * dc.Remise) MRemise  
FROM foody.DetailsCommande dc 
WHERE dc.NoCom = 10251

-- II.2- Traitement conditionnel

-- 1. A partir de la table Produit, afficher "Produit non disponible" lorsque l'attribut Indisponible vaut 1, et "Produit disponible" sinon.

SELECT *,
CASE WHEN Indisponible = 1 THEN 'Produit non disponible'
	 ELSE 'Produit disponible' END AS Status
FROM foody.Produit 

-- II.3- Fonctions sur chaînes de caractères

-- Dans une même requête, sur la table Client :
-- * Concaténer les champs Adresse, Ville, CodePostal et Pays dans un nouveau
-- champ nommé Adresse_complète, pour avoir : Adresse, CodePostal, Ville, Pays * Extraire les deux derniers caractères des codes clients
-- * Mettre en minuscule le nom des sociétés
-- * Remplacer le terme "Owner" par "Freelance" dans Fonction
-- * Indiquer la présence du terme "Manager" dans Fonction

SELECT 
concat(Adresse, Ville, CodePostal, Pays), 
substr(Codecli, -2) Codcli,
upper(Societe),
REPLACE(Fonction, 'Owner', 'Freelance') Fonction
FROM foody.Client
WHERE Fonction Like '%Manager%'


-- II.4- Fonctions sur les dates 

-- Afficher le jour de la semaine en lettre pour toutes les dates de commande, afficher "week-end" pour les samedi et dimanche,
SELECT *, 
IF(WEEKDAY(DateCom) < 5, DATE_FORMAT(DateCom, "%W≠"), 'weekend') DateCom
FROM foody.Commande


-- Calculer le nombre de jours entre la date de la commande (DateCom) et la date butoir de livraison (ALivAvant), 
-- Pour chaque commande, On souhaite aussi contacter les clients 1 mois après leur commande. 
-- Ajouter la date correspondante pour chaque commande
SELECT 
	DateCom,
 	DATEDIFF(c.ALivAvant, c.DateCom) NbrDay,
 	DATE_ADD(c.DateCom, INTERVAL 1 MONTH) DateContact
FROM foody.Commande c


-- III- Aggrégats 

-- III.1- Dénombrements

-- 1.Calculer le nombre d'employés qui sont "Sales Manager"
SELECT COUNT(*) NbrManager
FROM foody.Employe
WHERE Fonction = "Sales Manager"

-- 2.Calculer le nombre de produits de catégorie 1, des fournisseurs 1 et 18 
SELECT COUNT(*) NbrProduitCat
FROM foody.Produit
WHERE CodeCateg = 1 AND NoFour IN(1, 18)


-- 3.Calculer le nombre de pays différents de livraison
SELECT COUNT(DISTINCT PaysLiv) NbrPays 
FROM foody.Commande

-- 4.Calculer le nombre de commandes réalisées le en Aout 2006.
SELECT  COUNT(*) Nbr 
FROM foody.Commande
WHERE date_format(DateCom, '%M %Y') = "August 2006"


-- III.2- Calculs statistiques simples

-- Calculer le coût du port minimum et maximum des commandes , 
-- ainsi que le coût moyen du port pour les commandes du client dont le code est "QUICK" (attribut CodeCli)
SELECT min(Port) PortMin, max(Port) PortMax, AVG(Port) Moyenne 
FROM foody.Commande 
WHERE CodeCli = "QUICK"

-- 2.Pour chaque messager (par leur numéro : 1, 2 et 3), donner le montant total des frais de port leur correspondant
SELECT c.NoMess, SUM(c.Port) "Fras de port"
FROM foody.Commande c
GROUP BY c.NoMess

-- III.3- Agrégats selon attribut(s)

-- 1.Donner le nombre d'employés par fonction
SELECT e.Fonction, COUNT(e.Fonction) "Nombre employés"
FROM foody.Employe e
GROUP BY e.Fonction

-- 2.Donner le nombre de catégories de produits fournis par chaque fournisseur 3.Donner le prix moyen des produits pour chaque fournisseur et chaque catégorie de produits fournis par celui-ci
SELECT p.NoFour, AVG(DISTINCT p.PrixUnit) "Prix Moyen"
FROM foody.Produit p 
GROUP BY p.NoFour, CodeCateg

-- 3.Donner le prix moyen des produits pour chaque fournisseur et chaque catégorie de produits fournis par celui-ci
SELECT p.NoFour, AVG(DISTINCT p.PrixUnit) "Prix Moyen"
FROM foody.Produit p 
GROUP BY p.NoFour


-- III.4- Restriction sur agrégats

-- 1.Lister les fournisseurs ne fournissant qu'un seul produit
SELECT NoFour, COUNT(RefProd) nbrProduct
FROM foody.Produit
GROUP BY NoFour
HAVING nbrProduct = 1

-- 2.Lister les fournisseurs ne fournissant qu'une seule catégorie de produits
SELECT NoFour, COUNT(DISTINCT CodeCateg) Nombre_cat
FROM foody.Produit
GROUP BY NoFour
HAVING Nombre_cat = 1

-- 3.Lister le Products le plus cher pour chaque fournisseur, pour les Products de plus de 50 euro
SELECT NoFour, PrixUnit, MAX(PrixUnit) 
FROM foody.Produit
GROUP BY NoFour, PrixUnit
HAVING MAX(PrixUnit) > 50


-- IV- Jointures :
-- IV.1- Jointures naturelles

-- 1.Récupérer les informations des fournisseurs pour chaque produit
SELECT *
FROM foody.Produit
NATURAL JOIN foody.Fournisseur

-- 2.Afficher les informations des commandes du client "Lazy K Kountry Store"
SELECT  *
FROM foody.Client
NATURAL JOIN foody.Commande
WHERE Societe = "Lazy K Kountry Store"

-- 3.Afficher le nombre de commande pour chaque messager (en indiquant son nom)
SELECT NomMess, COUNT(*) as "Nb Commandes"
FROM Messager 
NATURAL JOIN Commande
GROUP BY NomMess;



-- IV.2- Jointures internes

-- 1.Récupérer les informations des fournisseurs pour chaque produit, avec une jointure interne
SELECT * 
FROM foody.Produit p
INNER JOIN foody.Fournisseur f
ON f.NoFour = p.NoFour

-- 2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec une jointure interne
SELECT * 
FROM foody.Commande co
INNER JOIN foody.Client c
ON co.CodeCli = c.CodeCli
WHERE Societe = "Lazy K Kountry Store"

-- 3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec une jointure interne
SELECT NomMess, COUNT(*) nbrCommande
FROM foody.Commande co 
INNER JOIN foody.Messager m
ON co.NoMess = m.NoMess
GROUP BY m.NomMess;


-- IV.3- Jointures externes

-- 1.Compter pour chaque produit, le nombre de commandes où il apparaît, même pour ceux dans aucune commande
SELECT NomProd, COUNT(DISTINCT NoCom) nbrCommande
FROM foody.Produit p
LEFT OUTER JOIN foody.DetailsCommande dc
ON p.RefProd = dc.RefProd
GROUP BY NomProd;

-- 2.Lister les produits n'apparaissant dans aucune commande
SELECT NomProd, COUNT(DISTINCT NoCom) NoPresent
FROM foody.Produit p
LEFT OUTER JOIN foody.DetailsCommande dc
ON p.RefProd = dc.RefProd
GROUP BY NomProd
HAVING COUNT(DISTINCT NoCom) = 0;

-- 3.Existe-t'il un employé n'ayant enregistré aucune commande ?
SELECT Nom, Prenom
FROM foody.Employe e
LEFT OUTER JOIN Commande co
ON e.NoEmp = co.NoEmp
GROUP BY Nom, Prenom
HAVING COUNT(DISTINCT NoCom) = 0;




-- IV.4- Jointures à la main

-- 1.Récupérer les informations des fournisseurs pour chaque produit, avec jointure à la main
SELECT *
FROM foody.Produit p, foody.Fournisseur f
WHERE p.NoFour = f.NoFour;

-- 2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec jointure à la main
SELECT *
FROM foody.Commande co, foody.Client c
WHERE co.CodeCli = c.Codecli
AND Societe = "Lazy K Kountry Store";

-- 3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec jointure à la main
SELECT NomMess, COUNT(*) nbrCommande
FROM foody.Commande co, foody.Messager m
WHERE co.NoMess = m.NoMess
GROUP BY NomMess;

-- V- Sous-requêtes

-- V.1- Sous-requêtes

-- 1.Lister les employés n'ayant jamais effectué une commande, via une sous-requête
SELECT Nom, Prenom
FROM foody.Employe
WHERE NoEmp 
NOT IN (    
    SELECT NoEmp 
    FROM foody.Commande
);

-- 2.Nombre de produits proposés par la société fournisseur "Ma Maison", via une sous-requête
SELECT COUNT(*) nbrproduit
FROM foody.Produit p
WHERE NoFour = (
    SELECT NoFour
    FROM foody.Fournisseur
    WHERE Societe = "Ma Maison"
);

-- 3.Nombre de commandes passées par des employés sous la responsabilité de "Buchanan Steven"
SELECT COUNT(co.NoCom) AS NbCom
FROM foody.Commande co
WHERE co.NoEmp 
IN (
    SELECT e.NoEmp 
    FROM foody.Employe e
    WHERE e.RendCompteA 
        = (
            SELECT e.NoEmp 
            FROM foody.Employe e
            WHERE e.Nom = "Buchanan" 
            AND e.Prenom = "Steven"
        )
    )



-- V.2- Opérateur EXISTS

-- 1.Lister les produits n'ayant jamais été commandés, à l'aide de l'opérateur EXISTS 
SELECT NomProd
FROM foody.Produit p
WHERE NOT EXISTS (
	SELECT *
	FROM foody.DetailsCommande dc
	WHERE dc.RefProd = p.RefProd
);

-- 2.Lister les fournisseurs dont au moins un produit a été livré en France
SELECT Societe
FROM foody.Fournisseur f
WHERE EXISTS (
	SELECT * 
	FROM foody.Produit p, foody.DetailsCommande dc, foody.Commande co
	WHERE p.RefProd = dc.RefProd
	AND dc.NoCom = co.NoCom
	AND PaysLiv = "France"
	AND NoFour = f.NoFour
);

-- 3.Liste des fournisseurs qui ne proposent que des boissons (drinks)
SELECT f.Societe
FROM foody.Fournisseur f
WHERE EXISTS (
            SELECT * 
            FROM foody.Produit p, foody.Categorie c
            WHERE p.NoFour = f.NoFour 
            AND p.CodeCateg = c.CodeCateg 
            AND c.NomCateg = "drinks"
		);


-- VI- Opérations Ensemblistes

-- VI.1- Union

-- 1.Lister les employés (nom et prénom) étant "Representative" ou étant basé au Royaume-Uni (UK)
SELECT Nom, Prenom
FROM foody.Employe d
WHERE Fonction Like "%Representative%"
    UNION  
SELECT Nom, Prenom
FROM foody.Employe 
WHERE Pays = "UK";

-- 2.Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel) ou ayant été livré par "Speedy Express"
SELECT Societe, c.Pays
    FROM foody.Client c, foody.Commande co, foody.Employe e
    WHERE c.CodeCli = co.CodeCli
    AND co.NoEmp = e.NoEmp
    AND e.Ville = "London"
UNION
SELECT Societe, c.Pays
    FROM Client c, Commande co, Messager m
    WHERE c.CodeCli = co.CodeCli
    AND co.NoMess = m.NoMess
    AND NomMess = "Speedy Express";


-- VI.2- Intersection

-- INTERCEPT Nom pris en compte par mysql 

-- 1.Lister les employés (nom et prénom) étant "Representative" et étant basé au Royaume-Uni (UK)
-- 2.Lister les clients (société et pays) ayant commandés via un employé basé à "Seattle" et ayant commandé des "Desserts"


-- VI.3- Différence


-- EXCEPT Nom pris en compte par mysql 

-- 1.Lister les employés (nom et prénom) étant "Representative" mais n'étant pas basé au Royaume-Uni (UK)
-- 2.Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel) et n'ayant jamais été livré par "United Package"

DROP DATABASE IF EXISTS foody;
CREATE DATABASE IF NOT EXISTS foody;
CREATE TABLE foody.Client (
	Codecli VARCHAR(5) PRIMARY KEY,
    Societe VARCHAR(45) NOT NULL,
    Contact VARCHAR(45) NOT NULL,
    Fonction VARCHAR(45) NOT NULL,
    Adresse VARCHAR(45),
    Ville VARCHAR(25) ,
    Region VARCHAR(25),
    Codepostal VARCHAR(10),
    Pays VARCHAR(25) ,
    Tel VARCHAR(25) ,
    Fax VARCHAR(25)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE foody.Employe (
	NoEmp INT PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(50) NOT NULL,
    Prenom VARCHAR(50) NOT NULL,
    Fonction VARCHAR(50) ,
    TitreCourtoisie VARCHAR(50),
    DateNaissance DATETIME,
    DateEmbauche DATETIME ,
    Adresse VARCHAR(60),
    Ville VARCHAR(50),
    Region VARCHAR(50),
    Codepostal VARCHAR(50) ,
    Pays VARCHAR(50) ,
    TelDom VARCHAR(20) ,
    Extension VARCHAR(50),
    RendCompteA INT,
    CONSTRAINT fk_Employe FOREIGN KEY (RendCompteA) REFERENCES foody.Employe (NoEmp)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE foody.Messager (
	NoMess INT PRIMARY KEY AUTO_INCREMENT,
    NomMess VARCHAR(50) NOT NULL,
    Tel VARCHAR(20)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE foody.Categorie (
	CodeCateg INT PRIMARY KEY AUTO_INCREMENT,
    NomCateg VARCHAR(15) NOT NULL,
    Description VARCHAR(255)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE foody.Fournisseur (
	NoFour INT PRIMARY KEY AUTO_INCREMENT,
    Societe VARCHAR(45) NOT NULL,
    Contact VARCHAR(45) ,
    Fonction VARCHAR(45) ,
    Adresse VARCHAR(255) ,
    Ville VARCHAR(45),
    Region VARCHAR(45),
    CodePostal VARCHAR(10) ,
    Pays VARCHAR(45) ,
    Tel VARCHAR(20) ,
    Fax VARCHAR(20),
    PageAccueil MEDIUMTEXT
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE foody.Produit (
	RefProd INT PRIMARY KEY AUTO_INCREMENT,
    NomProd VARCHAR(50) NOT NULL,
    NoFour INT,
    CodeCateg INT,
    QteParUnit VARCHAR(20),
    PrixUnit DECIMAL(10,4) DEFAULT 0,
    UnitesStock SMALLINT DEFAULT 0,
    UnitesCom SMALLINT DEFAULT 0,
    NiveauReap SMALLINT DEFAULT 0,
    Indisponible BIT NOT NULL default 0,
    CONSTRAINT FK_FourProduit FOREIGN KEY (NoFour) REFERENCES Fournisseur(NoFour),
    CONSTRAINT FK_CategProduit FOREIGN KEY (CodeCateg) REFERENCES Categorie(CodeCateg)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE foody.Commande (
	NoCom INT PRIMARY KEY AUTO_INCREMENT,
    CodeCli VARCHAR(10) ,
    NoEmp INT,
    DateCom DATETIME,
    ALivAvant DATETIME,
    DateEnv DATETIME,
    NoMess INT,
    Port DECIMAL(10,4) DEFAULT 0,
    Destinataire VARCHAR(50),
    AdrLiv VARCHAR(50),
    VilleLiv VARCHAR(50),
    RegionLiv VARCHAR(50),
    CodePostalLiv VARCHAR(20),
    PaysLiv VARCHAR(25),
    CONSTRAINT FK_ClientCommande FOREIGN KEY (CodeCli) REFERENCES Client(CodeCli),
    CONSTRAINT FK_MessCommande FOREIGN KEY (NoMess) REFERENCES Messager(NoMess),
    CONSTRAINT FK_EmployeCommande FOREIGN KEY (NoEmp) REFERENCES Employe(NoEmp)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE foody.DetailsCommande (
	NoCom INT NOT NULL,
    RefProd INT NOT NULL,
    PrixUnit DECIMAL(10,4) NOT NULL DEFAULT 0,
    Qte INT NOT NULL DEFAULT 1,
    Remise Double NOT NULL DEFAULT 0,
    PRIMARY KEY (NoCom, RefProd),
    CONSTRAINT FK_CommandeDetailCom FOREIGN KEY (NoCom) REFERENCES Commande(NoCom),
    CONSTRAINT FK_ProduitDetailCom FOREIGN KEY (RefProd) REFERENCES Produit(RefProd)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

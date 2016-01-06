/* 
Versie: 1.0
SQL Script gemaakt door Jeroen Roovers voor
DBS12 Ontwikkelopdracht
*/
-- Tijdsformaat aanpassen
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY';

-- Clear Database
DROP TABLE WINKEL CASCADE CONSTRAINTS;
DROP TABLE PRIJS CASCADE CONSTRAINTS;
DROP TABLE PRODUCT CASCADE CONSTRAINTS;
DROP TABLE CATEGORIE CASCADE CONSTRAINTS;
DROP TABLE REVIEWPAGINA CASCADE CONSTRAINTS;
DROP TABLE REVIEW CASCADE CONSTRAINTS;
DROP TABLE NIEUWS CASCADE CONSTRAINTS;
DROP TABLE PRODUCT_CATEGORIE CASCADE CONSTRAINTS;
DROP TABLE NIEUWS_CATEGORIE CASCADE CONSTRAINTS;
DROP TABLE REVIEW_CATEGORIE CASCADE CONSTRAINTS;
DROP TABLE PRODUCT_REVIEW CASCADE CONSTRAINTS;
DROP TABLE REACTIE CASCADE CONSTRAINTS;
DROP TABLE REACTIETYPE CASCADE CONSTRAINTS;
DROP TABLE GEBRUIKERSREVIEW CASCADE CONSTRAINTS;
DROP TABLE USERACCOUNT CASCADE CONSTRAINTS;

DROP SEQUENCE seq_winkel;
DROP SEQUENCE seq_prijs;
DROP SEQUENCE seq_product;
DROP SEQUENCE seq_categorie;
DROP SEQUENCE seq_review;
DROP SEQUENCE seq_nieuws;
DROP SEQUENCE seq_reactie;
DROP SEQUENCE seq_reactietype;
DROP SEQUENCE seq_gebruikersreview;
DROP SEQUENCE seq_useraccount;

-- Create Tables
CREATE TABLE WINKEL
(
  WINKELID				NUMBER(9) NOT NULL,
  NAAM           		VARCHAR2(255) NOT NULL,
  WEBSITE				VARCHAR2(255) NOT NULL,
  CONTENT				CLOB,
  FOTO					VARCHAR2(255) DEFAULT 'C:/'
);

CREATE TABLE PRIJS
(
  PRIJSID				NUMBER(9) NOT NULL,
  PRODUCTID				NUMBER(9) NOT NULL,
  WINKELID				NUMBER(9) NOT NULL,
  PRIJS					NUMBER(6,2)
);

CREATE TABLE PRODUCT
(
  PRODUCTID				NUMBER(9) NOT NULL,
  NAAM           		VARCHAR2(255) NOT NULL,
  FOTO					VARCHAR2(255) DEFAULT 'C:/' ,
  CONTENT				CLOB
);

CREATE TABLE CATEGORIE
(
  CATEGORIEID			NUMBER(9) NOT NULL,
  NAAM					VARCHAR2(255) NOT NULL UNIQUE CHECK (NAAM = UPPER(NAAM))
);

CREATE TABLE REVIEW
(
  REVIEWID				NUMBER(9) NOT NULL,
  TITEL           		VARCHAR2(255) NOT NULL,
  DATUM					DATE NOT NULL
);

CREATE TABLE NIEUWS
(
  NIEUWSID				NUMBER(9) NOT NULL,
  TITEL           		VARCHAR2(255) NOT NULL,
  DATUM					DATE NOT NULL,
  CONTENT				CLOB
);

CREATE TABLE PRODUCT_CATEGORIE
(
  PRODUCTID				NUMBER(9) NOT NULL,
  CATEGORIEID           NUMBER(9) NOT NULL
);

CREATE TABLE REVIEW_CATEGORIE
(
  REVIEWID				NUMBER(9) NOT NULL,
  CATEGORIEID           NUMBER(9) NOT NULL
);

CREATE TABLE NIEUWS_CATEGORIE
(
  NIEUWSID				NUMBER(9) NOT NULL,
  CATEGORIEID           NUMBER(9) NOT NULL 
);

CREATE TABLE PRODUCT_REVIEW
(
  PRODUCTID				NUMBER(9) NOT NULL,
  REVIEWID				NUMBER(9) NOT NULL
);

CREATE TABLE REVIEWPAGINA
(
  REVIEWID				NUMBER(9) NOT NULL,
  PAGINANR				NUMBER(9) NOT NULL,
  SUBTITEL				VARCHAR(255) NOT NULL,
  CONTENT				CLOB
);

CREATE TABLE REACTIE
(
  REACTIEID				NUMBER(9) NOT NULL,
  AUTEUR           		NUMBER(9) NOT NULL,
  EXTERNID				NUMBER(9) NOT NULL,
  REACTIETYPEID			NUMBER(9) NOT NULL,
  DATUM					DATE NOT NULL,
  CONTENT				VARCHAR2(4000) NOT NULL
);

CREATE TABLE REACTIETYPE
(
  REACTIETYPEID			NUMBER(9) NOT NULL,
  OMSCHRIJVING          VARCHAR2(255) NOT NULL UNIQUE
);

CREATE TABLE GEBRUIKERSREVIEW
(
  GEBRUIKERSREVIEWID	NUMBER(9) NOT NULL,
  PRODUCTID           	NUMBER(9) NOT NULL,
  AUTEUR				NUMBER(9) NOT NULL,
  DATUM					DATE NOT NULL,
  SAMENVATTING			VARCHAR(1024) NOT NULL,
  CONTENT				CLOB,
  BEOORDELING			NUMBER(1) NOT NULL
);

CREATE TABLE USERACCOUNT
(
  USERACCOUNTID			NUMBER(9) NOT NULL,
  ACCOUNTNAAM           VARCHAR2(255) NOT NULL UNIQUE CHECK (LENGTH(ACCOUNTNAAM) > 3),
  WACHTWOORD			VARCHAR2(255) NOT NULL CHECK (LENGTH(WACHTWOORD) > 3),
  EMAIL					VARCHAR2(255) NOT NULL CHECK (EMAIL LIKE '%@%'),
  NAAM					VARCHAR(255),
  FOTO					VARCHAR(255) DEFAULT 'C:/',
  GEBOORTEDATUM			DATE
);
-- END CREATE TABLE

-- ALTER TABLES:
-- 		PRIMARY KEYS
ALTER TABLE WINKEL ADD PRIMARY KEY (WINKELID);
ALTER TABLE PRIJS ADD PRIMARY KEY (PRIJSID);
ALTER TABLE PRODUCT ADD PRIMARY KEY (PRODUCTID);
ALTER TABLE CATEGORIE ADD PRIMARY KEY (CATEGORIEID);
ALTER TABLE REVIEW ADD PRIMARY KEY (REVIEWID);
ALTER TABLE NIEUWS ADD PRIMARY KEY (NIEUWSID);
ALTER TABLE REVIEWPAGINA ADD PRIMARY KEY (REVIEWID, PAGINANR);
ALTER TABLE REACTIE ADD PRIMARY KEY (REACTIEID);
ALTER TABLE REACTIETYPE ADD PRIMARY KEY (REACTIETYPEID);
ALTER TABLE USERACCOUNT ADD PRIMARY KEY (USERACCOUNTID);
ALTER TABLE GEBRUIKERSREVIEW ADD PRIMARY KEY (GEBRUIKERSREVIEWID);
-- 		FOREIGN KEYS
ALTER TABLE PRIJS ADD FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT (PRODUCTID);
ALTER TABLE PRIJS ADD FOREIGN KEY (WINKELID) REFERENCES WINKEL (WINKELID);
ALTER TABLE PRODUCT_CATEGORIE ADD FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT (PRODUCTID);
ALTER TABLE PRODUCT_CATEGORIE ADD FOREIGN KEY (CATEGORIEID) REFERENCES CATEGORIE (CATEGORIEID);
ALTER TABLE PRODUCT_REVIEW ADD FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT (PRODUCTID);
ALTER TABLE PRODUCT_REVIEW ADD FOREIGN KEY (REVIEWID) REFERENCES REVIEW (REVIEWID);
ALTER TABLE REVIEW_CATEGORIE ADD FOREIGN KEY (REVIEWID) REFERENCES REVIEW (REVIEWID);
ALTER TABLE REVIEW_CATEGORIE ADD FOREIGN KEY (CATEGORIEID) REFERENCES CATEGORIE (CATEGORIEID);
ALTER TABLE NIEUWS_CATEGORIE ADD FOREIGN KEY (NIEUWSID) REFERENCES NIEUWS (NIEUWSID);
ALTER TABLE NIEUWS_CATEGORIE ADD FOREIGN KEY (CATEGORIEID) REFERENCES CATEGORIE (CATEGORIEID);
ALTER TABLE REVIEWPAGINA ADD FOREIGN KEY (REVIEWID) REFERENCES REVIEW (REVIEWID);
ALTER TABLE REACTIE ADD FOREIGN KEY (AUTEUR) REFERENCES USERACCOUNT (USERACCOUNTID);
ALTER TABLE REACTIE ADD FOREIGN KEY (REACTIETYPEID) REFERENCES REACTIETYPE (REACTIETYPEID);
ALTER TABLE GEBRUIKERSREVIEW ADD FOREIGN KEY (PRODUCTID) REFERENCES PRODUCT (PRODUCTID);
ALTER TABLE GEBRUIKERSREVIEW ADD FOREIGN KEY (AUTEUR) REFERENCES USERACCOUNT (USERACCOUNTID);
-- END ALTER TABLE

-- AUTONUMBER
CREATE SEQUENCE seq_winkel
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_winkel
	before insert on winkel
	for each row
	begin
	select seq_winkel.nextval into :new.winkelid from dual;
	end;
	/
	
	CREATE SEQUENCE seq_prijs
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_prijs
	before insert on prijs
	for each row
	begin
	select seq_prijs.nextval into :new.prijsid from dual;
	end;
	/
	
		CREATE SEQUENCE seq_product
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_product
	before insert on product
	for each row
	begin
	select seq_product.nextval into :new.productid from dual;
	end;
	/
	
		CREATE SEQUENCE seq_categorie
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_categorie
	before insert on categorie
	for each row
	begin
	select seq_categorie.nextval into :new.categorieid from dual;
	end;
	/
	
		CREATE SEQUENCE seq_review
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_review
	before insert on review
	for each row
	begin
	select seq_review.nextval into :new.reviewid from dual;
	end;
	/
	
			CREATE SEQUENCE seq_nieuws
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_nieuws
	before insert on nieuws
	for each row
	begin
	select seq_nieuws.nextval into :new.nieuwsid from dual;
	end;
	/
	
			CREATE SEQUENCE seq_reactie
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_reactie
	before insert on reactie
	for each row
	begin
	select seq_reactie.nextval into :new.reactieid from dual;
	end;
	/
	
			CREATE SEQUENCE seq_reactietype
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_reactietype
	before insert on reactietype
	for each row
	begin
	select seq_reactietype.nextval into :new.reactietypeid from dual;
	end;
	/
	
				CREATE SEQUENCE seq_gebruikersreview
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_gebruikersreview
	before insert on gebruikersreview
	for each row
	begin
	select seq_gebruikersreview.nextval into :new.gebruikersreviewid from dual;
	end;
	/
	
				CREATE SEQUENCE seq_useraccount
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1
  CACHE 20;

CREATE Trigger trigger_useraccount
	before insert on useraccount
	for each row
	begin
	select seq_useraccount.nextval into :new.useraccountid from dual;
	end;
	/


-- FAKE DATABASE
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Lynnz0r','NOM22YBP3JC','egestas@nulla.ca','Mikayla Garner','C:/','08/12/1992');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('FelixDeKat','UNI32VUH8PJ','magna.tellus@euismodurna.org','Tanya Donovan','C:/','07/09/2000');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('HowardStern','SZX71BZA1YL','justo.sit@risus.com','Naomi Marquez','C:/','21/03/1997');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Hope_NL','KXC82SYV5ZQ','Mauris.non@imperdieterat.org','Sybill Barnes','C:/','12/03/1980');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Irisje','HET85GRL4UU','magna@ipsumdolorsit.net','Risa Mccray','C:/','25/07/1995');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('TashaTokkie','GZB84JIW4FZ','consectetuer@magnaCras.com','Evan Garner','C:/','06/05/1986');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('BrunoMarsFan98','DFZ60FNC1QS','egestas@facilisiseget.com','Yeo Hill','C:/','02/09/1984');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Floritain','BOW42AOR1OE','accumsan@mollisduiin.net','Camilla Crawford','C:/','17/10/1986');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Sweet_Caroline','CQQ80PBI9ZU','Sed.nulla@faucibus.edu','Hoyt Lott','C:/','15/12/1990');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Noelle','SIR79QLJ9TD','Aenean@vestibulumloremsit.ca','Echo Leblanc','C:/','27/02/1979');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('AnthonyKentonie','IOG71PWG1IN','vitae.diam@Phasellus.org','Nelle Strickland','C:/','24/07/1984');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Drewwie','BLE66IJW5RC','senectus.et@liberoduinec.edu','Emerson Larsen','C:/','28/04/1998');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Caesar','DZU91DRO1NV','semper@Pellentesquehabitantmorbi.ca','Wallace Pratt','C:/','13/10/1991');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Brandenburg','OWC23UDJ2FR','mauris.Suspendisse.aliquet@nisinibh.com','Abigail Noel','C:/','30/11/1990');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Moses','GAE94ABK8FQ','est@vitaeerat.com','Florence Baxter','C:/','06/05/2002');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('David','QQO98ZLH4LV','elit.erat.vitae@risusNuncac.co.uk','Howard Reynolds','C:/','22/05/1990');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Noellai','OWA17OPZ1BK','Mauris.nulla@lacuspedesagittis.edu','Chester Roy','C:/','10/04/1988');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Carlcarl','HOA54NUU3UL','molestie.sodales@metusurnaconvallis.co.uk','Shelley Aguilar','C:/','31/08/1980');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Camille','DMK67EBN7GN','Lorem.ipsum.dolor@disparturientmontes.com','Dai Oconnor','C:/','13/07/1983');
INSERT INTO USERACCOUNT (ACCOUNTNAAM,WACHTWOORD,EMAIL,NAAM,FOTO,GEBOORTEDATUM) VALUES ('Amelia','YWO78KAF5GV','ac.mattis@lectuspedeultrices.edu','Kermit Hamilton','C:/','25/04/1985');

INSERT INTO WINKEL (NAAM,WEBSITE,CONTENT,FOTO) VALUES ('Bal.com','www.bol.com','Meer dan 5,4 miljoen klanten kunnen kiezen uit ruim 9 miljoen artikelen bol.com opende op 30 maart 1999 zijn winkeldeuren. Vijftien jaar later heeft de winkel meer dan 5,4 miljoen actieve klanten in Nederland en België en een assortiment van ruim 9 miljoen artikelen. Bol.com behoort tot de meest populaire (web)winkel van Nederland en België en is tevens marktleider op het gebied van de online verkoop van boeken, entertainment, elektrische apparaten en speelgoed. Op het hoofdkantoor van bol.com in Utrecht werken bijna 900 experts. Bij bol.com vinden klanten het grootste assortiment in tientallen speciaalzaken met boeken en ebooks in het Nederlands en andere talen, muziek, film, games, elektronica, speelgoed, babyartikelen, tuin- en klusartikelen en alles voor wonen, dieren, sport, vrije tijd, persoonlijke verzorging, sieraden, horloges, tassen en lederwaren. Bol.com biedt verkoopkanaal voor particulieren en andere winkeliers Daarnaast biedt bol.com particulieren de mogelijkheid om tweedehands boeken, dvdâ€™s, cdâ€™s, Blu-rays, vinyl en consolegames te verkopen via bol.com. Sinds 2011 heeft bol.com haar winkels ook opengesteld voor het aanbod van andere winkeliers (bol.com Plaza). Winkeliers (met en zonder webwinkel) kunnen via bol.com hun producten aan een groot publiek aanbieden waardoor klanten een nog breder aanbod artikelen krijgen. Winkeliers kunnen via bol.com hun bereik en daarmee omzet verhogen. Sinds de introductie van bol.com Plaza hebben al ruim 15.000 zakelijke verkopers zich aangemeld bij bol.com. Samen hebben deze verkopers meer dan 2,5 miljoen nieuwe artikelen aan het totaalassortiment toegevoegd.Winkeliers die via bol.com verkopen, blijken flink meer bereik en omzet te genereren. Gemiddeld gaat het om een omzetstijging van 10-30%, met uitschieters naar 50% of zelfs 100%','C:/');
INSERT INTO WINKEL (NAAM,WEBSITE,CONTENT,FOTO) VALUES ('Coolred.nl','www.coolblue.nl','Je vindt Ã¡lles bij Coolblue.nl, dÃ© specialist. Bij ons ben je op het juiste adres voor het grootste assortiment. Beloofd.Voor al onze producten geldt: op werkdagen voor 23.59 uur besteld? Morgen in huis. Je kunt bij ons bestellen onder vooruitbetaling, rembours, met creditcard (Visa en Mastercard) en iDEAL. Het is ook mogelijk je bestelling af te halen bij onze winkels in Amsterdam, Eindhoven, Groningen, Rotterdam en Utrecht. Keuze.','C:/');
INSERT INTO WINKEL (NAAM,WEBSITE,CONTENT,FOTO) VALUES ('Cornad.nl','www.conrad.nl','Wij zijn Conrad. Wij zijn er voor iedereen met een voorliefde voor elektronica en techniek. Met een assortiment van vele honderdduizenden artikelen kunnen we je alles leveren om je leven wat aangenamer te maken. Van de nieuwste 3D-printers tot de meest geavanceerde quadrocopters. Van een batterij tot het kabeltje dat je nergens anders kunt vinden. Ook voor een nieuwe stijltang kun je bij ons terecht. En ons assortiment breidt zich nog altijd uit. Een groei die we te danken hebben aan onze passie voor elektronica. Wat jij zoekt hebben wij al gevonden.','C:/');
INSERT INTO WINKEL (NAAM,WEBSITE,CONTENT,FOTO) VALUES ('Media Plaza','www.mediamarkt.nl','Media Markt is al jarenlang marktleider in consumentenelektronica en bekend bij 95 procent van alle Nederlanders. De eerste Nederlandse winkel werd in 1999 in Rotterdam geopend en inmiddels verwelkomen meer dan dertig vestigingen elk weekend maar liefst 550.000 bezoekers. Sinds 12 april 2011 kunnen klanten ook online hun aankopen doen in de Media Markt-webshop. Met het grootste assortiment aan elektronische producten met alle A-merken, eerlijke prijzen en een uitstekende service weten bezoekers van Media Markt precies wat zij mogen verwachten.','C:/');
INSERT INTO WINKEL (NAAM,WEBSITE,CONTENT,FOTO) VALUES ('5Launch','www.4launch.nl','4Launch is de webshop voor al uw consumenten electronica en onderscheid zich door een breed assortiment, snelle en betrouwbare leveringen en heldere communicatie. voor producten uit voorraad geldt op werkdagen voor 23:00 besteld, de volgende dag in huis! Smartshopping doet u bij 4Launch.','C:/');
INSERT INTO WINKEL (NAAM,WEBSITE,CONTENT,FOTO) VALUES ('Wohkamp','www.wehkamp.nl','wehkamp heeft nog geen beschrijving toegevoegd. Voor meer informatie over deze shop verwijzen wij u door naar de beoordelingen van klanten van wehkamp','C:/');
INSERT INTO WINKEL (NAAM,WEBSITE,CONTENT,FOTO) VALUES ('MeStekko','www.megekko.nl','Megekko is de site voor echte mannen. Mannen die geen gebruiksaanwijzing, helpdesk of bieropener nodig hebben om in hun voornaamste levensbehoeften te voorzien. Problemen los je zelf op. Wij weten wat jij wilt, en dat is maar een ding: De beste prijs voor je artikelen. Natuurlijk laten we je niet in de steek als je tegen een probleem aan loopt, of als je de handleiding toch voorbarig weggegooid hebt. We hebben echter geen dure telefonisch helpdesk en bieden ook geen service aan huis. Dat zie je terug in de prijs. Megekko, dat is zo gek toch niet? ','C:/');
INSERT INTO WINKEL (NAAM,WEBSITE,CONTENT,FOTO) VALUES ('Laples.nl','www.staples.nl','Staples is in 1985 opgericht door Tom Stemberg. Toen hij tijdens een weekend geen nieuw printerlint kon kopen, bedacht hij een manier om gemakkelijker â€“ en betaalbaar â€“ aan kantoorbenodigdheden te komen. Inmiddels is Staples uitgegroeid tot de grootste leverancier van kantoorartikelen ter wereld: klanten (voornamelijk bedrijven, maar ook particulieren) kunnen op onze website kiezen uit meer dan 10.000 kantoorartikelen. Bureaustoelen, laptops, koffiezetapparaten, beveiligingscameraÂ´s â€“ er is eigenlijk niets wat wij nÃ­et hebben.','C:/');
INSERT INTO WINKEL (NAAM,WEBSITE,CONTENT,FOTO) VALUES ('ABB', 'www.bcc.nl','Bij BCC een goedkope SLR camera (uit 2015) op de kop getikt. Eerlijk is eerlijk de prijs was te mooi om waar te zijn. Het had ook een levertijd van 5 tot 10 werkdagen. Uiteindelijk pas uitgeleverd na ruim een maand. De radiostilte was wat vervelend, maar aan de ene kant was het ook begrijpelijk dat ze nog aan overleggen waren wat ze moesten doen met de hoeveelheid orders. Het wachten was in ieder geval waard voor deze goede camera, waarvan de tweedehands prijs hoger ligt dan wat ik betaald heb.','C:/');

INSERT INTO REACTIETYPE (OMSCHRIJVING) VALUES ('Reactie op nieuws');
INSERT INTO REACTIETYPE (OMSCHRIJVING) VALUES ('Reactie op review');
INSERT INTO REACTIETYPE (OMSCHRIJVING) VALUES ('Reactie op gebruikrsreview');
INSERT INTO REACTIETYPE (OMSCHRIJVING) VALUES ('Reactie op andere reactie');

INSERT INTO CATEGORIE (NAAM) VALUES ('COMPUTERS');
INSERT INTO CATEGORIE (NAAM) VALUES ('TABLET EN TELEFOONS');
INSERT INTO CATEGORIE (NAAM) VALUES ('IT PRO');
INSERT INTO CATEGORIE (NAAM) VALUES ('BEELD EN GELUID');
INSERT INTO CATEGORIE (NAAM) VALUES ('GAMES');
INSERT INTO CATEGORIE (NAAM) VALUES ('SONY');
INSERT INTO CATEGORIE (NAAM) VALUES ('PHILIPS');
INSERT INTO CATEGORIE (NAAM) VALUES ('SAMSUNG');
INSERT INTO CATEGORIE (NAAM) VALUES ('APPLE');
INSERT INTO CATEGORIE (NAAM) VALUES ('BEHUIZINGEN');

INSERT INTO REVIEW (TITEL, DATUM) VALUES ('In Wins glazen 805-behuizing', TO_DATE('11/09/2015 9:30', 'DD/MM/YYYY HH24:MI'));

INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 1, 'Tijd voor innovatie', 'Het grijsbruin van de computerbehuizingen van weleer is al jaren geleden vervangen door zwart, maar inmiddels heeft dat bijna hetzelfde saaie imago gekregen. Behuizingen voor gamers hebben weliswaar allerlei spannende vormen gekregen, met plastic uitstulpingen, en er zijn kasten met mooie materialen als geborsteld aluminium, maar het is stilaan tijd voor wat meer afwisseling.');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 2, 'Uiterlijk: glas, glas, glas', 'HÃ©t grote verschil tussen de In Win 805 en de eerder geteste 904 Plus is het glazen frontje. Dat is, zoals we inmiddels van In Win gewend zijn, gemaakt van getint glas, zodat het weliswaar transparant, maar niet volledig helder doorzichtig is. De doorzichtigheid is zo gekozen dat je nog subtiel het In Win-logo door het glas kunt zien. Ook de honingraatstructuur van het achterliggende metalen chassis komt mooi door het glas naar voren.');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 3, 'Het interieur: ruim', 'Nadat de zijpanelen met de vier kartelschroeven zijn verwijderd, kunnen we de volledig aluminium binnenkant bekijken. Aan de voorkant valt de brede rand van het metalen frame op. Dat is ongetwijfeld deels voor de stevigheid gedaan, maar zeker niet in de laatste plaats om het In Win-logo te tonen. Dat is in In Wins kenmerkende letters in het metaal uitgesneden en wordt verlicht door ledverlichting als het systeem aanstaat. Aan de andere kant van de behuizing zijn die letters niet te vinden; daar zit gewoon de moederbordbackplate, die over de hele zijkant doorloopt. Let op: ruimte voor een optische drive is er dus niet; er zijn geen 5,25"-drivebays te vinden.');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 4, 'Koeling en kabelmanagement', 'Het moge duidelijk zijn dat de In Win 805 vooral een pronkkast is. Al het glas maakt je componenten, zeker met hier en daar wat ledverlichting, mooi zichtbaar. Dat heeft natuurlijk ook een keerzijde; als alles zichtbaar is, worden een secure bouw en afwerking van je systeem belangrijker, omdat elk verkeerd gelegd kabeltje in het zicht zit. Een modulaire voeding is dus zeker geen overbodige luxe, aangezien je zo weinig mogelijk kabels in het zicht wil. Voor de kabels achter de moederbordplaat heb je ongeveer 22mm.');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 5, 'Prestaties', 'Net als bij het oude systeem lieten we alle ventilators in de behuizing in eerste instantie onbelast op lage snelheid draaien. De processorkoeler draaide op 1100rpm en de casefans op 50 procent volgens MSI''s Command Center. Nog steeds zonder belasting zetten we vervolgens de systeemventilators op de hoogste stand, met de processorkoeler nog op 1100rpm. De casefans van de MasterCase draaiden op 700 tot 1200rpm. Ten slotte zetten we ook de processorkoeler vol aan en belastten we het systeem met Furmark voor de videokaart en Prime95 voor de processor. We noteerden steeds de processor-, systeem- en gpu-temperatuur, zoals uitgelezen door Command Center en gpuz. Verder hebben we de geluidsproductie gemeten in de drie scenario''s op 20cm van de voorkant van de behuizing.');

INSERT INTO REVIEW_CATEGORIE (REVIEWID, CATEGORIEID) VALUES (1, 1);
INSERT INTO REVIEW_CATEGORIE (REVIEWID, CATEGORIEID) VALUES (1, 10);

INSERT INTO PRODUCT (NAAM, CONTENT) VALUES ('In Win 805 Zwart', 'Type: Tower, Formaat: ATX, Panel: Aluminium en glas');
INSERT INTO PRODUCT (NAAM, CONTENT) VALUES ('Samsung UE48JU6000W Zwart', 'Schermdiagonaal 48", Geoptimaliseerde refresh rate	800Hz');
INSERT INTO PRODUCT (NAAM, CONTENT) VALUES ('Apple iPhone 6 16GB Grijs', 'Telefoon van Apple');
INSERT INTO PRODUCT (NAAM, CONTENT) VALUES ('Fallout 4, PC (Windows)', 'Releasedatum 11 november 2015');
INSERT INTO PRODUCT (NAAM, CONTENT) VALUES ('Asus STRIX-GTX980TI-DC3OC-6GD5-GAMING', 'Chipset generatie	GeForce 900 Serie Videochipfabrikant Nvidia Geheugengrootte	6GB');

INSERT INTO PRODUCT_REVIEW (PRODUCTID, REVIEWID) VALUES (1, 1);

INSERT INTO PRODUCT_CATEGORIE (PRODUCTID, CATEGORIEID) VALUES (1, 1);
INSERT INTO PRODUCT_CATEGORIE (PRODUCTID, CATEGORIEID) VALUES (1, 10);
INSERT INTO PRODUCT_CATEGORIE (PRODUCTID, CATEGORIEID) VALUES (2, 4);
INSERT INTO PRODUCT_CATEGORIE (PRODUCTID, CATEGORIEID) VALUES (2, 8);
INSERT INTO PRODUCT_CATEGORIE (PRODUCTID, CATEGORIEID) VALUES (3, 2);
INSERT INTO PRODUCT_CATEGORIE (PRODUCTID, CATEGORIEID) VALUES (3, 9);
INSERT INTO PRODUCT_CATEGORIE (PRODUCTID, CATEGORIEID) VALUES (4, 5);
INSERT INTO PRODUCT_CATEGORIE (PRODUCTID, CATEGORIEID) VALUES (5, 1);

INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (1, 5, 182.30);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (1, 6, 187.95);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (2, 1, 1209.95);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (2, 2, 1209.95);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (2, 3, 1229.95);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (2, 4, 1274.80);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (2, 5, 1149.99);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (2, 6, 1429.99);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (3, 1, 689.99 );
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (3, 4, 669.99);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (3, 8, 719.99);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (5, 2, 649.99);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (5, 4, 639.99);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (5, 5, 639.95);
INSERT INTO PRIJS (PRODUCTID, WINKELID, PRIJS) VALUES (5, 6, 669.95);


INSERT INTO NIEUWS (TITEL, DATUM, CONTENT) VALUES ('Alle tankstations in Rusland moeten elektrische lader installeren', TO_DATE('21/10/2015 9:32', 'DD/MM/YYYY HH24:MI'), '<p><b>De Russische overheid heeft afgelopen week bepaald dat tankstations in heel het land over een jaar laadpalen voor elektrische auto''s moeten aanbieden. Momenteel rijden er slechts een paar honderd elektrische auto''s in Rusland, maar de maatregel moet dat veranderen.</b></p><p>Benzinestations hebben tot 1 november 2016 om de faciliteiten voor elektrisch laden te installeren, <a target="_blank" title="www.themoscowtimes.com - Russian Gas Stations Ordered to Provide Chargers for Electric Cars | Business | The Moscow Times" href="http://www.themoscowtimes.com/business/article/russian-gas-stations-ordered-to-provide-chargers-for-electric-cars/529411.html" rel="external">schrijft</a> The Moscow Times. Moskou wil de productie en het gebruik van elektrische voertuigen hiermee stimuleren. Tot nu toe ligt dat gebruik extreem laag: volgens het Russische onderzoeksbedrijf Autostat zijn er tot nu toe slechts 500 in heel het land verkocht, waaronder 49 EL Lada''s van de Russische fabrikant AutoVAZ. De prijzen liggen er hoog en critici menen dat de auto''s niet bestand zijn tegen de weersomstandigheden in het land.</p><p>Een van de overige problemen is het gebrek aan infrastructuur. In Moskou zijn er inmiddels wel wat laadstations, verspreid over de stad, maar dat zijn er slechts tientallen, die langzaam laden. De tankstations moeten straks zelf opdraaien voor de kosten van het plaatsen van de laadpalen. Het goedkoopste laadstation, waarmee opladen tot wel 9 uur kan duren, kost 100.000 roebel, omgerekend 1310 euro. Een snellader kost in het land al gauw omgerekend 46.000 euro volgens de krant.</p><p><img class="alignCenter" src="http://ic.tweakimg.net/ext/i/imagenormal/2000732889.jpeg" alt="EL Lada" height="413" width="620"></p>');
INSERT INTO NIEUWS (TITEL, DATUM, CONTENT) VALUES ('Pixmania heeft financiële problemen', TO_DATE('21/10/2015 12:02', 'DD/MM/YYYY HH24:MI'), '<p><b>Pixmania heeft zijn personeel ingelicht over financiële problemen en de mogelijkheid dat er uitstel van betaling wordt aangevraagd. Het bedrijf gaat zich opnieuw organiseren en zich naar verluidt op meer als marktplaats voor derde partijen richten.</b></p><p>De eigenaar van Pixmania, het Duitse Mutares AG, <a target="_blank" title="www.channelpartner.de - Restrukturierung gescheitert?: Pixmania beantragt angeblich Insolvenzverfahren - channelpartner.de" href="http://www.channelpartner.de/a/pixmania-beantragt-angeblich-insolvenzverfahren,3046651" rel="external">bevestigt</a> tegen Channelpartner dat het personeel op de hoogte is gebracht van de slechte financiële situatie. Daarnaast zouden de werknemers ingelicht zijn over de mogelijkheid van een zogenoemde <em>procédure de sauvegarde</em>. Dit is een procedure voor uitstel van betaling die het bedrijf zes maanden geeft voor een reorganisatie.</p><p>De mededeling van Mutares volgt op berichten in de Franse media, <a target="_blank" title="www.20minutes.fr - E-commerce: Pixmania veut être placé sous procédure de sauvegarde" href="http://www.20minutes.fr/economie/1712379-20151019-e-commerce-pixmania-veut-etre-place-sous-procedure-sauvegarde" rel="external">zoals</a> 20minutes, dat zo''n procedure al aangevraagd zou zijn. Bij Pixmania werken 430 mensen, waaronder 320 Fransen. Een Franse bron zou de media ingelicht hebben over de situatie.</p><p>Pixmania gaat proberen de kosten voor opslag en levering flink te verlagen en zich meer als ''marktplaats'' voor verkopers profileren, aldus de berichten. De webwinkel werd in 2000 opgericht en kampte afgelopen jaren met teruglopende omzetten door toegenomen concurrentie. De fysieke winkels van Pixmania moesten daarop in 2013 al sluiten. In 2014 kwam het bedrijf in handen van het Duitse Mutares, die het tij probeerde te keren. Dat lijkt vooralsnog niet het gewenste effect te hebben.</p><p><img src="http://ic.tweakimg.net/ext/i/imagenormal/2000810103.png" alt="Pixmania" height="370" width="620"></p>');
INSERT INTO NIEUWS (TITEL, DATUM, CONTENT) VALUES ('Tele2 introduceert nog dit jaar 4g-abonnementen in Nederland', TO_DATE('21/10/2015 17:53', 'DD/MM/YYYY HH24:MI'), '<p><b>Tele2 start nog voor het einde van 2015 met het aanbieden van 4g-abonnementen in Nederland en ook opent de provider nog dit jaar zijn eerste eigen winkel. Dit meldt de aanbieder bij de bekendmaking van de kwartaalcijfers. Het aantal mobiele klanten groeide niet.</b></p><p>In het afgelopen kwartaal haalde Tele2 een buitenshuis bereik van bijna 90 procent van de bevolking met zijn 4g-netwerk, waardoor een meerderheid van de klanten met een 4g-toestel nu van het netwerk gebruik kan maken. Komend kwartaal volgt daarom het <a target="_blank" href="http://filestest.smart.pr.s3-eu-west-1.amazonaws.com/04/96926077b911e5a3cdfd6261c8bf70/151021-Press-release---Tele2-lanceert-4G-abonnementen-voor-eind-2015.pdf" rel="external">starten</a> met 4g-abonnementen en in de komende drie maanden blijft Tele2 investeren om landelijke dekking te realiseren, wat begin 2016 een feit moet zijn.</p><p>Klanten van de provider die dekking hadden, konden met hun 3g-abonnement al gebruikmaken van het lte-netwerk van het bedrijf. Hoe de nieuwe abonnementen er precies uit komen te zien is nog niet bekend. Tele2 is bezig zijn eigen 4g-netwerk te bouwen, waarbij het gaat om een <em>4g-only</em>-netwerk.</p><p>De provider maakte eveneens bekend zijn eigen winkels in Nederland te gaan openen en de eerste moet eind 2015 zijn deuren openen. Het bedrijf zei dit bij het vrijgeven van de <a target="_blank" href="http://www.tele2.com/Documents/Cision/documents/2015/20151021-interim-report-third-quarter-2015-en-0-2014137.pdf?epslanguage=en" rel="external">cijfers</a> over het derde kwartaal. Tele2 noteerde geen groei wat betreft het aantal mobiele klanten: die bleef gelijk op 841.000. De provider zegt minder klanten te krijgen omdat het zich minder op prepaid-klanten en mensen met goedkope abonnementen richt en meer op klanten met 4g-toestellen.</p><p>Ook kampt het bedrijf met toenemende kosten in verband met toegenomen dataverkeer en het uitbouwen van zijn 4g-netwerk. Tele2 verloor bij vaste telefonie 5000 klanten en heeft nu nog 62.000 vaste bellers; bij vast internet nam het aantal klanten af van 355.000 tot 348.000.</p>');
INSERT INTO NIEUWS (TITEL, DATUM, CONTENT) VALUES ('''Pay2win''-skins in Payday 2 nu ook gratis te bemachtigen', TO_DATE('21/10/2015 18:43', 'DD/MM/YYYY HH24:MI'), '<p><b>Ontwikkelstudio Overkill heeft de nieuwe ''pay2win''-skins nu ook gratis te bemachtigen gemaakt. Spelers kunnen de <i>drills</i> die nodig zijn om de skins te machtigen, nu namelijk ook krijgen als <i>drop</i> na een succesvolle missie.</b></p><p>In de recente Black market Update heeft Overkill Studios de zogenaamde <em>safes </em><a target="_blank" title="Payday 2 krijgt microtransacties die gameplayvoordelen kunnen opleveren" href="http://tweakers.net/nieuws/105819/payday-2-krijgt-microtransacties-die-gameplayvoordelen-kunnen-opleveren.html" rel="external">geïntroduceerd</a> in co-op-multiplayershooter Payday 2. Spelers hebben een kans om een kluis afgeleverd te krijgen bij hun schuilplaats wanneer ze een missie volbrengen. De kluizen bevatten <em>skins </em>voor de verschillende wapens in de game en sommige van die skins verbeteren de prestaties van het wapen. Om de kluizen te kunnen openen, hebben spelers echter een <a target="_blank" title="steamcommunity.com - Steam Community Market :: Showing results for: PAYDAY 2, drill" href="http://steamcommunity.com/market/" rel="external">boor</a> nodig, die ze alleen met echt geld konden kopen op de Steam Community. Spelers van de game waren ontevreden met de situatie waarin mensen die meer geld uitgeven aan de game, een grotere kans hebben op de gameplayvoordelen.</p><p>Overkill lijkt gezwicht te zijn voor de kritiek die deze beslissing heeft opgeleverd. In de <a target="_blank" title="steamcommunity.com - Steam Community :: Group Announcements :: PAYDAY 2" href="http://steamcommunity.com/games/218620/announcements/detail/85925631416378667" rel="external">patch notes</a> van de nieuwste update voor de game valt te lezen dat spelers na een succesvolle missie nu net zo goed met een boor beloond kunnen worden als met een kluis. Op deze manier hoeven spelers geen geld uit te geven om de kluizen open te krijgen en is de <em>pay2win-</em>situatie waar menig speler zijn beklag over deed, in principe verholpen. Het is echter nog niet duidelijk hoe groot de kans is dat een speler een boor daadwerkelijk krijgt na een missie. In de update heeft Overkill overigens ook de <em>First World Bank</em>-missie uit de eerste Payday toegevoegd aan Payday 2.</p><p><img class="alignCenter" src="http://ic.tweakimg.net/ext/i/imagenormal/2000810130.jpeg" alt="" height="349" width="620"></p>');
INSERT INTO NIEUWS (TITEL, DATUM, CONTENT) VALUES ('Intel meet nanometer-structuren van chips met röntgendiffractie', TO_DATE('21/10/2015 20:18', 'DD/MM/YYYY HH24:MI'), '<p><b>Intel heeft samen met het NIST met succes een techniek voor röntgendiffractie ingezet om de kleine structuren van chips te kunnen meten. Het onderzoek maakt van de techniek een kandidaat om ingezet te worden als meettool voor steeds kleinere en complexere chipstructuren.</b></p><p>De huidige instrumenten die gebruikt worden om de structuren op chips bij de productie te controleren, naderen hun limiet vanwege de verkleining van de procedés en de toegenomen complexiteit, zoals bij de overstap van platte transistors naar finfet-varianten. Onderzoekers van Intel en het <abbr title="National Institute of Standards and Technology">NIST</abbr> zijn erin geslaagd röntgendiffractie in te zetten om nanometerstructuren, met de breedte van een enkel siliciumatoom, te meten.</p><p>De techniek die de wetenschappers gebruiken is de <abbr title="critical-dimension small angle X-ray scattering">cdsaxs</abbr>-technologie. <a target="_blank" title="nist.gov - NIST and Intel Get Critical (Dimensions) with X-rays" href="http://nist.gov/mml/nist-and-intel-get-critical-dimensions-with-x-rays.cfm" rel="external">Volgens</a> NIST-onderzoeker R. Joseph Kline zijn hiermee ten opzichte van andere meetmethodes "met afstand de kleinste en meest gecompliceerde nanostructuren" in kaart gebracht. "De resultaten tonen aan dat cdsaxs de resolutie heeft om te voldoen aan de vereisten voor de metrologie van de nieuwe generatie", aldus Kline.</p><p>Intel en het NIST pasten de röntgendiffractie-meetmethode toe op samples met structuren die op haaienvinnen lijken. De vinnen waren 12 nanometer breed en 32 nanometer hoog. De verschillen in hoogte tussen de structuren varieerden minder dan 0,5 nanometer. Met cdsaxs konden de onderzoekers afwijkingen accuraat tot op 0,1nm registreren.</p><p>Bij de techniek, waar het NIST al sinds 2000 aan werkt, worden patronen van de verstrooiing van röntgenstralen met een golflengte van 0,1nm opgevangen. De verstrooiing wordt veroorzaakt door botsingen met de elektronen in de nanostructuur. De golflengte van de straling verandert niet maar de impuls wel. Computers kunnen met behulp van het diffractiepatroon de oorspronkelijke vorm van de structuur berekenen. Deze techniek wordt al langer gebruikt om kristalstructuren tot op detail te bepalen.</p><p><a href="http://ic.tweakimg.net/ext/i/2000810147.jpeg" rel="imageviewer"><img src="http://ic.tweakimg.net/ext/i/imagenormal/2000810147.jpeg" alt="Intel NIST CDSAXS verstrooiing patronen" height="262" width="620"></a></p><p><a href="http://ic.tweakimg.net/ext/i/2000810147.jpeg" rel="imageviewer"><img src="http://ic.tweakimg.net/ext/i/imagenormal/2000810147.jpeg" alt="Intel NIST CDSAXS verstrooiing patronen" height="262" width="620"></a></p><p style="text-align center; font-size:9px;">Intel en NIST tonen een voorbeeld van links een patroon met interferentiepartoon van röntgenstralen, veroorzaakt door de nanostructuur. Rechtsboven het resultaat van de analyse van de cdsaxs-metingen, daaronder een afbeelding van vergelijkbare structuren, gemaakt met een elektronenmicroscoop.</p>');

INSERT INTO NIEUWS_CATEGORIE(NIEUWSID, CATEGORIEID) VALUES (1, 4);
INSERT INTO NIEUWS_CATEGORIE(NIEUWSID, CATEGORIEID) VALUES (2, 5);
INSERT INTO NIEUWS_CATEGORIE(NIEUWSID, CATEGORIEID) VALUES (3, 2);
INSERT INTO NIEUWS_CATEGORIE(NIEUWSID, CATEGORIEID) VALUES (4, 5);
INSERT INTO NIEUWS_CATEGORIE(NIEUWSID, CATEGORIEID) VALUES (5, 1);

INSERT INTO GEBRUIKERSREVIEW(PRODUCTID, AUTEUR, DATUM, SAMENVATTING, CONTENT, BEOORDELING) VALUES (5, 8, '19/10/2015', 'De videokaart is aan de dure kant, alleen je moet niet vergeten dat de videokaart wel de top-class is van de videokaarten. De kaart ziet er enorm goed uit en is ook stil onder full-load met een goede overclock.', 'Ik heb een beetje getest tot hoever ik de videokaart kon overclocken en het is mijn gelukt om een boost van 1477MHz core/3802MHz memory te behalen door alleen de power-limit tot het maximale (109%) te zetten. De videokaart wordt niet warmer dan 74C onder full-load. Af en toe zie je de videokaart naar 1494MHz core schieten, maar dit is maar voor 1-2 seconden en dan clockt de videokaart weer terug naar 1477MHz. Zowel met voltage toe te voegen als zonder kom ik niet hoger dan 1480MHz core stable. Tijdens GTA V 1920*1080 Maxed out zonder MSAA heb ik gemiddeld in de stad 120 FPS en in mijn appartement/garage 140-180. Als we het gaan hebben over de sandy-shores komt de videokaart er ook best goed vanaf. Ik heb gemiddeld 80 FPS in de sandy-shores. Zonder overclock had ik ongeveer 90-110 FPS in de stad en 130-140 FPS in mijn appartement/garage. In de sandy-shores had ik een FPS van gemiddeld 65-70.', 4);

INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (1, 1, 1, TO_DATE('11/09/2015 22:02', 'DD/MM/YYYY HH24:MI'), 'Mooi initiatief, ik hoop dat andere landen dit voorbeeld gaan volgen.');
INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (3, 1, 1, TO_DATE('11/09/2015 21:53', 'DD/MM/YYYY HH24:MI'), 'Jammer dat een land als rusland hiermee voor loopt. Maarja, Nederland draait dan bijvoorbeeld ook nog op kolencentrales.');
INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (1, 1, 4, TO_DATE('11/09/2015 23:49', 'DD/MM/YYYY HH24:MI'), 'Helaas wel de waarheid, ik hoop dat onze overheid meer moeite gaat doen om Nederland echt groen te maken.');
INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (15, 1, 2, TO_DATE('11/09/2015 20:22', 'DD/MM/YYYY HH24:MI'), 'Duidelijke review, misschien kan je het nog wat aankleden met een paar afbeeldingen!');
INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (1, 4, 1, TO_DATE('11/09/2015 20:21', 'DD/MM/YYYY HH24:MI'), 'Er was dan ook een heuse shitstorm onder de community van Payday, blij dat de ontwikkelaars toch nog luisteren.');

COMMIT;

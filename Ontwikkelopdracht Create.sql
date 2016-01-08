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
  SUBTITEL				VARCHAR2(255) NOT NULL,
  SAMENVATTING			VARCHAR2(255) NOT NULL,
  DATUM					DATE NOT NULL,
  THUMBFOTO				VARCHAR2(255),
  HIGHLIGHTFOTO			VARCHAR2(255)
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

INSERT INTO REVIEW (TITEL, SUBTITEL, THUMBFOTO, HIGHLIGHTFOTO, SAMENVATTING, DATUM) VALUES ('In Wins glazen 805-behuizing', 'Hypermodern ontwerp van binnen en buiten', 'http://ic.tweakimg.net/ext/i/2000610707.png', 'http://ic.tweakimg.net/ext/i/thumbs_fpa_small/2000807602.jpeg', 'De In Win 805 doet sterk denken aan de 904 Plus, maar is iets kleiner, heeft nóg meer glas en, niet onbelangrijk, een iets lagere prijs.' ,TO_DATE('11/09/2015 06:00', 'DD/MM/YYYY HH24:MI'));
INSERT INTO REVIEW (TITEL, SUBTITEL, THUMBFOTO, HIGHLIGHTFOTO, SAMENVATTING, DATUM) VALUES ('Samsung Galaxy Gear S2', 'Horloge met verdraaid handige bediening', 'http://ic.tweakimg.net/ext/i/1349425400.png', 'http://ic.tweakimg.net/ext/i/thumbs_fpa_small/2000880114.jpeg', 'De Gear S2 combineert een traditioneel uiterlijk, een mooi beeld en een intuïtieve bediening. Wij verruilden ons klassieke klokje een tijdlang voor twee varianten van deze smartwatch.' ,TO_DATE('25/09/2015 09:00', 'DD/MM/YYYY HH24:MI'));
INSERT INTO REVIEW (TITEL, SUBTITEL, THUMBFOTO, HIGHLIGHTFOTO, SAMENVATTING, DATUM) VALUES ('Asus Zenfone Zoom', 'Doodsteek voor de compactcamera?', 'http://ic.tweakimg.net/ext/i/1392983645.png', 'http://ic.tweakimg.net/ext/i/thumbs_fpa_small/2000899115.jpeg', 'Tijdens CES konden we voor het eerst aan de slag met Asus'' Zenfone Zoom, een smartphone die over een camera met optische zoom beschikt en toch relatief dun is.' ,TO_DATE('02/10/2015 09:00', 'DD/MM/YYYY HH24:MI'));

INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 1, 'Tijd voor innovatie', '<p>Het grijsbruin van de computerbehuizingen van weleer is al jaren geleden vervangen door zwart, maar inmiddels heeft dat bijna hetzelfde saaie imago gekregen. Behuizingen voor gamers hebben weliswaar allerlei spannende vormen gekregen, met plastic uitstulpingen, en er zijn kasten met mooie materialen als geborsteld aluminium, maar het is stilaan tijd voor wat meer afwisseling.</p><p>De Taiwanese fabrikant In Win, ooit dé leverancier van generieke behuizingen, heeft in de afgelopen tijd hard gewerkt om dat imago te veranderen. De S-Frame die het bedrijf tijdens de Computex van 2014 liet zien, werd tijdens diezelfde beurs in 2015 nog steeds veelvuldig tentoongesteld als vertegenwoordiger van innovatie in de behuizingenwereld.</p><p>De S-Frame is het paradepaardje van In Win, met een bijpassende prijs, maar het bedrijf heeft meer behuizingen die gezien mogen worden. Zo bekeken we dit voorjaar de 904 Plus, een luxueuze behuizing met glazen zijpanelen en een pittige prijs. De 805 doet sterk denken aan de 904 Plus, maar is iets kleiner, heeft nóg meer glas en, niet onbelangrijk, een iets lagere prijs. Tijd om de kijken of de In Win 805 even praktisch als mooi is.</p><p><a href="http://ic.tweakimg.net/ext/i/2000807602.jpeg" rel="imageviewer"><img class="alignCenter" src="http://ic.tweakimg.net/ext/i/imagenormal/2000807602.jpeg" alt="In Win 805 Zwart" height="413" width="620"></a></p>');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 2, 'Uiterlijk: glas, glas, glas', '<p>Hét grote verschil tussen de In Win 805 en de eerder geteste 904 Plus is het glazen frontje. Dat is, zoals we inmiddels van In Win gewend zijn, gemaakt van getint glas, zodat het weliswaar transparant, maar niet volledig helder doorzichtig is. De doorzichtigheid is zo gekozen dat je nog subtiel het In Win-logo door het glas kunt zien. Ook de honingraatstructuur van het achterliggende metalen chassis komt mooi door het glas naar voren.</p><p><img class="alignCenter border" src="http://ic.tweakimg.net/ext/i/imagenormal/2000807646.jpeg" alt="In Win 805" width="600"></p><p><a id="usb"></a>Het frontje bestaat niet volledig uit glas. Onderin is een plastic voet zichtbaar en het bovenste stripje is gemaakt van geborsteld aluminium met een gepolijst randje. In dat metalen randje van ongeveer 27 millimeter zijn de frontpaneelpoorten aangebracht. Van links naar rechts zijn dat twee usb 2.0-poorten, de twee audioaansluitingen en twee usb 3.0-poorten. Een van die laatste is een gewone type a-poort, maar de tweede is een moderne type c-connector. Aan de rechterkant zijn twee kleine gaatjes geboord voor de statusleds en uiterst rechts zit de powerbutton. Een resetknop ontbreekt.</p><p>De onderkant is wat onconventioneel. De voorste helft is voorzien van vier grote openingen die met een magnetisch stoffilter zijn afgeschermd. Op de plaats van de voeding is geen rooster te vinden; koele lucht van buiten aanzuigen is voor de voeding dus geen optie. De behuizing staat op twee u-vormige voetjes, die van plastic met een rubberen dopje zijn gemaakt.</p>');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 3, 'Het interieur: ruim', '<p>Nadat de zijpanelen met de vier kartelschroeven zijn verwijderd, kunnen we de volledig aluminium binnenkant bekijken. Aan de voorkant valt de brede rand van het metalen frame op. Dat is ongetwijfeld deels voor de stevigheid gedaan, maar zeker niet in de laatste plaats om het In Win-logo te tonen. Dat is in In Wins kenmerkende letters in het metaal uitgesneden en wordt verlicht door ledverlichting als het systeem aanstaat. Aan de andere kant van de behuizing zijn die letters niet te vinden; daar zit gewoon de moederbordbackplate, die over de hele zijkant doorloopt. Let op: ruimte voor een optische drive is er dus niet; er zijn geen 5,25"-drivebays te vinden.</p><p><a id="voeding"></a>De drivebays vinden we aan de voorzijde. Er is een enkel rek voor twee 3,5"-drives vooraan onderin geplaatst. Dat bevat twee sledes voor je harde schijven. Achter de sledes zijn sleuven in de achterwand aanwezig om de sata- en voedingsstekker in de schijf te kunnen prikken. Boven op de cage zit een verwijderbare 2,5"-houder voor je ssd. Achter op de moederbordplaat zitten nog drie van dergelijke 2,5"-diskhouders, zodat je in totaal vier ssd''s en twee harde schijven kwijt kunt. Desgewenst kun je de drivecage van de bodem losschroeven en tegen de voorkant van de behuizing bevestigen. Zo heb je iets meer flexibiliteit voor bijvoorbeeld koeling of lange voedingen.</p><p>De voeding wordt wat onconventioneel gemonteerd. We zijn gewend voedingen ondersteboven in behuizingen te schroeven, zodat de ventilator koele lucht van buiten, via een rooster in de bodem, kan aanzuigen. Bij de In Win 805 is geen rooster te vinden onder de voeding, zodat deze met de ventilator naar boven gemonteerd moet worden. Een verstevigend hoekprofiel in de rechterachterhoek van de behuizing is voorzien van luchtgaten, zodat de voeding alsnog voldoende lucht kan aanzuigen, zij het van binnen in de behuizing. Dat was bij de 904 Plus anders. Ook daar moest de voeding lucht van binnen aanzuigen, maar werd de ventilator goeddeels geblokkeerd door metaalplaat. Overigens wordt de voeding ''koud'' op het metaal van het frame, zowel van de onder- als achterplaat, gemonteerd; rubberen voetjes ontbreken.</p><p><a href="http://ic.tweakimg.net/ext/i/2000807597.jpeg" rel="imageviewer"><img class="alignCenter border" src="http://ic.tweakimg.net/ext/i/imagenormal/2000807597.jpeg" alt="In Win 805 Zwart" width="600"></a></p><p>Het moederbord wordt op de grote plaat aan de rechterkant bevestigd. Dat is één massieve aluminium plaat die van voor naar achter en van boven naar onder loopt. Daarom voelt de 805 ook heerlijk ruim aan; je loopt niet tegen drivecages aan die in de weg zitten bij de inbouw. Uiteraard zijn er uitsparingen in gemaakt voor toegang tot de cpu-koeler, voor de montage van de twee extra ssd-brackets en om je kabels doorheen te voeren. Die laatste, de gaten voor je kabels, zijn niet voorzien van rubberen afdichtringen. Dat is waarschijnlijk gedaan om het strakke uiterlijk geen geweld aan te doen, maar het leidt tot meer kabelzichtbaarheid. Het i/o-shield wordt ook wat apart gemonteerd. Er is geen afgebakende opening, maar alleen een boven- en onderkant waarin het shield wordt geklikt. Voor de exacte positie moet je daarom een beetje gokken.</p>');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 4, 'Koeling en kabelmanagement', '<p>Het moge duidelijk zijn dat de In Win 805 vooral een pronkkast is. Al het glas maakt je componenten, zeker met hier en daar wat ledverlichting, mooi zichtbaar. Dat heeft natuurlijk ook een keerzijde; als alles zichtbaar is, worden een secure bouw en afwerking van je systeem belangrijker, omdat elk verkeerd gelegd kabeltje in het zicht zit. Een modulaire voeding is dus zeker geen overbodige luxe, aangezien je zo weinig mogelijk kabels in het zicht wil. Voor de kabels achter de moederbordplaat heb je ongeveer 22mm.</p><p>Toch hoef je geen zielig systeempje in de 805 te bouwen. Er is voldoende ruimte voor een serieuze build, met aan de voorkant plaats voor twee 140mm-ventilators of een 280mm-radiator. Die bevestig je aan een met kartelschroeven verwijderbare plaat, zodat de installatie vergemakkelijkt wordt. Ook op de bodem is, na het verwijderen van de drivecage, plaats voor extra koeling; daar passen twee 120mm-ventilators. Bovenin kun je geen ventilators of radiators kwijt.</p><p><img class="alignCenter border" src="http://ic.tweakimg.net/ext/i/2000807599.jpeg" alt="In Win 805" width="600"></p><p>Videokaarten mogen tot 320mm lang zijn, maar hou rekening met de beperkte breedte van de behuizing. Met een totale breedte van 205mm is er binnenin ruimte voor videokaarten van maximaal 164mm hoog en de processorkoeler kan maar 156mm hoog zijn. Grote koelers met 140mm-ventilators zijn dus niet mogelijk; voor extra koelcapaciteit zul je naar een waterkoelsetje moeten uitkijken. Over extra koelcapaciteit gesproken, In Win levert alleen een 120mm-ventilator aan de achterzijde mee. Die moet airflow via de roosters voor in de bodemplaat opleveren, maar rijk uitgerust met standaardkoeling is de 805 dus niet.</p><p>De standaarduitrusting is voor een behuizing van zo''n 170 euro toch al niet bijzonder uitgebreid. De In Win-letters aan de zijkant worden verlicht, maar het logo voorop niet; een ledje had wel gemogen. Ook ontbreekt een fancontroller, en je bent vrij beperkt met drives en al helemaal met optische drives. Je zult dus kritisch naar de componenten moeten kijken voordat je ze in deze vitrinekast tentoonstelt.</p>');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (1, 5, 'Prestaties', '<p>Het testsysteem bestaat uit een op Intel gebaseerd systeem met een Haswell-processor en een Z97-moederbord. De Core i7-4790K hebben we in MSI''s Z97 MPower Max AC-moederbord gestoken en koelen we met een compacte Noctua NH-U9B SE2. Als videokaart hebben we Nvidia''s GTX 980 gekozen. Windows 8.1 installeerden we op een Force LX-ssd en we zetten daar een Samsung Spinpoint- harde schijf naast.</p><p>Net als bij het oude systeem lieten we alle ventilators in de behuizing in eerste instantie onbelast op lage snelheid draaien. De processorkoeler draaide op 1100rpm en de casefans op 50 procent volgens MSI''s Command Center. Nog steeds zonder belasting zetten we vervolgens de systeemventilators op de hoogste stand, met de processorkoeler nog op 1100rpm. De casefans van de MasterCase draaiden op 700 tot 1200rpm. Ten slotte zetten we ook de processorkoeler vol aan en belastten we het systeem met Furmark voor de videokaart en Prime95 voor de processor. We noteerden steeds de processor-, systeem- en gpu-temperatuur, zoals uitgelezen door Command Center en gpuz. Verder hebben we de geluidsproductie gemeten in de drie scenario''s op 20cm van de voorkant van de behuizing.</p><h3>Temperaturen</h3><p>We beginnen met de temperaturen zonder belasting, met de cpu-ventilator op 1050rpm en de ventilator in de behuizingen op de laagste stand, op 700rpm. Alle weergegeven temperaturen zijn relatief ten opzichte van de kamertemperatuur, omdat die enkele graden kan variëren. Gemiddeld kun je dus twintig graden bij de temperaturen in de tabellen optellen.</p><p><a id="prestaties"></a><iframe src="//charts.tweakzones.net/uCBIE/1/index.html" allowtransparency="true" allowfullscreen="allowfullscreen" webkitallowfullscreen="webkitallowfullscreen" mozallowfullscreen="mozallowfullscreen" oallowfullscreen="oallowfullscreen" msallowfullscreen="msallowfullscreen" frameborder="0" height="350" width="600"></iframe><iframe src="//charts.tweakzones.net/GuKoc/2/index.html" allowtransparency="true" allowfullscreen="allowfullscreen" webkitallowfullscreen="webkitallowfullscreen" mozallowfullscreen="mozallowfullscreen" oallowfullscreen="oallowfullscreen" msallowfullscreen="msallowfullscreen" frameborder="0" height="350" width="600"></iframe></p><p>Onbelast weet de enkele ventilator de componenten in de In Win-behuizing keurig koel te houden en met de systeemventilator een tandje hoger gaat er nog een graadje van de temperaturen af. Dat valt alles mee dus: de airflow wordt weliswaar slechts door één ventilator geleverd en verse lucht kan enkel door het filter in de bodem worden aangezogen, maar dat voldoet prima.</p><p>De behuizing heeft wat last van resonantie. Als we onze hand als demper bovenop gebruiken, is de 805 zeer stil, maar met de trilling erbij is het idle een van de luidere behuizingen. Het enkele ventilatortje maakt flink herrie als het toeren maakt, getuige de tweede grafiek. Onder belasting overstemt de videokaartventilator de processorkoeler en de systeemventilator weer.</p>');

INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (2, 1, 'Inleiding', '<p>De smartwatchindustrie heeft het niet makkelijk. Hoewel kleine spelers als Pebble mooie successen weten te boeken, heeft het de grotere fabrikanten tot nu toe nog niet gebracht wat ze ervan verwacht hadden. Samsung mag dan al enige jaren aan de weg timmeren met slimme horloges, slechts weinig mensen zijn zich daarvan bewust en verkoopsuccessen zijn het niet gebleken. Als zelfs een publiekslieveling als Apple de mainstream niet weet te overtuigen van het nut van een smartwatch, dan weet je dat er nog wat werk te verzetten valt.</p><p><a href="http://ic.tweakimg.net/ext/i/2000880114.jpeg" rel="imageviewer"><img class="alignCenter" src="http://ic.tweakimg.net/ext/i/imagenormal/2000880114.jpeg" alt="Samsung Gear S2" height="338" width="620"></a></p><p>Fabrikanten blijven driftig proberen de markt te vergroten en te veroveren. Nu de verkopen van smartphones onder druk staan, zijn ze op zoek naar een ander gebied om te groeien. Na enige jaren van experimenteren met verschillende vormen en softwareversies lijkt Samsung steeds beter in het vizier te krijgen wat een smartwatch goed maakt.</p><p>Dat resulteerde dit najaar in de nieuwste telg in de Gear-lijn: de Gear S2. Dit horloge combineert een aantal zaken die belangrijk zijn gebleken in smartwatchland: een traditioneel uiterlijk, een mooi beeld en een intuïtieve bediening. Wij verruilden ons klassieke klokje een tijdlang voor twee varianten van deze Gear S2 om te kijken of Samsung hiermee die doorbraak te pakken heeft waarnaar het op zoek is.</p>');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (2, 2, 'Subtiel ontwerp met mooi scherm', '<p>Het grootste compliment dat je de Gear S2 kunt maken is dat in eerste instantie niet meteen opvalt dat het een smartwatch is. Dat is een aspect waar horlogeliefhebbers zeker blij van zullen worden. De Gear S2 weet zich goed te camoufleren door het ronde ontwerp, maar vooral door zijn afmetingen en verhoudingen. De Moto 360 was ook rond, maar erg groot. LG''s G Watch R leek meer op een echt horloge, maar zijn forse dikte verraadde hem enigszins. De Gear S2 is zowel kleiner als dunner dan menige andere ronde smartwatch en dat is wat hem subtieler maakt.</p><p>Die subtiliteit wordt doorgezet in het ontwerp, dat behoorlijk eenvoudig is. Dit is ook wat de Gear S2 bij verdere inspectie duidelijk anders maakt dan veel echte horloges. Waar die zijn voorzien van grote draaiknoppen, details op de kast en verschillende materialen, is de Gear S2 simpeler, met enkel donkergrijze kleurtinten, een gladde afwerking en twee simpele knoppen. Hij doet daardoor een beetje futuristisch aan, als het horloge dat vijftig jaar geleden zou zijn voorspeld voor de toekomst.</p><p>Dat geldt minder voor de duurdere Classic-variant, die in aangepaste vorm in Nederland als ''Balr-editie'' wordt verkocht. Het enige verschil is de verpakking met voetbalthema en het extra bandje dat ook de link met voetbal moet leggen. Bevestig je het meegeleverde leren bandje aan het horloge, dan heb je gewoon de Classic-versie zoals die in andere landen te koop is.</p><h3><a id="scherm"></a>Mooi scherm</h3><p>Wat bijdraagt aan het uiterlijk van de Gear S2 is het prachtige amoledscherm, dat opvalt door het hoge contrast en het diepe zwart. Net als bij een echt horloge ligt deze digitale wijzerplaat een beetje verzonken in de behuizing. Bij smartphones zien we altijd graag dat het scherm bijna boven op het toestel ligt, maar bij de Gear S2 draagt het verzonken scherm juist bij aan het geheel, te meer doordat er geen nare interne reflecties optreden, zoals we wel eens zien bij telefoons met verzonken schermen.</p><p>Binnen in het horloge vinden we een Exynos 3250-dualcore-soc, bestaande uit twee Cortex A7-kernen op 1GHz. Vergeleken met moderne hardware uit smartphones stelt het niets voor, maar het blijkt in de praktijk meer dan snel genoeg om de software vloeiend en snel te draaien. De accu heeft een capaciteit van 250mAh en wordt opgeladen via een kleine houder waar je het horloge op legt.</p>');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (2, 3, 'Bedienen door te draaien', '<p>De ronde vorm is niet alleen uiterlijk vertoon, verre van zelfs, het staat centraal in Samsungs filosofie voor de manier waarop je het horloge bedient. Tot nu toe gebruikte je een touchscreen (Apple Watch, Android Wear) of knoppen (Pebble). Samsung voegt hier een derde manier aan toe, een draaibare ring, en het gooit die andere twee manieren eveneens in de mix. Voor het gros van de bediening gebruik je de draaibare rand rondom het scherm, aangevuld met het touchscreen om zaken aan te tikken en de twee knoppen aan de zijkant om snel terug en naar het thuisscherm te gaan.</p><p><a id="bediening"></a>Die draaibare bezel is een gouden vondst en het zou ons niets verbazen als veel fabrikanten die nu in hun ontwikkellabs aan het nabouwen zijn. Het is de intuïtiefste manier van interactie die we in lange tijd zijn tegengekomen en het doet een beetje Apple-achtig aan. Net zoals multitouch op een touchscreen binnen tien seconden logisch overkomt, voelt het werken met de draaibare ring <em>in no time</em> vertrouwd aan.</p><p>Daarbij moeten we Samsung ook een pluim geven voor de uitwerking, want het is juist de implementatie van de details die zo goed is. De ring biedt nét genoeg weerstand en geeft terwijl je draait kleine klikjes, zodat je ook in staat bent om subtiele input te geven. Daarnaast is de software erg responsief, waardoor er een heel directe relatie is tussen de draai die je doet en wat er op het scherm gebeurt. Het maakt werken met de Gear S2 leuk.</p>');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (2, 4, 'Software en integratie', '<p>De keuze voor een compleet nieuwe manier van bedienen betekent dat Samsung geen gebruik kan maken van het Android Wear-besturingssysteem, zoals veel andere smartwatchmakers doen. Google staat het fabrikanten namelijk niet toe de software ingrijpend aan te passen en op dit moment kun je Android Wear alleen via een touchscreen bedienen. Gelukkig had Samsung nog een eigen besturingssysteem op de plank liggen, dat het in het verleden ook al voor smartwatches heeft ingezet: Tizen.</p><p>De basisfunctionaliteit van de Gear S2 is gelijk aan die van andere smartwatches. Hij geeft de tijd weer, je krijgt notificaties van je telefoon door, er kunnen apps op draaien en hij heeft een stappenteller en hartslagmeter voor fitnessdoeleinden. Via een aparte app die je op je telefoon installeert, kun je het horloge voor een deel beheren en bepalen welke apps erop staan en welke notificaties doorkomen. Deze app werkt met elke Android-telefoon die Android 4.4 of hoger draait en meer dan 1,5GB geheugen heeft. iPhones worden niet ondersteund.</p><p><img class="alignCenter border" src="http://ic.tweakimg.net/ext/i/imagenormal/2000895708.jpeg" alt="In Win 805" width="600"></p><p>De versie van Tizen op de Gear S2 is helemaal aangepast voor het ronde scherm en de bediening met de ring. De interface bestaat uit verschillende ronde pagina''s die in een soort virtuele cirkel zijn opgesteld, waarbij de klok het standaardscherm is. Door aan de ring rondom het scherm te draaien navigeer je door die cirkel. Draai je vanaf het klokscherm linksom, dan kom je uit bij je notificaties. Het eerste scherm dat je tegenkomt als je rechtsom draait, is dat met icoontjes voor instellingen en je apps. Draai je verder, dan zie je verschillende widgets, bijvoorbeeld voor de stappenteller, het weer, je agenda en de muziekspeler. Die pagina''s zijn allemaal aan te passen en naar je eigen smaak te rangschikken.</p><p><a id="functies"></a>De keuze voor Tizen betekent wel dat Samsung het zichzelf niet makkelijk maakt wat app-aanbod en integratie betreft. Nog maar weinig fabrikanten vinden het de moeite waard om veel ontwikkeltijd in smartwatch-apps te steken en als ze het al doen, is het voor platforms als Android Wear en de Apple Watch. Samsung heeft daarom zijn best gedaan om zoveel mogelijk functionaliteit zelf al in te bouwen. Zo beschikt de Gear S2 onder andere over een stappenteller, hartslagmeter, stopwatch, muziekspeler, weer-app, agenda, mail-app, belfunctie, sms-app en fotogalerij. Voor een aantal van die functies, zoals de uitgebreide S Health-integratie voor fitness en de mail-app, heb je een Samsung-telefoon nodig.</p><p><a id="integratie"></a>Daarnaast is er al een aantal Nederlandse ontwikkelaars die een app gemaakt hebben. Zo kun je parkeren vanaf je horloge met Parkmobile of nieuws lezen via de NOS of De Telegraaf. De vraag is natuurlijk of je teksten wil lezen op het kleine horlogescherm: wij niet. Bij de apps die je waarschijnlijk wel vaker wil gebruiken, zoals WhatsApp, Telegram of Google Maps, is de integratie redelijk karig. Je kunt notificaties lezen en deze in sommige gevallen beantwoorden, maar daar blijft het dan vaak wel bij. Ook Google Now-integratie zoals bij Android Wear behoort niet tot de mogelijkheden.</p>');

INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (3, 1, 'Inleiding', '<p>De kwaliteit van smartphonecamera''s is in de laatste jaren met sprongen vooruitgegaan. Sensors worden groter, lenzen worden lichtsterker en technieken als optische beeldstabilisatie worden steeds meer gemeengoed. Sommige smartphones hebben zelfs sensors die even groot zijn als die in compactcamera''s en de verkoop van compactcamera''s staat logischerwijs onder druk. Niet alleen kun je met sommige smartphones vrijwel dezelfde kwaliteit verkrijgen, maar dankzij het grote app-aanbod kun je meteen iets met die foto''s doen, zoals plaatsen op sociale media of e-mailen.</p><p>Zijn compactcamera''s dan nergens beter in? Oh jazeker wel. In tegenstelling tot smartphonefabrikanten, vinden fabrikanten van camera''s het minder belangrijk dat hun product zo dun mogelijk is en ze reserveren dus veel meer ruimte voor de cameralens. Vrijwel elke compactcamera heeft dan ook een zoomlens, die uit de body steekt en uitschuift. Daardoor kun je onderwerpen op afstand beter vastleggen. Bij smartphones ben je aangewezen op digitale zoom, waarbij het beeld softwarematig uitvergroot wordt en de beeldkwaliteit afneemt. Er zijn in het verleden smartphonefabrikanten geweest die telefoons uitgebracht hebben met een echte zoomlens, maar dat waren eerder camera''s met telefoonfunctionaliteit dan andersom.</p><p>Asus denkt nu het beste van twee werelden in één product gevat te hebben met de Zenfone Zoom; een telefoon met een 3x-zoomlens, die niet uitsteekt. De Taiwanese fabrikant heeft de Zoom al een paar keer eerder getoond op verschillende beurzen, maar dan altijd achter glas. Met reden, want het bleek nog een forse klus om dit cameraconcept goed werkend te krijgen. Gelukkig is Asus nu zover dat het de telefoon werkend en al durft te tonen. Op de dag voordat de 2016-editie van elektronicabeurs CES losbarstte, begaven wij ons daarom al naar Asus'' demoruimte om de Zenfone Zoom te proberen.</p>');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (3, 2, 'Een minuscule zoomlens met prisma''s', '<p>De camera van de Zenfone Zoom is opgebouwd rond een 13-megapixelsensor van Panasonic, die op papier weinig indruk maakt. Met een formaat van 1/3,06" is de sensor aan de kleine kant en daarnaast is het een <em>front side illuminated-</em>sensor. Die zijn in de regel minder lichtgevoelig dan moderne <em>backside illuminated-</em>sensors, doordat de elektronica voor de fotodiodes zit en niet erachter. Wat dat alles in de praktijk betekent voor de beeldkwaliteit is moeilijk te zeggen. We hebben in Asus'' demoruimte wel wat foto''s gemaakt, maar omdat er vrij weinig licht aanwezig was, zeggen die niet veel.</p><p>Het is de lensconstructie waarmee Asus hoge ogen gooit. In tegenstelling tot een normale smartphonecamera, waarbij de lens boven de sensor zit, zitten lens en sensor bij de Zenfone Zoom tamelijk ver bij elkaar vandaan. Het licht komt de lens binnen, wordt via een prisma negentig graden afgebogen, komt dan langs verschillende lenselementen en eindigt via een tweede prisma bij de beeldsensor.</p><p><a href="http://ic.tweakimg.net/ext/i/2000899117.png" rel="imageviewer"><img src="http://ic.tweakimg.net/ext/i/imagenormal/2000899117.png" alt="Zenfone zoom uitleg" height="158" width="620"></a></p><p>Die middelste lenselementen zijn verbonden met een stappenmotor die de afstand tussen de elementen kan variëren, net als bij een normale zoomlens. Dankzij dit ontwerp hoeft de cameramodule niet veel dikker te zijn dan die van een smartphonecamera zonder zoom, al wordt hij er wel een stuk langer van. Dat is in veel smartphones echter geen probleem, die ruimte is er wel. Met 11,95mm is de telefoon weliswaar wat dikker dan de gemiddelde smartphone, maar het verschil is niet buitensporig en vergeleken met een compactcamera is hij vele malen dunner.</p><p>Asus zegt ongeveer twee jaar bezig te zijn geweest om samen met lensfabrikant Hoya de Zenfone Zoom te ontwikkelen. Vanwege de verschillende bewegende elementen, plus de ingebouwde optische beeldstabilisatie, is het geheel erg complex en gevoelig. Daarom is de module niet zomaar op de pcb geprikt, maar wordt het geheel in de telefoonbehuizing beschermd door een eigen, metalen behuizing.</p><p>Foto''s maken met de Zenfone Zoom gaat niet anders dan bij andere telefoons. Als je wil zoomen, kun je in de camera-app een <em>pinch to zoom-</em>multitouchgebaar gebruiken of je kiest ervoor om de volumeknoppen in te zetten. Leuk detail is dat op deze knoppen een ''w'' voor ''wide'' en een ''t'' voor ''tele'' gegraveerd zijn, net als bij een echte camera. Zoomen gaat niet enorm snel, maar zeker snel genoeg om te voorkomen dat het stoort in het dagelijks gebruik.</p><p><a href="http://ic.tweakimg.net/ext/i/2000899124.jpeg" rel="imageviewer"><img class="alignCenter" src="http://ic.tweakimg.net/ext/i/imagenormal/2000899124.jpeg" alt="Asus Zenfone Zoom" height="281" width="620"></a></p><p>Omgerekend naar kleinbeeldtermen heeft de lens een bereik van 28-84mm, met een diafragma dat loopt van f/2.7 tot f/4.8. Dat is niet bijster lichtsterk. Ter vergelijking: de LG G4 heeft een maximale diafragmaopening van f/1.8 en zal daarom betere foto''s opleveren in situaties met weinig licht.</p>');
INSERT INTO REVIEWPAGINA (REVIEWID, PAGINANR, SUBTITEL, CONTENT) VALUES (3, 3, 'Prima specs en een aparte behuizing', '<p>Een van de in de demoruimte aanwezige Asus-medewerkers wist ons te vertellen dat de fabrikant met het ontwerp probeert het gevoel van een traditionele dslr of systeemcamera op te roepen. Specifiek willen ze dat doen met de achterkant, die voorzien is van een leren textuur, die moet doen denken aan het materiaal waarvan handgrepen op camera''s vaak gemaakt zijn. Leuk bedacht, maar zonder die uitleg hadden we de link waarschijnlijk niet gelegd.</p><p><img width="620px" alt="Asus Zenfone Zoom" src="http://ic.tweakimg.net/ext/i/imagenormal/2000899128.jpeg"></img></p><p>De voorzijde van de 5,5"-telefoon lijkt sterk op die van eerdere Zenfones, met capacitieve knoppen en een geborsteld metalen uiterlijk. De rand is duidelijk anders, met de als zoomknoppen functionerende volumeknoppen, een losse sluiterknop en een klein rond knopje om een video-opname mee te starten. Dat laatste lijkt in de praktijk wat te klein om goed bruikbaar te zijn.</p><p>Op hardwareniveau is de Zoom méér dan alleen een indrukwekkende camera, want Asus lijkt ook op de rest van de hardware niet beknibbeld te hebben. De telefoon wordt aangedreven door een Intel Atom Z3590-soc; een quadcore-soc met een maximale kloksnelheid van 2,5GHz, die bij de Zenfone Zoom gekoppeld is aan maar liefst 4GB werkgeheugen. Ook wat opslag betreft is Asus gul geweest, want het basismodel begint bij 64GB. Dat terwijl er ook nog een micro-sd-slot aanwezig is.</p><p>Het geheel wordt gevoed door een accu met een capaciteit van 3000mAh, die via de meegeleverde snellader binnen veertig minuten tot zestig procent volgeladen kan worden. Al die zaken, samen met het full-hd-ips-scherm van 5,5", maken een indrukwekkende speclijst, zeker als je je bedenkt dat de telefoon slechts 400 euro zal kosten.</p>');

INSERT INTO REVIEW_CATEGORIE (REVIEWID, CATEGORIEID) VALUES (1, 1);
INSERT INTO REVIEW_CATEGORIE (REVIEWID, CATEGORIEID) VALUES (1, 10);

INSERT INTO PRODUCT (NAAM, FOTO, CONTENT) VALUES ('In Win 805 Zwart', 'http://ic.tweakimg.net/ext/i/thumblarge/2000655225.jpeg', 'Type: Tower, Formaat: ATX, Panel: Aluminium en glas');
INSERT INTO PRODUCT (NAAM, FOTO, CONTENT) VALUES ('Samsung UE48JU6000W Zwart', 'http://ic.tweakimg.net/ext/i/thumblarge/2000645068.jpeg', 'Schermdiagonaal 48", Geoptimaliseerde refresh rate 600Hz');
INSERT INTO PRODUCT (NAAM, FOTO, CONTENT) VALUES ('Apple iPhone 6 16GB Grijs', 'http://ic.tweakimg.net/ext/i/thumblarge/2000544428.png', '4,7" display, 4G-support, geen geheugenslot');
INSERT INTO PRODUCT (NAAM, FOTO, CONTENT) VALUES ('Fallout 4, PC (Windows)', 'http://ic.tweakimg.net/ext/i/thumblarge/2000620185.png' ,'RPG game voor Windows, Releasedatum 11 november 2015');
INSERT INTO PRODUCT (NAAM, FOTO, CONTENT) VALUES ('Asus STRIX-GTX980TI-DC3OC-6GD5-GAMING', 'http://ic.tweakimg.net/ext/i/thumblarge/2000630451.jpeg', 'Chipset generatie: GeForce 900-Serie Videochipfabrikant: Nvidia Geheugengrootte: 6GB');

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

INSERT INTO GEBRUIKERSREVIEW(PRODUCTID, AUTEUR, DATUM, SAMENVATTING, CONTENT, BEOORDELING) VALUES (5, 8, TO_DATE('11/09/2015 14:37', 'DD/MM/YYYY HH24:MI'), 'De videokaart is aan de dure kant, alleen je moet niet vergeten dat de videokaart wel de top-class is van de videokaarten. De kaart ziet er enorm goed uit en is ook stil onder full-load met een goede overclock.', 'Ik heb een beetje getest tot hoever ik de videokaart kon overclocken en het is mijn gelukt om een boost van 1477MHz core/3802MHz memory te behalen door alleen de power-limit tot het maximale (109%) te zetten. De videokaart wordt niet warmer dan 74C onder full-load. Af en toe zie je de videokaart naar 1494MHz core schieten, maar dit is maar voor 1-2 seconden en dan clockt de videokaart weer terug naar 1477MHz. Zowel met voltage toe te voegen als zonder kom ik niet hoger dan 1480MHz core stable. Tijdens GTA V 1920*1080 Maxed out zonder MSAA heb ik gemiddeld in de stad 120 FPS en in mijn appartement/garage 140-180. Als we het gaan hebben over de sandy-shores komt de videokaart er ook best goed vanaf. Ik heb gemiddeld 80 FPS in de sandy-shores. Zonder overclock had ik ongeveer 90-110 FPS in de stad en 130-140 FPS in mijn appartement/garage. In de sandy-shores had ik een FPS van gemiddeld 65-70.', 4);

INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (1, 1, 1, TO_DATE('22/10/2015 22:02', 'DD/MM/YYYY HH24:MI'), 'Mooi initiatief, ik hoop dat andere landen dit voorbeeld gaan volgen.');
INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (3, 1, 1, TO_DATE('22/10/2015 21:53', 'DD/MM/YYYY HH24:MI'), 'Jammer dat een land als rusland hiermee voor loopt. Maarja, Nederland draait dan bijvoorbeeld ook nog op kolencentrales.');
INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (1, 1, 4, TO_DATE('22/10/2015 23:49', 'DD/MM/YYYY HH24:MI'), 'Helaas wel de waarheid, ik hoop dat onze overheid meer moeite gaat doen om Nederland echt groen te maken.');
INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (7, 1, 2, TO_DATE('22/10/2015 20:24', 'DD/MM/YYYY HH24:MI'), 'Bij kasten heb ik altijd snel het idee dat over smaak niet te twisten valt. Ik zou deze kast nooit kopen namelijk... Geef mij maar gewoon een recht-toe-recht-aan kast van de meesters van Fractal Design ofzo. Al die ramen hoeven niet meer van mij sinds ik ouder dan 12 ben.');
INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (15, 1, 3, TO_DATE('22/10/2015 20:22', 'DD/MM/YYYY HH24:MI'), 'Duidelijke review, misschien kan je het nog wat aankleden met een paar afbeeldingen!');
INSERT INTO REACTIE(AUTEUR, EXTERNID, REACTIETYPEID, DATUM, CONTENT) VALUES (1, 4, 1, TO_DATE('23/10/2015 20:21', 'DD/MM/YYYY HH24:MI'), 'Er was dan ook een heuse shitstorm onder de community van Payday, blij dat de ontwikkelaars toch nog luisteren.');

COMMIT;

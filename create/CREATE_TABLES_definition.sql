-- Definitionstabellen 

DROP TABLE IF EXISTS development.def_erfasser;
CREATE TABLE IF NOT EXISTS development.def_erfasser
(
 	id integer PRIMARY KEY generated always as identity,
    name text NOT NULL
);

INSERT INTO development.def_Erfasser (name) VALUES 
	('Louise Warnow'),
	('Franz Dietzmann'),
	('Kirsten Krepelin'),
	('Barbara Kuendiger'),
	('Kaja Teschner'),
	('Stefan Krug'),
	('Tanja Trittel')
;

DROP TABLE IF EXISTS development.def_erhaltungszustand;
CREATE TABLE IF NOT EXISTS development.def_erhaltungszustand
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL
);

INSERT INTO development.def_erhaltungszustand (bezeichnung) VALUES 
	('Ruine'),
	('Fragment')
;

DROP TABLE IF EXISTS development.def_kategorie;
CREATE TABLE IF NOT EXISTS development.def_kategorie
(
   id integer PRIMARY KEY generated always as identity,
   bezeichnung text NOT NULL
);

INSERT INTO development.def_kategorie (bezeichnung) VALUES 
	('Kat. 1 - Bergbau'),
	('Kat. 2 - Verstromung'),
	('Kat. 3 - Veredelung'),
	('Kat. 4 - Transport und Infrastruktur'),
	('Kat. 5 - Sozialstrukturen'), 
	('Kat. 6 - Synergie- und Nachfolgeindustrie'), 
	('Kat. 7 - Gelaendestrukturen und Rekultivierung')
;

DROP TABLE IF EXISTS development.def_nachnutzung;
CREATE TABLE IF NOT EXISTS development.def_nachnutzung
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL
);

INSERT INTO development.def_nachnutzung (bezeichnung) VALUES 
	-- in nachnutzung -> retcon?
	('vorhanden'),
	('bedingt vorhanden'),
	('nicht vorhanden')
;

DROP TABLE IF EXISTS development.def_schutzstatus;
CREATE TABLE IF NOT EXISTS development.def_schutzstatus
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL
);

INSERT INTO development.def_schutzstatus (bezeichnung) VALUES 
	('Kulturdenkmal'),
	('Denkmalverdacht')
;

DROP TABLE IF EXISTS development.def_jahresschnitt;
CREATE TABLE IF NOT EXISTS development.def_jahresschnitt
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL
);

INSERT INTO development.def_jahresschnitt (bezeichnung) VALUES 
	('1936-1943'),
	('1989'),
	('2021')
;

DROP TABLE IF EXISTS development.def_nutzungsart;
CREATE TABLE IF NOT EXISTS development.def_nutzungsart
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL
);

INSERT INTO development.def_nutzungsart (bezeichnung) VALUES 
	('Wasser'),
	('Wald'),
	('Naturschutzgebiet'), -- Schraffur
	('Grünflächen'),
	('Landwirtschaft'),
	('Offene Flächen'),
	('Industriegebiet'),
	('Siedlungsfläche'),
	('Verkehr'),
	('Eisenbahn'),
	('Erneuerbare Energien') -- Schraffur
;
-- Definitionstabellen 

DROP TABLE IF EXISTS development.def_erfasser;
CREATE TABLE IF NOT EXISTS development.def_erfasser
(
 	id integer PRIMARY KEY generated always as identity,
    name text NOT NULL,
    sortierung integer
);

INSERT INTO development.def_Erfasser (name, sortierung) VALUES 
	('Louise Warnow', 1),
	('Franz Dietzmann', 2),
	('Kirsten Krepelin', 3),
	('Barbara Kuendiger', 4),
	('Kaja Teschner', 5),
	('Stefan Krug', 6),
	('Tanja Trittel', 7)
;

DROP TABLE IF EXISTS development.def_erhaltungszustand;
CREATE TABLE IF NOT EXISTS development.def_erhaltungszustand
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO development.def_erhaltungszustand (bezeichnung, sortierung) VALUES 
	('Ruine', 1),
	('Fragment', 2)
;

DROP TABLE IF EXISTS development.def_kategorie;
CREATE TABLE IF NOT EXISTS development.def_kategorie
(
   id integer PRIMARY KEY generated always as identity,
   bezeichnung text NOT NULL,
   sortierung integer
);

INSERT INTO development.def_kategorie (bezeichnung, sortierung) VALUES 
	('Kat. 1 - Bergbau', 1),
	('Kat. 2 - Kraftwerke (Verstromung, Fernwärme)', 2),
	('Kat. 3 - Veredelung', 3),
	('Kat. 4 - Technische Infrastruktur', 4),
	('Kat. 5 - Sozialstrukturen', 5), 
	('Kat. 6 - Folgeindustrie', 6), 
	('Kat. 7 - Gelaendestrukturen und Rekultivierung', 7)
	('kein Braunkohlebezug', 8)
;

DROP TABLE IF EXISTS development.def_nachnutzung;
CREATE TABLE IF NOT EXISTS development.def_nachnutzung
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO development.def_nachnutzung (bezeichnung, sortierung) VALUES 
	-- in nachnutzung -> retcon?
	('vorhanden', 1),
	-- ('bedingt vorhanden', 2),
	('zur Nachnutzung empfohlen', 2),
	('in Nutzung', 3),
	('nicht vorhanden', 4)
;

DROP TABLE IF EXISTS development.def_schutzstatus;
CREATE TABLE IF NOT EXISTS development.def_schutzstatus
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO development.def_schutzstatus (bezeichnung, sortierung) VALUES 
	('Kulturdenkmal', 1),
	('Denkmalverdacht', 2)
;

DROP TABLE IF EXISTS development.def_jahresschnitt;
CREATE TABLE IF NOT EXISTS development.def_jahresschnitt
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO development.def_jahresschnitt (bezeichnung, sortierung) VALUES 
	('1936-1943', 1),
	('1989', 2),
	('2021', 3)
;

DROP TABLE IF EXISTS development.def_nutzungsart;
CREATE TABLE IF NOT EXISTS development.def_nutzungsart
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO development.def_nutzungsart (bezeichnung, sortierung) VALUES 
	('Wasser', 1),
	('Wald', 2),
	('Naturschutzgebiet', 3), -- Schraffur
	('Grünflächen', 4),
	('Landwirtschaft', 5),
	('Offene Flächen', 6),
	('Industriegebiet', 7),
	('Siedlungsfläche', 8),
	('Verkehr', 9),
	('Eisenbahn', 10),
	('Erneuerbare Energien', 11) -- Schraffur
;
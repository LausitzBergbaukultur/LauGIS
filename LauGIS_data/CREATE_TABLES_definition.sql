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

--------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS development.def_kategorie;
CREATE TABLE IF NOT EXISTS development.def_kategorie
(
   id integer PRIMARY KEY generated always as identity,
   bezeichnung text NOT NULL,
   sortierung integer
);

INSERT INTO development.def_kategorie (bezeichnung, sortierung) VALUES 
	('Kat. 1 - Bergbau', 1),
	('Kat. 2 - Energieerzeugung', 2),
	('Kat. 3 - Veredelung', 3),
	('Kat. 4 - Technische Infrastruktur', 4),
	('Kat. 5 - Sozialstrukturen', 5), 
	('Kat. 6 - Begleit- und Folgeindustrie', 6), 
	('Kat. 7 - Gelaendestrukturen und Rekultivierung', 7)
	('kein Braunkohlebezug', 8)
;

--------------------------------------------------------------------------------------

-- obsolet
/* DROP TABLE IF EXISTS development.def_nachnutzung;
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
;*/

--------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------

# Beschreibt die Ereignisarten der Datierungen
DROP TABLE IF EXISTS development.def_datierung;
CREATE TABLE IF NOT EXISTS development.def_datierung
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO development.def_datierung (bezeichnung, sortierung) VALUES 
	('Abbruch', 1),
	('Abteufung', 2),
	('Aufstellung', 3),
	('Ausführung', 4),
	('Baujahr', 5),
	('Brand', 6),
	('Entstehung', 7),
	('Erbauung', 8),
	('Errichtung', 9),
	('Erweiterung', 10),
	('Flutung', 11),
	('Grundsteinlegung', 12),
	('Gründung', 13),
	('Neubau', 14),
	('Ortsabbruch', 15),
	('Planung', 16),
	('Restaurierung', 17),
	('Rückbau', 18),
	('Sanierung', 19),
	('Teilabbruch', 20),
	('Teilrückbau', 21),
	('Translozierung', 22),
	('Umbau', 22),
	('Umsiedlung', 23),
	('Veränderung', 24),
	('Verfüllung', 25),
	('Wiederaufbau', 26),
	('Teilortsabbruch', 27),
	('FREITEXT', 999)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS development.def_material;
CREATE TABLE IF NOT EXISTS development.def_material
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO development.def_material (bezeichnung, sortierung) VALUES 
('Aluminium', 1),
('Beton', 2),
('Betonziegel', 3),
('Bimsbeton', 4),
('Blei', 5),
('Bruchstein', 6),
('Edelstahl', 7),
('Findling', 8),
('Fliese', 9),
('GFK', 10),
('Glas', 11),
('Glasbaustein', 12),
('Glasfasergewebe', 13),
('Granit', 14),
('Gussbeton', 15),
('Gusseisen', 16),
('Gussstahl', 17),
('Hecke', 18),
('Hochdruckschichtpressstoffplatte', 19),
('Holz', 20),
('Kalksandstein', 21),
('Kalkstein', 22),
('Kalktuff', 23),
('Keramik', 24),
('Klinker', 25),
('Kunststein', 26),
('Kupfer', 27),
('Kupferblech', 28),
('Lehm', 29),
('Lehmstrohwickel', 30),
('Lehmziegel', 31),
('Leichtbeton', 32),
('Lesestein', 33),
('Marmor', 34),
('Muschelkalk', 35),
('Naturstein', 36),
('Porphyr', 37),
('Porzellan', 38),
('Raseneisenstein', 39),
('Sandstein', 40),
('Schiefer', 41),
('Schlackestein', 42),
('Schmiedeeisen', 43),
('Stahl', 44),
('Stahlbeton', 45),
('Stahlblech', 46), 
('Stahlplatte', 47),
('Stahlseil', 48),
('Stahlträger', 49),
('Stampfbeton', 50),
('Terrakotta', 51),
('Ton', 52),
('Travertin', 53),
('Wellblech', 54),
('Ziegel', 55),
('Zinkblech', 56),
('Zinkguss', 57),
('Putz', 58),
('Gehölze', 59),
('Stauden / Wechselflor', 60),
('Rasen / Wiese', 61),
('Asphalt', 62),
('Kies / Sand', 63),
('Wasser', 64),
('Bronze', 65),
('Feldstein', 66)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS development.def_personen;
CREATE TABLE IF NOT EXISTS development.def_personen
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    is_ausführend bool,
    sortierung integer
);

INSERT INTO development.def_personen (bezeichnung, is_ausführend, sortierung) VALUES 
('Architekt:in', false, 1),
('Architekturbüro', false, 2),
('Auftraggeber:in', false, 3),
('Ausführung', true, 4),
('Bauausführung', true, 5),
('Bauherr:in', false, 6),
('Umbau', true, 7),
('Planung', false, 8),
('Projektpartner:in', false, 9),
('Bauleitung', false, 10),
('Baumeister:in', true, 11),
('Bauunternehmer:in', false, 12),
('Eigentümer:in', false, 13),	
('Betreiber:in', false, 14),
('Entwurf', false, 15),
('Projektleitung', false, 16),
('Unterstützer:in', false, 17),
('FREITEXT', null, 999)
;
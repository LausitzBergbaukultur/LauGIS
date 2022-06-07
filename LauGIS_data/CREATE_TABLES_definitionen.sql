-- Definitionstabellen 

DROP TABLE IF EXISTS laugis.def_erfasser;
CREATE TABLE IF NOT EXISTS laugis.def_erfasser
(
 	id integer PRIMARY KEY generated always as identity,
    name text NOT NULL,
    sortierung integer,
    username text
);

INSERT INTO laugis.def_Erfasser (name, sortierung, username) VALUES 
	('Louise Warnow', 1, 'lwarnow'),
	('Franz Dietzmann', 2, 'fdietzmann'),
	('Kirsten Krepelin', 3, 'kkrepelin'),
	('Barbara Kuendiger', 4, 'bkuendiger'),
	('Kaja Teschner', 5, 'kteschner'),
	('Stefan Krug', 6, 'skrug'),
	('Tanja Trittel', 7, 'ttrittel')
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_kategorie;
CREATE TABLE IF NOT EXISTS laugis.def_kategorie
(
   id integer PRIMARY KEY generated always as identity,
   bezeichnung text NOT NULL,
   sortierung integer
);

INSERT INTO laugis.def_kategorie (bezeichnung, sortierung) VALUES 
	('Kat. 1 - Bergbau', 1),
	('Kat. 2 - Energieerzeugung', 2),
	('Kat. 3 - Veredelung', 3),
	('Kat. 4 - Technische Infrastruktur', 4),
	('Kat. 5 - Sozialstrukturen', 5), 
	('Kat. 6 - Begleit- und Folgeindustrie', 6), 
	('Kat. 7 - Gelaendestrukturen und Rekultivierung', 7),
	('kein Braunkohlebezug', 8)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_schutzstatus;
CREATE TABLE IF NOT EXISTS laugis.def_schutzstatus
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_schutzstatus (bezeichnung, sortierung) VALUES 
	('Kulturdenkmal', 1),
	('Denkmalverdacht', 2)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_jahresschnitt;
CREATE TABLE IF NOT EXISTS laugis.def_jahresschnitt
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_jahresschnitt (bezeichnung, sortierung) VALUES 
	('1936-1943', 1),
	('1989', 2),
	('2021', 3)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_nutzungsart;
CREATE TABLE IF NOT EXISTS laugis.def_nutzungsart
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_nutzungsart (bezeichnung, sortierung) VALUES 
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

-- # Beschreibt die Ereignisarten der Datierungen
DROP TABLE IF EXISTS laugis.def_datierung;
CREATE TABLE IF NOT EXISTS laugis.def_datierung
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_datierung (bezeichnung, sortierung) VALUES 
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
	('Produktion', 17),
	('Restaurierung', 18),
	('Rückbau', 19),
	('Sanierung', 20),
	('Stilllegung', 21),
	('Teilabbruch', 22),
	('Teilrückbau', 23),
	('Teilortsabbruch', 24),
	('Translozierung', 25),
	('Umbau', 26),
	('Umsiedlung', 27),
	('Veränderung', 28),
	('Verfüllung', 29),
	('Wiederaufbau', 30),
	('FREITEXT', 999)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_material;
CREATE TABLE IF NOT EXISTS laugis.def_material
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_material (bezeichnung, sortierung) VALUES 
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
('Feldstein', 66),
('FREITEXT', 999)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_personen;
CREATE TABLE IF NOT EXISTS laugis.def_personen
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    is_ausfuehrend bool,
    sortierung integer
);

INSERT INTO laugis.def_personen (bezeichnung, is_ausfuehrend, sortierung) VALUES 
('Architekt:in', false, 1),
('Architekturbüro', false, 2),
('Auftraggeber:in', false, 3),
('Ausführung', true, 4),
('Bauausführung', true, 5),
('Bauherr:in', false, 6),
('Hersteller', true, 7),
('Umbau', true, 8),
('Planung', false, 9),
('Projektpartner:in', false, 10),
('Bauleitung', false, 11),
('Baumeister:in', true, 12),
('Bauunternehmer:in', false, 13),
('Eigentümer:in', false, 14),	
('Betreiber:in', false, 15),
('Entwurf', false, 16),
('Projektleitung', false, 17),
('Unterstützer:in', false, 18),
('FREITEXT', null, 999)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_blickbeziehung;
CREATE TABLE IF NOT EXISTS laugis.def_blickbeziehung
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_blickbeziehung (bezeichnung, sortierung) VALUES 
	('gerichtet', 1),
	('ungerichtet', 2)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_bearbeitung;
CREATE TABLE IF NOT EXISTS laugis.def_bearbeitung
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_bearbeitung (bezeichnung, sortierung) VALUES 
	('in Bearbeitung', 1),
	('in Prüfung', 2),
	('abgeschlossen', 3)
;

--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_dachform;
CREATE TABLE IF NOT EXISTS laugis.def_dachform
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_dachform (bezeichnung, sortierung) VALUES
('Berliner Dach', 1),
('Bogendach', 2),
('Faltdach', 3),
('Flachdach', 4),
('Fußwalm', 5),
('Giebelwalm', 6),
('Glockendach', 7),
('Halbkegeldach', 8),
('Halbwalmdach', 9),
('Kegeldach', 10),
('Kopfwalm', 11),
('Kreuzdach', 12),
('Krüppelwalmdach', 13),
('Kuppeldach', 14),
('Mansarddach', 15),
('Mansarddach mit Schopf', 16),
('Mansardgiebeldach', 17),
('Mansardwalmdach', 18),
('Pagodendach', 19),
('Pultdach', 20),
('Pyramidendach', 21),
('Satteldach', 22),
('Satteldach (geschweift)', 23),
('Schalendach', 24),
('Schleppdach', 25),
('Schmetterlingsdach', 26),
('Schopfwalm', 27),
('Schweifhaube', 28),
('Sheddach', 29),
('Terrassendach', 30),
('Tonnendach', 31),
('Walmdach', 32),
('Walmdach (geschweift)', 33),
('Wellendach', 34),
('Zeltdach', 35),
('FREITEXT', 999)
;
--------------------------------------------------------------------------------------

DROP TABLE IF EXISTS laugis.def_konstruktion;
CREATE TABLE IF NOT EXISTS laugis.def_konstruktion
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL,
    sortierung integer
);

INSERT INTO laugis.def_konstruktion (bezeichnung, sortierung) VALUES
('Binderkonstruktion', 1),
('Blockbauweise', 2),
('Blockbohlenbauweise', 3),
('Blockständerbauweise', 4),
('Fachwerk', 5),
('Fertigbauweise', 6),
('Gitterbinderkonstruktion', 7),
('Gitterträgerkonstruktion', 8),
('Großblockbauweise', 9),
('Hypar-Schalenkonstruktion', 10),
('Lehmstampfbauweise', 11),
('Massivbauweise', 12),
('Montagebauweise', 13),
('Plattenbauweise', 14),
('Plattenbauweise Typ P2', 15),
('Plattenbauweise Typ Q6', 16),
('Rahmenbauweise', 17),
('Rahmenbinderkonstruktion', 18),
('Schalenkonstruktion', 19),
('Schottenbauweise', 20),
('Skelettbauweise', 21),
('Spannbetonkonstruktion', 22),
('Stabknotenfachwerk', 23),
('Gleitbauweise', 24),
('Stahlfachwerk', 25),
('Lammellenkonstruktion', 26),
('Ständerbauweise', 27),
('Tafelbauweise', 28),
('Umgebinde', 29),
('Wandständerbauweise', 30),
('Ständerkonstruktion', 31),
('Gerüstbauweise', 32),
('Hohlkastenkonstruktion', 33),
('FREITEXT', 999)
;
--------------------------------------------------------------------------------------
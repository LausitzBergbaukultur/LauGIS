/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-05-25
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Create & insert statements for all base data tables.
Call by:            -
Affected tables:	
Used By:            most tables and functions
Parameters:			none
***************************************************************************************************/
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
	('Kaja Boelcke', 5, 'kteschner'),
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
	('Denkmalvermutung', 2)
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
	('1846', 1),
	('1936-1943', 2),
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

-- Erweiterung Nutzungsart um Hierarchisierung
ALTER TABLE IF EXISTS laugis.def_nutzungsart
    ADD COLUMN uebergeordnet smallint,
    ADD CONSTRAINT "fkey uebernutzungsart" FOREIGN KEY (uebergeordnet)
    REFERENCES laugis.def_nutzungsart (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

UPDATE laugis.def_nutzungsart
	SET uebergeordnet = id;

INSERT INTO laugis.def_nutzungsart (bezeichnung, uebergeordnet) VALUES 
	('Mischwald', 2),
	('Laubwald', 2),
	('Nadelwald', 2),
	('Weidefläche', 4),
	('Garten, Parkanlage', 4),
	('Unland (Sümpfe, Moore)', 4),
	('Baumschule', 5),
	('Obtsanbau', 5),
	('Weinbau', 5),
	('Tagebau', 6)
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

INSERT INTO laugis.def_datierung (bezeichnung, sortierung) VALUES 
('Aufschluss', 31),
('Abbau', 32),
('Entwässerung', 33);

UPDATE laugis.def_datierung
SET sortierung = 1
WHERE id = 33;

UPDATE laugis.def_datierung
SET sortierung = 2
WHERE id = 1;

UPDATE laugis.def_datierung
SET sortierung = 3
WHERE id = 2;

UPDATE laugis.def_datierung
SET sortierung = 4
WHERE id = 32;

UPDATE laugis.def_datierung
SET sortierung = 5
WHERE id = 3;

UPDATE laugis.def_datierung
SET sortierung = 6
WHERE id = 4;

UPDATE laugis.def_datierung
SET sortierung = 7
WHERE id = 5;

UPDATE laugis.def_datierung
SET sortierung = 8
WHERE id = 6;

UPDATE laugis.def_datierung
SET sortierung = 9
WHERE id = 7;

UPDATE laugis.def_datierung
SET sortierung = 10
WHERE id = 34;

UPDATE laugis.def_datierung
SET sortierung = 11
WHERE id = 8;

UPDATE laugis.def_datierung
SET sortierung = 12
WHERE id = 9;

UPDATE laugis.def_datierung
SET sortierung = 13
WHERE id = 10;

UPDATE laugis.def_datierung
SET sortierung = 14
WHERE id = 11;

UPDATE laugis.def_datierung
SET sortierung = 15
WHERE id = 12;

UPDATE laugis.def_datierung
SET sortierung = 16
WHERE id = 13;

UPDATE laugis.def_datierung
SET sortierung = 17
WHERE id = 14;

UPDATE laugis.def_datierung
SET sortierung = 18
WHERE id = 15;

UPDATE laugis.def_datierung
SET sortierung = 19
WHERE id = 16;

UPDATE laugis.def_datierung
SET sortierung = 20
WHERE id = 17;

UPDATE laugis.def_datierung
SET sortierung = 21
WHERE id = 18;

UPDATE laugis.def_datierung
SET sortierung = 22
WHERE id = 19;

UPDATE laugis.def_datierung
SET sortierung = 23
WHERE id = 20;

UPDATE laugis.def_datierung
SET sortierung = 24
WHERE id = 21;

UPDATE laugis.def_datierung
SET sortierung = 25
WHERE id = 22;

UPDATE laugis.def_datierung
SET sortierung = 26
WHERE id = 24;

UPDATE laugis.def_datierung
SET sortierung = 27
WHERE id = 23;

UPDATE laugis.def_datierung
SET sortierung = 28
WHERE id = 25;

UPDATE laugis.def_datierung
SET sortierung = 29
WHERE id = 26;

UPDATE laugis.def_datierung
SET sortierung = 30
WHERE id = 27;

UPDATE laugis.def_datierung
SET sortierung = 31
WHERE id = 28;

UPDATE laugis.def_datierung
SET sortierung = 32
WHERE id = 29;

UPDATE laugis.def_datierung
SET sortierung = 33
WHERE id = 30;

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

UPDATE laugis.def_material
SET sortierung = 1
WHERE id = 1;

UPDATE laugis.def_material
SET sortierung = 2
WHERE id = 62;

UPDATE laugis.def_material
SET sortierung = 3
WHERE id = 2;

UPDATE laugis.def_material
SET sortierung = 4
WHERE id = 3;

UPDATE laugis.def_material
SET sortierung = 5
WHERE id = 4;

UPDATE laugis.def_material
SET sortierung = 6
WHERE id = 5;

UPDATE laugis.def_material
SET sortierung = 7
WHERE id = 65;

UPDATE laugis.def_material
SET sortierung = 8
WHERE id = 6;

UPDATE laugis.def_material
SET sortierung = 9
WHERE id = 7;

UPDATE laugis.def_material
SET sortierung = 10
WHERE id = 66;

UPDATE laugis.def_material
SET sortierung = 11
WHERE id = 8;

UPDATE laugis.def_material
SET sortierung = 12
WHERE id = 9;

UPDATE laugis.def_material
SET sortierung = 999
WHERE id = 67;

UPDATE laugis.def_material
SET sortierung = 14
WHERE id = 59;

UPDATE laugis.def_material
SET sortierung = 15
WHERE id = 10;

UPDATE laugis.def_material
SET sortierung = 16
WHERE id = 11;

UPDATE laugis.def_material
SET sortierung = 17
WHERE id = 12;

UPDATE laugis.def_material
SET sortierung = 17
WHERE id = 13;

UPDATE laugis.def_material
SET sortierung = 18
WHERE id = 14;

UPDATE laugis.def_material
SET sortierung = 19
WHERE id = 15;

UPDATE laugis.def_material
SET sortierung = 20
WHERE id = 16;

UPDATE laugis.def_material
SET sortierung = 21
WHERE id = 17;

UPDATE laugis.def_material
SET sortierung = 22
WHERE id = 18;

UPDATE laugis.def_material
SET sortierung = 23
WHERE id = 19;

UPDATE laugis.def_material
SET sortierung = 24
WHERE id = 20;

UPDATE laugis.def_material
SET sortierung = 25
WHERE id = 21;

UPDATE laugis.def_material
SET sortierung = 26
WHERE id = 22;

UPDATE laugis.def_material
SET sortierung = 27
WHERE id = 23;

UPDATE laugis.def_material
SET sortierung = 28
WHERE id = 24;

UPDATE laugis.def_material
SET sortierung = 29
WHERE id = 63;

UPDATE laugis.def_material
SET sortierung = 30
WHERE id = 25;

UPDATE laugis.def_material
SET sortierung = 31
WHERE id = 26;

UPDATE laugis.def_material
SET sortierung = 32
WHERE id = 27;

UPDATE laugis.def_material
SET sortierung = 33
WHERE id = 28;

UPDATE laugis.def_material
SET sortierung = 34
WHERE id = 29;

UPDATE laugis.def_material
SET sortierung = 35
WHERE id = 30;

UPDATE laugis.def_material
SET sortierung = 36
WHERE id = 31;

UPDATE laugis.def_material
SET sortierung = 37
WHERE id = 32;

UPDATE laugis.def_material
SET sortierung = 38
WHERE id = 33;

UPDATE laugis.def_material
SET sortierung = 39
WHERE id = 34;

UPDATE laugis.def_material
SET sortierung = 40
WHERE id = 35;

UPDATE laugis.def_material
SET sortierung = 41
WHERE id = 36;

UPDATE laugis.def_material
SET sortierung = 42
WHERE id = 37;

UPDATE laugis.def_material
SET sortierung = 43
WHERE id = 38;

UPDATE laugis.def_material
SET sortierung = 44
WHERE id = 58;

UPDATE laugis.def_material
SET sortierung = 45
WHERE id = 39;

UPDATE laugis.def_material
SET sortierung = 46
WHERE id = 61;

UPDATE laugis.def_material
SET sortierung = 47
WHERE id = 40;

UPDATE laugis.def_material
SET sortierung = 48
WHERE id = 41;

UPDATE laugis.def_material
SET sortierung = 49
WHERE id = 42;

UPDATE laugis.def_material
SET sortierung = 50
WHERE id = 43;

UPDATE laugis.def_material
SET sortierung = 51
WHERE id = 44;

UPDATE laugis.def_material
SET sortierung = 52
WHERE id = 45;

UPDATE laugis.def_material
SET sortierung = 53
WHERE id = 46;

UPDATE laugis.def_material
SET sortierung = 54
WHERE id = 47;

UPDATE laugis.def_material
SET sortierung = 55
WHERE id = 48;

UPDATE laugis.def_material
SET sortierung = 56
WHERE id = 49;

UPDATE laugis.def_material
SET sortierung = 57
WHERE id = 50;

UPDATE laugis.def_material
SET sortierung = 58
WHERE id = 60;

UPDATE laugis.def_material
SET sortierung = 59
WHERE id = 51;

UPDATE laugis.def_material
SET sortierung = 60
WHERE id = 52;

UPDATE laugis.def_material
SET sortierung = 61
WHERE id = 53;

UPDATE laugis.def_material
SET sortierung = 62
WHERE id = 64;

UPDATE laugis.def_material
SET sortierung = 63
WHERE id = 54;

UPDATE laugis.def_material
SET sortierung = 64
WHERE id = 55;

UPDATE laugis.def_material
SET sortierung = 65
WHERE id = 56;

UPDATE laugis.def_material
SET sortierung = 66
WHERE id = 57;

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


UPDATE laugis.def_personen
SET sortierung = 1
WHERE id = 1;

UPDATE laugis.def_personen
SET sortierung = 2
WHERE id = 2;

UPDATE laugis.def_personen
SET sortierung = 3
WHERE id = 3;

UPDATE laugis.def_personen
SET sortierung = 4
WHERE id = 4;

UPDATE laugis.def_personen
SET sortierung = 5
WHERE id = 5;

UPDATE laugis.def_personen
SET sortierung = 6
WHERE id = 6;

UPDATE laugis.def_personen
SET sortierung = 7
WHERE id = 11;

UPDATE laugis.def_personen
SET sortierung = 8
WHERE id = 12;

UPDATE laugis.def_personen
SET sortierung = 9
WHERE id = 13;

UPDATE laugis.def_personen
SET sortierung = 10
WHERE id = 15;

UPDATE laugis.def_personen
SET sortierung = 11
WHERE id = 14;

UPDATE laugis.def_personen
SET sortierung = 12
WHERE id = 16;

UPDATE laugis.def_personen
SET sortierung = 13
WHERE id = 7;

UPDATE laugis.def_personen
SET sortierung = 14
WHERE id = 9;

UPDATE laugis.def_personen
SET sortierung = 15
WHERE id = 17;

UPDATE laugis.def_personen
SET sortierung = 16
WHERE id = 10;

UPDATE laugis.def_personen
SET sortierung = 17
WHERE id = 8;

UPDATE laugis.def_personen
SET sortierung = 18
WHERE id = 18;

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
	('ungerichtet', 2),
	('undefiniert', 3)
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
	('in Prüfung', 3),
	('abgeschlossen', 4),
	('zur Prüfung freigegeben', 2),
	('in Korrektur', 5),
	('Rückfrage', 6),
	('korrigiert', 7);
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

-- Beschreibt die Quellengrundlagen, die in obj_lwk referenziert werden.
-- Über den Verweis auf def_jahresschnitt werden über rel_grundlage implizit Zuordnungen zu den Jahresschnitten getroffen.

DROP TABLE IF EXISTS laugis.rel_grundlage;
CREATE TABLE IF NOT EXISTS laugis.rel_grundlage
(
 	id integer PRIMARY KEY generated always as identity,
	bezeichnung text NOT NULL,
	autorschaft text,
	herkunft text,
	zeitraum text,
	jahresschnitt integer, --fk
	erstellt text,
	kommentar text,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_jahresschnitt_id FOREIGN KEY (jahresschnitt)
    REFERENCES laugis.def_jahresschnitt (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

INSERT INTO laugis.rel_grundlage (bezeichnung, autorschaft, herkunft, zeitraum, jahresschnitt, erstellt, kommentar) VALUES 
	('Landnutzung 1846', 'Lausitzer und Mitteldeutsche Bergbau-Verwaltungsgesellschaft mbH', 'Preußische Ur-Messtischblätter (1822-1872); Topographische Karte des Deutschen Reiches (1877-1921); Quadratmeilenblätter (1816-1821)','1846', 1, '2021',NULL),
	('Karte des Deutschen Reiches 1:25 000 – Messtischblatt / DR Messtischblätter 25', 'Landesvermessung und Geobasisinformation Brandenburg (LGB)', NULL, 'um 1945', 2, 'Erstellung 31.12.1919; Aktualisierung 31.12.1949', '© GeoBasis-DE/LGB, dl-de/by-2-0'),
	('Datensatz ''Tatsächliche Nutzung'' des Amtlichen Liegenschaftskatasterinformationssystems (ALKIS-Daten)ALKIS', 'LGB (Landesvermessung und Geobasisinformation Brandenburg)', NULL, '2021', 3, '28.02.2013, kontinuierliche Aktualisierung', '© GeoBasis-DE/LGB, dl-de/by-2-0')
;

--------------------------------------------------------------------------------------

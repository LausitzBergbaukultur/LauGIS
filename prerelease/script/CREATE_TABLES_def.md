# Definitionstabellen 

Definitionstabellen sind stets vor Inhaltstabellen anzulegen. -> Sicherstellung FK-Constraints.

## def	Erfasser

```SQL
DROP TABLE def_Erfasser;

CREATE TABLE def_Erfasser
(
 	id integer PRIMARY KEY generated always as identity,
    Name text NOT NULL
);

INSERT INTO def_Erfasser (Name) VALUES 
	('Louise Warnow'),
	('Franz Dietzmann'),
	('Kirsten Krepelin'),
	('Barbara Kuendiger'),
	('Kaja Teschner'),
	('Stefan Krug'),
	('Tanja Trittel')
;
```

## def	Erhaltungszustand

```SQL
CREATE TABLE IF NOT EXISTS "def_Erhaltungszustand"
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL
);

INSERT INTO def_Erhaltungszustand (bezeichnung) VALUES 
	('Ruine'),
	('Fragment')
;
```

## def	Kategorie

```SQL
DROP TABLE def_Kategorie;

CREATE TABLE def_Kategorie
(
   id integer PRIMARY KEY generated always as identity,
   Bezeichnung text NOT NULL
);

INSERT INTO def_Kategorie (Bezeichnung) VALUES 
	('Kat. 1 - Bergbau'),
	('Kat. 2 - Veredelung'),
	('Kat. 3 - Verstromung'),
	('Kat. 4 - Transport und Infrastruktur'),
	('Kat. 5 - Sozialstrukturen'), 
	('Kat. 6 - Synergie- und Nachfolgeindustrie'), 
	('Kat. 7 - Gelaendestrukturen und Rekultivierung')
;
```

## def	Nachnutzung

```SQL
DROP TABLE def_Nachnutzung;

CREATE TABLE def_Nachnutzung
(
 	id integer PRIMARY KEY generated always as identity,
    Bezeichnung text NOT NULL
);

INSERT INTO def_Nachnutzung (Bezeichnung) VALUES 
	-- in nachnutzung -> retcon?
	('vorhanden'),
	('bedingt vorhanden'),
	('nicht vorhanden')
;
```

## def	Schutzstatus

```SQL
DROP TABLE def_Schutzstatus;

CREATE TABLE def_Schutzstatus
(
 	id integer PRIMARY KEY generated always as identity,
    Bezeichnung text NOT NULL
);

INSERT INTO def_Schutzstatus (Bezeichnung) VALUES 
	('Kulturdenkmal'),
	('Denkmalverdacht')
;
```

## def	Jahresschnitt

```SQL
CREATE TABLE IF NOT EXISTS "def_Jahresschnitt"
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL
);

INSERT INTO "def_Jahresschnitt" (bezeichnung) VALUES 
	('1936-1943'),
	('1989'),
	('2021')
;
```

## def	Nutzungsart

```SQL
CREATE TABLE IF NOT EXISTS "def_Nutzungsart"
(
 	id integer PRIMARY KEY generated always as identity,
    bezeichnung text NOT NULL
);

INSERT INTO "def_Nutzungsart" (bezeichnung) VALUES 
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
```

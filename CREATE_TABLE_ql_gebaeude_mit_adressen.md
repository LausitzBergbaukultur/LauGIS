# Quelle: Gebäude mit Adressen

```SQL
DROP TABLE IF EXISTS "Quellen"."ql_gebaeude_mit_adressen";

CREATE TABLE IF NOT EXISTS "Quellen"."ql_gebaeude_mit_adressen"
( 	
    -- Identifikatoren
    in_bearbeitung bool,			-- default 1
    objekt_nr text,					-- 5000 FKEY ref_Objektnummer
	sachbegriff text,				-- 5230 TODO ref
	bezeichnung text,				-- 9990
    bauwerksname_eigenname text, 	-- 5202
	kategorie smallint,				-- FKEY def_Kategorie, NOT NULL
	datierung text,					-- 5060
    ref_objektbereich smallint,		-- FKEY objektbereich, IS NULL
    
    -- Deskriptoren
    grundriss text,					-- 5244 TODO ref
	geschosszahl smallint,			-- 5390
	achsenzahl smallint,			-- 5392
	dachform text,					-- 5910 TODO ref
	material text,					-- 5280 TODO ref
	konstruktion_technik text,		-- 5300 TODO ref
    beschreibung text,				-- 9980
    blickbeziehung text,
    notiz_intern text,				-- 9984 '9980 = Kommentar'
    
    -- Bewertung
    erhaltungszustand smallint,		-- 5210 FKEY def_Erhaltungszustand
	schutzstatus smallint,			-- FKEY def_Schutzstatus
	funktion text,					-- 5231 gefüllt aus gebaeudefu
    nachnutzungspotential smallint,	-- FKEY def_Nachnutzung
	quellen_literatur text,			-- 8330
    
	-- Personen
    Person_werk text,				-- ob30
	Soziet_werk text,				-- ob35
	Person_verantw text,			-- ob40
	Soziet_verantw text,			-- ob45
    
    -- Lokalisatoren
    kreis text,						-- 5098
	gemeinde text,					-- 5100
	ort text, 						-- 5108 gefüllt aus postort
	sorbisch text,					-- 5115
	strasse text, 					-- 5116 gefüllt aus strname
	hausnummer text,				-- 5117 gefüllt aus hsnr
	gem_flur text,					-- 5120
	lage_beschreibung text,			-- 5125
    bilder text,					-- 99PI
    
	-- Metadaten
    erfassung smallint,				-- 9582 FKEY def_Erfasser
	erfassungsdatum date,			-- 9580
	aenderungsdatum date,			-- 9950
    hida_nr int,					-- 5000
    
    -- Shape und PK
    id integer PRIMARY KEY generated always as identity, -- PK
   	geom geometry(MultiPolygon, 25833),
    
    -- ueberzaehliges aus der Ursprungstabelle
    kreisschlu text,
    gemeindesc text,
    plz text,
    ort_alt text,					-- ehemals ort
    ortstext text,
    zupostort text,
    postortstr text,
    objekthoeh text    
);
```
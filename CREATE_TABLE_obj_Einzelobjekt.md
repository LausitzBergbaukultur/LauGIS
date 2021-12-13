# Objekt: Einzelobjekt (Multipoligon / Linie)

Beschreibt ein einzelnes Einzelobjekten oder eine gleichartige Gruppe. Übergeordnete Objektbereiche werden durch Verweis (ref_Objektbereich) verknüpft.

```SQL
SET search_path TO "Erfassung",public;
-- OR
SET search_path TO "Entwicklung",public;
```

```SQL
-- DROP TABLE "obj_Einzelobjekt";
-- DROP TABLE "obj_Einzelobjekt_line";

CREATE TABLE IF NOT EXISTS "obj_Einzelobjekt"
-- CREATE TABLE IF NOT EXISTS "obj_Einzelobjekt_line" -- NB geom!
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
	funktion text,					-- 5231 (unter Vorbehalt)
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
	ort text, 						-- 5108
	sorbisch text,					-- 5115
	strasse text, 					-- 5116
	hausnummer text,				-- 5117
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
    -- geom geometry(MultiLinestring, 25833),
    
    -- constraints
    -- mangels Eindeutigkeit der Tabelle (Polygon/Line) nicht anwendbar
    -- CONSTRAINT fkey_obj_Objektbereich FOREIGN KEY (ref_objektbereich)
    	-- REFERENCES "obj_Objektbereich" (id) MATCH SIMPLE
		-- ON UPDATE NO ACTION
        -- ON DELETE NO ACTION,
    CONSTRAINT fkey_objekt_nr FOREIGN KEY (objekt_nr)
        REFERENCES "ref_Objektnummer" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
    CONSTRAINT fkey_erfasser FOREIGN KEY (erfassung)
        REFERENCES "def_Erfasser" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fkey_erhaltungszustand FOREIGN KEY (erhaltungszustand)
        REFERENCES "def_Erhaltungszustand" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fkey_kategorie FOREIGN KEY (kategorie)
        REFERENCES "def_Kategorie" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fkey_nachnutzung FOREIGN KEY (nachnutzungspotential)
        REFERENCES "def_Nachnutzung" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fkey_schutzstatus FOREIGN KEY (schutzstatus)
        REFERENCES "def_Schutzstatus" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
```


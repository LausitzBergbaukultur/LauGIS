# Objekt: Anlage (Punkt / Linie)

Beschreibt eine Anlage. Anlagen sind üblicherweise einem Einzelobjekt zugeordnet (ref_Einzelobjekt).

```SQL
SET search_path TO "Erfassung",public;
-- OR
SET search_path TO "Entwicklung",public;
```

```SQL
-- DROP TABLE "obj_Anlage";

CREATE TABLE IF NOT EXISTS "obj_Anlage"
-- CREATE TABLE IF NOT EXISTS "obj_Anlage_line"
( 	
    -- Identifikatoren
    in_bearbeitung bool,			-- default true
    objekt_nr text,					-- 5001 FKEY objektnummer
	sachbegriff text,				-- 5230 TODO ref
	bezeichnung text,				-- 9990
	datierung text,					-- 5060
    ref_einzelobjekt smallint,		-- FKEY einzelobjekt, NOT NULL
    
    -- Deskriptoren
    konstruktion_technik text,		-- 5300 TODO ref
    antrieb text,					-- 5930
    abmessung text,					-- ?
    hersteller text,				-- ob35
    gewicht text,					-- ?
    material text,					-- 5280 TODO ref
    beschreibung_funktion text,		-- 9980
    notiz_intern text,				-- 9984 '9980 = Kommentar'
	bilder text,					-- 99PI
    
   	-- Metadaten
    erfassung smallint,				-- 9582 FKEY def_Erfasser
	erfassungsdatum date,			-- 9580
	aenderungsdatum date,			-- 9950
    
    -- Shape und PK
    id integer PRIMARY KEY generated always as identity, -- PK
   	geom geometry(MultiPoint, 25833),
    -- geom geometry(MultiLinestring, 25833),
    
    -- constraints
    -- CONSTRAINT fkey_obj_Einzelobjekt FOREIGN KEY (ref_einzelobjekt)
    	-- REFERENCES "obj_Einzelobjekt" (id) MATCH SIMPLE
		-- ON UPDATE NO ACTION
        -- ON DELETE NO ACTION,    
    CONSTRAINT fkey_objekt_nr FOREIGN KEY (objekt_nr)
        REFERENCES "ref_Objektnummer" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
    CONSTRAINT fkey_erfasser FOREIGN KEY (erfassung)
        REFERENCES "def_Erfasser" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);
```


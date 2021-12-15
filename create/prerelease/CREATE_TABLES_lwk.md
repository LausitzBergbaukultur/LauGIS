# Landschaftswandelkarte

## lwk Bereich (Multipoligon)

```SQL
SET search_path TO "Erfassung",public;
-- OR
SET search_path TO "Entwicklung",public;
```

```SQL
CREATE TABLE IF NOT EXISTS "lwk_Bereich"
( 	
    -- Identifikatoren
   	beschriftung text,				-- Bezeichnung und Identifikation
    jahresschnitt smallint REFERENCES "def_Jahresschnitt" (id),			-- FKEY def_Jahresschnitt
    nutzungsart smallint REFERENCES "def_Nutzungsart" (id),			-- FKEY def_Nutzungsart
        
	-- Metadaten
    erfassung smallint REFERENCES "def_Erfasser" (id),				-- 9582 FKEY def_Erfasser
	erfassungsdatum date,			-- 9580
	aenderungsdatum date,			-- 9950
        
    -- Shape und PK
    id integer PRIMARY KEY generated always as identity, -- PK
   	geom geometry(MultiPolygon, 25833)
);
```

## lwk Strecke (Multilinestring)

```SQL
CREATE TABLE IF NOT EXISTS "lwk_Strecke"
( 	
    -- Identifikatoren
   	beschriftung text,				-- Bezeichnung und Identifikation
 	jahresschnitt smallint REFERENCES "def_Jahresschnitt" (id), -- FKEY def_Jahresschnitt
    nutzungsart smallint REFERENCES "def_Nutzungsart" (id), -- FKEY def_Nutzungsart
        
	-- Metadaten
    erfassung smallint REFERENCES "def_Erfasser" (id), -- 9582 FKEY def_Erfasser
	erfassungsdatum date,			-- 9580
	aenderungsdatum date,			-- 9950
        
    -- Shape und PK
    id integer PRIMARY KEY generated always as identity, -- PK
   	geom geometry(MultiLinestring, 25833)
);
```


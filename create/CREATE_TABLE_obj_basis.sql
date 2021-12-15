-- In der Tabelle obj_base werden die Metadaten und Deskriptoren sämtlicher Objekte abgelegt.
-- Die explizite Beschreibung der einzelnen Objekte findet durch Erweiterungstabellen statt. 

DROP TABLE IF EXISTS obj_basis;
CREATE TABLE IF NOT EXISTS obj_basis
(     
    -- # Metadaten
    objekt_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk
    objekt_nr text,                 -- 5000
    erfassungsdatum date,           -- 9580
    aenderungsdatum date,           -- 9950
    -- erfasser -> ref

    -- # Deskriptoren
    in_bearbeitung bool,            -- default 1
    beschreibung text,              -- 9980
    beschreibung_ergaenzung text,   -- 9980
    lagebeschreibung text,          -- 5125
    quellen_literatur text,         -- 8330
    notiz_intern text,              -- 9984 '9980 = Kommentar'
    hida_nr text,                   -- 5000
    -- datierung -> ref
    -- Person_werk -> ref   
    -- Soziet_werk -> ref
    -- Person_verantw -> ref
    -- Soziet_verantw -> ref
    -- bilder_extern -> ref
    -- bilder_intern -> ref

-- Referenz zu übergeordneten Objekten
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES "obj_basis" (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
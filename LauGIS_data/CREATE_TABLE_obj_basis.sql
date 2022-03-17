-- In der Tabelle obj_base werden die Metadaten und Deskriptoren sämtlicher Objekte abgelegt.
-- Die explizite Beschreibung der einzelnen Objekte findet durch Erweiterungstabellen statt. 

DROP TABLE IF EXISTS development.obj_basis;
CREATE TABLE IF NOT EXISTS development.obj_basis
(     
    -- # Metadaten
    objekt_id integer PRIMARY KEY generated always as identity, -- PK
    objekt_nr integer UNIQUE,       -- 5000
    rel_objekt_nr integer,          -- fk
    status_bearbeitung smallint,    -- fk
    erfassungsdatum date,           -- 9580
    aenderungsdatum date,           -- 9950
    letzte_aenderung timestamp,     -- meta zur Filterung
    geloescht bool,                 -- meta zur Filterung
    -- erfasser -> rel

    -- # Deskriptoren
    kategorie smallint,             -- fk NOT NULL
    sachbegriff integer,            -- fk 5230
    sachbegriff_alt text,           -- 5230 (als Altdaten-temp sowie für Freitexte)
    beschreibung text,              -- 9980
    beschreibung_ergaenzung text,   -- 9980
    lagebeschreibung text,          -- 5125
    quellen_literatur text,         -- 8330
    notiz_intern text,              -- 9984 '9980 = Kommentar'
    hida_nr text,                   -- 5000
    -- datierung -> rel
    -- Person_werk -> rel   
    -- Soziet_werk -> rel
    -- Person_verantw -> rel
    -- Soziet_verantw -> rel
    -- bilder_extern -> rel
    -- bilder_intern -> rel

-- Referenz zu übergeordneten Objekten
CONSTRAINT fkey_rel_objekt_nr FOREIGN KEY (rel_objekt_nr)
    REFERENCES development.obj_basis (objekt_nr) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

CONSTRAINT fkey_status_bearbeitung FOREIGN KEY (status_bearbeitung)
    REFERENCES development.def_bearbeitung (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

CONSTRAINT fkey_kategorie FOREIGN KEY (kategorie)
    REFERENCES development.def_kategorie (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

CONSTRAINT fkey_sachbegriff FOREIGN KEY (sachbegriff)
    REFERENCES development.def_sachbegriff (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
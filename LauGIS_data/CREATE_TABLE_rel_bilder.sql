DROP TABLE IF EXISTS development.rel_bilder;
CREATE TABLE IF NOT EXISTS development.rel_bilder
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    dateiname text,                 -- Dateiname incl. Endung
    intern bool,                    -- Kennzeichen 'nicht zur Veröffentlichung'

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES development.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
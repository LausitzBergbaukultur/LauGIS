DROP TABLE IF EXISTS laugis.rel_bilder;
CREATE TABLE IF NOT EXISTS laugis.rel_bilder
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    dateiname text,                 -- Dateiname incl. Endung
    intern bool,                    -- Kennzeichen 'nicht zur Veröffentlichung'

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
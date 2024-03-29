DROP TABLE IF EXISTS laugis.rel_nutzung;
CREATE TABLE IF NOT EXISTS laugis.rel_nutzung
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    nutzungsart text,               -- Freitext Nutzungsart
    datierung text,                 -- formatierte Datumsangabe

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
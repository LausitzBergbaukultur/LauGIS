-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_dachform vorgehalten. 

DROP TABLE IF EXISTS development.rel_konstruktion;
CREATE TABLE IF NOT EXISTS development.rel_konstruktion
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    ref_konstruktion_id integer,        -- fk NOT NULL

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES development.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_dachform_id FOREIGN KEY (ref_konstruktion_id)
    REFERENCES development.def_konstruktion (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
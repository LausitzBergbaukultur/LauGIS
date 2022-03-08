-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_blick vorgehalten. 

DROP TABLE IF EXISTS development.rel_blickbeziehung;
CREATE TABLE IF NOT EXISTS development.rel_blickbeziehung
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    beschreibung text,              -- Beschreibung der Blickbeziehung
    rel_objekt_nr integer,          -- Referenz auf ObjektNr
    ref_blick_id integer,           -- fk NOT NULL, Blickart

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES development.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur ziel Objekt-Base
CONSTRAINT fkey_rel_objekt_nr FOREIGN KEY (rel_objekt_nr)
    REFERENCES development.obj_basis (objekt_nr) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_blick_id FOREIGN KEY (ref_blick_id)
    REFERENCES development.def_blickbeziehung (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
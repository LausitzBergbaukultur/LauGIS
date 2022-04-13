-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_erfasser vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_erfasser;
CREATE TABLE IF NOT EXISTS laugis.rel_erfasser
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    ref_erfasser_id integer,        -- fk NOT NULL
    is_creator bool,                -- Urheberkennzeichen

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_erfasser_id FOREIGN KEY (ref_erfasser_id)
    REFERENCES laugis.def_erfasser (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
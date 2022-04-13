-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_erfasser vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_material;
CREATE TABLE IF NOT EXISTS laugis.rel_material
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    ref_material_id integer,        -- fk NOT NULL


-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_material_id FOREIGN KEY (ref_material_id)
    REFERENCES laugis.def_material (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
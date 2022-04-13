-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_datierung vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_datierung;
CREATE TABLE IF NOT EXISTS laugis.rel_datierung
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    datierung text,                 -- formatierte Datumsangabe
    ref_ereignis_id integer,       -- fk NOT NULL, Datierungsart
    alt_ereignis text,             -- alternative Datierungsart

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_datierung_id FOREIGN KEY (ref_ereignis_id)
    REFERENCES laugis.def_datierung (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
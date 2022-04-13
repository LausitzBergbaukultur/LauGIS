-- In dieser Tabelle werden die Relationen zwischen obj_basis und def_personen vorgehalten. 

DROP TABLE IF EXISTS laugis.rel_personen;
CREATE TABLE IF NOT EXISTS laugis.rel_personen
(     
    relation_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    bezeichnung text,               -- Name oder Firma
    ref_funktion_id integer,        -- fk NOT NULL, Funktionsbeschreibung
    alt_funktion text,              -- alternative Funktionsbeschreibung
    is_sozietaet bool,               -- Kennzeichen: natürliche person / sozietät

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

-- Referenz zur erfasser-Tabelle
CONSTRAINT fkey_datierung_id FOREIGN KEY (ref_funktion_id)
    REFERENCES laugis.def_personen (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
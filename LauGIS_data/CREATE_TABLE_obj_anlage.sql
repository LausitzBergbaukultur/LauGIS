-- In der Tabelle obj_anlage werden die spezifischen Informationen zu Anlagen abgelegt.
-- Anlagen bestehen aus zusammenhängenden Einträgen in obj_basis und obj_anlage.

DROP TABLE IF EXISTS development.obj_anlage;
CREATE TABLE IF NOT EXISTS development.obj_anlage
(     
    -- # Metadaten
    anlage_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    
    -- # Deskriptoren
    antrieb text,                   -- 5930
    abmessung text,                 -- ?
    gewicht text,                   -- ?
    -- material -> ref              -- 5280
    material_alt text,
    -- konstruktion_technik -> ref  -- 5300
    konstruktion_alt text,

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES development.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
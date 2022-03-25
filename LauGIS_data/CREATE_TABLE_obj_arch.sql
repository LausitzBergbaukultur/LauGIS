-- In der Tabelle obj_arch werden die Architekturdaten von Einzelobjekten abgelegt.
-- Einzelobjekte bestehen aus zusammenhängenden Einträgen in obj_basis, obj_stamm und obj_arch.

DROP TABLE IF EXISTS obj_arch;
CREATE TABLE IF NOT EXISTS obj_arch
(     
    -- # Metadaten
    architektur_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    
    -- # Deskriptoren
    geschosszahl smallint,          -- 5390
    achsenzahl smallint,            -- 5392
    -- grundriss -> ref             -- 5244
    grundriss text,
    -- dachform -> ref              -- 5910     
    dachform_alt text,
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
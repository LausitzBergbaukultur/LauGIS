-- In der Tabelle obj_tech werden die Architekturdaten von Einzelobjekten und Anlagen abgelegt.
-- Einzelobjekte und Anlagen bestehen aus zusammenhängenden Einträgen in obj_basis und obj_tech.

DROP TABLE IF EXISTS laugis.obj_tech;
CREATE TABLE IF NOT EXISTS laugis.obj_tech
(     
    -- # Metadaten
    tech_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    techn_anlage bool,              -- Kennzeichen zur Auswahl der Deskriptoren

    -- # Deskriptoren allgemein
    -- material -> ref              -- 5280
    material_alt text,
    -- konstruktion_technik -> ref  -- 5300
    konstruktion_alt text,

    -- # Deskriptoren architektonisch
    geschosszahl smallint,          -- 5390
    achsenzahl smallint,            -- 5392
    -- grundriss -> ref             -- 5244
    grundriss text,
    -- dachform -> ref              -- 5910     
    dachform_alt text,
    
    -- # Deskriptoren technische Anlage
    antrieb text,                   -- 5930
    abmessung text,                 -- ?
    gewicht text,                   -- ?

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
-- In dieser Tabelle werden Geometrien vom Typ 'Multipoint' vorgehalten.
-- Über den fk_objekt_id wird die Geometrie einem Basis-Objekt zugeordnet 

DROP TABLE IF EXISTS development.geo_point;
CREATE TABLE IF NOT EXISTS development.geo_point
(     
    -- # Metadaten
    geo_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    geom geometry(MultiPoint, 25833),

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES development.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
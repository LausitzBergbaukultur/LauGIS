-- In dieser Tabelle werden Geometrien vom Typ 'Multipolygon' vorgehalten.
-- Über den fk_objekt_id wird die Geometrie einem Basis-Objekt zugeordnet 

DROP TABLE IF EXISTS laugis.geo_poly;
CREATE TABLE IF NOT EXISTS laugis.geo_poly
(     
    -- # Metadaten
    geo_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    geom geometry(MultiPolygon, 25833),

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES laugis.obj_basis (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
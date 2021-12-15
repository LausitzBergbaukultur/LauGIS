-- In der Tabelle obj_stamm werden die Stammdaten von Objektbereichen und Einzelobjekten abgelegt.
-- Objektbereiche bestehen aus zusammenhängenden Einträgen in obj_base und obj_stamm. 

DROP TABLE IF EXISTS obj_stamm;
CREATE TABLE IF NOT EXISTS obj_stamm
(     
    -- # Metadaten
    stammdaten_id integer PRIMARY KEY generated always as identity, -- PK
    ref_objekt_id integer,          -- fk NOT NULL
    
    -- # Stammdaten
    sachbegriff text,               -- 5230
    bezeichnung text,               -- 9990
    bauwerksname_eigenname text,    -- 5202
    kategorie smallint,             -- fk NOT NULL
    erhaltungszustand smallint,     -- fk 5210
    schutzstatus smallint,          -- fk
    nachnutzungspotential smallint, -- fk
    -- funktion -> ref

    -- # Lokalisatoren
    kreis text,                     -- 5098
    gemeinde text,                  -- 5100
    ort text,                       -- 5108
    sorbisch text,                  -- 5115
    strasse text,                   -- 5116
    hausnummer text,                -- 5117
    gem_flur text,                  -- 5120

-- Referenz zur übergeordneten Objekt-Base
CONSTRAINT fkey_objekt_id FOREIGN KEY (ref_objekt_id)
    REFERENCES "obj_basis" (objekt_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
CONSTRAINT fkey_erhaltungszustand FOREIGN KEY (erhaltungszustand)
    REFERENCES "def_erhaltungszustand" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
CONSTRAINT fkey_kategorie FOREIGN KEY (kategorie)
    REFERENCES "def_kategorie" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
CONSTRAINT fkey_nachnutzung FOREIGN KEY (nachnutzungspotential)
    REFERENCES "def_nachnutzung" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
CONSTRAINT fkey_schutzstatus FOREIGN KEY (schutzstatus)
    REFERENCES "def_schutzstatus" (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION

);
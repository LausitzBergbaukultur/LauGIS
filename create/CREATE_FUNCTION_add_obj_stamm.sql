-- insert obj_stamm returning new id

CREATE OR REPLACE FUNCTION development.add_obj_stamm(
    ref_objekt_id integer,          -- fk NOT NULL
    -- # Stammdaten
    sachbegriff text,               -- 5230
    bezeichnung text,               -- 9990
    bauwerksname_eigenname text,    -- 5202
    kategorie smallint,             -- fk NOT NULL
    erhaltungszustand smallint,     -- fk 5210
    schutzstatus smallint,          -- fk
    nachnutzungspotential smallint, -- fk
    
    -- # Lokalisatoren
    kreis text,                     -- 5098
    gemeinde text,                  -- 5100
    ort text,                       -- 5108
    sorbisch text,                  -- 5115
    strasse text,                   -- 5116
    hausnummer text,                -- 5117
    gem_flur text                   -- 5120
    ) 
RETURNS INTEGER AS $$

DECLARE 
  ob_id integer;
BEGIN

INSERT INTO development.obj_stamm(
    ref_objekt_id,
    sachbegriff,
    bezeichnung,
    bauwerksname_eigenname,
    kategorie,
    erhaltungszustand,
    schutzstatus,
    nachnutzungspotential,
    kreis,
    gemeinde,
    ort,
    sorbisch,
    strasse,
    hausnummer,
    gem_flur)
    VALUES (
    ref_objekt_id,
    sachbegriff,
    bezeichnung,
    bauwerksname_eigenname,
    kategorie,
    erhaltungszustand,
    schutzstatus,
    nachnutzungspotential,
    kreis,
    gemeinde,
    ort,
    sorbisch,
    strasse,
    hausnummer,
    gem_flur)
    RETURNING stammdaten_id INTO ob_id;
    
    RETURN ob_id;

END;
$$ LANGUAGE plpgsql;
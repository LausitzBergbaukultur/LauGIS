--

CREATE OR REPLACE PROCEDURE development.write_objektbereich(
   -- # Metadaten
  objekt_id integer,              -- pk       
  ref_objekt_id integer,          -- fk
  objekt_nr text,                 -- 5000
  erfassungsdatum date,           -- 9580
  aenderungsdatum date,           -- 9950

  -- # Deskriptoren
  in_bearbeitung bool,            -- default 1
  beschreibung text,              -- 9980
  beschreibung_ergaenzung text,   -- 9980
  lagebeschreibung text,          -- 5125
  quellen_literatur text,         -- 8330
  notiz_intern text,              -- 9984 '9980 = Kommentar'
  hida_nr text,                   -- 5000

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
  gem_flur text,                  -- 5120
  geom geometry
)

LANGUAGE plpgsql
AS $$

DECLARE
  _obj_id int;        -- FK fuer Zuordnung Stammdaten -> Basis

BEGIN
  -- Basis-Objekt anlegen/updaten und Objekt-Id ermitteln
  SELECT development.update_obj_basis(
    objekt_id,                  -- pk (NULL -> INSERT)
    ref_objekt_id,              -- nur bei Selbstreferenz wie z.B. uebergeordnete Objektbereiche
    objekt_nr,                  -- 5000
    erfassungsdatum,            -- 9580
    aenderungsdatum,            -- 9950

    -- # Deskriptoren
    in_bearbeitung,             -- default 1
    beschreibung,               -- 9980
    beschreibung_ergaenzung,    -- 9980
    lagebeschreibung,           -- 5125
    quellen_literatur,          -- 8330
    notiz_intern,               -- 9984 '9980 = Kommentar'
    hida_nr,                    -- 5000
    geom
  )
  INTO _obj_id;

  -- zugehöriges Stammdaten-Objekt anlegen/updaten
  PERFORM development.update_obj_stamm(
    _obj_id,                    -- ref zu angelegter Objekt-Basis, NOT NULL
    -- # Stammdaten
    sachbegriff,                -- 5230
    bezeichnung,                -- 9990
    bauwerksname_eigenname,     -- 5202
    kategorie,                  -- fk NOT NULL
    erhaltungszustand,          -- fk 5210
    schutzstatus,               -- fk
    nachnutzungspotential,      -- fk

    -- # Lokalisatoren
    kreis,                      -- 5098
    gemeinde,                   -- 5100
    ort,                        -- 5108
    sorbisch,                   -- 5115
    strasse,                    -- 5116
    hausnummer,                 -- 5117
    gem_flur                    -- 5120
  );
END;
$$;
--

CREATE OR REPLACE PROCEDURE development.add_objektbereich(
   -- # Metadaten
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
--
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
LANGUAGE plpgsql
AS $$
BEGIN
PERFORM development.add_obj_stamm(
  (SELECT development.add_obj_basis(
  NULL,
  'testeintrag 123',
  NULL, 
  NULL,
  NULL, 
  NULL, 
  NULL, 
  NULL, 
  NULL, 
  NULL, 
  NULL
)), 
  NULL,
  'TEST!2',
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL,
  NULL
);
END;
$$;
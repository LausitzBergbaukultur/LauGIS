-- insert obj_basis returning new id
-- Erzeugt einen neuen Basis-Eintrag
-- das Flag 'geloescht' wird auf false gesetzt
-- letzte_aenderung wird mit NOW() befüllt

CREATE OR REPLACE FUNCTION development.add_obj_basis(
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
  hida_nr text                   -- 5000
  ) 
RETURNS INTEGER AS $$

DECLARE 
  ob_id integer;
BEGIN

INSERT INTO development.obj_basis(
    ref_objekt_id,
    objekt_nr,
    erfassungsdatum,
    aenderungsdatum,
    letzte_aenderung,
    geloescht,
    in_bearbeitung,
    beschreibung,
    beschreibung_ergaenzung,
    lagebeschreibung,
    quellen_literatur,
    notiz_intern,
    hida_nr)
    VALUES (
      ref_objekt_id,
      objekt_nr,
      erfassungsdatum,
      aenderungsdatum,
      NOW(),
      FALSE,
      in_bearbeitung,
      beschreibung,
      beschreibung_ergaenzung,
      lagebeschreibung,
      quellen_literatur,
      notiz_intern,
      hida_nr
      )
    RETURNING objekt_id INTO ob_id;
    
    RETURN ob_id;

END;
$$ LANGUAGE plpgsql;
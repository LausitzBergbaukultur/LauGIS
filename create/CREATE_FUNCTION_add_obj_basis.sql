-- insert obj_basis returning new id

CREATE OR REPLACE FUNCTION development.add_obj_basis(
  ref_objekt_id integer,
  objekt_nr text,
  erfassungsdatum date,
  aenderungsdatum date,
  in_bearbeitung bool,
  beschreibung text,
  beschreibung_ergaenzung text,
  lagebeschreibung text,
  quellen_literatur text,
  notiz_intern text,
  hida_nr text) 
RETURNS INTEGER AS $$

DECLARE 
  ob_id integer;
BEGIN

INSERT INTO development.obj_basis(
    ref_objekt_id,
    objekt_nr,
    erfassungsdatum,
    aenderungsdatum,
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
      in_bearbeitung,
      beschreibung,
      beschreibung_ergaenzung,
      lagebeschreibung,
      quellen_literatur,
      notiz_intern,
      hida_nr)
    RETURNING objekt_id INTO ob_id;
    
    RETURN ob_id;

END;
$$ LANGUAGE plpgsql;
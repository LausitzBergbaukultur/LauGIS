-- Setzt die Werte für ein bestehendes oder neues Basis-Objekt
-- Legt entsprechend der Geometrie-Art einen passenden verknüpften Eintrag an
-- Setzt das Flag 'geloescht' auf false
-- Fügt in 'letzte_aenderung' den aktuellen Timestamp
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION development.update_obj_basis(
  -- # Metadaten
  _objekt_id integer,              -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _objekt_nr text,                 -- 5000
  _erfassungsdatum date,           -- 9580
  _aenderungsdatum date,           -- 9950
  
  -- # Deskriptoren
  _in_bearbeitung bool,            -- default 1
  _beschreibung text,              -- 9980
  _beschreibung_ergaenzung text,   -- 9980
  _lagebeschreibung text,          -- 5125
  _quellen_literatur text,         -- 8330
  _notiz_intern text,              -- 9984 '9980 = Kommentar'
  _hida_nr text,                   -- 5000

  -- # Geometrie
  geom geometry                   -- 
  ) 
RETURNS INTEGER AS $$

DECLARE 
  _ob_id integer = _objekt_id;
BEGIN

  -- check if UPDATE or INSERT
  IF (_objekt_id IS NOT NULL) THEN
    UPDATE development.obj_basis
    SET
        ref_objekt_id = _ref_objekt_id,
        objekt_nr = _objekt_nr,
        erfassungsdatum = _erfassungsdatum,
        aenderungsdatum = _aenderungsdatum,
        letzte_aenderung = NOW(),
        in_bearbeitung = _in_bearbeitung,
        beschreibung = _beschreibung,
        beschreibung_ergaenzung = _beschreibung_ergaenzung,
        lagebeschreibung = _lagebeschreibung,
        quellen_literatur = _quellen_literatur,
        notiz_intern = _notiz_intern,
        hida_nr = _hida_nr
    WHERE objekt_id = _ob_id;
  ELSE
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
        _ref_objekt_id,
        _objekt_nr,
        _erfassungsdatum,
        _aenderungsdatum,
        NOW(),
        FALSE,
        _in_bearbeitung,
        _beschreibung,
        _beschreibung_ergaenzung,
        _lagebeschreibung,
        _quellen_literatur,
        _notiz_intern,
        _hida_nr
        )
      RETURNING obj_basis.objekt_id INTO _ob_id;
  END IF;

  -- check geometry type and insert accordingly
  IF (TRUE)
  THEN 
    INSERT INTO development.geo_poly(
        ref_objekt_id,
        geom
        )
      VALUES (
        _ob_id,
        geom);
  ELSE 
    RAISE NOTICE 'geht nicht';
  END IF;

RETURN _ob_id;

END;
$$ LANGUAGE plpgsql;
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
  _geom geometry                   -- undefined geometry
  ) 
RETURNS INTEGER AS $$

DECLARE 
  _ob_id integer = _objekt_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_objekt_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  -- handle obj_basis entries
  IF (_is_update) THEN
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

  -- handle geometry entries
  IF (ST_GeometryType(_geom) = 'ST_MultiPolygon') THEN 
    
    IF (_is_update) THEN
        UPDATE development.geo_poly
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;  
    ELSE 
        INSERT INTO development.geo_poly(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  
  
  ELSEIF (ST_GeometryType(_geom) = 'ST_MultiLineString') THEN
    
    IF (_is_update) THEN
        UPDATE development.geo_line
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;    
    ELSE  
        INSERT INTO development.geo_line(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  

  ELSEIF (ST_GeometryType(_geom) = 'ST_MultiPoint') THEN
    
    IF (_is_update) THEN
        UPDATE development.geo_point
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;
    ELSE 
        INSERT INTO development.geo_point(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  

  END IF;

-- return (inserted) object id
RETURN _ob_id;

END;
$$ LANGUAGE plpgsql;
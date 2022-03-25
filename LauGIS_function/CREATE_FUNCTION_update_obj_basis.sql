-- Setzt die Werte für ein bestehendes oder neues Basis-Objekt
-- Legt entsprechend der Geometrie-Art einen passenden verknüpften Eintrag an
-- Setzt das Flag 'geloescht' auf false
-- Fügt in 'letzte_aenderung' den aktuellen Timestamp
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION development.update_obj_basis(
  -- # Metadaten
  _objekt_id integer,              -- pk IF NOT NULL -> UPDATE
  _objekt_nr integer,              -- 5000
  _rel_objekt_nr integer,          -- fk
  _status_bearbeitung smallint,    -- fk
  _erfassungsdatum date,           -- 9580
  _aenderungsdatum date,           -- 9950
  
  -- # Deskriptoren
  _kategorie smallint,             -- fk NOT NULL
  _sachbegriff integer,            -- fk 5230
  _sachbegriff_alt text,           -- 5230 (als Altdaten-temp sowie für Freitexte)
  _beschreibung text,              -- 9980
  _beschreibung_ergaenzung text,   -- 9980
  _lagebeschreibung text,          -- 5125
  _quellen_literatur text,         -- 8330
  _notiz_intern text,              -- 9984 '9980 = Kommentar'
  _hida_nr text,                   -- 5000
  _bilder_anmerkung text,          -- temp und anmerkung

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

---------------------------------------------------------------------------------------------------------------
-- Handle obj_basis entries
---------------------------------------------------------------------------------------------------------------

  IF (_is_update) THEN
    UPDATE development.obj_basis
    SET
        objekt_nr = _objekt_nr,
        rel_objekt_nr = _rel_objekt_nr,
        status_bearbeitung = _status_bearbeitung,
        erfassungsdatum = _erfassungsdatum,
        aenderungsdatum = _aenderungsdatum,
        letzte_aenderung = NOW(),
        kategorie = _kategorie,
        sachbegriff = _sachbegriff,
        sachbegriff_alt = _sachbegriff_alt,
        beschreibung = _beschreibung,
        beschreibung_ergaenzung = _beschreibung_ergaenzung,
        lagebeschreibung = _lagebeschreibung,
        quellen_literatur = _quellen_literatur,
        notiz_intern = _notiz_intern,
        hida_nr = _hida_nr,
        bilder_anmerkung = _bilder_anmerkung
    WHERE objekt_id = _ob_id;
  ELSE
    INSERT INTO development.obj_basis(
        objekt_nr,
        rel_objekt_nr,
        status_bearbeitung,
        erfassungsdatum,
        aenderungsdatum,
        letzte_aenderung,
        geloescht,
        kategorie,
        sachbegriff,
        sachbegriff_alt,
        beschreibung,
        beschreibung_ergaenzung,
        lagebeschreibung,
        quellen_literatur,
        notiz_intern,
        hida_nr,
        bilder_anmerkung)
      VALUES (
        _objekt_nr,
        _rel_objekt_nr,
        _status_bearbeitung,
        _erfassungsdatum,
        _aenderungsdatum,
        NOW(),
        FALSE,
        _kategorie,
        _sachbegriff,
        _sachbegriff_alt,
        _beschreibung,
        _beschreibung_ergaenzung,
        _lagebeschreibung,
        _quellen_literatur,
        _notiz_intern,
        _hida_nr,
        _bilder_anmerkung
        )
      RETURNING obj_basis.objekt_id INTO _ob_id;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Objekt-Nr generation
---------------------------------------------------------------------------------------------------------------

  IF NOT (_is_update) AND (_objekt_nr IS NULL) THEN
    -- generate nr by adding 32.000.000 to the identifier 
    _objekt_nr = (_ob_id + 32000000);
    
    UPDATE development.obj_basis
    SET
        objekt_nr = _objekt_nr
    WHERE objekt_id = _ob_id;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Geometry handling
---------------------------------------------------------------------------------------------------------------

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
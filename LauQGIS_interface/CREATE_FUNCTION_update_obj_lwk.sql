-- Setzt die Werte für ein bestehendes oder neues LWK-Objekt
-- Legt entsprechend der Geometrie-Art einen passenden verknüpften Eintrag an
-- Setzt das Flag 'geloescht' auf false
-- Fügt in 'letzte_aenderung' den aktuellen Timestamp
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_obj_lwk(
  -- # Metadaten  
  _objekt_id integer, -- PK
  _erfassungsdatum date,     -- 9580
  _aenderungsdatum date,     -- 9950
  _erfassung smallint,

  -- Identifikatoren
  _beschriftung text,        -- Bezeichnung und Identifikation
  _jahresschnitt smallint,
  _nutzungsart smallint,
  _grundlage smallint,

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
    UPDATE laugis.obj_lwk
    SET
        erfassungsdatum         = _erfassungsdatum,
        aenderungsdatum         = _aenderungsdatum,
        letzte_aenderung        = NOW(),
        erfassung               = _erfassung,
        beschriftung            = _beschriftung,
        jahresschnitt           = _jahresschnitt,
        nutzungsart             = _nutzungsart,
        grundlage               = _grundlage
    WHERE objekt_id             = _ob_id;
  ELSE
    INSERT INTO laugis.obj_lwk(
        erfassungsdatum,
        aenderungsdatum,
        letzte_aenderung,
        geloescht,
        erfassung,
        beschriftung,
        jahresschnitt,
        nutzungsart,
        grundlage
        )
      VALUES (
        _erfassungsdatum,
        _aenderungsdatum,
        NOW(),
        FALSE,
        _erfassung,
        _beschriftung,
        _jahresschnitt,
        _nutzungsart,
        _grundlage
        )
      RETURNING obj_lwk.objekt_id INTO _ob_id;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Geometry handling
---------------------------------------------------------------------------------------------------------------

  IF (ST_GeometryType(_geom) = 'ST_MultiPolygon') THEN 
    
    IF (_is_update) THEN
        UPDATE laugis.geo_lwk_poly
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;  
    ELSE 
        INSERT INTO laugis.geo_lwk_poly(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  
  
  ELSEIF (ST_GeometryType(_geom) = 'ST_MultiLineString') THEN
    
    IF (_is_update) THEN
        UPDATE laugis.geo_lwk_line
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;    
    ELSE  
        INSERT INTO laugis.geo_lwk_line(
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
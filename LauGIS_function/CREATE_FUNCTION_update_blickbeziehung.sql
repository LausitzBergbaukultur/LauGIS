-- Setzt die Werte für eine bestehende oder neue Blickbeziehung-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_blickbeziehung(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _beschreibung text,
  _rel_objekt_nr integer,          -- rel fk
  _ref_blick_id integer
  ) 

RETURNS INTEGER AS $$

DECLARE 
  _rel_id integer = _relation_id;
  _is_update bool = NULL;
BEGIN

  -- check if UPDATE or INSERT
  IF (_rel_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

  IF (_is_update) THEN
    UPDATE laugis.rel_blickbeziehung
    SET
        ref_objekt_id = _ref_objekt_id,
        beschreibung = _beschreibung,
        rel_objekt_nr = _rel_objekt_nr,
        ref_blick_id = _ref_blick_id
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_blickbeziehung(
        ref_objekt_id,
        beschreibung,
        rel_objekt_nr,
        ref_blick_id
        )
      VALUES (
        _ref_objekt_id,
        _beschreibung,
        _rel_objekt_nr,
        _ref_blick_id
        )
      RETURNING rel_blickbeziehung.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;
-- Setzt die Werte für eine bestehende oder neue Bilder-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION development.update_bilder(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _dateiname text,
  _intern bool
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
    UPDATE development.rel_bilder
    SET
        ref_objekt_id = _ref_objekt_id,
        nutzungsart = _nutzungsart,
        datierung = _datierung
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO development.rel_bilder(
        ref_objekt_id,
        dateiname,
        intern
        )
      VALUES (
        _ref_objekt_id,
        _dateiname,
        _intern
        )
      RETURNING rel_bilder.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;
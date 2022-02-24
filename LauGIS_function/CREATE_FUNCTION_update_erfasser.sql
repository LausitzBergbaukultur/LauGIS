-- Setzt die Werte für eine bestehende oder neue Erfasser-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION development.update_erfasser(
  -- # Metadaten
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _ref_erfasser_id integer,        -- fk
  _is_creator bool
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
    UPDATE development.rel_erfasser
    SET
        ref_objekt_id = _ref_objekt_id,
        ref_erfasser_id = _ref_erfasser_id,
        is_creator = _is_creator
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO development.rel_erfasser(
        ref_objekt_id,
        ref_erfasser_id,
        is_creator)
      VALUES (
        _ref_objekt_id,
        _ref_erfasser_id,
        _is_creator
        )
      RETURNING rel_erfasser.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;
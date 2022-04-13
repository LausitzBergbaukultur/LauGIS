-- Setzt die Werte für eine bestehende oder neue Literatur-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_literatur(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _literatur text,
  _lib_ref text
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
    UPDATE laugis.rel_literatur
    SET
        ref_objekt_id = _ref_objekt_id,
        literatur = _literatur,
        lib_ref = _lib_ref
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_literatur(
        ref_objekt_id,
        literatur,
        lib_ref
        )
      VALUES (
        _ref_objekt_id,
        _literatur,
        _lib_ref
        )
      RETURNING rel_literatur.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;
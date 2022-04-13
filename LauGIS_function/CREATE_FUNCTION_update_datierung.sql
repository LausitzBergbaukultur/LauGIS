-- Setzt die Werte für eine bestehende oder neue Datierung-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_datierung(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _datierung text,
  _ref_ereignis_id integer,        -- fk
  _alt_ereignis text
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
    UPDATE laugis.rel_datierung
    SET
        ref_objekt_id = _ref_objekt_id,
        datierung = _datierung,
        ref_ereignis_id = _ref_ereignis_id,
        alt_ereignis = _alt_ereignis
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_datierung(
        ref_objekt_id,
        datierung,
        ref_ereignis_id,
        alt_ereignis
        )
      VALUES (
        _ref_objekt_id,
        _datierung,
        _ref_ereignis_id,
        _alt_ereignis
        )
      RETURNING rel_datierung.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;
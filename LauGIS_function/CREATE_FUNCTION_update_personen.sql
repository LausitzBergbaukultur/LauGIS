-- Setzt die Werte für eine bestehende oder neue Personen-Relation
-- Gibt die ID des bearbeiteten Eintrags zurück

CREATE OR REPLACE FUNCTION laugis.update_personen(
  _relation_id integer,            -- pk IF NOT NULL -> UPDATE
  _ref_objekt_id integer,          -- fk
  _bezeichnung text,
  _ref_funktion_id integer,        -- fk
  _alt_funktion text,
  _is_sozietaet bool
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
    UPDATE laugis.rel_personen
    SET
        ref_objekt_id = _ref_objekt_id,
        bezeichnung = _bezeichnung,
        ref_funktion_id = _ref_funktion_id,
        alt_funktion = _alt_funktion,
        is_sozietaet = _is_sozietaet
    WHERE relation_id = _relation_id;
  ELSE
    INSERT INTO laugis.rel_personen(
        ref_objekt_id,
        bezeichnung,
        ref_funktion_id,
        alt_funktion,
        is_sozietaet
        )
      VALUES (
        _ref_objekt_id,
        _bezeichnung,
        _ref_funktion_id,
        _alt_funktion,
        _is_sozietaet
        )
      RETURNING rel_personen.relation_id INTO _relation_id;
  END IF;
 
-- return (inserted) rel id
RETURN _relation_id;

END;
$$ LANGUAGE plpgsql;
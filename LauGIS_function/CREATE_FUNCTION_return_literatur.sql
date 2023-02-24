-- Gibt für ein Objekt die Literaturliste als JSON(text) zurück
-- Format: [{relation_id, objekt_id, literatur, lib_ref}]

CREATE OR REPLACE FUNCTION laugis.return_literatur(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_literatur AS rel ON rel.ref_objekt_id = obb.objekt_id
        WHERE obb.objekt_id = _objekt_id
          AND rel.geloescht IS NOT TRUE
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
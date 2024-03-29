-- Gibt für ein Objekt die Erfasserliste rel_dachform als JSON(text) zurück
-- Format: [{rel_id, obj_id, dachform_id, dachform_alt}]

CREATE OR REPLACE FUNCTION laugis.return_dachform(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_dachform AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_dachform AS def ON rel.ref_dachform_id = def.id
        WHERE obb.objekt_id = _objekt_id
          AND rel.geloescht IS NOT TRUE
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
-- Gibt für ein Objekt die Erfasserliste rel_erfasser als JSON(text) zurück
-- Format: [{rel_id, obj_id, erf_id, is_erfasser}]

CREATE OR REPLACE FUNCTION laugis.return_material(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_material AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_material AS def ON rel.ref_material_id = def.id
        WHERE obb.objekt_id = _objekt_id
          AND rel.geloescht IS NOT TRUE
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
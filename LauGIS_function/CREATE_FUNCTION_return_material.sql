-- Gibt für ein Objekt die Erfasserliste rel_erfasser als JSON(text) zurück
-- Format: [{rel_id, obj_id, erf_id, is_erfasser}]

CREATE OR REPLACE FUNCTION development.return_material(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM development.obj_basis AS obb
        JOIN development.rel_material AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN development.def_material AS def ON rel.ref_material_id = def.id
        WHERE obb.objekt_id = _objekt_id
        --ORDER By def.sortierung
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
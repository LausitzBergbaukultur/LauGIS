-- Gibt für ein Objekt die Erfasserliste rel_konstruktion als JSON(text) zurück
-- Format: [{rel_id, obj_id, dachform_id, dachform_alt}]

CREATE OR REPLACE FUNCTION development.return_konstruktion(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM development.obj_basis AS obb
        JOIN development.rel_konstruktion AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN development.def_konstruktion AS def ON rel.ref_konstruktion_id = def.id
        WHERE obb.objekt_id = _objekt_id
        --ORDER By def.sortierung
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
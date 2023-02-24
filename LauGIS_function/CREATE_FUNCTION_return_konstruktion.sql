-- Gibt für ein Objekt die Erfasserliste rel_konstruktion als JSON(text) zurück
-- Format: [{rel_id, obj_id, dachform_id, dachform_alt}]

CREATE OR REPLACE FUNCTION laugis.return_konstruktion(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_konstruktion AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_konstruktion AS def ON rel.ref_konstruktion_id = def.id
        WHERE obb.objekt_id = _objekt_id
          AND rel.geloescht IS NOT TRUE
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
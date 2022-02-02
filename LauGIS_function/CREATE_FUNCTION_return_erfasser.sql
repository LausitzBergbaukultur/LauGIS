CREATE OR REPLACE FUNCTION development.return_erfasser(
  _objekt_id integer              -- pk
  ) 
RETURNS text[] AS $$

DECLARE 
  _ar text[];
BEGIN

SELECT ARRAY(
  SELECT ARRAY(SELECT (json_each_text(to_json(rel))).value) AS row_value
    FROM development.obj_basis AS obb
        JOIN development.rel_erfasser AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN development.def_erfasser AS def ON rel.ref_erfasser_id = def.id
        WHERE obb.objekt_id = _objekt_id)
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
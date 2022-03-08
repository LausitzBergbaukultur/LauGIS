-- Gibt für ein Objekt die Datierungsliste rel_datierung als JSON(text) zurück
-- Format: [{relation_id, objekt_id, datierung, ref_ereignis_id, alt_ereignis}]

CREATE OR REPLACE FUNCTION development.return_nutzung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM development.obj_basis AS obb
        JOIN development.rel_nutzung AS rel ON rel.ref_objekt_id = obb.objekt_id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
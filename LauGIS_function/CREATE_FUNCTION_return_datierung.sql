-- Gibt für ein Objekt die Datierungsliste rel_datierung als JSON(text) zurück
-- Format: [{relation_id, objekt_id, datierung, ref_ereignis_id, alt_ereignis}]

CREATE OR REPLACE FUNCTION laugis.return_datierung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel) ORDER BY LEFT(NULLIF(regexp_replace(rel.datierung, '\D','','g'), ''), 4))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_datierung AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_datierung AS def ON rel.ref_ereignis_id = def.id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
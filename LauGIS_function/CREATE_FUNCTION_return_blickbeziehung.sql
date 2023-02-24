-- Gibt für ein Objekt die Blickbeziehungen rel_datierung als JSON(text) zurück
-- Format: [{relation_id, objekt_id, beschreibung, rel_objekt_nr, ref_blick_id}]

CREATE OR REPLACE FUNCTION laugis.return_blickbeziehung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_blickbeziehung AS rel ON rel.ref_objekt_id = obb.objekt_id
        WHERE obb.objekt_id = _objekt_id
          AND rel.geloescht IS NOT TRUE
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
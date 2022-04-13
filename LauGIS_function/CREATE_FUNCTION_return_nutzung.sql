-- Gibt für ein Objekt die Nutzungsliste rel_nutzung als JSON(text) zurück

CREATE OR REPLACE FUNCTION laugis.return_nutzung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_nutzung AS rel ON rel.ref_objekt_id = obb.objekt_id
        WHERE obb.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
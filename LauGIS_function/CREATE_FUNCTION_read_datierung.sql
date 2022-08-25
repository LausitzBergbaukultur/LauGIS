-- Gibt für ein Objekt die aggregierten Datierungseinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_datierung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(subquery.bezeichnung || ': ' || COALESCE(subquery.datierung, ''), ' | ')) AS row_value
FROM (
  SELECT def.bezeichnung, rel.datierung
  FROM laugis.obj_basis AS ob
        JOIN laugis.rel_datierung AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_datierung AS def ON rel.ref_ereignis_id = def.id
    WHERE ob.objekt_id = _objekt_id
    ORDER BY LEFT(NULLIF(regexp_replace(rel.datierung, '\D','','g'), ''), 4)
    ) AS subquery
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
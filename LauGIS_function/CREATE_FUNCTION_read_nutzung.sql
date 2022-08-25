-- Gibt für ein Objekt die aggregierten und sortierten Nutzungseinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_nutzung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(COALESCE(subquery.nutzungsart, '') || ' ' || COALESCE(subquery.datierung, ''), ' | ')) AS row_value
FROM (
  SELECT rel.nutzungsart, rel.datierung
  FROM laugis.obj_basis AS ob
        JOIN laugis.rel_nutzung AS rel ON rel.ref_objekt_id = ob.objekt_id
    WHERE ob.objekt_id = _objekt_id
    ORDER BY LEFT(NULLIF(regexp_replace(rel.datierung, '\D','','g'), ''), 4)
        ) AS subquery
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
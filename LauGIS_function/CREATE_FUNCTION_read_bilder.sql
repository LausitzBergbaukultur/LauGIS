-- Gibt für ein Objekt die aggregierten Bildereinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_bilder(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(COALESCE(rel.dateiname, ''), ' | ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_bilder AS rel ON rel.ref_objekt_id = ob.objekt_id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
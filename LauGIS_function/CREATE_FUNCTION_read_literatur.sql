-- Gibt für ein Objekt die aggregierten Literatureinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_literatur(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT string_agg(rel.literatur, ' | ') AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_literatur AS rel ON rel.ref_objekt_id = ob.objekt_id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
-- Gibt für ein Objekt die aggregierten Blickbeziehungen zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_blickbeziehung(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (string_agg(def.bezeichnung || ': ' || COALESCE(rel.beschreibung, '') || ' -> ' || COALESCE(rel_ob.bezeichnung, ''), ' | ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_blickbeziehung AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_blickbeziehung AS def ON rel.ref_blick_id = def.id
        LEFT JOIN laugis.obj_basis AS rel_ob ON rel.rel_objekt_nr = rel_ob.objekt_nr
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
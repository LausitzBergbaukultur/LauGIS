-- Gibt für ein Objekt die aggregierten Materialien zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_material(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
  _freitext text;
BEGIN

-- Alternativtext Ermitteln
SELECT tech.material_alt
    FROM laugis.obj_tech AS tech
        WHERE tech.ref_objekt_id = _objekt_id
INTO _freitext;

-- Liste mit Materialien ermitteln
SELECT (string_agg(def.bezeichnung, ', ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_material AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_material AS def ON rel.ref_material_id = def.id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

-- Begriff FREITEXT gegen Alternativtext austauschen
_ar = REPLACE (_ar, 'FREITEXT', _freitext);

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
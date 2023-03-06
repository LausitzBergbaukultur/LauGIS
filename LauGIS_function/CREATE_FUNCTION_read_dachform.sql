-- Gibt für ein Objekt die aggregierten Dachformen zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_dachform(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
  _freitext text;
BEGIN

-- Alternativtext Ermitteln
SELECT tech.dachform_alt
    FROM laugis.obj_tech AS tech
        WHERE tech.ref_objekt_id = _objekt_id
INTO _freitext; 

-- Liste mit Dachformen ermitteln
SELECT (string_agg(def.bezeichnung, ', ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_dachform AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_dachform AS def ON rel.ref_dachform_id = def.id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

-- Begriff FREITEXT gegen Alternativtext austauschen
_ar = REPLACE (_ar, 'FREITEXT', _freitext);

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
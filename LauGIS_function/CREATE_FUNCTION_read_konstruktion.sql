-- Gibt für ein Objekt die aggregierten Konstruktionsarten/Techniken zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_konstruktion(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
  _freitext text;
BEGIN

-- Alternativtext Ermitteln
SELECT tech.konstruktion_alt
    FROM laugis.obj_tech AS tech
        WHERE tech.ref_objekt_id = _objekt_id
INTO _freitext;

-- Liste mit Konstruktionsarten ermitteln
SELECT (string_agg(def.bezeichnung, ', ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_konstruktion AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_konstruktion AS def ON rel.ref_konstruktion_id = def.id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

-- Begriff FREITEXT gegen Alternativtext austauschen
_ar = REPLACE (_ar, 'FREITEXT', _freitext);

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
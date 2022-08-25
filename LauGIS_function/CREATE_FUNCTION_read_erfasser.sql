-- Gibt für ein Objekt die primäre Ersteller:in oder nur die Beitragenden read only zurück.
-- Das Kennzeichen _only_ceator::bool bestimmt den Modus. 
-- Mehrere Erfasser:innen werden aggregiert übergeben.

CREATE OR REPLACE FUNCTION laugis.read_erfasser(
  _objekt_id integer,              -- pk
  _only_creator bool                -- kennzeichen
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN
  
SELECT (string_agg(def.name, ', ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_erfasser AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_erfasser AS def ON rel.ref_erfasser_id = def.id
        WHERE ob.objekt_id = _objekt_id
          AND rel.is_creator = _only_creator
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
-- Gibt für ein Objekt die Personenliste rel_personen als JSON(text) zurück
-- Format: [{relation_id, objekt_id, bezeichnung, ref_funktion_id, alt_funktion}]

CREATE OR REPLACE FUNCTION laugis.return_personen(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT (json_agg(row_to_json(rel))) AS row_value
    FROM laugis.obj_basis AS obb
        JOIN laugis.rel_personen AS rel ON rel.ref_objekt_id = obb.objekt_id
        JOIN laugis.def_personen AS def ON rel.ref_funktion_id = def.id
        WHERE obb.objekt_id = _objekt_id
          AND rel.geloescht IS NOT TRUE
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
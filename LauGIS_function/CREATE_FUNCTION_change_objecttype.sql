-- Ändert den Objekttyp eines Objektes von Objektbereich zu Einzelobjekt oder umgekehrt.
-- Obacht:
-- Beim Wechsel von Einzelobjekt zu Objektbereich gehen die direkt im Objekt gespeicherten
-- architektonisch/technischen Informationen verloren. Referenzen (Material etc.) bleiben jedoch erhalten.

CREATE OR REPLACE FUNCTION laugis.change_objecttype(
  _objekt_id integer              -- pk
  ) 
RETURNS VOID AS $$

BEGIN
-- check current type
IF (SELECT COUNT(*)
    FROM laugis.obj_basis AS ob
    JOIN laugis.obj_tech AS ot ON ot.ref_objekt_id = ob.objekt_id
    WHERE ob.objekt_id = _objekt_id) > 0 THEN

  -- Objekt ist ein Einzelobjekt -> obj_tech-Eintrag entfernen
  DELETE FROM laugis.obj_tech AS ot
    WHERE ot.ref_objekt_id = _objekt_id;

ELSE
  -- Objekt ist Objektbereich -> obj_tech-Eintrag anlegen
  PERFORM laugis.update_obj_tech(
    _objekt_id,
    NULL,
    NULL,
    NULL,
    NULL, 
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
  );
END IF;

END;
$$ LANGUAGE plpgsql;
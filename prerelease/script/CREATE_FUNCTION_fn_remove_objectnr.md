# Funktion: create objectnumber

```SQL
SET search_path TO "Erfassung",public;
-- OR
SET search_path TO "Entwicklung",public;
```

---

Löscht die Objektnummer zum zu entfernenden Eintrag.

```SQL
CREATE OR REPLACE FUNCTION fn_remove_objectnumber()
	RETURNS trigger AS $$
BEGIN
	DELETE FROM "Entwicklung"."ref_Objektnummer"
	-- DELETE FROM "Erfassung"."ref_Objektnummer"
	WHERE id = OLD.objekt_nr;
    RETURN OLD;
END;
$$
LANGUAGE 'plpgsql';
```

## Trigger:

Wird nach dem Löschen eines Objektes ausgeführt.

```SQL
CREATE TRIGGER tr_remove_objectnumber
AFTER DELETE ON "obj_Einzelobjekt"
FOR EACH ROW EXECUTE PROCEDURE fn_remove_objectnumber();


CREATE TRIGGER tr_remove_objectnumber
AFTER DELETE ON "obj_Einzelobjekt_line"
FOR EACH ROW EXECUTE PROCEDURE fn_remove_objectnumber();


CREATE TRIGGER tr_remove_objectnumber
AFTER DELETE ON "obj_Objektbereich"
FOR EACH ROW EXECUTE PROCEDURE fn_remove_objectnumber();


CREATE TRIGGER tr_remove_objectnumber
AFTER DELETE ON "obj_Objektbereich_line"
FOR EACH ROW EXECUTE PROCEDURE fn_remove_objectnumber();


CREATE TRIGGER tr_remove_objectnumber
AFTER DELETE ON "obj_Anlage"
FOR EACH ROW EXECUTE PROCEDURE fn_remove_objectnumber();


CREATE TRIGGER tr_remove_objectnumber
AFTER DELETE ON "obj_Anlage_line"
FOR EACH ROW EXECUTE PROCEDURE fn_remove_objectnumber();
```
# Funktion: rel_Anlage (Anlage)

```SQL
SET search_path TO "Erfassung",public;
-- OR
SET search_path TO "Entwicklung",public;
```

---

Ermittelt für eine Anlage das zugehörige Einzelobjekt. Hierzu wird geprüft, ob der Punkt der Anlage innerhalb der Geometrie des EO liegt. (ST_contains())

```SQL
CREATE OR REPLACE FUNCTION fn_rel_anlage()
	RETURNS trigger AS $$
BEGIN
	SELECT 	eo.id
	INTO 	NEW.ref_einzelobjekt
	FROM "Entwicklung"."obj_Einzelobjekt" AS eo
	-- FROM "Erfassung"."obj_Einzelobjekt" AS eo
	WHERE ST_Contains(eo.geom, NEW.geom);
	RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
```

## Trigger: rel_Anlage (Anlage)

Wird beim Insert einer Anlage ausgeführt.

```SQL
CREATE TRIGGER tr_rel_anlage
BEFORE INSERT ON "obj_Anlage"
FOR EACH ROW EXECUTE PROCEDURE fn_rel_anlage();
```

```SQL
CREATE TRIGGER tr_rel_anlage
BEFORE INSERT ON "obj_Anlage_line"
FOR EACH ROW EXECUTE PROCEDURE fn_rel_anlage();
```

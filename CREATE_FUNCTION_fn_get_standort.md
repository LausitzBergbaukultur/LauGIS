# Funktion: get_Standort (Einzelobjekt, Objektbereich)

```SQL
SET search_path TO "Erfassung",public;
-- OR
SET search_path TO "Entwicklung",public;
```

---

Ermittelt für ein Einzelobjekt oder einen Objektbereich die Standortinformationen eines darüberliegenden Objektbereichs und übernimmt diese, sofern die Geometrie des EO/OB vollständig innerhalb der Geometrie des OB liegt. (ST_contains())

```SQL
-- TODO: überschreibt Initialwerte bei INSERT

CREATE OR REPLACE FUNCTION fn_get_standort()
	RETURNS trigger AS $$
BEGIN
	SELECT 	ob.id, ob.kreis, ob.gemeinde,
			ob.ort, ob.sorbisch, ob.gem_flur, ob.strasse,
			ob.hausnummer, ob.lage_beschreibung
	INTO 	NEW.ref_objektbereich, NEW.kreis, NEW.gemeinde,
			NEW.ort, NEW.sorbisch, NEW.gem_flur, NEW.strasse,
			NEW.hausnummer, NEW.lage_beschreibung
	FROM "Entwicklung"."obj_Objektbereich" AS ob
	-- FROM "Erfassung"."obj_Objektbereich" AS ob
	WHERE ST_Contains(ob.geom, NEW.geom);
	RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
```

## Trigger: get_Standort (EO, OB)

Wird beim Insert eines Einzelobjekts ausgeführt.

```SQL
CREATE TRIGGER tr_get_standort
BEFORE INSERT ON "obj_Einzelobjekt"
FOR EACH ROW EXECUTE PROCEDURE fn_get_standort();
```

Wird beim Insert eines Einzelobjekts (Linie) ausgeführt.

```SQL
CREATE TRIGGER tr_get_standort
BEFORE INSERT ON "obj_Einzelobjekt_line"
FOR EACH ROW EXECUTE PROCEDURE fn_get_standort();
```

Wird beim Insert eines Objektbereichs ausgeführt.

```SQL
CREATE TRIGGER tr_get_standort
BEFORE INSERT ON "obj_Objektbereich"
FOR EACH ROW EXECUTE PROCEDURE fn_get_standort();
```

Wird beim Insert eines Objektbereichs ausgeführt.

```SQL
CREATE TRIGGER tr_get_standort
BEFORE INSERT ON "obj_Objektbereich_line"
FOR EACH ROW EXECUTE PROCEDURE fn_get_standort();
```
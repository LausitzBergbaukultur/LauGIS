# Funktion: create objectnumber

```SQL
SET search_path TO "Erfassung",public;
-- OR
SET search_path TO "Entwicklung",public;
```

---

Erzeugt eine neue, eindeutige Objektnummer und gibt deren ID zurück..

```SQL
CREATE OR REPLACE FUNCTION fn_create_objectnumber()
	RETURNS integer AS $$
BEGIN
	-- INSERT INTO "Entwicklung"."ref_Objektnummer"
	INSERT INTO "Erfassung"."ref_Objektnummer"
    (
        objekt_nr
    )
    SELECT 
        MAX(id+32000001)	-- fortlaufende ID plus Konstante
    FROM 
        -- "Entwicklung"."ref_Objektnummer"
        "Erfassung"."ref_Objektnummer"
    ;
    -- RETURN (SELECT MAX(id) FROM "Entwicklung"."ref_Objektnummer");
    RETURN (SELECT MAX(id) FROM "Erfassung"."ref_Objektnummer");
END;
$$
LANGUAGE 'plpgsql';
```

Ruft die Funktion zum Erzeugen einer neuen Objektnummer auf und trägt die übergebene ID in ein neu erstelltes Objekt ein.

```SQL
CREATE OR REPLACE FUNCTION fn_getnew_objectnumber()
	RETURNS trigger AS $$
BEGIN
	-- SELECT "Entwicklung".fn_create_objectnumber()
	SELECT "Erfassung".fn_create_objectnumber()
    INTO NEW."objekt_nr";
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
```

## Trigger: 

Wird beim Insert eines Einzelobjektes ausgeführt.

```SQL
CREATE TRIGGER tr_getnew_objectnumber
BEFORE INSERT ON "obj_Einzelobjekt"
FOR EACH ROW EXECUTE PROCEDURE fn_getnew_objectnumber();


CREATE TRIGGER tr_getnew_objectnumber
BEFORE INSERT ON "obj_Einzelobjekt_line"
FOR EACH ROW EXECUTE PROCEDURE fn_getnew_objectnumber();


CREATE TRIGGER tr_getnew_objectnumber
BEFORE INSERT ON "obj_Objektbereich"
FOR EACH ROW EXECUTE PROCEDURE fn_getnew_objectnumber();


CREATE TRIGGER tr_getnew_objectnumber
BEFORE INSERT ON "obj_Objektbereich_line"
FOR EACH ROW EXECUTE PROCEDURE fn_getnew_objectnumber();


CREATE TRIGGER tr_getnew_objectnumber
BEFORE INSERT ON "obj_Anlage"
FOR EACH ROW EXECUTE PROCEDURE fn_getnew_objectnumber();


CREATE TRIGGER tr_getnew_objectnumber
BEFORE INSERT ON "obj_Anlage_line"
FOR EACH ROW EXECUTE PROCEDURE fn_getnew_objectnumber();
```
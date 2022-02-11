-- Tausch der Kategorien 2 und 3. Um Sortierungen gem ID beizubehalten, werden die Referenzen getauscht. 

-- insert dummy entry
INSERT INTO "Erfassung"."def_Kategorie" (bezeichnung)
VALUES ('austausch');

-- check dummy id
SELECT * FROM "Erfassung"."def_Kategorie"
WHERE bezeichnung = 'austausch';

-- kategorie 2 -> dummy 9
UPDATE "Erfassung"."obj_Einzelobjekt"
SET kategorie = 9
WHERE kategorie = 2;
UPDATE "Erfassung"."obj_Einzelobjekt_line"
SET kategorie = 9
WHERE kategorie = 2;
UPDATE "Erfassung"."obj_Objektbereich"
SET kategorie = 9
WHERE kategorie = 2;
UPDATE "Erfassung"."obj_Objektbereich_line"
SET kategorie = 9
WHERE kategorie = 2;

-- new description - Kat 2
UPDATE "Erfassung"."def_Kategorie"
SET bezeichnung = 'Kat. 2 - Kraftwerke (Verstromung, Fernwärme)'
WHERE id = 2

-- kategorie 3 old -> kategorie 2
UPDATE "Erfassung"."obj_Einzelobjekt"
SET kategorie = 2
WHERE kategorie = 3;
UPDATE "Erfassung"."obj_Einzelobjekt_line"
SET kategorie = 2
WHERE kategorie = 3;
UPDATE "Erfassung"."obj_Objektbereich"
SET kategorie = 2
WHERE kategorie = 3;
UPDATE "Erfassung"."obj_Objektbereich_line"
SET kategorie = 2
WHERE kategorie = 3;

-- new description - Kat 3
UPDATE "Erfassung"."def_Kategorie"
SET bezeichnung = 'Kat. 3 - Veredelung'
WHERE id = 3;

-- kategorie 2 old (dummy) -> kategorie 3
UPDATE "Erfassung"."obj_Einzelobjekt"
SET kategorie = 3
WHERE kategorie = 9;
UPDATE "Erfassung"."obj_Einzelobjekt_line"
SET kategorie = 3
WHERE kategorie = 9;
UPDATE "Erfassung"."obj_Objektbereich"
SET kategorie = 3
WHERE kategorie = 9;
UPDATE "Erfassung"."obj_Objektbereich_line"
SET kategorie = 3
WHERE kategorie = 9;

-- delete dummy
DELETE FROM "Erfassung"."def_Kategorie"
WHERE id = 9;
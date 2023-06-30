-- Autor: Alexandra Krug	Datum: 20230512 
-- Snippet, um doppelte Leerzeichen in verschiedenen Feldern zu entfernen.

-- Objekte identifizieren
SELECT objekt_nr, LENGTH(beschreibung)-LENGTH(REPLACE(beschreibung, '  ', ' ')) AS diff, laugis.read_erfasser(objekt_id, true)--, beschreibung, REPLACE(beschreibung, '  ', ' ') AS korrektur
FROM laugis.obj_basis
WHERE beschreibung LIKE '%  %'
ORDER BY read_erfasser, diff;

-- Objekte korrigieren, bei höchstens drei Vorkommen
UPDATE laugis.obj_basis
SET beschreibung = REPLACE(beschreibung, '  ', ' ')
WHERE beschreibung LIKE '%  %'
	AND LENGTH(beschreibung)-LENGTH(REPLACE(beschreibung, '  ', ' ')) <= 3;
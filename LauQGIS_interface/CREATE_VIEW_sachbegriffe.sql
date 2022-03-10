CREATE OR REPLACE VIEW development.def_sachbegriffe AS

SELECT sb_erw.id AS "id", sb_erw.sachbegriff AS "sachbegriff", sb_basis.sachbegriff AS "sachbegriff_ueber", sb_erw.kategorie AS "kategorie", sb_erw.show_anlage AS "anlage", sb_erw.ref_sachbegriff_id AS "ref_sachbegriff_id", sb_erw.sortierung AS "sortierung"
FROM development.def_sachbegriff as sb_erw
	LEFT JOIN development.def_sachbegriff as sb_basis ON sb_erw.ref_sachbegriff_id = sb_basis.id
ORDER BY sb_erw.sortierung
;


--
/*SELECT 
    
SELECT sb_basis.sachbegriff || ' > ' || sb_erw.sachbegriff
FROM development.def_sachbegriff as sb_erw
	JOIN development.def_sachbegriff as sb_basis ON sb_erw.ref_sachbegriff_id = sb_basis.id
WHERE sb_erw.kategorie = 1
ORDER BY sb_erw.id;

SELECT sachbegriff
FROM development.def_sachbegriff AS sb
WHERE (sb.ref_sachbegriff_id IS NULL OR sb.ref_sachbegriff_id = sb.id)
AND sb.kategorie = 1


SELECT COALESCE(sb1.sachbegriff, '') || ' / ' || sb2.sachbegriff, sb1.sachbegriff, sb2.sachbegriff, sb1.id, sb2.id
FROM development.def_sachbegriff as sb1
	RIGHT OUTER JOIN development.def_sachbegriff as sb2 on sb1.id = sb2.ref_sachbegriff_id
WHERE sb2.kategorie = 2

-- ermittelt sachbegriffe mit pfad
SELECT COALESCE(sb_basis.sachbegriff, '-') || ' > ' || sb_erw.sachbegriff
FROM development.def_sachbegriff as sb_erw
	LEFT JOIN development.def_sachbegriff as sb_basis ON sb_erw.ref_sachbegriff_id = sb_basis.id
WHERE sb_erw.kategorie = 1
ORDER BY sb_erw.id

-- ermittelt nur oberbegriffe
SELECT sachbegriff || ' +'
FROM development.def_sachbegriff AS sb
WHERE sb.ref_sachbegriff_id = sb.id
UNION
-- ermittelt nur einzelbegriffe
SELECT sachbegriff
FROM development.def_sachbegriff AS sb
WHERE sb.ref_sachbegriff_id IS NULL*/

CREATE OR REPLACE VIEW lauqgis.sachbegriffe AS

SELECT sb_erw.id AS "id", sb_erw.sachbegriff AS "sachbegriff", sb_basis.sachbegriff AS "sachbegriff_ueber"
	, sb_erw.kategorie AS "kategorie", sb_erw.show_anlage AS "anlage"
	, laugis.check_sachbegriff_anlage(sb_erw.id, sb_erw.ref_sachbegriff_id) AS anlage_erweitert
	, sb_erw.ref_sachbegriff_id AS "ref_sachbegriff_id", sb_erw.sortierung AS "sortierung"
FROM laugis.def_sachbegriff as sb_erw
	LEFT JOIN laugis.def_sachbegriff as sb_basis ON sb_erw.ref_sachbegriff_id = sb_basis.id
ORDER BY sb_erw.sortierung
;
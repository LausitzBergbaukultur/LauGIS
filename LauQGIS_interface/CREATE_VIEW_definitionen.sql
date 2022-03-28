CREATE OR REPLACE VIEW development.definitionen AS

SELECT CAST(row_number() OVER () AS integer) AS PID, *
FROM (
		SELECT 'def_personen' AS tabelle, per.id, per.bezeichnung, per.is_ausfuehrend, per.sortierung
		FROM development.def_personen AS per
	UNION
		SELECT 'def_bearbeitung' AS tabelle, bea.id, bea.bezeichnung, NULL AS is_ausfuehrend, bea.sortierung
		FROM development.def_bearbeitung AS bea
	UNION
		SELECT 'def_kategorie' AS tabelle, kat.id, kat.bezeichnung, NULL AS is_ausfuehrend, kat.sortierung
		FROM development.def_kategorie AS kat
	UNION
		SELECT 'def_datierung' AS tabelle, dat.id, dat.bezeichnung, NULL AS is_ausfuehrend, dat.sortierung
		FROM development.def_datierung AS dat
	UNION
		SELECT 'def_blickbeziehung' AS tabelle, blk.id, blk.bezeichnung, NULL AS is_ausfuehrend, blk.sortierung
		FROM development.def_blickbeziehung AS blk
	UNION
		SELECT 'def_schutzstatus' AS tabelle, stz.id, stz.bezeichnung, NULL AS is_ausfuehrend, stz.sortierung
		FROM development.def_schutzstatus AS stz 
	UNION
		SELECT 'def_erhaltungszustand' AS tabelle, erh.id, erh.bezeichnung, NULL AS is_ausfuehrend, erh.sortierung
		FROM development.def_erhaltungszustand AS erh
	UNION
		SELECT 'def_erfasser' AS tabelle, erf.id, erf.name AS bezeichnung, NULL AS is_ausfuehrend, erf.sortierung
		FROM development.def_erfasser AS erf
	UNION
		SELECT 'def_jahresschnitt' AS tabelle, jsn.id, jsn.bezeichnung, NULL as is_ausfuehrend, jsn.sortierung
		FROM development.def_jahresschnitt AS jsn
	UNION
		SELECT 'def_nutzungsart' AS tabelle, ntz.id, ntz.bezeichnung, NULL as is_ausfuehrend, ntz.sortierung
		FROM development.def_nutzungsart AS ntz
	UNION
		SELECT 'def_material' AS tabelle, mat.id, mat.bezeichnung, NULL as is_ausfuehrend, mat.sortierung
		FROM development.def_material AS mat
	UNION
		SELECT 'def_dachform' AS tabelle, daf.id, daf.bezeichnung, NULL as is_ausfuehrend, daf.sortierung
		FROM development.def_dachform AS daf
	UNION
		SELECT 'def_dachform' AS tabelle, daf.id, daf.bezeichnung, NULL as is_ausfuehrend, daf.sortierung
		FROM development.def_dachform AS daf
	UNION
		SELECT 'def_konstruktion' AS tabelle, kon.id, kon.bezeichnung, NULL as is_ausfuehrend, kon.sortierung
		FROM development.def_konstruktion AS kon
		
	ORDER BY tabelle, sortierung

) AS subquery
;
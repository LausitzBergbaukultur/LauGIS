/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-05-31
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Reads and orders the occurence of definition entries, grouped by their respective
					table. Offers a brief insight into the effective usage.
Call by:            none
Affected tables:	none
Used By:            Administration and possibly exports
Parameters:			none
***************************************************************************************************/

CREATE OR REPLACE VIEW public.laugis_definitionen_nutzung AS

	SELECT CAST(row_number() OVER () AS integer) AS PID, tabelle, bezeichnung, anzahl
	FROM (
		SELECT 'Konstruktion / Technik' AS tabelle, bezeichnung, COUNT(relation_id) AS anzahl
		FROM laugis.def_konstruktion AS def
			LEFT JOIN laugis.rel_konstruktion AS rel 
			ON def.id = rel.ref_konstruktion_id
		GROUP BY id
	UNION
		SELECT 'Material' AS tabelle, bezeichnung, COUNT(relation_id) AS anzahl
		FROM laugis.def_material AS def
			LEFT JOIN laugis.rel_material AS rel ON def.id = rel.ref_material_id
		GROUP BY id
	UNION
		SELECT 'Dachform' AS tabelle, bezeichnung, COUNT(relation_id) AS anzahl
		FROM laugis.def_dachform AS def
			LEFT JOIN laugis.rel_dachform AS rel ON def.id = rel.ref_dachform_id
		GROUP BY id

		ORDER BY tabelle, anzahl DESC
	) AS sq
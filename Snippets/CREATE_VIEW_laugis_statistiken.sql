/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-06-30
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Shows a brief statistic based upon the object status.
***************************************************************************************************/

-- DROP VIEW public.laugis_statistiken; 
CREATE OR REPLACE VIEW public.laugis_statistiken AS

SELECT 
	(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht) AS "Objekte gesamt",
		
	(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht	AND status_bearbeitung = 1)::text || ' (' ||
	((((SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht	AND status_bearbeitung = 1)::real
		/(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht)::real)*100)::integer) || ' %)' AS "1. In Bearbeitung",
		
	(SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND (status_bearbeitung = 2 OR status_bearbeitung = 4))::text || ' (' ||
	((((SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND (status_bearbeitung = 2 OR status_bearbeitung = 4))::real
		/(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht)::real)*100)::integer) || ' %)' AS "2./3. In Prüfung",
				
	(SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 3)::text || ' (' ||
	((((SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 3)::real
		/(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht)::real)*100)::integer) || ' %)' AS "4. abgeschlossen",
	
	(SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 5)::text || ' (' ||
	((((SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 5)::real
		/(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht)::real)*100)::integer) || ' %)' AS "5. in Korrektur",
		
		(SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 7)::text || ' (' ||
	((((SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 7)::real
		/(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht)::real)*100)::integer) || ' %)' AS "6. Rückfrage",
		
	(SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 6)::text || ' (' ||
	((((SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 6)::real
		/(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht)::real)*100)::integer) || ' %)' AS "7. korrigiert"
;
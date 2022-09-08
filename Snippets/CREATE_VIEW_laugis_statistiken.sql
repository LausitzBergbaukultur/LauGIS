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
		WHERE NOT geloescht)::real)*100)::integer) || ' %)' AS "In Bearbeitung",
	(SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND (status_bearbeitung = 2 OR status_bearbeitung = 4))::text || ' (' ||
	((((SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND (status_bearbeitung = 2 OR status_bearbeitung = 4))::real
		/(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht)::real)*100)::integer) || ' %)' AS "In Prüfung",
	(SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 3)::text || ' (' ||
	((((SELECT count(status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht AND status_bearbeitung = 3)::real
		/(SELECT count(obb.status_bearbeitung)
		FROM laugis.obj_basis AS obb
		WHERE NOT geloescht)::real)*100)::integer) || ' %)' AS "abgeschlossen"
;
-- Die View repräsentiert die Struktur "Landschaftswandelkarte"
-- Die zugehörigen Geometrie ist Multipolygon
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

DROP VIEW lauqgis.landschaftswandel_bereich;
CREATE VIEW lauqgis.landschaftswandel_bereich AS

SELECT 
    lwk.objekt_id,
	lwk.erfassungsdatum,			-- 9580
	lwk.aenderungsdatum,			-- 9950
    lwk.erfassung,

    -- Identifikatoren
   	lwk.beschriftung,				-- Bezeichnung und Identifikation
    lwk.grundlage,
    COALESCE(grl.bezeichnung, '') || ': ' || COALESCE(grl.autorschaft, '') || ', ' || COALESCE(grl.erstellt, '') AS read_grundlage,
    grl.jahresschnitt,
    lwk.nutzungsart,

	-- # Geometrie 
	geo.geom
		
	FROM laugis.obj_lwk AS lwk
	JOIN laugis.geo_lwk_poly AS geo ON lwk.objekt_id = geo.ref_objekt_id
	LEFT JOIN laugis.rel_grundlage AS grl ON lwk.grundlage = grl.id
	WHERE lwk.geloescht IS NOT TRUE
;
	
CREATE TRIGGER tr_instead_lwk_bereich
INSTEAD OF INSERT OR UPDATE OR DELETE ON lauqgis.landschaftswandel_bereich
    FOR EACH ROW EXECUTE FUNCTION lauqgis.trf_landschaftswandel();
-- Die View repräsentiert die Struktur "Landschaftswandelkarte"
-- Die zugehörigen Geometrie ist Multilinestring
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

DROP VIEW lauqgis.landschaftswandel_strecke;
CREATE VIEW lauqgis.landschaftswandel_strecke AS

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
	JOIN laugis.geo_lwk_line AS geo ON lwk.objekt_id = geo.ref_objekt_id
	LEFT JOIN laugis.rel_grundlage AS grl ON lwk.grundlage = grl.id
	WHERE lwk.geloescht IS NOT TRUE
;
	
CREATE TRIGGER tr_instead_lwk_strcke
INSTEAD OF INSERT OR UPDATE OR DELETE ON lauqgis.landschaftswandel_strecke
    FOR EACH ROW EXECUTE FUNCTION lauqgis.trf_landschaftswandel();
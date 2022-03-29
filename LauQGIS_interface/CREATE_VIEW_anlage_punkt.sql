-- Die View repräsentiert die Struktur "Anlage"
-- Die zugehörige Geometrie ist "Punkt"
-- Es werden die zusammenhängenden Datensätze der Tabellen obj_basis und obj_anlage angezeigt.
-- Komplexe Daten werden als text(json[]) übergebem.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

CREATE OR REPLACE VIEW development.anlage_punkt AS

SELECT 
    -- # Metadaten
    	ob.objekt_id,
		ob.objekt_nr,
		ob.rel_objekt_nr,
		ob.status_bearbeitung,
		ob.erfassungsdatum, 
		ob.aenderungsdatum, 
		development.return_erfasser(ob.objekt_id) AS return_erfasser, 

    -- # Deskriptoren 
		ob.kategorie,
		ob.sachbegriff,
    	ob.sachbegriff_alt,
		ob.beschreibung, 
		ob.beschreibung_ergaenzung, 
		ob.lagebeschreibung, 
		ob.quellen_literatur, 
		ob.notiz_intern, 
		ob.hida_nr, 
		development.return_datierung(ob.objekt_id) AS return_datierung, 
		development.return_nutzung(ob.objekt_id) AS return_nutzung,
	    development.return_personen(ob.objekt_id) AS return_personen,
	    development.return_bilder(ob.objekt_id) AS return_bilder,
		ob.bilder_anmerkung,

		anl.antrieb,                   -- 5930
    	anl.abmessung,                 -- ?
    	anl.gewicht,                   -- ?
    	development.return_material(ob.objekt_id) AS return_material,               -- 5280
    	anl.material_alt,
    	development.return_konstruktion(ob.objekt_id) AS return_konstruktion,   -- 5300
		anl.konstruktion_alt,
		-- development.return_blickbeziehung(ob.objekt_id) AS return_blickbeziehung,

	-- # Geometrie 
		geo.geom
		
	FROM development.obj_basis AS ob
	JOIN development.geo_point AS geo ON ob.objekt_id = geo.ref_objekt_id
	JOIN development.obj_anlage AS anl ON ob.objekt_id = anl.ref_objekt_id
	WHERE ob.geloescht IS NOT TRUE
		-- # explizit kein Einzelobjekt
		AND NOT EXISTS (
		SELECT FROM development.obj_arch AS ar
		WHERE  ob.objekt_id = ar.ref_objekt_id
		)
;
	
CREATE TRIGGER tr_instead_anlage
INSTEAD OF INSERT OR UPDATE OR DELETE ON development.anlage_punkt
    FOR EACH ROW EXECUTE FUNCTION development.trf_anlage();
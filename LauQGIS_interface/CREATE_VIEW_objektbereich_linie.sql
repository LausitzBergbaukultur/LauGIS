-- Die View repräsentiert die Struktur "Objektbereich"
-- Die zugehörigen Geometrie ist Multiline
-- Objektbereiche definieren sich durch einen Eintrag in der obj_basis und die Abwesenheit einer Referenz zu obj_tech
-- Komplexe Daten werden als text(json[]) übergebem.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

CREATE OR REPLACE VIEW lauqgis.objektbereich_linie AS

SELECT 
    -- # Metadaten
    	ob.objekt_id,
		ob.objekt_nr,
		ob.rel_objekt_nr,
		ob.status_bearbeitung,
		ob.erfassungsdatum, 
		ob.aenderungsdatum, 
		laugis.return_erfasser(ob.objekt_id) AS return_erfasser, 

    -- # Deskriptoren 
		ob.kategorie,
		ob.sachbegriff,
    	ob.sachbegriff_alt,
		ob.beschreibung, 
		ob.beschreibung_ergaenzung, 
		ob.lagebeschreibung, 
		laugis.return_literatur(ob.objekt_id) AS return_literatur,
		ob.notiz_intern, 
		ob.hida_nr, 
		laugis.return_datierung(ob.objekt_id) AS return_datierung, 
		laugis.return_nutzung(ob.objekt_id) AS return_nutzung,
	    laugis.return_personen(ob.objekt_id) AS return_personen,
	    laugis.return_bilder(ob.objekt_id) AS return_bilder,
		ob.bilder_anmerkung,

    -- # Stammdaten  
		ob.bezeichnung, 
		ob.bauwerksname_eigenname,
		ob.schutzstatus, 
		ob.foerderfaehig,

	-- # Lokalisatoren
		ob.kreis, 
		ob.gemeinde, 
		ob.ort, 
		ob.sorbisch, 
		ob.strasse, 
		ob.hausnummer, 
		ob.gem_flur,
		laugis.return_blickbeziehung(ob.objekt_id) AS return_blickbeziehung,

	-- # Geometrie 
		geo.geom
		
	FROM laugis.obj_basis AS ob
	JOIN laugis.geo_line AS geo ON ob.objekt_id = geo.ref_objekt_id
	WHERE ob.geloescht IS NOT TRUE
		-- # explizit kein Einzelobjekt
		AND NOT EXISTS (
		SELECT FROM laugis.obj_tech AS tech
		WHERE ob.objekt_id = tech.ref_objekt_id
		)
;
	
CREATE TRIGGER tr_instead_objektbereich
INSTEAD OF INSERT OR UPDATE OR DELETE ON lauqgis.objektbereich_linie
    FOR EACH ROW EXECUTE FUNCTION lauqgis.trf_objektbereich();
-- Die View repräsentiert die Struktur "Objektbereich"
-- Die zugehörigen Geometrie ist Multipolygon
-- Es werden die zusammenhängenden Datensätze der Tabellen obj_basis und obj_stamm angezeigt.
-- Komplexe Daten werden als text(json[]) übergebem.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

CREATE OR REPLACE VIEW development.objektbereich_poly AS

SELECT 
    -- # Metadaten
    	objekt_id,
		ob.ref_objekt_id,
		stammdaten_id,
		objekt_nr, 
		erfassungsdatum, 
		aenderungsdatum, 
		development.return_erfasser(ob.objekt_id) AS return_erfasser, 

    -- # Deskriptoren
		in_bearbeitung, 
		beschreibung, 
		beschreibung_ergaenzung, 
		lagebeschreibung, 
		quellen_literatur, 
		notiz_intern, 
		hida_nr, 
		development.return_datierung(ob.objekt_id) AS return_datierung, 
	    -- Person_werk -> ref   
	    -- Soziet_werk -> ref
	    -- Person_verantw -> ref
	    -- Soziet_verantw -> ref
	    -- bilder_extern -> ref
	    -- bilder_intern -> ref
		
    -- # Stammdaten 
		sachbegriff, 
		bezeichnung, 
		bauwerksname_eigenname, 
		kategorie, 
		erhaltungszustand, 
		schutzstatus, 
		foerderfaehig,

	-- # Lokalisatoren
		kreis, 
		gemeinde, 
		ort, 
		sorbisch, 
		strasse, 
		hausnummer, 
		gem_flur,

	-- # Geometrie 
		geom
	FROM development.obj_basis AS ob
	JOIN development.geo_poly AS geo ON ob.objekt_id = geo.ref_objekt_id
	JOIN development.obj_stamm AS os ON ob.objekt_id = os.ref_objekt_id
	WHERE ob.geloescht IS NOT TRUE;

CREATE TRIGGER tr_instead_objektbereich
INSTEAD OF INSERT OR UPDATE OR DELETE ON development.objektbereich_poly
    FOR EACH ROW EXECUTE FUNCTION development.trf_objektbereich();
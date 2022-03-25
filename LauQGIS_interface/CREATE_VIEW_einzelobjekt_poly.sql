-- Die View repräsentiert die Struktur "Einzelobjekt"
-- Die zugehörigen Geometrie ist Multipolygon
-- Es werden die zusammenhängenden Datensätze der Tabellen obj_basis, obj_stamm und obj_arch angezeigt.
-- Komplexe Daten werden als text(json[]) übergebem.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

CREATE OR REPLACE VIEW development.einzelobjekt_poly AS

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

    -- # Stammdaten  
		os.bezeichnung, 
		os.bauwerksname_eigenname,
		os.erhaltungszustand, 
		os.schutzstatus, 
		os.foerderfaehig,

	-- # Lokalisatoren
		os.kreis, 
		os.gemeinde, 
		os.ort, 
		os.sorbisch, 
		os.strasse, 
		os.hausnummer, 
		os.gem_flur,
		development.return_blickbeziehung(ob.objekt_id) AS return_blickbeziehung,
   
	-- # Deskriptoren - Architektur
	    ar.geschosszahl,
	    ar.achsenzahl,
	    ar.grundriss,
	    NULL AS return_dachform, 		-- dachform -> ref              -- 5910     
	    ar.dachform_alt,
	    development.return_material(ob.objekt_id) AS return_material,
	    ar.material_alt,
	    NULL AS return_konstruktion, 	-- konstruktion_technik -> ref  -- 5300
	    ar.konstruktion_alt,

	-- # Geometrie 
		geo.geom

	FROM development.obj_basis AS ob
	JOIN development.geo_poly AS geo ON ob.objekt_id = geo.ref_objekt_id
	JOIN development.obj_stamm AS os ON ob.objekt_id = os.ref_objekt_id
	JOIN development.obj_arch AS ar ON ob.objekt_id = ar.ref_objekt_id
	WHERE ob.geloescht IS NOT TRUE;

CREATE TRIGGER tr_instead_einzelobjekt
INSTEAD OF INSERT OR UPDATE OR DELETE ON development.einzelobjekt_poly
    FOR EACH ROW EXECUTE FUNCTION development.trf_einzelobjekt();
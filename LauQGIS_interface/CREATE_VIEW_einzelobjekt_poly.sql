-- Die View repräsentiert die Struktur "Einzelobjekt"
-- Die zugehörigen Geometrie ist Multipolygon
-- Einzelobjekte definierenw sich über deinen zusammenhängenden Datensatz in obj_basis und obj_tech
-- Komplexe Daten werden als text(json[]) übergebem.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

CREATE OR REPLACE VIEW lauqgis.einzelobjekt_poly AS

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
   
	-- # Deskriptoren
		tech.techn_anlage,
	    laugis.return_material(ob.objekt_id) AS return_material,
	    tech.material_alt,
	    laugis.return_konstruktion(ob.objekt_id) AS return_konstruktion,
	    tech.konstruktion_alt,
	-- # Deskrptoren - Architektur
	    tech.geschosszahl,
	    tech.achsenzahl,
	    tech.grundriss,
	    laugis.return_dachform(ob.objekt_id) AS return_dachform,
	    tech.dachform_alt,
	-- # Deskriptoren - Technik
		tech.antrieb,
		tech.abmessung,
		tech.gewicht,

	-- # Geometrie 
		geo.geom

	FROM laugis.obj_basis AS ob
	JOIN laugis.geo_poly AS geo ON ob.objekt_id = geo.ref_objekt_id
	JOIN laugis.obj_tech AS tech ON ob.objekt_id = tech.ref_objekt_id
	WHERE ob.geloescht IS NOT TRUE;

CREATE TRIGGER tr_instead_einzelobjekt
INSTEAD OF INSERT OR UPDATE OR DELETE ON lauqgis.einzelobjekt_poly
    FOR EACH ROW EXECUTE FUNCTION lauqgis.trf_einzelobjekt();
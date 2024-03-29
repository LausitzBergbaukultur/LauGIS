/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-05-25
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        s.b.
Call by:            none
Affected tables:	none
Used By:            Systems interfacing LauGIS via LauQGIS.
Parameters:			none
***************************************************************************************************/

-- Die View repräsentiert die Struktur "Objektbereich"
-- Die zugehörigen Geometrie ist Multipolygon
-- Objektbereiche definieren sich durch einen Eintrag in der obj_basis und die Abwesenheit einer Referenz zu obj_tech
-- Komplexe Daten werden als text(json[]) übergebem.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

DROP VIEW lauqgis.objektbereich_poly;
CREATE VIEW lauqgis.objektbereich_poly AS

SELECT 
    -- # Metadaten
    	ob.objekt_id,
		ob.objekt_nr,
		ob.rel_objekt_nr,
		laugis.read_untergeordnet(ob.objekt_id) AS read_untergeordnet,
		ob.status_bearbeitung,
		ob.erfassungsdatum, 
		ob.aenderungsdatum, 
		laugis.return_erfasser(ob.objekt_id) AS return_erfasser, 
		laugis.read_erfasser(ob.objekt_id, true) AS read_erfasser, 

    -- # Deskriptoren 
		ob.kategorie,
		ob.sachbegriff,
    	ob.sachbegriff_alt,
		ob.beschreibung, 
		ob.beschreibung_ergaenzung, 
		ob.lagebeschreibung, 
		laugis.return_literatur(ob.objekt_id) AS return_literatur,
		laugis.read_literatur(ob.objekt_id) AS read_literatur,
		ob.notiz_intern, 
		ob.hida_nr, 
		laugis.return_datierung(ob.objekt_id) AS return_datierung,
		laugis.read_datierung(ob.objekt_id) AS read_datierung, 
		laugis.return_nutzung(ob.objekt_id) AS return_nutzung,
		laugis.read_nutzung(ob.objekt_id) AS read_nutzung,
	    laugis.return_personen(ob.objekt_id) AS return_personen,
	    laugis.read_personen(ob.objekt_id) AS read_personen,
	    laugis.return_bilder(ob.objekt_id) AS return_bilder,
	    laugis.read_bilder(ob.objekt_id) AS read_bilder,
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
		laugis.read_blickbeziehung(ob.objekt_id) AS read_blickbeziehung,

	-- # Geometrie 
		geo.geom,

	-- # interface (explicit text, nulled)
		NULL::text AS api
		
	FROM laugis.obj_basis AS ob
	JOIN laugis.geo_poly AS geo ON ob.objekt_id = geo.ref_objekt_id
	WHERE ob.geloescht IS NOT TRUE
		-- # explizit kein Einzelobjekt
		AND NOT EXISTS (
		SELECT FROM laugis.obj_tech AS tech
		WHERE ob.objekt_id = tech.ref_objekt_id
		)
;
	
CREATE TRIGGER tr_instead_objektbereich
INSTEAD OF INSERT OR UPDATE OR DELETE ON lauqgis.objektbereich_poly
    FOR EACH ROW EXECUTE FUNCTION lauqgis.trf_objektbereich();
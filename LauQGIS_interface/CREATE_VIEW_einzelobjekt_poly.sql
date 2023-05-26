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

-- Die View repräsentiert die Struktur "Einzelobjekt"
-- Die zugehörigen Geometrie ist Multipolygon
-- Einzelobjekte definierenw sich über deinen zusammenhängenden Datensatz in obj_basis und obj_tech
-- Komplexe Daten werden als text(json[]) übergebem.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

DROP VIEW lauqgis.einzelobjekt_poly;
CREATE VIEW lauqgis.einzelobjekt_poly AS

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
   
	-- # Deskriptoren
		tech.techn_anlage,
	    laugis.return_material(ob.objekt_id) AS return_material,
	    laugis.read_material(ob.objekt_id) AS read_material,
	    tech.material_alt,
	    laugis.return_konstruktion(ob.objekt_id) AS return_konstruktion,
	    laugis.read_konstruktion(ob.objekt_id) AS read_konstruktion,
	    tech.konstruktion_alt,
	-- # Deskriptoren - Architektur
	    tech.geschosszahl,
	    tech.achsenzahl,
	    tech.grundriss,
	    laugis.return_dachform(ob.objekt_id) AS return_dachform,
	    laugis.read_dachform(ob.objekt_id) AS read_dachform,
	    tech.dachform_alt,
	-- # Deskriptoren - Technik
		tech.antrieb,
		tech.abmessung,
		tech.gewicht,

	-- # Geometrie 
		geo.geom,

	-- # interface (explicit text, nulled)
		NULL::text AS api

	FROM laugis.obj_basis AS ob
	JOIN laugis.geo_poly AS geo ON ob.objekt_id = geo.ref_objekt_id
	JOIN laugis.obj_tech AS tech ON ob.objekt_id = tech.ref_objekt_id
	WHERE ob.geloescht IS NOT TRUE;

CREATE TRIGGER tr_instead_einzelobjekt
INSTEAD OF INSERT OR UPDATE OR DELETE ON lauqgis.einzelobjekt_poly
    FOR EACH ROW EXECUTE FUNCTION lauqgis.trf_einzelobjekt();
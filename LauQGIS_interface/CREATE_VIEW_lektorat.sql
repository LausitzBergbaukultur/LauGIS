/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-04-27
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Selects a subset of fields for use in proofreading. Only shows items with status 5-7 ('in Korrektur', 'korrigiert', 'Rückfrage')
Call by:            view lauqgis.lektorat
Affected tables:	laugis.obj_basis
					laugis.obj_hist
Used By:            Interface views and exports
Parameters:			none
***************************************************************************************************/

DROP VIEW lauqgis.lektorat;
CREATE VIEW lauqgis.lektorat AS

SELECT 
	-- # angezeigte Felder, Rechte werden in der GUI gesetzt
		ob.objekt_nr,							-- read only
		ob.rel_objekt_nr,						-- read only
		kat.bezeichnung AS read_kategorie, 		-- read only
		ob.bezeichnung,							-- rw	
		COALESCE(laugis.read_sachbegriff(ob.objekt_id), '') AS read_sachbegriff,	-- read only
    	ob.bauwerksname_eigenname,				-- rw			
		ob.beschreibung,						-- rw
		ob.beschreibung_ergaenzung,				-- rw 
		COALESCE(laugis.read_literatur(ob.objekt_id), '') AS read_literatur, 	-- read only
		COALESCE(laugis.read_bilder(ob.objekt_id), '') AS read_bilder,			-- read only
		laugis.read_erfasser(ob.objekt_id, true) AS erfasser, 					-- read only
		COALESCE(laugis.read_erfasser(ob.objekt_id, false), '') AS beitraeger,	-- read only
		ob.erfassungsdatum, 					-- read only
		ob.aenderungsdatum,  					-- read only
		ob.status_bearbeitung,					-- rw
    
    -- # legacy Felder zur Nutzung existierender Funktionen, werden in der GUI ausgeblendet
    -- # Metadaten
    	ob.objekt_id,
		laugis.return_erfasser(ob.objekt_id) AS return_erfasser,

    -- # Deskriptoren 
		ob.kategorie,
		ob.sachbegriff,
    	ob.sachbegriff_alt,
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
		laugis.return_blickbeziehung(ob.objekt_id) AS return_blickbeziehung

	FROM laugis.obj_basis AS ob
	LEFT JOIN laugis.def_kategorie AS kat
		ON ob.kategorie = kat.id
	LEFT JOIN laugis.def_bearbeitung AS bea
		ON ob.status_bearbeitung = bea.id
	WHERE ob.geloescht IS NOT TRUE
		AND ob.status_bearbeitung IN (5, 6, 7)
	ORDER BY ob.objekt_nr DESC
;

-- Trigger wird nur für UPDATE ausgelöst
CREATE TRIGGER tr_instead_lektorat
INSTEAD OF UPDATE ON lauqgis.lektorat
    FOR EACH ROW EXECUTE FUNCTION lauqgis.trf_lektorat();
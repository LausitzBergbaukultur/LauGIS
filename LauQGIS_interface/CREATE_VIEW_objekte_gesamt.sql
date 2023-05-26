/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-05-12
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Selects all valid (not deleted) objects and presents them optimized for humand readability and printability.
Call by:            none
Affected tables:	none
Used By:            Systems interfacing LauGIS via LauQGIS.
Parameters:			none
***************************************************************************************************/

DROP VIEW lauqgis.objekte_gesamt;
CREATE VIEW lauqgis.objekte_gesamt AS

SELECT * 
FROM
	(SELECT 
    -- # Metadaten
		ob.objekt_nr,
		'Einzelobjekt (Linie)' AS objekttyp,
		ob.bezeichnung,
		bea.bezeichnung AS status, 				--ob.status_bearbeitung,
		kat.bezeichnung AS kategorie, 			--ob.kategorie,
		--'Kat. ' || sachb.kategorie || ' - ' || sachb.sachbegriff_ueber || ' > ' || sachb.sachbegriff AS sachbegriff,	-- ob.sachbegriff,
		COALESCE(laugis.read_sachbegriff(ob.objekt_id), '') AS sachbegriff,
    	COALESCE(ob.sachbegriff_alt, '') AS sachbegriff_alt,
		COALESCE(ob.rel_objekt_nr::text, '') AS objekt_uebergeordnet,
		COALESCE(laugis.read_untergeordnet(ob.objekt_id), '') AS objekte_untergeordnet,

    -- # Deskriptoren
    	COALESCE(ob.bauwerksname_eigenname, '') AS bauwerksname_eigenname,		
		ob.beschreibung, 
		COALESCE(ob.beschreibung_ergaenzung, '') AS beschreibung_ergaenzung, 
		COALESCE(ob.lagebeschreibung, '') AS lagebeschreibung, 
		COALESCE(laugis.read_literatur(ob.objekt_id), '') AS literatur,
		COALESCE(ob.notiz_intern, '') AS notiz_intern, 
		COALESCE(ob.hida_nr, '') AS hida_nr, 
		COALESCE(laugis.read_datierung(ob.objekt_id), '') AS datierung, 
		COALESCE(laugis.read_nutzung(ob.objekt_id), '') AS nutzung,
	    COALESCE(laugis.read_personen(ob.objekt_id), '') AS personen,
	    COALESCE(laugis.read_bilder(ob.objekt_id), '') AS bilder,
		COALESCE(ob.bilder_anmerkung, '') AS bilder_anmerkung, 
		ob.erfassungsdatum, 
		ob.aenderungsdatum,  
		laugis.read_erfasser(ob.objekt_id, true) AS erfasser, 
		COALESCE(laugis.read_erfasser(ob.objekt_id, false), '') AS beitraeger, 

    -- # Stammdaten  
		COALESCE(sstatus.bezeichnung, '') AS schutzstatus, -- ob.schutzstatus, 
		COALESCE(ob.foerderfaehig::text, '') AS foerderfaehig,

	-- # Lokalisatoren
		COALESCE(ob.kreis, '') AS kreis,
		COALESCE(ob.gemeinde, '') AS gemeinde, 
		COALESCE(ob.ort, '') AS ort, 
		COALESCE(ob.sorbisch, '') AS sorbisch, 
		COALESCE(ob.strasse, '') AS strasse, 
		COALESCE(ob.hausnummer, '') AS hausnummer, 
		COALESCE(ob.gem_flur, '') AS gem_flur,
		COALESCE(laugis.read_blickbeziehung(ob.objekt_id), '') AS blickbeziehung,
   
	-- # Deskriptoren
		COALESCE(tech.techn_anlage::text, '') AS ist_anlage,
	    COALESCE(laugis.read_material(ob.objekt_id), '') AS material,
	    COALESCE(tech.material_alt, '') AS material_alt,
	    COALESCE(laugis.read_konstruktion(ob.objekt_id), '') AS konstruktion,
	    COALESCE(tech.konstruktion_alt, '') AS konstruktion_alt,
	-- # Deskriptoren - Architektur
	    COALESCE(tech.geschosszahl::text, '') AS geschosszahl,
	    COALESCE(tech.achsenzahl::text, '') AS achsenzahl,
	    COALESCE(tech.grundriss, '') AS grundriss,
	    COALESCE(laugis.read_dachform(ob.objekt_id), '') AS dachform,
	    COALESCE(tech.dachform_alt, '') AS dachform_alt,
	-- # Deskriptoren - Technik
		COALESCE(tech.antrieb, '') AS antrieb,
		COALESCE(tech.abmessung, '') AS abmessung,
		COALESCE(tech.gewicht, '') AS gewicht

	FROM laugis.obj_basis AS ob
	JOIN laugis.obj_tech AS tech 
		ON ob.objekt_id = tech.ref_objekt_id
	JOIN laugis.geo_line AS geo 
		ON ob.objekt_id = geo.ref_objekt_id
	LEFT JOIN laugis.def_kategorie AS kat
		ON ob.kategorie = kat.id
	LEFT JOIN laugis.def_bearbeitung AS bea
		ON ob.status_bearbeitung = bea.id
	--LEFT JOIN lauqgis.sachbegriffe AS sachb
	--	ON ob.sachbegriff = sachb.id
	LEFT JOIN laugis.def_schutzstatus AS sstatus
		ON ob.schutzstatus = sstatus.id
	WHERE ob.geloescht IS NOT TRUE

	UNION

	SELECT 
    -- # Metadaten
		ob.objekt_nr,
		'Einzelobjekt (Polygon)' AS objekttyp,
		ob.bezeichnung,
		bea.bezeichnung AS status, 				--ob.status_bearbeitung,
		kat.bezeichnung AS kategorie, 			--ob.kategorie,
		--'Kat. ' || sachb.kategorie || ' - ' || sachb.sachbegriff_ueber || ' > ' || sachb.sachbegriff AS sachbegriff,	-- ob.sachbegriff,
    	COALESCE(laugis.read_sachbegriff(ob.objekt_id), '') AS sachbegriff,
    	COALESCE(ob.sachbegriff_alt, '') AS sachbegriff_alt,
		COALESCE(ob.rel_objekt_nr::text, '') AS objekt_uebergeordnet,
		COALESCE(laugis.read_untergeordnet(ob.objekt_id), '') AS objekte_untergeordnet,

    -- # Deskriptoren
    	COALESCE(ob.bauwerksname_eigenname, '') AS bauwerksname_eigenname,		
		ob.beschreibung, 
		COALESCE(ob.beschreibung_ergaenzung, '') AS beschreibung_ergaenzung, 
		COALESCE(ob.lagebeschreibung, '') AS lagebeschreibung, 
		COALESCE(laugis.read_literatur(ob.objekt_id), '') AS literatur,
		COALESCE(ob.notiz_intern, '') AS notiz_intern, 
		COALESCE(ob.hida_nr, '') AS hida_nr, 
		COALESCE(laugis.read_datierung(ob.objekt_id), '') AS datierung, 
		COALESCE(laugis.read_nutzung(ob.objekt_id), '') AS nutzung,
	    COALESCE(laugis.read_personen(ob.objekt_id), '') AS personen,
	    COALESCE(laugis.read_bilder(ob.objekt_id), '') AS bilder,
		COALESCE(ob.bilder_anmerkung, '') AS bilder_anmerkung, 
		ob.erfassungsdatum, 
		ob.aenderungsdatum,  
		laugis.read_erfasser(ob.objekt_id, true) AS erfasser, 
		COALESCE(laugis.read_erfasser(ob.objekt_id, false), '') AS beitraeger, 

    -- # Stammdaten  
		COALESCE(sstatus.bezeichnung, '') AS schutzstatus, -- ob.schutzstatus, 
		COALESCE(ob.foerderfaehig::text, '') AS foerderfaehig,

	-- # Lokalisatoren
		COALESCE(ob.kreis, '') AS kreis,
		COALESCE(ob.gemeinde, '') AS gemeinde, 
		COALESCE(ob.ort, '') AS ort, 
		COALESCE(ob.sorbisch, '') AS sorbisch, 
		COALESCE(ob.strasse, '') AS strasse, 
		COALESCE(ob.hausnummer, '') AS hausnummer, 
		COALESCE(ob.gem_flur, '') AS gem_flur,
		COALESCE(laugis.read_blickbeziehung(ob.objekt_id), '') AS blickbeziehung,
   
	-- # Deskriptoren
		COALESCE(tech.techn_anlage::text, '') AS ist_anlage,
	    COALESCE(laugis.read_material(ob.objekt_id), '') AS material,
	    COALESCE(tech.material_alt, '') AS material_alt,
	    COALESCE(laugis.read_konstruktion(ob.objekt_id), '') AS konstruktion,
	    COALESCE(tech.konstruktion_alt, '') AS konstruktion_alt,
	-- # Deskriptoren - Architektur
	    COALESCE(tech.geschosszahl::text, '') AS geschosszahl,
	    COALESCE(tech.achsenzahl::text, '') AS achsenzahl,
	    COALESCE(tech.grundriss, '') AS grundriss,
	    COALESCE(laugis.read_dachform(ob.objekt_id), '') AS dachform,
	    COALESCE(tech.dachform_alt, '') AS dachform_alt,
	-- # Deskriptoren - Technik
		COALESCE(tech.antrieb, '') AS antrieb,
		COALESCE(tech.abmessung, '') AS abmessung,
		COALESCE(tech.gewicht, '') AS gewicht

	FROM laugis.obj_basis AS ob
	JOIN laugis.obj_tech AS tech 
		ON ob.objekt_id = tech.ref_objekt_id
	JOIN laugis.geo_poly AS geo 
		ON ob.objekt_id = geo.ref_objekt_id
	LEFT JOIN laugis.def_kategorie AS kat
		ON ob.kategorie = kat.id
	LEFT JOIN laugis.def_bearbeitung AS bea
		ON ob.status_bearbeitung = bea.id
	--LEFT JOIN lauqgis.sachbegriffe AS sachb
	--	ON ob.sachbegriff = sachb.id
	LEFT JOIN laugis.def_schutzstatus AS sstatus
		ON ob.schutzstatus = sstatus.id
	WHERE ob.geloescht IS NOT TRUE

	UNION

	SELECT 
    -- # Metadaten
		ob.objekt_nr,
		'Einzelobjekt (Punkt)' AS objekttyp,
		ob.bezeichnung,
		bea.bezeichnung AS status, 				--ob.status_bearbeitung,
		kat.bezeichnung AS kategorie, 			--ob.kategorie,
		--'Kat. ' || sachb.kategorie || ' - ' || sachb.sachbegriff_ueber || ' > ' || sachb.sachbegriff AS sachbegriff,	-- ob.sachbegriff,
    	COALESCE(laugis.read_sachbegriff(ob.objekt_id), '') AS sachbegriff,
    	COALESCE(ob.sachbegriff_alt, '') AS sachbegriff_alt,
		COALESCE(ob.rel_objekt_nr::text, '') AS objekt_uebergeordnet,
		COALESCE(laugis.read_untergeordnet(ob.objekt_id), '') AS objekte_untergeordnet,

    -- # Deskriptoren
    	COALESCE(ob.bauwerksname_eigenname, '') AS bauwerksname_eigenname,		
		ob.beschreibung, 
		COALESCE(ob.beschreibung_ergaenzung, '') AS beschreibung_ergaenzung, 
		COALESCE(ob.lagebeschreibung, '') AS lagebeschreibung, 
		COALESCE(laugis.read_literatur(ob.objekt_id), '') AS literatur,
		COALESCE(ob.notiz_intern, '') AS notiz_intern, 
		COALESCE(ob.hida_nr, '') AS hida_nr, 
		COALESCE(laugis.read_datierung(ob.objekt_id), '') AS datierung, 
		COALESCE(laugis.read_nutzung(ob.objekt_id), '') AS nutzung,
	    COALESCE(laugis.read_personen(ob.objekt_id), '') AS personen,
	    COALESCE(laugis.read_bilder(ob.objekt_id), '') AS bilder,
		COALESCE(ob.bilder_anmerkung, '') AS bilder_anmerkung, 
		ob.erfassungsdatum, 
		ob.aenderungsdatum,  
		laugis.read_erfasser(ob.objekt_id, true) AS erfasser, 
		COALESCE(laugis.read_erfasser(ob.objekt_id, false), '') AS beitraeger, 

    -- # Stammdaten  
		COALESCE(sstatus.bezeichnung, '') AS schutzstatus, -- ob.schutzstatus, 
		COALESCE(ob.foerderfaehig::text, '') AS foerderfaehig,

	-- # Lokalisatoren
		COALESCE(ob.kreis, '') AS kreis,
		COALESCE(ob.gemeinde, '') AS gemeinde, 
		COALESCE(ob.ort, '') AS ort, 
		COALESCE(ob.sorbisch, '') AS sorbisch, 
		COALESCE(ob.strasse, '') AS strasse, 
		COALESCE(ob.hausnummer, '') AS hausnummer, 
		COALESCE(ob.gem_flur, '') AS gem_flur,
		COALESCE(laugis.read_blickbeziehung(ob.objekt_id), '') AS blickbeziehung,
   
	-- # Deskriptoren
		COALESCE(tech.techn_anlage::text, '') AS ist_anlage,
	    COALESCE(laugis.read_material(ob.objekt_id), '') AS material,
	    COALESCE(tech.material_alt, '') AS material_alt,
	    COALESCE(laugis.read_konstruktion(ob.objekt_id), '') AS konstruktion,
	    COALESCE(tech.konstruktion_alt, '') AS konstruktion_alt,
	-- # Deskriptoren - Architektur
	    COALESCE(tech.geschosszahl::text, '') AS geschosszahl,
	    COALESCE(tech.achsenzahl::text, '') AS achsenzahl,
	    COALESCE(tech.grundriss, '') AS grundriss,
	    COALESCE(laugis.read_dachform(ob.objekt_id), '') AS dachform,
	    COALESCE(tech.dachform_alt, '') AS dachform_alt,
	-- # Deskriptoren - Technik
		COALESCE(tech.antrieb, '') AS antrieb,
		COALESCE(tech.abmessung, '') AS abmessung,
		COALESCE(tech.gewicht, '') AS gewicht

	FROM laugis.obj_basis AS ob
	JOIN laugis.obj_tech AS tech 
		ON ob.objekt_id = tech.ref_objekt_id
	JOIN laugis.geo_point AS geo 
		ON ob.objekt_id = geo.ref_objekt_id
	LEFT JOIN laugis.def_kategorie AS kat
		ON ob.kategorie = kat.id
	LEFT JOIN laugis.def_bearbeitung AS bea
		ON ob.status_bearbeitung = bea.id
	--LEFT JOIN lauqgis.sachbegriffe AS sachb
	--	ON ob.sachbegriff = sachb.id
	LEFT JOIN laugis.def_schutzstatus AS sstatus
		ON ob.schutzstatus = sstatus.id
	WHERE ob.geloescht IS NOT TRUE

	UNION

	SELECT 
    -- # Metadaten
		ob.objekt_nr,
		'Objektbereich (Linie)' AS objekttyp,
		ob.bezeichnung,
		bea.bezeichnung AS status, 				--ob.status_bearbeitung,
		kat.bezeichnung AS kategorie, 			--ob.kategorie,
		--'Kat. ' || sachb.kategorie || ' - ' || sachb.sachbegriff_ueber || ' > ' || sachb.sachbegriff AS sachbegriff,	-- ob.sachbegriff,
    	COALESCE(laugis.read_sachbegriff(ob.objekt_id), '') AS sachbegriff,
    	COALESCE(ob.sachbegriff_alt, '') AS sachbegriff_alt,
		COALESCE(ob.rel_objekt_nr::text, '') AS objekt_uebergeordnet,
		COALESCE(laugis.read_untergeordnet(ob.objekt_id), '') AS objekte_untergeordnet,

    -- # Deskriptoren
    	COALESCE(ob.bauwerksname_eigenname, '') AS bauwerksname_eigenname,		
		ob.beschreibung, 
		COALESCE(ob.beschreibung_ergaenzung, '') AS beschreibung_ergaenzung, 
		COALESCE(ob.lagebeschreibung, '') AS lagebeschreibung, 
		COALESCE(laugis.read_literatur(ob.objekt_id), '') AS literatur,
		COALESCE(ob.notiz_intern, '') AS notiz_intern, 
		COALESCE(ob.hida_nr, '') AS hida_nr, 
		COALESCE(laugis.read_datierung(ob.objekt_id), '') AS datierung, 
		COALESCE(laugis.read_nutzung(ob.objekt_id), '') AS nutzung,
	    COALESCE(laugis.read_personen(ob.objekt_id), '') AS personen,
	    COALESCE(laugis.read_bilder(ob.objekt_id), '') AS bilder,
		COALESCE(ob.bilder_anmerkung, '') AS bilder_anmerkung, 
		ob.erfassungsdatum, 
		ob.aenderungsdatum,  
		laugis.read_erfasser(ob.objekt_id, true) AS erfasser, 
		COALESCE(laugis.read_erfasser(ob.objekt_id, false), '') AS beitraeger, 

    -- # Stammdaten  
		COALESCE(sstatus.bezeichnung, '') AS schutzstatus, -- ob.schutzstatus, 
		COALESCE(ob.foerderfaehig::text, '') AS foerderfaehig,

	-- # Lokalisatoren
		COALESCE(ob.kreis, '') AS kreis,
		COALESCE(ob.gemeinde, '') AS gemeinde, 
		COALESCE(ob.ort, '') AS ort, 
		COALESCE(ob.sorbisch, '') AS sorbisch, 
		COALESCE(ob.strasse, '') AS strasse, 
		COALESCE(ob.hausnummer, '') AS hausnummer, 
		COALESCE(ob.gem_flur, '') AS gem_flur,
		COALESCE(laugis.read_blickbeziehung(ob.objekt_id), '') AS blickbeziehung,
   
	-- # Deskriptoren
		'' AS ist_anlage,
	    '' AS material,
	    '' AS material_alt,
	    '' AS konstruktion,
	    '' AS konstruktion_alt,
	-- # Deskriptoren - Architektur
	    '' AS geschosszahl,
	    '' AS achsenzahl,
	    '' AS grundriss,
	    '' AS dachform,
	    '' AS dachform_alt,
	-- # Deskriptoren - Technik
		'' AS antrieb,
		'' AS abmessung,
		'' AS gewicht

	FROM laugis.obj_basis AS ob
	JOIN laugis.geo_line AS geo 
		ON ob.objekt_id = geo.ref_objekt_id
	LEFT JOIN laugis.def_kategorie AS kat
		ON ob.kategorie = kat.id
	LEFT JOIN laugis.def_bearbeitung AS bea
		ON ob.status_bearbeitung = bea.id
	--LEFT JOIN lauqgis.sachbegriffe AS sachb
	--	ON ob.sachbegriff = sachb.id
	LEFT JOIN laugis.def_schutzstatus AS sstatus
		ON ob.schutzstatus = sstatus.id
	WHERE ob.geloescht IS NOT TRUE
		-- # explizit kein Einzelobjekt
		AND NOT EXISTS (
		SELECT FROM laugis.obj_tech AS tech
		WHERE ob.objekt_id = tech.ref_objekt_id
		)

	UNION

	SELECT 
    -- # Metadaten
		ob.objekt_nr,
		'Objektbereich (Polygon)' AS objekttyp,
		ob.bezeichnung,
		bea.bezeichnung AS status, 				--ob.status_bearbeitung,
		kat.bezeichnung AS kategorie, 			--ob.kategorie,
		--'Kat. ' || sachb.kategorie || ' - ' || sachb.sachbegriff_ueber || ' > ' || sachb.sachbegriff AS sachbegriff,	-- ob.sachbegriff,
    	COALESCE(laugis.read_sachbegriff(ob.objekt_id), '') AS sachbegriff,
    	COALESCE(ob.sachbegriff_alt, '') AS sachbegriff_alt,
		COALESCE(ob.rel_objekt_nr::text, '') AS objekt_uebergeordnet,
		COALESCE(laugis.read_untergeordnet(ob.objekt_id), '') AS objekte_untergeordnet,

    -- # Deskriptoren
    	COALESCE(ob.bauwerksname_eigenname, '') AS bauwerksname_eigenname,		
		ob.beschreibung, 
		COALESCE(ob.beschreibung_ergaenzung, '') AS beschreibung_ergaenzung, 
		COALESCE(ob.lagebeschreibung, '') AS lagebeschreibung, 
		COALESCE(laugis.read_literatur(ob.objekt_id), '') AS literatur,
		COALESCE(ob.notiz_intern, '') AS notiz_intern, 
		COALESCE(ob.hida_nr, '') AS hida_nr, 
		COALESCE(laugis.read_datierung(ob.objekt_id), '') AS datierung, 
		COALESCE(laugis.read_nutzung(ob.objekt_id), '') AS nutzung,
	    COALESCE(laugis.read_personen(ob.objekt_id), '') AS personen,
	    COALESCE(laugis.read_bilder(ob.objekt_id), '') AS bilder,
		COALESCE(ob.bilder_anmerkung, '') AS bilder_anmerkung, 
		ob.erfassungsdatum, 
		ob.aenderungsdatum,  
		laugis.read_erfasser(ob.objekt_id, true) AS erfasser, 
		COALESCE(laugis.read_erfasser(ob.objekt_id, false), '') AS beitraeger, 

    -- # Stammdaten  
		COALESCE(sstatus.bezeichnung, '') AS schutzstatus, -- ob.schutzstatus, 
		COALESCE(ob.foerderfaehig::text, '') AS foerderfaehig,

	-- # Lokalisatoren
		COALESCE(ob.kreis, '') AS kreis,
		COALESCE(ob.gemeinde, '') AS gemeinde, 
		COALESCE(ob.ort, '') AS ort, 
		COALESCE(ob.sorbisch, '') AS sorbisch, 
		COALESCE(ob.strasse, '') AS strasse, 
		COALESCE(ob.hausnummer, '') AS hausnummer, 
		COALESCE(ob.gem_flur, '') AS gem_flur,
		COALESCE(laugis.read_blickbeziehung(ob.objekt_id), '') AS blickbeziehung,
   
	-- # Deskriptoren
		'' AS ist_anlage,
	    '' AS material,
	    '' AS material_alt,
	    '' AS konstruktion,
	    '' AS konstruktion_alt,
	-- # Deskriptoren - Architektur
	    '' AS geschosszahl,
	    '' AS achsenzahl,
	    '' AS grundriss,
	    '' AS dachform,
	    '' AS dachform_alt,
	-- # Deskriptoren - Technik
		'' AS antrieb,
		'' AS abmessung,
		'' AS gewicht

	FROM laugis.obj_basis AS ob
	JOIN laugis.geo_poly AS geo 
		ON ob.objekt_id = geo.ref_objekt_id
	LEFT JOIN laugis.def_kategorie AS kat
		ON ob.kategorie = kat.id
	LEFT JOIN laugis.def_bearbeitung AS bea
		ON ob.status_bearbeitung = bea.id
	--LEFT JOIN lauqgis.sachbegriffe AS sachb
	--	ON ob.sachbegriff = sachb.id
	LEFT JOIN laugis.def_schutzstatus AS sstatus
		ON ob.schutzstatus = sstatus.id
	WHERE ob.geloescht IS NOT TRUE
		-- # explizit kein Einzelobjekt
		AND NOT EXISTS (
		SELECT FROM laugis.obj_tech AS tech
		WHERE ob.objekt_id = tech.ref_objekt_id
		)
	) AS sq
ORDER BY sq.objekt_nr DESC;
/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-04-27
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        s.b.
Call by:            view lauqgis.lektorat
Affected tables:	laugis.obj_basis
					laugis.obj_hist
Used By:            Interface views and exports
Parameters:			none
***************************************************************************************************/

-- Die Triggerfunktion behandelt die Eingaben der View lauqgis.lektorat
-- Die View löst ausschließlich UPDATES aus.
-- Eingeschränktes Feldinventar, es werden nur Felder aus obj_basis verarbeitet.
-- Fehlende Felder (obj_tech in Historisierung) werden als NULL übergeben.
-- Historisierung wird kommentiert.

CREATE OR REPLACE FUNCTION lauqgis.trf_lektorat()
RETURNS TRIGGER AS $$
BEGIN 

-- Ausschließlich UPDATE behandeln
IF (TG_OP = 'UPDATE') THEN

---------------------------------------------------------------------------------------------------------------
-- Historisierung: Abbild des Alt-Zustandes wird gesichert.
-- Besonderheit Lektorat: Kommentar wird in beschreibung_ergaenzung eingefügt, tech Felder sind NULL.
---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.write_obj_history(
		OLD.objekt_nr,  
		OLD.rel_objekt_nr,
		OLD.status_bearbeitung, 
		OLD.erfassungsdatum,
		OLD.aenderungsdatum, 
		OLD.return_erfasser,

		-- # Deskriptoren
		OLD.kategorie,  
		OLD.sachbegriff, 
		OLD.sachbegriff_alt, 
		OLD.beschreibung,  
		TRIM('[Lektorat] '||COALESCE(OLD.beschreibung_ergaenzung, '')), 
		OLD.lagebeschreibung, 
		OLD.return_literatur,
		OLD.notiz_intern,   
		OLD.hida_nr,
		OLD.return_datierung,
		OLD.return_nutzung,
		OLD.return_personen,
		OLD.return_bilder,
		OLD.bilder_anmerkung,   

		-- # Stammdaten
		OLD.bezeichnung, 
		OLD.bauwerksname_eigenname, 
		OLD.schutzstatus,
		OLD.foerderfaehig, 

		-- # Lokalisatoren
		OLD.kreis, 
		OLD.gemeinde,  
		OLD.ort,  
		OLD.sorbisch, 
		OLD.strasse,  
		OLD.hausnummer,  
		OLD.gem_flur,
		OLD.return_blickbeziehung,

		-- # Deskriptoren allgemein - werden im Lektorat nicht verarbeitet
		NULL, --OLD.techn_anlage,    
		NULL, --OLD.return_material,
		NULL, --OLD.material_alt,
		NULL, --OLD.return_konstruktion,
		NULL, --OLD.konstruktion_alt,

		-- # Deskriptoren architektonisch - werden im Lektorat nicht verarbeitet
		NULL, --OLD.geschosszahl,  
		NULL, --OLD.achsenzahl,  
		NULL, --OLD.grundriss,
		NULL, --OLD.return_dachform,   
		NULL, --OLD.dachform_alt,

		-- # Deskriptoren technische Anlage
		NULL, --OLD.antrieb,   
		NULL, --OLD.abmessung, 
		NULL --OLD.gewicht  
	);

---------------------------------------------------------------------------------------------------------------
-- Basis-Objekt updaten
---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_obj_basis(
	    -- # Metadaten
	    NEW.objekt_id,
		NEW.objekt_nr,
		NEW.rel_objekt_nr,
		NEW.status_bearbeitung,
		NEW.erfassungsdatum, 
		NEW.aenderungsdatum,

	    -- # Deskriptoren
		NEW.kategorie,
    	NEW.sachbegriff,
		NEW.sachbegriff_alt,
		NEW.beschreibung, 
		NEW.beschreibung_ergaenzung, 
		NEW.lagebeschreibung, 
		NEW.notiz_intern,
		NEW.hida_nr,
		NEW.bilder_anmerkung,
	    
	    -- # Stammdaten
		NEW.bezeichnung, 
		NEW.bauwerksname_eigenname, 
		NEW.schutzstatus, 
		NEW.foerderfaehig,

	    -- # Lokalisatoren
		NEW.kreis, 
		NEW.gemeinde, 
		NEW.ort, 
		NEW.sorbisch, 
		NEW.strasse, 
		NEW.hausnummer, 
		NEW.gem_flur,

	  	-- # Geometrie
		NULL
	);

    RETURN NEW;

END IF;

END;
$$ LANGUAGE plpgsql;
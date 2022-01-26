CREATE OR REPLACE FUNCTION development.trf_objektbereich()
RETURNS TRIGGER AS $$
DECLARE
	_ob_id integer;
	_erfasser text[];
BEGIN 

	raise notice 'Value: %', NEW.return_erfasser;

	-- inkorrekte ID-Übernahme abfangen
	IF (TG_OP = 'DELETE' OR TG_OP = 'UPDATE') THEN
		
		_ob_id = OLD.objekt_id;

	ELSIF (TG_OP = 'INSERT') THEN
	
		_ob_id = NULL;

	END IF;

	-- QGIS gibt das Array als TEXT zurück
	SELECT string_to_array(trim(both '()' from NEW.return_erfasser[1]), ',', 'NULL')
	INTO _erfasser;

    IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN

    	-- Prozedur zur Verwaltung des Objektes
        CALL development.write_objektbereich(
       	_ob_id,
			NEW.ref_objekt_id, 
			NEW.objekt_nr, 
			NEW.erfassungsdatum, 
			NEW.aenderungsdatum, 
			_erfasser,				
			NEW.in_bearbeitung, 
			NEW.beschreibung, 
			NEW.beschreibung_ergaenzung, 
			NEW.lagebeschreibung, 
			NEW.quellen_literatur, 
			NEW.notiz_intern,
			NEW.hida_nr, 
			NEW.sachbegriff, 
			NEW.bezeichnung, 
			NEW.bauwerksname_eigenname, 
			NEW.kategorie, 
			NEW.erhaltungszustand, 
			NEW.schutzstatus, 
			NEW.nachnutzungspotential, 
			NEW.kreis, 
			NEW.gemeinde, 
			NEW.ort, 
			NEW.sorbisch, 
			NEW.strasse, 
			NEW.hausnummer, 
			NEW.gem_flur, 
			NEW.geom
			);
        RETURN NEW;
    
    ELSIF (TG_OP = 'DELETE') THEN

    	PERFORM development.delete_objekt(_ob_id);
    	RETURN NULL;
    
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_instead_objektbereich
INSTEAD OF INSERT OR UPDATE OR DELETE ON development.objektbereich_poly
    FOR EACH ROW EXECUTE FUNCTION development.trf_objektbereich();
CREATE OR REPLACE FUNCTION lauqgis.trf_landschaftswandel()
RETURNS TRIGGER AS $$
DECLARE
	_obj_id integer;
BEGIN 

---------------------------------------------------------------------------------------------------------------
-- inkorrekte ID-Übernahme abfangen
---------------------------------------------------------------------------------------------------------------
	
	IF (TG_OP = 'DELETE' OR TG_OP = 'UPDATE') THEN
		
		_obj_id = OLD.objekt_id;

	ELSIF (TG_OP = 'INSERT') THEN
	
		_obj_id = NULL;

	END IF;

---------------------------------------------------------------------------------------------------------------
-- Löschprüfung. Bei Erfolg werden Objekte als gelöscht markiert.
---------------------------------------------------------------------------------------------------------------

IF (TG_OP = 'DELETE') THEN

	PERFORM laugis.delete_lwk(_obj_id);
    RETURN NULL;
    
ELSIF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN

---------------------------------------------------------------------------------------------------------------
-- Basis-Objekt anlegen/updaten und Objekt-Id ermitteln
---------------------------------------------------------------------------------------------------------------

	SELECT laugis.update_obj_lwk(
	    -- # Metadaten
	    _obj_id,				-- pk IF NOT NULL -> UPDATE
		NEW.erfassungsdatum,     -- 9580
		NEW.aenderungsdatum,     -- 9950
		NEW.erfassung,

		-- Identifikatoren
		NEW.beschriftung,        -- Bezeichnung und Identifikation
		NEW.jahresschnitt,
		NEW.nutzungsart,

		  -- # Geometrie
  		NEW.geom   
	)
	INTO _obj_id;

	RETURN NEW;

END IF;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------- 
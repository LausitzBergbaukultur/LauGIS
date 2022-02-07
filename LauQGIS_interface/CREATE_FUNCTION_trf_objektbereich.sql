CREATE OR REPLACE FUNCTION development.trf_objektbereich()
RETURNS TRIGGER AS $$
DECLARE
	_obj_id integer;
	_relation text[];
	_rel_id integer;
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

	PERFORM development.delete_objekt(_obj_id);
    RETURN NULL;
    
ELSIF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN

---------------------------------------------------------------------------------------------------------------
-- Basis-Objekt anlegen/updaten und Objekt-Id ermitteln
---------------------------------------------------------------------------------------------------------------

	SELECT development.update_obj_basis(
	    -- # Metadaten
	    _obj_id,				-- pk IF NOT NULL -> UPDATE
		NEW.ref_objekt_id, 
		NEW.objekt_nr, 
		NEW.erfassungsdatum, 
		NEW.aenderungsdatum,

	    -- # Deskriptoren
		NEW.in_bearbeitung, 
		NEW.beschreibung, 
		NEW.beschreibung_ergaenzung, 
		NEW.lagebeschreibung, 
		NEW.quellen_literatur, 
		NEW.notiz_intern,
		NEW.hida_nr,
	    
	  	-- # Geometrie
		NEW.geom
	)
	INTO _obj_id;

---------------------------------------------------------------------------------------------------------------
-- zugehöriges Stammdaten-Objekt anlegen/updaten
---------------------------------------------------------------------------------------------------------------

  	PERFORM development.update_obj_stamm(
	    _obj_id,                   -- fk zu angelegter Objekt-Basis, NOT NULL
	    -- # Stammdaten
		NEW.sachbegriff, 
		NEW.bezeichnung, 
		NEW.bauwerksname_eigenname, 
		NEW.kategorie, 
		NEW.erhaltungszustand, 
		NEW.schutzstatus, 
		NEW.nachnutzungspotential,

	    -- # Lokalisatoren
		NEW.kreis, 
		NEW.gemeinde, 
		NEW.ort, 
		NEW.sorbisch, 
		NEW.strasse, 
		NEW.hausnummer, 
		NEW.gem_flur
  	);

---------------------------------------------------------------------------------------------------------------
-- Relation: Erfasser
---------------------------------------------------------------------------------------------------------------
	-- erfasser = {{rel_id, obj_id (obsolet), erf_id, is_erfasser::bool}}

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
				FROM unnest(OLD.return_erfasser[:][1]) AS erf_old
				WHERE erf_old NOT IN (SELECT erf_new FROM unnest(NEW.return_erfasser[:][1]) as erf_new)
		LOOP
			PERFORM development.remove_erfasser(_rel_id);
		END LOOP;
	
	-- update for new
  	IF array_length(NEW.return_erfasser, 1) > 0 THEN
		FOREACH _relation SLICE 1 IN ARRAY NEW.return_erfasser
		LOOP
			-- Funktion für aktuellen Slice aufrufen
			PERFORM development.update_erfasser(
			_relation[1]::integer,
			_obj_id,
			_relation[3]::integer,
			_relation[4]::bool
			);
		END LOOP;
 	END IF;   

    RETURN NEW;

END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_instead_objektbereich
INSTEAD OF INSERT OR UPDATE OR DELETE ON development.objektbereich_poly
    FOR EACH ROW EXECUTE FUNCTION development.trf_objektbereich();
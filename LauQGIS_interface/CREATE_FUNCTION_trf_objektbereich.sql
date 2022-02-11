CREATE OR REPLACE FUNCTION development.trf_objektbereich()
RETURNS TRIGGER AS $$
DECLARE
	_obj_id integer;

	-- relation handling
	_rel_new text[];		-- text[] to store entries as json
	_rel_old_ids text[]; 	-- id list, type 'text' to handle literal 'NULL'
	_rel_new_ids text[];	-- -"-
	_rel_id text;			-- iterator and temp variable
	_rel json;				-- iterator
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

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_erfasser::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_erfasser::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM development.remove_erfasser(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_erfasser::json))
   	INTO _rel_new;
	
  	IF array_length(_rel_new, 1) > 0 THEN
		FOREACH _rel IN ARRAY(_rel_new)
		LOOP
			-- catch 'NULL' in rel_id -> used to identify new entries
			_rel_id = (_rel->>'relation_id')::text;
			IF _rel_id = 'NULL' THEN
				_rel_id = NULL;
			END IF;
			
			-- call update function
			PERFORM development.update_erfasser(
			_rel_id::integer,
			_obj_id,
			(_rel->>'ref_erfasser_id')::integer,
			(_rel->>'is_creator')::bool
			);
		END LOOP;
 	END IF;   

---------------------------------------------------------------------------------------------------------------
-- Relation: TODO
---------------------------------------------------------------------------------------------------------------

    RETURN NEW;

END IF;
END;
$$ LANGUAGE plpgsql;
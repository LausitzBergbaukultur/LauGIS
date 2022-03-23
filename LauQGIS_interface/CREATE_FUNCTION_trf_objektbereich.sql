CREATE OR REPLACE FUNCTION development.trf_objektbereich()
RETURNS TRIGGER AS $$
DECLARE
	_obj_id integer;

	-- relation handling
	_rel_new text[];		-- text[] to store entries as json
	_rel_old_ids text[]; 	-- id list, type 'text' to handle literal 'NULL'
	_rel_new_ids text[];	-- -"-
	_rel_id text;			-- iterator and temp variable
	_rel_temp text;			-- temp variable
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
		NEW.quellen_literatur, 
		NEW.notiz_intern,
		NEW.hida_nr,
		NEW.bilder_anmerkung,
	    
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
		NEW.bezeichnung, 
		NEW.bauwerksname_eigenname, 
		NEW.erhaltungszustand, 
		NEW.schutzstatus, 
		NEW.foerderfaehig,

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

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;
	
---------------------------------------------------------------------------------------------------------------
-- Relation: Datierung
--------------------------------------------------------------------------------------------------------------- 	

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_datierung::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_datierung::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM development.remove_datierung(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_datierung::json))
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
			PERFORM development.update_datierung(
			_rel_id::integer,
			_obj_id,
			(_rel->>'datierung')::text,
			(_rel->>'ref_ereignis_id')::integer,
			(_rel->>'alt_ereignis')::text
			);
		END LOOP;
	END IF;   

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;

---------------------------------------------------------------------------------------------------------------
-- Relation: Nutzung / Funktion
--------------------------------------------------------------------------------------------------------------- 	

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_nutzung::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_nutzung::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM development.remove_nutzung(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_nutzung::json))
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
			PERFORM development.update_nutzung(
			_rel_id::integer,
			_obj_id,
			(_rel->>'nutzungsart')::text,
			(_rel->>'datierung')::text
			);
		END LOOP;
	END IF;   

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;

---------------------------------------------------------------------------------------------------------------
-- Relation: Personen
--------------------------------------------------------------------------------------------------------------- 	

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_personen::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_personen::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM development.remove_personen(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_personen::json))
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
			PERFORM development.update_personen(
			_rel_id::integer,
			_obj_id,
			(_rel->>'bezeichnung')::text,
			(_rel->>'ref_funktion_id')::integer,
			(_rel->>'alt_funktion')::text,
			(_rel->>'is_sozietaet')::bool
			);
		END LOOP;
	END IF; 

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;

---------------------------------------------------------------------------------------------------------------
-- Relation: Blickbeziehung
--------------------------------------------------------------------------------------------------------------- 	

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_nutzung::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_nutzung::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM development.remove_blickbeziehung(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_blickbeziehung::json))
   	INTO _rel_new;
	
  	IF array_length(_rel_new, 1) > 0 THEN
		FOREACH _rel IN ARRAY(_rel_new)
		LOOP
			-- catch 'NULL' in rel_id -> used to identify new entries
			_rel_id = (_rel->>'relation_id')::text;
			IF _rel_id = 'NULL' THEN
				_rel_id = NULL;
			END IF;

			-- catch 'NULL' and '' in rel_obejkt_nr to ensure valid casting
			_rel_temp = (_rel->>'rel_objekt_nr')::text;
			IF _rel_temp = 'NULL' OR _rel_temp = '' THEN
				_rel_temp = NULL;
			END IF;
			
			-- call update function
			PERFORM development.update_blickbeziehung(
			_rel_id::integer,
			_obj_id,
			(_rel->>'beschreibung')::text,
			--(_rel->>'rel_objekt_nr')::integer,
			_rel_temp::integer,
			(_rel->>'ref_blick_id')::integer
			);
		END LOOP;
	END IF;   

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;
	_rel_temp = NULL;

---------------------------------------------------------------------------------------------------------------
-- Relation: Bilder
--------------------------------------------------------------------------------------------------------------- 	

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_bilder::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_bilder::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM development.remove_bilder(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_bilder::json))
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
			PERFORM development.update_bilder(
			_rel_id::integer,
			_obj_id,
			(_rel->>'dateiname')::text,
			(_rel->>'intern')::bool
			);
		END LOOP;
	END IF;   

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;

---------------------------------------------------------------------------------------------------------------
-- Relation: TODO
---------------------------------------------------------------------------------------------------------------
	
    RETURN NEW;

END IF;
END;
$$ LANGUAGE plpgsql;
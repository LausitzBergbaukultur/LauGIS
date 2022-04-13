-- VORSICHT! Nicht zum Update einer bestehenden Instanz geeignet!
--
-- Erzeugt alle notwendigen Views und Trigger zur Anbindung an QGIS.
-- Erwartet eine PostgreSQL Datenbank mit dem Schema 'lauqgis' sowie
-- einem mittels "setup_db_LAUGIS.sql" befüllten Schema 'laugis'.
--
-- Stand: 2020-04-13
-- Autor: Stefan Krug
--
--------------------------------------------------------------------------------------------------------------------------------------
-- # LAUQGIS INTERFACE
--------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
-- # trf_einzelobjekt (trigger function)
--------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION lauqgis.trf_einzelobjekt()
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

-----------------------------------------------------------------------------------------
-- inkorrekte ID-Übernahme abfangen
-----------------------------------------------------------------------------------------
	
	IF (TG_OP = 'DELETE' OR TG_OP = 'UPDATE') THEN
		
		_obj_id = OLD.objekt_id;

	ELSIF (TG_OP = 'INSERT') THEN
	
		_obj_id = NULL;

	END IF;

-----------------------------------------------------------------------------------------
-- Löschprüfung. Bei Erfolg werden Objekte als gelöscht markiert.
-----------------------------------------------------------------------------------------

IF (TG_OP = 'DELETE') THEN

	PERFORM laugis.delete_objekt(_obj_id);
    RETURN NULL;
    
ELSIF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN

-----------------------------------------------------------------------------------------
-- Basis-Objekt anlegen/updaten und Objekt-Id ermitteln
-----------------------------------------------------------------------------------------

	SELECT laugis.update_obj_basis(
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
		NEW.geom
	)
	INTO _obj_id;

-----------------------------------------------------------------------------------------
-- zugehöriges Architektur-Objekt anlegen/updaten
-----------------------------------------------------------------------------------------

  	PERFORM laugis.update_obj_tech(
	    _obj_id,                   -- fk zu angelegter Objekt-Basis, NOT NULL
	    -- # Deskriptoren allgemein
	    NEW.techn_anlage,
        NEW.material_alt,
        NEW.konstruktion_alt,
        -- # architektonisch
		NEW.geschosszahl, 
		NEW.achsenzahl,
		NEW.grundriss,
		NEW.dachform_alt,
		-- # technisch
		NEW.antrieb,
        NEW.abmessung,             
        New.gewicht		
  	);

-----------------------------------------------------------------------------------------
-- Relation: Erfasser
-----------------------------------------------------------------------------------------

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
		PERFORM laugis.remove_erfasser(_rel_id::integer);
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
			PERFORM laugis.update_erfasser(
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
	
------------------------------------------------------------------------------------------
-- Relation: Datierung
------------------------------------------------------------------------------------------	

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
		PERFORM laugis.remove_datierung(_rel_id::integer);
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
			PERFORM laugis.update_datierung(
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

---------------------------------------------------------------------------------------
-- Relation: Nutzung / Funktion
---------------------------------------------------------------------------------------	

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
		PERFORM laugis.remove_nutzung(_rel_id::integer);
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
			PERFORM laugis.update_nutzung(
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

-----------------------------------------------------------------------------------------
-- Relation: Personen
-----------------------------------------------------------------------------------------	

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
		PERFORM laugis.remove_personen(_rel_id::integer);
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
			PERFORM laugis.update_personen(
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

---------------------------------------------------------------------------------------
-- Relation: Blickbeziehung
---------------------------------------------------------------------------------------	

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
		PERFORM laugis.remove_blickbeziehung(_rel_id::integer);
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
			PERFORM laugis.update_blickbeziehung(
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

--------------------------------------------------------------------------------------
-- Relation: Bilder
--------------------------------------------------------------------------------------

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
		PERFORM laugis.remove_bilder(_rel_id::integer);
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
			PERFORM laugis.update_bilder(
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

---------------------------------------------------------------------------------------
-- Relation: Material
---------------------------------------------------------------------------------------

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_material::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_material::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM laugis.remove_material(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_material::json))
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
			PERFORM laugis.update_material(
			_rel_id::integer,
			_obj_id,
			(_rel->>'ref_material_id')::integer
			);
		END LOOP;
	END IF;   

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;

----------------------------------------------------------------------------------------
-- Relation: Dachform
----------------------------------------------------------------------------------------	

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_dachform::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_dachform::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM laugis.remove_dachform(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_dachform::json))
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
			PERFORM laugis.update_dachform(
			_rel_id::integer,
			_obj_id,
			(_rel->>'ref_dachform_id')::integer
			);
		END LOOP;
	END IF;   

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;

-------------------------------------------------------------------------------------------
-- Relation: Konstruktion
------------------------------------------------------------------------------------------- 	

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_konstruktion::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_konstruktion::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM laugis.remove_konstruktion(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_konstruktion::json))
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
			PERFORM laugis.update_konstruktion(
			_rel_id::integer,
			_obj_id,
			(_rel->>'ref_konstruktion_id')::integer
			);
		END LOOP;
	END IF;   

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;

----------------------------------------------------------------------------------------
-- Relation: Literatur
----------------------------------------------------------------------------------------	

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_literatur::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_literatur::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM laugis.remove_literatur(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_literatur::json))
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
			PERFORM laugis.update_literatur(
			_rel_id::integer,
			_obj_id,
			(_rel->>'literatur')::text,
			(_rel->>'lib_ref')::text
			);
		END LOOP;
	END IF;   

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;
	
    RETURN NEW;

END IF;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # trf_einzelobjekt (trigger function)
--------------------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION lauqgis.trf_objektbereich()
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

----------------------------------------------------------------------------------------
-- inkorrekte ID-Übernahme abfangen
----------------------------------------------------------------------------------------
	
	IF (TG_OP = 'DELETE' OR TG_OP = 'UPDATE') THEN
		
		_obj_id = OLD.objekt_id;

	ELSIF (TG_OP = 'INSERT') THEN
	
		_obj_id = NULL;

	END IF;

----------------------------------------------------------------------------------------
-- Löschprüfung. Bei Erfolg werden Objekte als gelöscht markiert.
----------------------------------------------------------------------------------------

IF (TG_OP = 'DELETE') THEN

	PERFORM laugis.delete_objekt(_obj_id);
    RETURN NULL;
    
ELSIF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN

----------------------------------------------------------------------------------------
-- Basis-Objekt anlegen/updaten und Objekt-Id ermitteln
----------------------------------------------------------------------------------------

	SELECT laugis.update_obj_basis(
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
		NEW.geom
	)
	INTO _obj_id;

----------------------------------------------------------------------------------------
-- Relation: Erfasser
----------------------------------------------------------------------------------------

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
		PERFORM laugis.remove_erfasser(_rel_id::integer);
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
			PERFORM laugis.update_erfasser(
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
	
----------------------------------------------------------------------------------------
-- Relation: Datierung
---------------------------------------------------------------------------------------- 	

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
		PERFORM laugis.remove_datierung(_rel_id::integer);
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
			PERFORM laugis.update_datierung(
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

----------------------------------------------------------------------------------------
-- Relation: Nutzung / Funktion
---------------------------------------------------------------------------------------- 	

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
		PERFORM laugis.remove_nutzung(_rel_id::integer);
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
			PERFORM laugis.update_nutzung(
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

----------------------------------------------------------------------------------------
-- Relation: Personen
---------------------------------------------------------------------------------------- 	

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
		PERFORM laugis.remove_personen(_rel_id::integer);
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
			PERFORM laugis.update_personen(
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

----------------------------------------------------------------------------------------
-- Relation: Blickbeziehung
---------------------------------------------------------------------------------------- 	

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
		PERFORM laugis.remove_blickbeziehung(_rel_id::integer);
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
			PERFORM laugis.update_blickbeziehung(
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

----------------------------------------------------------------------------------------
-- Relation: Bilder
---------------------------------------------------------------------------------------- 	

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
		PERFORM laugis.remove_bilder(_rel_id::integer);
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
			PERFORM laugis.update_bilder(
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

----------------------------------------------------------------------------------------
-- Relation: Literatur
---------------------------------------------------------------------------------------- 	

	-- determine text[] for old relation-ids to compare against 
   	SELECT ARRAY(SELECT json_array_elements(OLD.return_literatur::json)->>'relation_id')
   	INTO _rel_old_ids;
	
	-- determine text[] of new relation-ids to compare against 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_literatur::json)->>'relation_id')
   	INTO _rel_new_ids;

	-- delete diff old/new
	FOR _rel_id in SELECT erf_old
		FROM unnest(_rel_old_ids) AS erf_old
		WHERE erf_old NOT IN (SELECT erf_new FROM unnest(_rel_new_ids) as erf_new)
	LOOP
		PERFORM laugis.remove_literatur(_rel_id::integer);
	END LOOP;
	
	-- determine json[] for new/updated entries 
	SELECT ARRAY(SELECT json_array_elements(NEW.return_literatur::json))
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
			PERFORM laugis.update_literatur(
			_rel_id::integer,
			_obj_id,
			(_rel->>'literatur')::text,
			(_rel->>'lib_ref')::text
			);
		END LOOP;
	END IF;   

	-- clean variables
	_rel_old_ids = NULL;
	_rel_new_ids = NULL;
	
    RETURN NEW;

END IF;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------------------------------------------------
-- # definitionen (view)
-------------------------------------------------------------------------------------------------------------------------------------- 

CREATE OR REPLACE VIEW lauqgis.definitionen AS

SELECT CAST(row_number() OVER () AS integer) AS PID, *
FROM (
		SELECT 'def_personen' AS tabelle, per.id, per.bezeichnung, per.is_ausfuehrend, per.sortierung
		FROM laugis.def_personen AS per
	UNION
		SELECT 'def_bearbeitung' AS tabelle, bea.id, bea.bezeichnung, NULL AS is_ausfuehrend, bea.sortierung
		FROM laugis.def_bearbeitung AS bea
	UNION
		SELECT 'def_kategorie' AS tabelle, kat.id, kat.bezeichnung, NULL AS is_ausfuehrend, kat.sortierung
		FROM laugis.def_kategorie AS kat
	UNION
		SELECT 'def_datierung' AS tabelle, dat.id, dat.bezeichnung, NULL AS is_ausfuehrend, dat.sortierung
		FROM laugis.def_datierung AS dat
	UNION
		SELECT 'def_blickbeziehung' AS tabelle, blk.id, blk.bezeichnung, NULL AS is_ausfuehrend, blk.sortierung
		FROM laugis.def_blickbeziehung AS blk
	UNION
		SELECT 'def_schutzstatus' AS tabelle, stz.id, stz.bezeichnung, NULL AS is_ausfuehrend, stz.sortierung
		FROM laugis.def_schutzstatus AS stz 
	UNION
		SELECT 'def_erfasser' AS tabelle, erf.id, erf.name AS bezeichnung, NULL AS is_ausfuehrend, erf.sortierung
		FROM laugis.def_erfasser AS erf
	UNION
		SELECT 'def_jahresschnitt' AS tabelle, jsn.id, jsn.bezeichnung, NULL as is_ausfuehrend, jsn.sortierung
		FROM laugis.def_jahresschnitt AS jsn
	UNION
		SELECT 'def_nutzungsart' AS tabelle, ntz.id, ntz.bezeichnung, NULL as is_ausfuehrend, ntz.sortierung
		FROM laugis.def_nutzungsart AS ntz
	UNION
		SELECT 'def_material' AS tabelle, mat.id, mat.bezeichnung, NULL as is_ausfuehrend, mat.sortierung
		FROM laugis.def_material AS mat
	UNION
		SELECT 'def_dachform' AS tabelle, daf.id, daf.bezeichnung, NULL as is_ausfuehrend, daf.sortierung
		FROM laugis.def_dachform AS daf
	UNION
		SELECT 'def_dachform' AS tabelle, daf.id, daf.bezeichnung, NULL as is_ausfuehrend, daf.sortierung
		FROM laugis.def_dachform AS daf
	UNION
		SELECT 'def_konstruktion' AS tabelle, kon.id, kon.bezeichnung, NULL as is_ausfuehrend, kon.sortierung
		FROM laugis.def_konstruktion AS kon
		
	ORDER BY tabelle, sortierung

) AS subquery
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # sachbegriffe (view)
-------------------------------------------------------------------------------------------------------------------------------------- 

CREATE OR REPLACE VIEW lauqgis.sachbegriffe AS

SELECT sb_erw.id AS "id", sb_erw.sachbegriff AS "sachbegriff", sb_basis.sachbegriff AS "sachbegriff_ueber"
	, sb_erw.kategorie AS "kategorie", sb_erw.show_anlage AS "anlage"
	, laugis.check_sachbegriff_anlage(sb_erw.id, sb_erw.ref_sachbegriff_id) AS anlage_erweitert
	, sb_erw.ref_sachbegriff_id AS "ref_sachbegriff_id", sb_erw.sortierung AS "sortierung"
FROM laugis.def_sachbegriff as sb_erw
	LEFT JOIN laugis.def_sachbegriff as sb_basis ON sb_erw.ref_sachbegriff_id = sb_basis.id
ORDER BY sb_erw.sortierung
;

--------------------------------------------------------------------------------------------------------------------------------------
-- # einzelobjekt_poly (view)
-------------------------------------------------------------------------------------------------------------------------------------- 

-- Die View repräsentiert die Struktur "Einzelobjekt"
-- Die zugehörigen Geometrie ist Multipolygon
-- Einzelobjekte definierenw sich über deinen zusammenhängenden Datensatz in obj_basis und obj_tech
-- Komplexe Daten werden als text(json[]) übergebem.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

CREATE OR REPLACE VIEW lauqgis.einzelobjekt_poly AS

SELECT 
    -- # Metadaten
    	ob.objekt_id,
		ob.objekt_nr,
		ob.rel_objekt_nr,
		ob.status_bearbeitung,
		ob.erfassungsdatum, 
		ob.aenderungsdatum, 
		laugis.return_erfasser(ob.objekt_id) AS return_erfasser, 

    -- # Deskriptoren 
		ob.kategorie,
		ob.sachbegriff,
    	ob.sachbegriff_alt,
		ob.beschreibung, 
		ob.beschreibung_ergaenzung, 
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
   
	-- # Deskriptoren
		tech.techn_anlage,
	    laugis.return_material(ob.objekt_id) AS return_material,
	    tech.material_alt,
	    laugis.return_konstruktion(ob.objekt_id) AS return_konstruktion,
	    tech.konstruktion_alt,
	-- # Deskrptoren - Architektur
	    tech.geschosszahl,
	    tech.achsenzahl,
	    tech.grundriss,
	    laugis.return_dachform(ob.objekt_id) AS return_dachform,
	    tech.dachform_alt,
	-- # Deskriptoren - Technik
		tech.antrieb,
		tech.abmessung,
		tech.gewicht,

	-- # Geometrie 
		geo.geom

	FROM laugis.obj_basis AS ob
	JOIN laugis.geo_poly AS geo ON ob.objekt_id = geo.ref_objekt_id
	JOIN laugis.obj_tech AS tech ON ob.objekt_id = tech.ref_objekt_id
	WHERE ob.geloescht IS NOT TRUE;

CREATE TRIGGER tr_instead_einzelobjekt
INSTEAD OF INSERT OR UPDATE OR DELETE ON lauqgis.einzelobjekt_poly
    FOR EACH ROW EXECUTE FUNCTION lauqgis.trf_einzelobjekt();

--------------------------------------------------------------------------------------------------------------------------------------
-- # objektbereich_poly (view)
-------------------------------------------------------------------------------------------------------------------------------------- 

-- Die View repräsentiert die Struktur "Objektbereich"
-- Die zugehörigen Geometrie ist Multipolygon
-- Objektbereiche definieren sich durch einen Eintrag in der obj_basis und die Abwesenheit einer Referenz zu obj_tech
-- Komplexe Daten werden als text(json[]) übergebem.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

CREATE OR REPLACE VIEW lauqgis.objektbereich_poly AS

SELECT 
    -- # Metadaten
    	ob.objekt_id,
		ob.objekt_nr,
		ob.rel_objekt_nr,
		ob.status_bearbeitung,
		ob.erfassungsdatum, 
		ob.aenderungsdatum, 
		laugis.return_erfasser(ob.objekt_id) AS return_erfasser, 

    -- # Deskriptoren 
		ob.kategorie,
		ob.sachbegriff,
    	ob.sachbegriff_alt,
		ob.beschreibung, 
		ob.beschreibung_ergaenzung, 
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

	-- # Geometrie 
		geo.geom
		
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
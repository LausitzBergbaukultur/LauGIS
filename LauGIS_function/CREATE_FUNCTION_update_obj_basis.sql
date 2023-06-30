/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-06-30
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Setzt die Werte für ein bestehendes oder neues Basis-Objekt
					Erzeugt eine definierte Objektnummer
					Legt entsprechend der Geometrie-Art einen passenden verknüpften Eintrag an
					Setzt das Flag 'geloescht' auf false
					Fügt in 'letzte_aenderung' den aktuellen Timestamp
					Gibt die ID des bearbeiteten Eintrags zurück
Call by:            trigger functions
					- trf_einzelobjekt
					- trf_objektbereich
Affected tables:	objekt and geometry tables
					- laugis.obj_basis
					- laugis.geo_poly
					- laugis.geo_point
					- laugis.geo_line
Parameters:			s.b.
***************************************************************************************************/

CREATE OR REPLACE FUNCTION laugis.update_obj_basis(
  -- # Metadaten
  _objekt_id integer,              -- pk IF NOT NULL -> UPDATE
  _objekt_nr integer,              -- 5000
  _rel_objekt_nr integer,          -- fk
  _status_bearbeitung smallint,    -- fk
  _erfassungsdatum date,           -- 9580
  _aenderungsdatum date,           -- 9950
  
  -- # Deskriptoren
  _kategorie smallint,             -- fk NOT NULL
  _sachbegriff integer,            -- fk 5230
  _sachbegriff_alt text,           -- 5230 (als Altdaten-temp sowie für Freitexte)
  _beschreibung text,              -- 9980
  _beschreibung_ergaenzung text,   -- 9980
  _lagebeschreibung text,          -- 5125
  _notiz_intern text,              -- 9984 '9980 = Kommentar'
  _hida_nr text,                   -- 5000
  _bilder_anmerkung text,          -- temp und anmerkung

  -- # Stammdaten
  _bezeichnung text,               -- 9990
  _bauwerksname_eigenname text,    -- 5202
  _schutzstatus smallint,          -- fk
  _foerderfaehig bool, 
    
  -- # Lokalisatoren
  _kreis text,                     -- 5098
  _gemeinde text,                  -- 5100
  _ort text,                       -- 5108
  _sorbisch text,                  -- 5115
  _strasse text,                   -- 5116
  _hausnummer text,                -- 5117
  _gem_flur text,                  -- 5120

  -- # Geometrie
  _geom geometry                   -- undefined geometry
  ) 
RETURNS INTEGER AS $$

DECLARE
  _ob_id integer = _objekt_id;
  _is_update bool = NULL;
  _gemarkung TEXT = '';				-- iteration variable
  _gemflur_arr TEXT[];				-- list array
BEGIN

  -- check if UPDATE or INSERT
  IF (_objekt_id IS NOT NULL) THEN
    _is_update = TRUE;
  ELSE
    _is_update = FALSE;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- determine location by geometry
---------------------------------------------------------------------------------------------------------------
 	
	-- check if source view exists AND if any of the location variables are empty
	IF (SELECT COUNT(*) FROM pg_matviews WHERE matviewname = 'location_by_plot') > 0
		AND (_kreis IS NULL OR _kreis = '' 
			OR _gemeinde IS NULL OR _gemeinde = ''
			OR _ort IS NULL OR _ort = ''
			OR _sorbisch IS NULL OR _sorbisch = ''
		--	OR _strasse IS NULL OR _strasse = ''
			OR _gem_flur IS NULL OR _gem_flur = '') THEN
	
		-- create a set with all location data that matches (intersects) the geometry of the defined object
		CREATE TEMPORARY TABLE dataset_loc
		AS
		SELECT lbp.kreis, lbp.gemeinde, lbp.ort, lbp.sorbisch, lbp.gem, lbp.flur, lbp.zaehler, lbp.nenner
		FROM quellen.location_by_plot AS lbp
			WHERE ST_intersects(lbp.geom, _geom)
			ORDER BY lbp.kreis, lbp.gemeinde, lbp.ort, lbp.gem, lbp.flur, lbp.zaehler, lbp.nenner
		;
	
		-- set _kreis if empty
		IF _kreis IS NULL OR _kreis = '' THEN
			_kreis = (SELECT string_agg(DISTINCT(dsl.kreis), ' | ') FROM dataset_loc dsl);
		END IF;
		
		-- set _gemeinde if empty
		IF _gemeinde IS NULL OR _gemeinde = '' THEN
			_gemeinde = (SELECT string_agg(DISTINCT(dsl.gemeinde), ' | ') FROM dataset_loc dsl);
		END IF;
		
		-- set _ort if empty
		IF _ort IS NULL OR _ort = '' THEN
			_ort = (SELECT string_agg(DISTINCT(dsl.ort), ' | ') FROM dataset_loc dsl);
		END IF;

		-- set _sorbisch if empty
		IF _sorbisch IS NULL OR _sorbisch = '' THEN
			_sorbisch = (SELECT string_agg(DISTINCT(dsl.sorbisch), ' | ') FROM dataset_loc dsl);
		END IF;
	
	/*  -- deactivated because the data basis does not include street information
		-- set _strasse if empty
		IF _strasse IS NULL OR _strasse = '' THEN
			_strasse = (SELECT string_agg(DISTINCT(dsl.strasse), ' | ') FROM dataset_loc dsl);
		END IF;
	*/
		-- set _gem_flur if empty
		IF _gem_flur IS NULL OR _gem_flur = '' THEN 
			-- build plot notation for distinct Gemarkung (gem)
			FOR _gemarkung IN 
				SELECT DISTINCT(gem) FROM dataset_loc LOOP
					-- pattern: "GEM: 'FLUR - ZAEHLER, ' OR 'FLUR - ZAEHLER/NENNER, ' | " (if nenner is not NULL)
					_gemflur_arr := _gemflur_arr || (_gemarkung || ': ' || (SELECT string_agg(
						(dsl.flur || ' - ' || dsl.zaehler) || COALESCE('/' || dsl.nenner, '')
						, ', ') FROM dataset_loc AS dsl WHERE gem = _gemarkung));	
			END LOOP;
			_gem_flur = array_to_string(_gemflur_arr, ' | ');	
		END IF;
		
		-- clean up temp table
		DROP TABLE IF EXISTS dataset_loc;
				
	END IF;
	
---------------------------------------------------------------------------------------------------------------
-- Handle obj_basis entries
---------------------------------------------------------------------------------------------------------------

  IF (_is_update) THEN
    UPDATE laugis.obj_basis
    SET
        objekt_nr               = _objekt_nr,
        rel_objekt_nr           = _rel_objekt_nr,
        status_bearbeitung      = _status_bearbeitung,
        erfassungsdatum         = _erfassungsdatum,
        aenderungsdatum         = _aenderungsdatum,
        letzte_aenderung        = NOW(),
        kategorie               = _kategorie,
        sachbegriff             = _sachbegriff,
        sachbegriff_alt         = _sachbegriff_alt,
        beschreibung            = _beschreibung,
        beschreibung_ergaenzung = _beschreibung_ergaenzung,
        lagebeschreibung        = _lagebeschreibung,
        notiz_intern            = _notiz_intern,
        hida_nr                 = _hida_nr,
        bilder_anmerkung        = _bilder_anmerkung,
        bezeichnung             = _bezeichnung,
        bauwerksname_eigenname  = _bauwerksname_eigenname,
        schutzstatus            = _schutzstatus,
        foerderfaehig           = _foerderfaehig,
        kreis                   = _kreis,
        gemeinde                = _gemeinde,
        ort                     = _ort,
        sorbisch                = _sorbisch,
        strasse                 = _strasse,
        hausnummer              = _hausnummer,
        gem_flur                = _gem_flur
    WHERE objekt_id             = _ob_id;
  ELSE
    INSERT INTO laugis.obj_basis(
        objekt_nr,
        rel_objekt_nr,
        status_bearbeitung,
        erfassungsdatum,
        aenderungsdatum,
        letzte_aenderung,
        geloescht,
        kategorie,
        sachbegriff,
        sachbegriff_alt,
        beschreibung,
        beschreibung_ergaenzung,
        lagebeschreibung,
        notiz_intern,
        hida_nr,
        bilder_anmerkung,
        bezeichnung,
        bauwerksname_eigenname,
        schutzstatus,
        foerderfaehig,
        kreis,
        gemeinde,
        ort,
        sorbisch,
        strasse,
        hausnummer,
        gem_flur)
      VALUES (
        _objekt_nr,
        _rel_objekt_nr,
        _status_bearbeitung,
        _erfassungsdatum,
        _aenderungsdatum,
        NOW(),
        FALSE,
        _kategorie,
        _sachbegriff,
        _sachbegriff_alt,
        _beschreibung,
        _beschreibung_ergaenzung,
        _lagebeschreibung,
        _notiz_intern,
        _hida_nr,
        _bilder_anmerkung,
        _bezeichnung,
        _bauwerksname_eigenname,
        _schutzstatus,
        _foerderfaehig,
        _kreis,
        _gemeinde,
        _ort,
        _sorbisch,
        _strasse,
        _hausnummer,
        _gem_flur)
      RETURNING obj_basis.objekt_id INTO _ob_id;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Objekt-Nr generation
---------------------------------------------------------------------------------------------------------------

  IF NOT (_is_update) AND (_objekt_nr IS NULL) THEN
    -- generate nr by adding 32.000.000 to the identifier 
    _objekt_nr = (_ob_id + 32000000);
    
    UPDATE laugis.obj_basis
    SET
        objekt_nr = _objekt_nr
    WHERE objekt_id = _ob_id;
  END IF;

---------------------------------------------------------------------------------------------------------------
-- Geometry handling
---------------------------------------------------------------------------------------------------------------

  IF (ST_GeometryType(_geom) = 'ST_MultiPolygon') THEN 
    
    IF (_is_update) THEN
        UPDATE laugis.geo_poly
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;  
    ELSE 
        INSERT INTO laugis.geo_poly(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  
  
  ELSEIF (ST_GeometryType(_geom) = 'ST_MultiLineString') THEN
    
    IF (_is_update) THEN
        UPDATE laugis.geo_line
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;    
    ELSE  
        INSERT INTO laugis.geo_line(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  

  ELSEIF (ST_GeometryType(_geom) = 'ST_MultiPoint') THEN
    
    IF (_is_update) THEN
        UPDATE laugis.geo_point
        SET geom = _geom
        WHERE ref_objekt_id = _ob_id;
    ELSE 
        INSERT INTO laugis.geo_point(
            ref_objekt_id,
            geom
            )
          VALUES (
            _ob_id,
            _geom);
    END IF;  

  END IF;

-- return (inserted) object id
RETURN _ob_id;

END;
$$ LANGUAGE plpgsql;
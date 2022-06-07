CREATE OR REPLACE FUNCTION "Erfassung".migrate_data(
_objekt_nr integer -- identifies the dataset in both databases, format 3200****
)

RETURNS TEXT AS $$

DECLARE
	---------------------------------------------------------------------------------------------------------------
	-- # const - ggf. durch IDs aus Zieldatenbank ersetzen:

	_FREITEXT_sachbegriff integer = 9999;
	_FREITEXT_person smallint = 19;
	_FREITEXT_datierung smallint = 31;
	_FREITEXT_material smallint = 67;
	_FREITEXT_dachform smallint = 36;
	_FREITEXT_konstruktion smallint = 34;
	_blick_unbestimmt smallint = 3;

	---------------------------------------------------------------------------------------------------------------
	-- # Metadaten
	_objekt_id integer;
	_status_bearbeitung integer;
	_erfassungsdatum date;
	_aenderungsdatum date;
	
	-- # Deskriptoren
	_kategorie smallint;
	_sachbegriff_alt text; 
	_beschreibung text; 
	_beschreibung_ergaenzend text; 
	_lage_beschreibung text; 
	_notiz_intern text;
	_hida_nr text;
	_bilder_anmerkung text;
	_literatur text;
	_blickbeziehung text;
	
	-- # Stammdaten
	_bezeichnung text;
	_bauwerksname_eigenname text; 
	_schutzstatus smallint;
	_foerderfaehig bool;
	
	-- # Lokalisatoren 
	_kreis text;              
	_gemeinde text;                 
	_ort text; 
	_sorbisch text;  
	_strasse text;  
	_hausnummer text; 
	_gem_flur text;   

	-- # tech allgemein
	_material_alt text;
	_konstruktion_alt text;

	-- # architektonisch
	_geschosszahl smallint;
	_achsenzahl smallint;
	_grundriss text;
	_dachform_alt text;

	-- # tech
	_antrieb text;
    _abmessung text;
    _gewicht text;
	
	-- # Geometrie
	_geom geometry;	
	
	-- # Relationen
	_funktion text;
	_personen text;
	_datierung text;

BEGIN

---------------------------------------------------------------------------------------------------------------
-- # check obj_Objektbereich
---------------------------------------------------------------------------------------------------------------
IF (SELECT COUNT(*) FROM "Erfassung"."obj_Objektbereich" AS ob 
	INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
	WHERE onr.objekt_nr::integer = _objekt_nr) = 1 THEN

	---------------------------------------------------------------------------------------------------------------
	-- # Metadaten
	---------------------------------------------------------------------------------------------------------------

	-- status_bearbeitung
	IF (SELECT ob.in_bearbeitung FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr) THEN
		_status_bearbeitung = 1;
	ELSE
		_status_bearbeitung = 3;
	END IF;

	_erfassungsdatum = (SELECT ob.erfassungsdatum
						FROM "Erfassung"."obj_Objektbereich" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _erfassungsdatum IS NULL THEN
		_erfassungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Erfassungsdatum nachgetragen; ';
	END IF;

	_aenderungsdatum = (SELECT ob.aenderungsdatum
						FROM "Erfassung"."obj_Objektbereich" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _aenderungsdatum IS NULL THEN
		_aenderungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Änderungsdatum nachgetragen; ';
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Deskriptoren
	---------------------------------------------------------------------------------------------------------------

	_kategorie = (SELECT ob.kategorie FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_sachbegriff_alt = (SELECT ob.sachbegriff FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung = (SELECT ob.beschreibung FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung_ergaenzend = (SELECT ob.beschreibung_ergaenzend FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_lage_beschreibung = (SELECT ob.lage_beschreibung FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_notiz_intern = COALESCE(_notiz_intern, '') || (SELECT COALESCE(ob.notiz_intern, '') || '; Erhaltungszustand: ' || COALESCE(erh.bezeichnung, '') AS notiz_intern
				FROM "Erfassung"."obj_Objektbereich" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				INNER JOIN "Erfassung"."def_Erhaltungszustand" AS erh
					ON ob.erhaltungszustand = erh.id
				WHERE onr.objekt_nr::integer = _objekt_nr);

	_hida_nr  = (SELECT ob.hida_nr FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bilder_anmerkung = (SELECT COALESCE(ob.bilder_extern, '') || '; <intern>: ' || COALESCE(ob.bilder_intern, '') AS bilder
				FROM "Erfassung"."obj_Objektbereich" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _bilder_anmerkung = '; <intern>: ' THEN
		_bilder_anmerkung = NULL;
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Stammdaten
	---------------------------------------------------------------------------------------------------------------
	
	_bezeichnung = (SELECT ob.bezeichnung FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bauwerksname_eigenname = (SELECT ob.bauwerksname_eigenname FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_schutzstatus = (SELECT ob.schutzstatus FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_foerderfaehig = (SELECT ob.foerderfaehig FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Lokalisatoren
	---------------------------------------------------------------------------------------------------------------
	
	_kreis = (SELECT ob.kreis FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_gemeinde = (SELECT ob.gemeinde FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_ort = (SELECT ob.ort FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_sorbisch = (SELECT ob.sorbisch FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_strasse = (SELECT ob.strasse FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_hausnummer = (SELECT ob.hausnummer FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_gem_flur = (SELECT ob.gem_flur FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Geometrie
	---------------------------------------------------------------------------------------------------------------

	_geom = (SELECT ob.geom FROM "Erfassung"."obj_Objektbereich" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_basis and geo
	---------------------------------------------------------------------------------------------------------------

	_objekt_id = laugis.update_obj_basis(   
			-- # Metadaten
		    NULL,				-- pk IF NOT NULL -> UPDATE
			_objekt_nr::integer,		--NEW.objekt_nr,
			NULL,--NEW.rel_objekt_nr,   -- TODO händisch: ref_objektbereich
			_status_bearbeitung::smallint,--NEW.status_bearbeitung,
			_erfassungsdatum::date,--NEW.erfassungsdatum, 
			_aenderungsdatum::date,--NEW.aenderungsdatum,

		    -- # Deskriptoren
			_kategorie::smallint,--NEW.kategorie,
	    	_FREITEXT_sachbegriff,--NEW.sachbegriff, -> FREITEXT
			_sachbegriff_alt::text,--NEW.sachbegriff_alt,
			_beschreibung::text,--NEW.beschreibung, 
			_beschreibung_ergaenzend::text,--NEW.beschreibung_ergaenzung, 
			_lage_beschreibung,--NEW.lagebeschreibung, 
			_notiz_intern,--NEW.notiz_intern,
			_hida_nr,--NEW.hida_nr,
			_bilder_anmerkung,--NEW.bilder_anmerkung,

		    -- # Stammdaten
			_bezeichnung,--NEW.bezeichnung, 
			_bauwerksname_eigenname,--NEW.bauwerksname_eigenname, 
			_schutzstatus,--NEW.schutzstatus, 
			_foerderfaehig,--NEW.foerderfaehig,

		    -- # Lokalisatoren
			_kreis,--NEW.kreis, 
			_gemeinde,--NEW.gemeinde, 
			_ort,--NEW.ort, 
			_sorbisch,--NEW.sorbisch, 
			_strasse,--NEW.strasse, 
			_hausnummer,--NEW.hausnummer, 
			_gem_flur,--NEW.gem_flur,

		  	-- # Geometrie
			_geom::geometry(MultiPolygon, 25833)--NEW.geom
			);

	---------------------------------------------------------------------------------------------------------------
	-- Erfasser:in übertragen
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_erfasser(
		NULL,
		_objekt_id,
		(SELECT erfassung
			FROM "Erfassung"."obj_Objektbereich" AS ob 
			INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
				ON ob.objekt_nr = onr.id 
			WHERE onr.objekt_nr::integer = _objekt_nr),
		TRUE);

	---------------------------------------------------------------------------------------------------------------
	-- Funktion übertragen
	---------------------------------------------------------------------------------------------------------------

	_funktion = (SELECT funktion
				FROM "Erfassung"."obj_Objektbereich" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _funktion IS NOT NULL THEN
		PERFORM laugis.update_nutzung(
		NULL,
		_objekt_id,
		_funktion,
		'');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Literatur übertragen
	---------------------------------------------------------------------------------------------------------------

	_literatur = (SELECT quellen_literatur
				FROM "Erfassung"."obj_Objektbereich" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _literatur IS NOT NULL THEN
		PERFORM laugis.update_literatur(
		NULL,
		_objekt_id,
		_literatur,
		'');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Blickbeziehung übertragen
	---------------------------------------------------------------------------------------------------------------

	_blickbeziehung = (SELECT blickbeziehung
				FROM "Erfassung"."obj_Objektbereich" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _blickbeziehung IS NOT NULL THEN
		PERFORM laugis.update_blickbeziehung(
		NULL,
		_objekt_id,
		_blickbeziehung,
		NULL,
		_blick_unbestimmt);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Personen übertragen
	---------------------------------------------------------------------------------------------------------------

	-- natürliche personen
	_personen = (SELECT COALESCE(ob.person_werk, '') || '; verantwortlich: ' || COALESCE(ob.person_verantw, '') AS person
				FROM "Erfassung"."obj_Objektbereich" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _personen != '; verantwortlich: ' THEN
		PERFORM laugis.update_personen(
			NULL,
			_objekt_id,
			_personen,
			_FREITEXT_person, -- 19,	-- freitext
			'IMPORT',
			false);
	END IF;
	-- sozietäten
	_personen = (SELECT COALESCE(ob.Soziet_werk, '') || '; verantwortlich: ' || COALESCE(ob.Soziet_verantw, '') AS person
				FROM "Erfassung"."obj_Objektbereich" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _personen != '; verantwortlich: ' THEN
		PERFORM laugis.update_personen(
			NULL,
			_objekt_id,
			_personen,
			_FREITEXT_person,
			'IMPORT',
			true);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Datierung übertragen
	---------------------------------------------------------------------------------------------------------------

	_datierung = (SELECT datierung
				 FROM "Erfassung"."obj_Objektbereich" AS ob 
				 INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				 WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _datierung IS NOT NULL THEN
		PERFORM laugis.update_datierung(
		NULL,
		_objekt_id,
		_datierung,
		_FREITEXT_datierung, --30, -- freitext
		'IMPORT');
	END IF;

---------------------------------------------------------------------------------------------------------------
-- # check obj_Objektbereich_line
---------------------------------------------------------------------------------------------------------------
ELSIF (SELECT COUNT(*) FROM "Erfassung"."obj_Objektbereich_line" AS ob 
	INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
	WHERE onr.objekt_nr::integer = _objekt_nr) = 1 THEN

	---------------------------------------------------------------------------------------------------------------
	-- # Metadaten
	---------------------------------------------------------------------------------------------------------------

	-- status_bearbeitung
	IF (SELECT ob.in_bearbeitung FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr) THEN
		_status_bearbeitung = 1;
	ELSE
		_status_bearbeitung = 3;
	END IF;

	_erfassungsdatum = (SELECT ob.erfassungsdatum
						FROM "Erfassung"."obj_Objektbereich_line" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _erfassungsdatum IS NULL THEN
		_erfassungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Erfassungsdatum nachgetragen; ';
	END IF;

	_aenderungsdatum = (SELECT ob.aenderungsdatum
						FROM "Erfassung"."obj_Objektbereich_line" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _aenderungsdatum IS NULL THEN
		_aenderungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Änderungsdatum nachgetragen; ';
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Deskriptoren
	---------------------------------------------------------------------------------------------------------------

	_kategorie = (SELECT ob.kategorie FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_sachbegriff_alt = (SELECT ob.sachbegriff FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung = (SELECT ob.beschreibung FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung_ergaenzend = (SELECT ob.beschreibung_ergaenzend FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_lage_beschreibung = (SELECT ob.lage_beschreibung FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_notiz_intern = COALESCE(_notiz_intern, '') || (SELECT COALESCE(ob.notiz_intern, '') || '; Erhaltungszustand: ' || COALESCE(erh.bezeichnung, '') AS notiz_intern
				FROM "Erfassung"."obj_Objektbereich_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				INNER JOIN "Erfassung"."def_Erhaltungszustand" AS erh
					ON ob.erhaltungszustand = erh.id
				WHERE onr.objekt_nr::integer = _objekt_nr);

	_hida_nr  = (SELECT ob.hida_nr FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bilder_anmerkung = (SELECT COALESCE(ob.bilder_extern, '') || '; <intern>: ' || COALESCE(ob.bilder_intern, '') AS bilder
				FROM "Erfassung"."obj_Objektbereich_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _bilder_anmerkung = '; <intern>: ' THEN
		_bilder_anmerkung = NULL;
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Stammdaten
	---------------------------------------------------------------------------------------------------------------
	
	_bezeichnung = (SELECT ob.bezeichnung FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bauwerksname_eigenname = (SELECT ob.bauwerksname_eigenname FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_schutzstatus = (SELECT ob.schutzstatus FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_foerderfaehig = (SELECT ob.foerderfaehig FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Lokalisatoren
	---------------------------------------------------------------------------------------------------------------
	
	_kreis = (SELECT ob.kreis FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_gemeinde = (SELECT ob.gemeinde FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_ort = (SELECT ob.ort FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_sorbisch = (SELECT ob.sorbisch FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_strasse = (SELECT ob.strasse FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_hausnummer = (SELECT ob.hausnummer FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_gem_flur = (SELECT ob.gem_flur FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Geometrie
	---------------------------------------------------------------------------------------------------------------

	_geom = (SELECT ob.geom FROM "Erfassung"."obj_Objektbereich_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_basis and geo
	---------------------------------------------------------------------------------------------------------------

	_objekt_id = laugis.update_obj_basis(   
			-- # Metadaten
		    NULL,				-- pk IF NOT NULL -> UPDATE
			_objekt_nr::integer,		--NEW.objekt_nr,
			NULL,--NEW.rel_objekt_nr,   -- TODO händisch: ref_objektbereich
			_status_bearbeitung::smallint,--NEW.status_bearbeitung,
			_erfassungsdatum::date,--NEW.erfassungsdatum, 
			_aenderungsdatum::date,--NEW.aenderungsdatum,

		    -- # Deskriptoren
			_kategorie::smallint,--NEW.kategorie,
	    	_FREITEXT_sachbegriff,--NEW.sachbegriff, -> FREITEXT
			_sachbegriff_alt::text,--NEW.sachbegriff_alt,
			_beschreibung::text,--NEW.beschreibung, 
			_beschreibung_ergaenzend::text,--NEW.beschreibung_ergaenzung, 
			_lage_beschreibung,--NEW.lagebeschreibung, 
			_notiz_intern,--NEW.notiz_intern,
			_hida_nr,--NEW.hida_nr,
			_bilder_anmerkung,--NEW.bilder_anmerkung,

		    -- # Stammdaten
			_bezeichnung,--NEW.bezeichnung, 
			_bauwerksname_eigenname,--NEW.bauwerksname_eigenname, 
			_schutzstatus,--NEW.schutzstatus, 
			_foerderfaehig,--NEW.foerderfaehig,

		    -- # Lokalisatoren
			_kreis,--NEW.kreis, 
			_gemeinde,--NEW.gemeinde, 
			_ort,--NEW.ort, 
			_sorbisch,--NEW.sorbisch, 
			_strasse,--NEW.strasse, 
			_hausnummer,--NEW.hausnummer, 
			_gem_flur,--NEW.gem_flur,

		  	-- # Geometrie
			_geom::geometry(MultiLinestring, 25833)--NEW.geom
			);

	---------------------------------------------------------------------------------------------------------------
	-- Erfasser:in übertragen
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_erfasser(
		NULL,
		_objekt_id,
		(SELECT erfassung
			FROM "Erfassung"."obj_Objektbereich_line" AS ob 
			INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
				ON ob.objekt_nr = onr.id 
			WHERE onr.objekt_nr::integer = _objekt_nr),
		TRUE);

	---------------------------------------------------------------------------------------------------------------
	-- Funktion übertragen
	---------------------------------------------------------------------------------------------------------------

	_funktion = (SELECT funktion
				FROM "Erfassung"."obj_Objektbereich_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _funktion IS NOT NULL THEN
		PERFORM laugis.update_nutzung(
		NULL,
		_objekt_id,
		_funktion,
		'');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Literatur übertragen
	---------------------------------------------------------------------------------------------------------------

	_literatur = (SELECT quellen_literatur
				FROM "Erfassung"."obj_Objektbereich_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _literatur IS NOT NULL THEN
		PERFORM laugis.update_literatur(
		NULL,
		_objekt_id,
		_literatur,
		'');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Blickbeziehung übertragen
	---------------------------------------------------------------------------------------------------------------

	_blickbeziehung = (SELECT blickbeziehung
				FROM "Erfassung"."obj_Objektbereich_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _blickbeziehung IS NOT NULL THEN
		PERFORM laugis.update_blickbeziehung(
		NULL,
		_objekt_id,
		_blickbeziehung,
		NULL,
		_blick_unbestimmt);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Personen übertragen
	---------------------------------------------------------------------------------------------------------------

	-- natürliche personen
	_personen = (SELECT COALESCE(ob.person_werk, '') || '; verantwortlich: ' || COALESCE(ob.person_verantw, '') AS person
				FROM "Erfassung"."obj_Objektbereich_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _personen != '; verantwortlich: ' THEN
		PERFORM laugis.update_personen(
			NULL,
			_objekt_id,
			_personen,
			_FREITEXT_person, -- 19,	-- freitext
			'IMPORT',
			false);
	END IF;
	-- sozietäten
	_personen = (SELECT COALESCE(ob.Soziet_werk, '') || '; verantwortlich: ' || COALESCE(ob.Soziet_verantw, '') AS person
				FROM "Erfassung"."obj_Objektbereich_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _personen != '; verantwortlich: ' THEN
		PERFORM laugis.update_personen(
			NULL,
			_objekt_id,
			_personen,
			_FREITEXT_person,
			'IMPORT',
			true);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Datierung übertragen
	---------------------------------------------------------------------------------------------------------------

	_datierung = (SELECT datierung
				 FROM "Erfassung"."obj_Objektbereich_line" AS ob 
				 INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				 WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _datierung IS NOT NULL THEN
		PERFORM laugis.update_datierung(
		NULL,
		_objekt_id,
		_datierung,
		_FREITEXT_datierung, --30, -- freitext
		'IMPORT');
	END IF;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- # check obj_Einzelobjekt
---------------------------------------------------------------------------------------------------------------
ELSIF (SELECT COUNT(*) FROM "Erfassung"."obj_Einzelobjekt" AS ob 
	INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
	WHERE onr.objekt_nr::integer = _objekt_nr) = 1 THEN

	---------------------------------------------------------------------------------------------------------------
	-- # Metadaten
	---------------------------------------------------------------------------------------------------------------

	-- status_bearbeitung
	IF (SELECT ob.in_bearbeitung FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr) THEN
		_status_bearbeitung = 1;
	ELSE
		_status_bearbeitung = 3;
	END IF;

	_erfassungsdatum = (SELECT ob.erfassungsdatum
						FROM "Erfassung"."obj_Einzelobjekt" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _erfassungsdatum IS NULL THEN
		_erfassungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Erfassungsdatum nachgetragen; ';
	END IF;

	_aenderungsdatum = (SELECT ob.aenderungsdatum
						FROM "Erfassung"."obj_Einzelobjekt" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _aenderungsdatum IS NULL THEN
		_aenderungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Änderungsdatum nachgetragen; ';
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Deskriptoren
	---------------------------------------------------------------------------------------------------------------

	_kategorie = (SELECT ob.kategorie FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_sachbegriff_alt = (SELECT ob.sachbegriff FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung = (SELECT ob.beschreibung FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung_ergaenzend = (SELECT ob.beschreibung_ergaenzend FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_lage_beschreibung = (SELECT ob.lage_beschreibung FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_notiz_intern = COALESCE(_notiz_intern, '') || (SELECT COALESCE(ob.notiz_intern, '') || '; Erhaltungszustand: ' || COALESCE(erh.bezeichnung, '') AS notiz_intern
				FROM "Erfassung"."obj_Einzelobjekt" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				INNER JOIN "Erfassung"."def_Erhaltungszustand" AS erh
					ON ob.erhaltungszustand = erh.id
				WHERE onr.objekt_nr::integer = _objekt_nr);

	_hida_nr  = (SELECT ob.hida_nr FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bilder_anmerkung = (SELECT COALESCE(ob.bilder_extern, '') || '; <intern>: ' || COALESCE(ob.bilder_intern, '') AS bilder
				FROM "Erfassung"."obj_Einzelobjekt" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _bilder_anmerkung = '; <intern>: ' THEN
		_bilder_anmerkung = NULL;
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Stammdaten
	---------------------------------------------------------------------------------------------------------------
	
	_bezeichnung = (SELECT ob.bezeichnung FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bauwerksname_eigenname = (SELECT ob.bauwerksname_eigenname FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_schutzstatus = (SELECT ob.schutzstatus FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_foerderfaehig = (SELECT ob.foerderfaehig FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Lokalisatoren
	---------------------------------------------------------------------------------------------------------------
	
	_kreis = (SELECT ob.kreis FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_gemeinde = (SELECT ob.gemeinde FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_ort = (SELECT ob.ort FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_sorbisch = (SELECT ob.sorbisch FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_strasse = (SELECT ob.strasse FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_hausnummer = (SELECT ob.hausnummer FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_gem_flur = (SELECT ob.gem_flur FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Technik allgemein
	---------------------------------------------------------------------------------------------------------------

	_material_alt = (SELECT ob.material FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_konstruktion_alt = (SELECT ob.konstruktion_technik FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Architektonisch
	---------------------------------------------------------------------------------------------------------------

	_geschosszahl = (SELECT ob.geschosszahl FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_achsenzahl = (SELECT ob.achsenzahl FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_grundriss = (SELECT ob.grundriss FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_dachform_alt  = (SELECT ob.dachform FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Technik
	---------------------------------------------------------------------------------------------------------------

	_antrieb = NULL;

    _abmessung = NULL;

    _gewicht = NULL;

	---------------------------------------------------------------------------------------------------------------
	-- # Geometrie
	---------------------------------------------------------------------------------------------------------------

	_geom = (SELECT ob.geom FROM "Erfassung"."obj_Einzelobjekt" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_basis and geo
	---------------------------------------------------------------------------------------------------------------

	_objekt_id = laugis.update_obj_basis(   
		-- # Metadaten
	    NULL,				-- pk IF NOT NULL -> UPDATE
		_objekt_nr::integer,		--NEW.objekt_nr,
		NULL,--NEW.rel_objekt_nr,   -- TODO händisch: ref_objektbereich
		_status_bearbeitung::smallint,--NEW.status_bearbeitung,
		_erfassungsdatum::date,--NEW.erfassungsdatum, 
		_aenderungsdatum::date,--NEW.aenderungsdatum,

	    -- # Deskriptoren
		_kategorie::smallint,--NEW.kategorie,
    	_FREITEXT_sachbegriff,--NEW.sachbegriff, -> FREITEXT
		_sachbegriff_alt::text,--NEW.sachbegriff_alt,
		_beschreibung::text,--NEW.beschreibung, 
		_beschreibung_ergaenzend::text,--NEW.beschreibung_ergaenzung, 
		_lage_beschreibung,--NEW.lagebeschreibung, 
		_notiz_intern,--NEW.notiz_intern,
		_hida_nr,--NEW.hida_nr,
		_bilder_anmerkung,--NEW.bilder_anmerkung,

	    -- # Stammdaten
		_bezeichnung,--NEW.bezeichnung, 
		_bauwerksname_eigenname,--NEW.bauwerksname_eigenname, 
		_schutzstatus,--NEW.schutzstatus, 
		_foerderfaehig,--NEW.foerderfaehig,

	    -- # Lokalisatoren
		_kreis,--NEW.kreis, 
		_gemeinde,--NEW.gemeinde, 
		_ort,--NEW.ort, 
		_sorbisch,--NEW.sorbisch, 
		_strasse,--NEW.strasse, 
		_hausnummer,--NEW.hausnummer, 
		_gem_flur,--NEW.gem_flur,

	  	-- # Geometrie
		_geom::geometry(MultiPolygon, 25833)--NEW.geom
		);	

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_tech
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_obj_tech(
	    _objekt_id,                   -- fk zu angelegter Objekt-Basis, NOT NULL
	    
	    -- # Deskriptoren allgemein
	    FALSE, --NEW.techn_anlage,
        _material_alt, --NEW.material_alt,
        _konstruktion_alt, --NEW.konstruktion_alt,
        
        -- # architektonisch
		_geschosszahl,-- NEW.geschosszahl, 
		_achsenzahl, -- NEW.achsenzahl,
		_grundriss, -- NEW.grundriss,
		_dachform_alt, -- NEW.dachform_alt,
		
		-- # technisch
		_antrieb,
        _abmessung,             
        _gewicht	
  	);

	---------------------------------------------------------------------------------------------------------------
	-- Erfasser:in übertragen
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_erfasser(
		NULL,
		_objekt_id,
		(SELECT erfassung
			FROM "Erfassung"."obj_Einzelobjekt" AS ob 
			INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
				ON ob.objekt_nr = onr.id 
			WHERE onr.objekt_nr::integer = _objekt_nr),
		TRUE);

	---------------------------------------------------------------------------------------------------------------
	-- Funktion übertragen
	---------------------------------------------------------------------------------------------------------------

	_funktion = (SELECT funktion
				FROM "Erfassung"."obj_Einzelobjekt" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _funktion IS NOT NULL THEN
		PERFORM laugis.update_nutzung(
		NULL,
		_objekt_id,
		_funktion,
		'');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Literatur übertragen
	---------------------------------------------------------------------------------------------------------------

	_literatur = (SELECT quellen_literatur
				FROM "Erfassung"."obj_Einzelobjekt" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _literatur IS NOT NULL THEN
		PERFORM laugis.update_literatur(
		NULL,
		_objekt_id,
		_literatur,
		'');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Blickbeziehung übertragen
	---------------------------------------------------------------------------------------------------------------

	_blickbeziehung = (SELECT blickbeziehung
				FROM "Erfassung"."obj_Einzelobjekt" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _blickbeziehung IS NOT NULL THEN
		PERFORM laugis.update_blickbeziehung(
		NULL,
		_objekt_id,
		_blickbeziehung,
		NULL,
		_blick_unbestimmt);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Personen übertragen
	---------------------------------------------------------------------------------------------------------------

	-- natürliche personen
	_personen = (SELECT COALESCE(ob.person_werk, '') || '; verantwortlich: ' || COALESCE(ob.person_verantw, '') AS person
				FROM "Erfassung"."obj_Einzelobjekt" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _personen != '; verantwortlich: ' THEN
		PERFORM laugis.update_personen(
			NULL,
			_objekt_id,
			_personen,
			_FREITEXT_person,
			'IMPORT',
			false);
	END IF;
	-- sozietäten
	_personen = (SELECT COALESCE(ob.Soziet_werk, '') || '; verantwortlich: ' || COALESCE(ob.Soziet_verantw, '') AS person
				FROM "Erfassung"."obj_Einzelobjekt" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _personen != '; verantwortlich: ' THEN
		PERFORM laugis.update_personen(
			NULL,
			_objekt_id,
			_personen,
			_FREITEXT_person,
			'IMPORT',
			true);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Datierung übertragen
	---------------------------------------------------------------------------------------------------------------

	_datierung = (SELECT datierung
				 FROM "Erfassung"."obj_Einzelobjekt" AS ob 
				 INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				 WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _datierung IS NOT NULL THEN
		PERFORM laugis.update_datierung(
			NULL,
			_objekt_id,
			_datierung,
			_FREITEXT_datierung,
			'IMPORT');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Material übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _material_alt IS NOT NULL THEN
		PERFORM laugis.update_material(
			NULL,
			_objekt_id,
			_FREITEXT_material
			);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Dachform übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _dachform_alt IS NOT NULL THEN
		PERFORM laugis.update_dachform(
			NULL,
			_objekt_id,
			_FREITEXT_dachform
			);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Konstruktion übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _konstruktion_alt IS NOT NULL THEN
		PERFORM laugis.update_konstruktion(
			NULL,
			_objekt_id,
			_FREITEXT_konstruktion
			);
	END IF;

---------------------------------------------------------------------------------------------------------------
-- # check obj_Einzelobjekt_line
---------------------------------------------------------------------------------------------------------------
ELSIF (SELECT COUNT(*) FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
	INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
	WHERE onr.objekt_nr::integer = _objekt_nr) = 1 THEN

	---------------------------------------------------------------------------------------------------------------
	-- # Metadaten
	---------------------------------------------------------------------------------------------------------------

	-- status_bearbeitung
	IF (SELECT ob.in_bearbeitung FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr) THEN
		_status_bearbeitung = 1;
	ELSE
		_status_bearbeitung = 3;
	END IF;

	_erfassungsdatum = (SELECT ob.erfassungsdatum
						FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _erfassungsdatum IS NULL THEN
		_erfassungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Erfassungsdatum nachgetragen; ';
	END IF;

	_aenderungsdatum = (SELECT ob.aenderungsdatum
						FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _aenderungsdatum IS NULL THEN
		_aenderungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Änderungsdatum nachgetragen; ';
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Deskriptoren
	---------------------------------------------------------------------------------------------------------------

	_kategorie = (SELECT ob.kategorie FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_sachbegriff_alt = (SELECT ob.sachbegriff FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung = (SELECT ob.beschreibung FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung_ergaenzend = (SELECT ob.beschreibung_ergaenzend FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_lage_beschreibung = (SELECT ob.lage_beschreibung FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_notiz_intern = COALESCE(_notiz_intern, '') || (SELECT COALESCE(ob.notiz_intern, '') || '; Erhaltungszustand: ' || COALESCE(erh.bezeichnung, '') AS notiz_intern
				FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				INNER JOIN "Erfassung"."def_Erhaltungszustand" AS erh
					ON ob.erhaltungszustand = erh.id
				WHERE onr.objekt_nr::integer = _objekt_nr);

	_hida_nr  = (SELECT ob.hida_nr FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bilder_anmerkung = (SELECT COALESCE(ob.bilder_extern, '') || '; <intern>: ' || COALESCE(ob.bilder_intern, '') AS bilder
				FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _bilder_anmerkung = '; <intern>: ' THEN
		_bilder_anmerkung = NULL;
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Stammdaten
	---------------------------------------------------------------------------------------------------------------
	
	_bezeichnung = (SELECT ob.bezeichnung FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bauwerksname_eigenname = (SELECT ob.bauwerksname_eigenname FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_schutzstatus = (SELECT ob.schutzstatus FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_foerderfaehig = (SELECT ob.foerderfaehig FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Lokalisatoren
	---------------------------------------------------------------------------------------------------------------
	
	_kreis = (SELECT ob.kreis FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_gemeinde = (SELECT ob.gemeinde FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_ort = (SELECT ob.ort FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_sorbisch = (SELECT ob.sorbisch FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_strasse = (SELECT ob.strasse FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_hausnummer = (SELECT ob.hausnummer FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_gem_flur = (SELECT ob.gem_flur FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Technik allgemein
	---------------------------------------------------------------------------------------------------------------

	_material_alt = (SELECT ob.material FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_konstruktion_alt = (SELECT ob.konstruktion_technik FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Architektonisch
	---------------------------------------------------------------------------------------------------------------

	_geschosszahl = (SELECT ob.geschosszahl FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_achsenzahl = (SELECT ob.achsenzahl FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_grundriss = (SELECT ob.grundriss FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);
	
	_dachform_alt  = (SELECT ob.dachform FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Technik
	---------------------------------------------------------------------------------------------------------------

	_antrieb = NULL;

    _abmessung = NULL;

    _gewicht = NULL;

	---------------------------------------------------------------------------------------------------------------
	-- # Geometrie
	---------------------------------------------------------------------------------------------------------------

	_geom = (SELECT ob.geom FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_basis and geo
	---------------------------------------------------------------------------------------------------------------

	_objekt_id = laugis.update_obj_basis(   
		-- # Metadaten
	    NULL,				-- pk IF NOT NULL -> UPDATE
		_objekt_nr::integer,		--NEW.objekt_nr,
		NULL,--NEW.rel_objekt_nr,   -- TODO händisch: ref_objektbereich
		_status_bearbeitung::smallint,--NEW.status_bearbeitung,
		_erfassungsdatum::date,--NEW.erfassungsdatum, 
		_aenderungsdatum::date,--NEW.aenderungsdatum,

	    -- # Deskriptoren
		_kategorie::smallint,--NEW.kategorie,
    	_FREITEXT_sachbegriff,--NEW.sachbegriff, -> FREITEXT
		_sachbegriff_alt::text,--NEW.sachbegriff_alt,
		_beschreibung::text,--NEW.beschreibung, 
		_beschreibung_ergaenzend::text,--NEW.beschreibung_ergaenzung, 
		_lage_beschreibung,--NEW.lagebeschreibung, 
		_notiz_intern,--NEW.notiz_intern,
		_hida_nr,--NEW.hida_nr,
		_bilder_anmerkung,--NEW.bilder_anmerkung,

	    -- # Stammdaten
		_bezeichnung,--NEW.bezeichnung, 
		_bauwerksname_eigenname,--NEW.bauwerksname_eigenname, 
		_schutzstatus,--NEW.schutzstatus, 
		_foerderfaehig,--NEW.foerderfaehig,

	    -- # Lokalisatoren
		_kreis,--NEW.kreis, 
		_gemeinde,--NEW.gemeinde, 
		_ort,--NEW.ort, 
		_sorbisch,--NEW.sorbisch, 
		_strasse,--NEW.strasse, 
		_hausnummer,--NEW.hausnummer, 
		_gem_flur,--NEW.gem_flur,

	  	-- # Geometrie
		_geom::geometry(MultiLinestring, 25833)--NEW.geom
		);	

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_tech
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_obj_tech(
	    _objekt_id,                   -- fk zu angelegter Objekt-Basis, NOT NULL
	    
	    -- # Deskriptoren allgemein
	    FALSE, --NEW.techn_anlage,
        _material_alt, --NEW.material_alt,
        _konstruktion_alt, --NEW.konstruktion_alt,
        
        -- # architektonisch
		_geschosszahl,-- NEW.geschosszahl, 
		_achsenzahl, -- NEW.achsenzahl,
		_grundriss, -- NEW.grundriss,
		_dachform_alt, -- NEW.dachform_alt,
		
		-- # technisch
		_antrieb,
        _abmessung,             
        _gewicht	
  	);

	---------------------------------------------------------------------------------------------------------------
	-- Erfasser:in übertragen
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_erfasser(
		NULL,
		_objekt_id,
		(SELECT erfassung
			FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
			INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
				ON ob.objekt_nr = onr.id 
			WHERE onr.objekt_nr::integer = _objekt_nr),
		TRUE);

	---------------------------------------------------------------------------------------------------------------
	-- Funktion übertragen
	---------------------------------------------------------------------------------------------------------------

	_funktion = (SELECT funktion
				FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _funktion IS NOT NULL THEN
		PERFORM laugis.update_nutzung(
		NULL,
		_objekt_id,
		_funktion,
		'');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Literatur übertragen
	---------------------------------------------------------------------------------------------------------------

	_literatur = (SELECT quellen_literatur
				FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _literatur IS NOT NULL THEN
		PERFORM laugis.update_literatur(
		NULL,
		_objekt_id,
		_literatur,
		'');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Blickbeziehung übertragen
	---------------------------------------------------------------------------------------------------------------

	_blickbeziehung = (SELECT blickbeziehung
				FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _blickbeziehung IS NOT NULL THEN
		PERFORM laugis.update_blickbeziehung(
		NULL,
		_objekt_id,
		_blickbeziehung,
		NULL,
		_blick_unbestimmt);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Personen übertragen
	---------------------------------------------------------------------------------------------------------------

	-- natürliche personen
	_personen = (SELECT COALESCE(ob.person_werk, '') || '; verantwortlich: ' || COALESCE(ob.person_verantw, '') AS person
				FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _personen != '; verantwortlich: ' THEN
		PERFORM laugis.update_personen(
			NULL,
			_objekt_id,
			_personen,
			_FREITEXT_person,
			'IMPORT',
			false);
	END IF;
	-- sozietäten
	_personen = (SELECT COALESCE(ob.Soziet_werk, '') || '; verantwortlich: ' || COALESCE(ob.Soziet_verantw, '') AS person
				FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _personen != '; verantwortlich: ' THEN
		PERFORM laugis.update_personen(
			NULL,
			_objekt_id,
			_personen,
			_FREITEXT_person,
			'IMPORT',
			true);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Datierung übertragen
	---------------------------------------------------------------------------------------------------------------

	_datierung = (SELECT datierung
				 FROM "Erfassung"."obj_Einzelobjekt_line" AS ob 
				 INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				 WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _datierung IS NOT NULL THEN
		PERFORM laugis.update_datierung(
			NULL,
			_objekt_id,
			_datierung,
			_FREITEXT_datierung,
			'IMPORT');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Material übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _material_alt IS NOT NULL THEN
		PERFORM laugis.update_material(
			NULL,
			_objekt_id,
			_FREITEXT_material
			);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Dachform übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _dachform_alt IS NOT NULL THEN
		PERFORM laugis.update_dachform(
			NULL,
			_objekt_id,
			_FREITEXT_dachform
			);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Konstruktion übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _konstruktion_alt IS NOT NULL THEN
		PERFORM laugis.update_konstruktion(
			NULL,
			_objekt_id,
			_FREITEXT_konstruktion
			);
	END IF;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- # check obj_Anlage
---------------------------------------------------------------------------------------------------------------
ELSIF (SELECT COUNT(*) FROM "Erfassung"."obj_Anlage" AS ob 
	INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
	WHERE onr.objekt_nr::integer = _objekt_nr) = 1 THEN

	---------------------------------------------------------------------------------------------------------------
	-- # Metadaten
	---------------------------------------------------------------------------------------------------------------

	-- status_bearbeitung
	IF (SELECT ob.in_bearbeitung FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr) THEN
		_status_bearbeitung = 1;
	ELSE
		_status_bearbeitung = 3;
	END IF;

	_erfassungsdatum = (SELECT ob.erfassungsdatum
						FROM "Erfassung"."obj_Anlage" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _erfassungsdatum IS NULL THEN
		_erfassungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Erfassungsdatum nachgetragen; ';
	END IF;

	_aenderungsdatum = (SELECT ob.aenderungsdatum
						FROM "Erfassung"."obj_Anlage" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _aenderungsdatum IS NULL THEN
		_aenderungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Änderungsdatum nachgetragen; ';
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Deskriptoren
	---------------------------------------------------------------------------------------------------------------

	_kategorie = 8; -- kein Braunkohlebezug als Platzhalter

	_sachbegriff_alt = (SELECT ob.sachbegriff FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung = (SELECT ob.beschreibung_funktion FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung_ergaenzend = NULL;

	_lage_beschreibung = NULL;

	_notiz_intern = COALESCE(_notiz_intern, '') || (SELECT ob.notiz_intern FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_hida_nr = NULL;

	_bilder_anmerkung = (SELECT COALESCE(ob.bilder_extern, '') || '; <intern>: ' || COALESCE(ob.bilder_intern, '') AS bilder
				FROM "Erfassung"."obj_Anlage" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _bilder_anmerkung = '; <intern>: ' THEN
		_bilder_anmerkung = NULL;
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Stammdaten
	---------------------------------------------------------------------------------------------------------------
	
	_bezeichnung = (SELECT ob.bezeichnung FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bauwerksname_eigenname = NULL;

	_schutzstatus = NULL;

	_foerderfaehig = NULL;

	---------------------------------------------------------------------------------------------------------------
	-- # Lokalisatoren
	---------------------------------------------------------------------------------------------------------------
	
	_kreis = NULL;
	
	_gemeinde = NULL;

	_ort = NULL;

	_sorbisch = NULL;

	_strasse = NULL;

	_hausnummer = NULL;

	_gem_flur = NULL;

	---------------------------------------------------------------------------------------------------------------
	-- # Technik allgemein
	---------------------------------------------------------------------------------------------------------------

	_material_alt = (SELECT ob.material FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_konstruktion_alt = (SELECT ob.konstruktion_technik FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Architektonisch
	---------------------------------------------------------------------------------------------------------------

	_geschosszahl = NULL;

	_achsenzahl = NULL;

	_grundriss = NULL;
	
	_dachform_alt = NULL;

	---------------------------------------------------------------------------------------------------------------
	-- # Technik
	---------------------------------------------------------------------------------------------------------------

	_antrieb = (SELECT ob.antrieb FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

    _abmessung = (SELECT ob.abmessung FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);             

    _gewicht = (SELECT ob.gewicht FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Geometrie
	---------------------------------------------------------------------------------------------------------------

	_geom = (SELECT ob.geom FROM "Erfassung"."obj_Anlage" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_basis and geo
	---------------------------------------------------------------------------------------------------------------

	_objekt_id = laugis.update_obj_basis(   
		-- # Metadaten
	    NULL,				-- pk IF NOT NULL -> UPDATE
		_objekt_nr::integer,		--NEW.objekt_nr,
		NULL,--NEW.rel_objekt_nr,   -- TODO händisch: ref_objektbereich
		_status_bearbeitung::smallint,--NEW.status_bearbeitung,
		_erfassungsdatum::date,--NEW.erfassungsdatum, 
		_aenderungsdatum::date,--NEW.aenderungsdatum,

	    -- # Deskriptoren
		_kategorie::smallint,--NEW.kategorie,
    	_FREITEXT_sachbegriff,--NEW.sachbegriff, -> FREITEXT
		_sachbegriff_alt::text,--NEW.sachbegriff_alt,
		_beschreibung::text,--NEW.beschreibung, 
		_beschreibung_ergaenzend::text,--NEW.beschreibung_ergaenzung, 
		_lage_beschreibung,--NEW.lagebeschreibung, 
		_notiz_intern,--NEW.notiz_intern,
		_hida_nr,--NEW.hida_nr,
		_bilder_anmerkung,--NEW.bilder_anmerkung,

	    -- # Stammdaten
		_bezeichnung,--NEW.bezeichnung, 
		_bauwerksname_eigenname,--NEW.bauwerksname_eigenname, 
		_schutzstatus,--NEW.schutzstatus, 
		_foerderfaehig,--NEW.foerderfaehig,

	    -- # Lokalisatoren
		_kreis,--NEW.kreis, 
		_gemeinde,--NEW.gemeinde, 
		_ort,--NEW.ort, 
		_sorbisch,--NEW.sorbisch, 
		_strasse,--NEW.strasse, 
		_hausnummer,--NEW.hausnummer, 
		_gem_flur,--NEW.gem_flur,

	  	-- # Geometrie
		_geom::geometry(MultiPoint, 25833)--NEW.geom
		);	

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_tech
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_obj_tech(
	    _objekt_id,                   -- fk zu angelegter Objekt-Basis, NOT NULL
	    
	    -- # Deskriptoren allgemein
	    TRUE, --NEW.techn_anlage,
        _material_alt, --NEW.material_alt,
        _konstruktion_alt, --NEW.konstruktion_alt,
        
        -- # architektonisch
		_geschosszahl,-- NEW.geschosszahl, 
		_achsenzahl, -- NEW.achsenzahl,
		_grundriss, -- NEW.grundriss,
		_dachform_alt, -- NEW.dachform_alt,
		
		-- # technisch
		_antrieb,
        _abmessung,             
        _gewicht		
  	);

	---------------------------------------------------------------------------------------------------------------
	-- Erfasser:in übertragen
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_erfasser(
		NULL,
		_objekt_id,
		(SELECT erfassung
			FROM "Erfassung"."obj_Anlage" AS ob 
			INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
				ON ob.objekt_nr = onr.id 
			WHERE onr.objekt_nr::integer = _objekt_nr),
		TRUE);

	---------------------------------------------------------------------------------------------------------------
	-- Datierung übertragen
	---------------------------------------------------------------------------------------------------------------

	_datierung = (SELECT datierung
				 FROM "Erfassung"."obj_Anlage" AS ob 
				 INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				 WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _datierung IS NOT NULL THEN
		PERFORM laugis.update_datierung(
			NULL,
			_objekt_id,
			_datierung,
			_FREITEXT_datierung,
			'IMPORT');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Material übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _material_alt IS NOT NULL THEN
		PERFORM laugis.update_material(
			NULL,
			_objekt_id,
			_FREITEXT_material
			);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Konstruktion übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _konstruktion_alt IS NOT NULL THEN
		PERFORM laugis.update_konstruktion(
			NULL,
			_objekt_id,
			_FREITEXT_konstruktion
			);
	END IF;

	---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- # check obj_Anlage_linie
---------------------------------------------------------------------------------------------------------------
ELSIF (SELECT COUNT(*) FROM "Erfassung"."obj_Anlage_line" AS ob 
	INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
	WHERE onr.objekt_nr::integer = _objekt_nr) = 1 THEN

	---------------------------------------------------------------------------------------------------------------
	-- # Metadaten
	---------------------------------------------------------------------------------------------------------------

	-- status_bearbeitung
	IF (SELECT ob.in_bearbeitung FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr) THEN
		_status_bearbeitung = 1;
	ELSE
		_status_bearbeitung = 3;
	END IF;

	_erfassungsdatum = (SELECT ob.erfassungsdatum
						FROM "Erfassung"."obj_Anlage_line" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _erfassungsdatum IS NULL THEN
		_erfassungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Erfassungsdatum nachgetragen; ';
	END IF;

	_aenderungsdatum = (SELECT ob.aenderungsdatum
						FROM "Erfassung"."obj_Anlage_line" AS ob 
						INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
							ON ob.objekt_nr = onr.id 
						WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _aenderungsdatum IS NULL THEN
		_aenderungsdatum = NOW();
		_notiz_intern = COALESCE(_notiz_intern, '') || 'IMPORT: Änderungsdatum nachgetragen; ';
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Deskriptoren
	---------------------------------------------------------------------------------------------------------------

	_kategorie = 8; -- kein Braunkohlebezug als Platzhalter

	_sachbegriff_alt = (SELECT ob.sachbegriff FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung = (SELECT ob.beschreibung_funktion FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_beschreibung_ergaenzend = NULL;

	_lage_beschreibung = NULL;

	_notiz_intern = COALESCE(_notiz_intern, '') || (SELECT ob.notiz_intern FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_hida_nr = NULL;

	_bilder_anmerkung = (SELECT COALESCE(ob.bilder_extern, '') || '; <intern>: ' || COALESCE(ob.bilder_intern, '') AS bilder
				FROM "Erfassung"."obj_Anlage_line" AS ob 
				INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _bilder_anmerkung = '; <intern>: ' THEN
		_bilder_anmerkung = NULL;
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- # Stammdaten
	---------------------------------------------------------------------------------------------------------------
	
	_bezeichnung = (SELECT ob.bezeichnung FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_bauwerksname_eigenname = NULL;

	_schutzstatus = NULL;

	_foerderfaehig = NULL;

	---------------------------------------------------------------------------------------------------------------
	-- # Lokalisatoren
	---------------------------------------------------------------------------------------------------------------
	
	_kreis = NULL;
	
	_gemeinde = NULL;

	_ort = NULL;

	_sorbisch = NULL;

	_strasse = NULL;

	_hausnummer = NULL;

	_gem_flur = NULL;

	---------------------------------------------------------------------------------------------------------------
	-- # Technik allgemein
	---------------------------------------------------------------------------------------------------------------

	_material_alt = (SELECT ob.material FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	_konstruktion_alt = (SELECT ob.konstruktion_technik FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Architektonisch
	---------------------------------------------------------------------------------------------------------------

	_geschosszahl = NULL;

	_achsenzahl = NULL;

	_grundriss = NULL;
	
	_dachform_alt = NULL;

	---------------------------------------------------------------------------------------------------------------
	-- # Technik
	---------------------------------------------------------------------------------------------------------------

	_antrieb = (SELECT ob.antrieb FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

    _abmessung = (SELECT ob.abmessung FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);             

    _gewicht = (SELECT ob.gewicht FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- # Geometrie
	---------------------------------------------------------------------------------------------------------------

	_geom = (SELECT ob.geom FROM "Erfassung"."obj_Anlage_line" AS ob 
		INNER JOIN "Erfassung"."ref_Objektnummer" AS onr ON ob.objekt_nr = onr.id
		WHERE onr.objekt_nr::integer = _objekt_nr);

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_basis and geo
	---------------------------------------------------------------------------------------------------------------

	_objekt_id = laugis.update_obj_basis(   
		-- # Metadaten
	    NULL,				-- pk IF NOT NULL -> UPDATE
		_objekt_nr::integer,		--NEW.objekt_nr,
		NULL,--NEW.rel_objekt_nr,   -- TODO händisch: ref_objektbereich
		_status_bearbeitung::smallint,--NEW.status_bearbeitung,
		_erfassungsdatum::date,--NEW.erfassungsdatum, 
		_aenderungsdatum::date,--NEW.aenderungsdatum,

	    -- # Deskriptoren
		_kategorie::smallint,--NEW.kategorie,
    	_FREITEXT_sachbegriff,--NEW.sachbegriff, -> FREITEXT
		_sachbegriff_alt::text,--NEW.sachbegriff_alt,
		_beschreibung::text,--NEW.beschreibung, 
		_beschreibung_ergaenzend::text,--NEW.beschreibung_ergaenzung, 
		_lage_beschreibung,--NEW.lagebeschreibung, 
		_notiz_intern,--NEW.notiz_intern,
		_hida_nr,--NEW.hida_nr,
		_bilder_anmerkung,--NEW.bilder_anmerkung,

	    -- # Stammdaten
		_bezeichnung,--NEW.bezeichnung, 
		_bauwerksname_eigenname,--NEW.bauwerksname_eigenname, 
		_schutzstatus,--NEW.schutzstatus, 
		_foerderfaehig,--NEW.foerderfaehig,

	    -- # Lokalisatoren
		_kreis,--NEW.kreis, 
		_gemeinde,--NEW.gemeinde, 
		_ort,--NEW.ort, 
		_sorbisch,--NEW.sorbisch, 
		_strasse,--NEW.strasse, 
		_hausnummer,--NEW.hausnummer, 
		_gem_flur,--NEW.gem_flur,

	  	-- # Geometrie
		_geom::geometry(MultiLinestring, 25833)--NEW.geom
		);	

	---------------------------------------------------------------------------------------------------------------
	-- insert obj_tech
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_obj_tech(
	    _objekt_id,                   -- fk zu angelegter Objekt-Basis, NOT NULL
	    
	    -- # Deskriptoren allgemein
	    TRUE, --NEW.techn_anlage,
        _material_alt, --NEW.material_alt,
        _konstruktion_alt, --NEW.konstruktion_alt,
        
        -- # architektonisch
		_geschosszahl,-- NEW.geschosszahl, 
		_achsenzahl, -- NEW.achsenzahl,
		_grundriss, -- NEW.grundriss,
		_dachform_alt, -- NEW.dachform_alt,
		
		-- # technisch
		_antrieb,
        _abmessung,             
        _gewicht		
  	);

	---------------------------------------------------------------------------------------------------------------
	-- Erfasser:in übertragen
	---------------------------------------------------------------------------------------------------------------

	PERFORM laugis.update_erfasser(
		NULL,
		_objekt_id,
		(SELECT erfassung
			FROM "Erfassung"."obj_Anlage_line" AS ob 
			INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
				ON ob.objekt_nr = onr.id 
			WHERE onr.objekt_nr::integer = _objekt_nr),
		TRUE);

	---------------------------------------------------------------------------------------------------------------
	-- Datierung übertragen
	---------------------------------------------------------------------------------------------------------------

	_datierung = (SELECT datierung
				 FROM "Erfassung"."obj_Anlage_line" AS ob 
				 INNER JOIN "Erfassung"."ref_Objektnummer" AS onr 
					ON ob.objekt_nr = onr.id 
				 WHERE onr.objekt_nr::integer = _objekt_nr);
	IF _datierung IS NOT NULL THEN
		PERFORM laugis.update_datierung(
			NULL,
			_objekt_id,
			_datierung,
			_FREITEXT_datierung,
			'IMPORT');
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Material übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _material_alt IS NOT NULL THEN
		PERFORM laugis.update_material(
			NULL,
			_objekt_id,
			_FREITEXT_material
			);
	END IF;

	---------------------------------------------------------------------------------------------------------------
	-- Konstruktion übertragen
	---------------------------------------------------------------------------------------------------------------

	IF _konstruktion_alt IS NOT NULL THEN
		PERFORM laugis.update_konstruktion(
			NULL,
			_objekt_id,
			_FREITEXT_konstruktion
			);
	END IF;

	---------------------------------------------------------------------------------------------------------------
END IF;

RETURN _objekt_id::text;

END;
$$ LANGUAGE plpgsql;
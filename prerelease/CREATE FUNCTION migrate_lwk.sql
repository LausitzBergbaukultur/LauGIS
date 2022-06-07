CREATE OR REPLACE FUNCTION "Erfassung".migrate_lwk()
RETURNS void AS $$
DECLARE
	_objekt_id integer;
	_erfassungsdatum date;
	_aenderungsdatum date;
	_erfassung smallint;
  	
  	-- Identifikatoren
	_beschriftung text;
	_jahresschnitt smallint;
	_nutzungsart smallint;

	-- # Geometrie
	_geom geometry;

BEGIN 
	FOR _objekt_id IN (SELECT id FROM "Erfassung"."lwk_Bereich")
	LOOP
		_erfassungsdatum = (SELECT ob.erfassungsdatum
							FROM "Erfassung"."lwk_Bereich" AS ob 
							WHERE ob.id = _objekt_id);
		IF _erfassungsdatum IS NULL THEN
			_erfassungsdatum = NOW();
		END IF;
		
		_aenderungsdatum = (SELECT ob.aenderungsdatum
							FROM "Erfassung"."lwk_Bereich" AS ob 
							WHERE ob.id = _objekt_id);
		IF _aenderungsdatum IS NULL THEN
			_aenderungsdatum = NOW();
		END IF;

		_erfassung = (SELECT ob.erfassung
							FROM "Erfassung"."lwk_Bereich" AS ob 
							WHERE ob.id = _objekt_id);
		IF _erfassung IS NULL THEN
			_erfassung = 3;
		END IF;

		_beschriftung = (SELECT ob.beschriftung
							FROM "Erfassung"."lwk_Bereich" AS ob 
							WHERE ob.id = _objekt_id);

		_jahresschnitt = (SELECT ob.jahresschnitt
							FROM "Erfassung"."lwk_Bereich" AS ob 
							WHERE ob.id = _objekt_id);

		_nutzungsart = (SELECT ob.nutzungsart
							FROM "Erfassung"."lwk_Bereich" AS ob 
							WHERE ob.id = _objekt_id);

		_geom = (SELECT ob.geom
							FROM "Erfassung"."lwk_Bereich" AS ob 
							WHERE ob.id = _objekt_id);
		
		PERFORM laugis.update_obj_lwk(
		  NULL,
		  _erfassungsdatum,
		  _aenderungsdatum,
		  _erfassung,

		  _beschriftung,
		  _jahresschnitt,
		  _nutzungsart,

		  _geom
		  );

		_erfassungsdatum 	= NULL;
		_aenderungsdatum 	= NULL;
		_erfassung 			= NULL;
		_beschriftung 		= NULL;
		_jahresschnitt 		= NULL;
		_nutzungsart 		= NULL;
		_geom 				= NULL;

	END LOOP;

	FOR _objekt_id IN (SELECT id FROM "Erfassung"."lwk_Strecke")
	LOOP
		_erfassungsdatum = (SELECT ob.erfassungsdatum
							FROM "Erfassung"."lwk_Strecke" AS ob 
							WHERE ob.id = _objekt_id);
		IF _erfassungsdatum IS NULL THEN
			_erfassungsdatum = NOW();
		END IF;
		
		_aenderungsdatum = (SELECT ob.aenderungsdatum
							FROM "Erfassung"."lwk_Strecke" AS ob 
							WHERE ob.id = _objekt_id);
		IF _aenderungsdatum IS NULL THEN
			_aenderungsdatum = NOW();
		END IF;

		_erfassung = (SELECT ob.erfassung
							FROM "Erfassung"."lwk_Strecke" AS ob 
							WHERE ob.id = _objekt_id);
		IF _erfassung IS NULL THEN
			_erfassung = 3;
		END IF;

		_beschriftung = (SELECT ob.beschriftung
							FROM "Erfassung"."lwk_Strecke" AS ob 
							WHERE ob.id = _objekt_id);

		_jahresschnitt = (SELECT ob.jahresschnitt
							FROM "Erfassung"."lwk_Strecke" AS ob 
							WHERE ob.id = _objekt_id);

		_nutzungsart = (SELECT ob.nutzungsart
							FROM "Erfassung"."lwk_Strecke" AS ob 
							WHERE ob.id = _objekt_id);

		_geom = (SELECT ob.geom
							FROM "Erfassung"."lwk_Strecke" AS ob 
							WHERE ob.id = _objekt_id);
		
		PERFORM laugis.update_obj_lwk(
		  NULL,
		  _erfassungsdatum,
		  _aenderungsdatum,
		  _erfassung,

		  _beschriftung,
		  _jahresschnitt,
		  _nutzungsart,

		  _geom
		  );

		_erfassungsdatum 	= NULL;
		_aenderungsdatum 	= NULL;
		_erfassung 			= NULL;
		_beschriftung 		= NULL;
		_jahresschnitt 		= NULL;
		_nutzungsart 		= NULL;
		_geom 				= NULL;

	END LOOP;
END;
$$ LANGUAGE plpgsql;
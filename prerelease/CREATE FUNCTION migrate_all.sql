CREATE OR REPLACE FUNCTION "Erfassung".migrate_all()
RETURNS integer AS $$
DECLARE
	_obj_nr integer;
BEGIN 
	FOR _obj_nr IN (SELECT objekt_nr FROM "Erfassung"."ref_Objektnummer")
	LOOP
		PERFORM "Erfassung".migrate_data(_obj_nr);
	END LOOP;
	RETURN _obj_nr;
	-- USE: ALTER SEQUENCE laugis.obj_basis_objekt_id_seq RESTART WITH ??
END;
$$ LANGUAGE plpgsql;
-- Prueft uebergeordente Sachbegriffe auf untergeordnete Anlagen-Sachbegriffe

CREATE OR REPLACE FUNCTION laugis.check_sachbegriff_anlage(
	_sachbegriff_id integer,
	_ref_sachbegriff_id integer
	)
RETURNS bool AS $$

BEGIN 

---------------------------------------------------------------------------------------------------------------
-- erweiterte Sachbegriffe abfangen -> folgender Prozess behandelt ausschließlich uebergeordnete Sachbegriffe
---------------------------------------------------------------------------------------------------------------

	IF (_sachbegriff_id != _ref_sachbegriff_id) THEN
		RETURN FALSE;
	END IF;

---------------------------------------------------------------------------------------------------------------
-- untergeordnete Sachbegriffe ermitteln
---------------------------------------------------------------------------------------------------------------

	IF TRUE IN (SELECT sb.show_anlage
		FROM laugis.def_sachbegriff AS sb 
		WHERE sb.ref_sachbegriff_id = _sachbegriff_id) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;

END;
$$ LANGUAGE plpgsql;
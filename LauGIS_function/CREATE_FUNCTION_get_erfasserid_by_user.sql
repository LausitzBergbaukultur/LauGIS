CREATE OR REPLACE FUNCTION laugis.get_erfasserid_by_user()
RETURNS integer AS $$
BEGIN 
	RETURN(SELECT erf.id
		FROM laugis.def_erfasser as erf
		WHERE erf.username = current_user
		LIMIT 1);
END;
$$ LANGUAGE plpgsql;
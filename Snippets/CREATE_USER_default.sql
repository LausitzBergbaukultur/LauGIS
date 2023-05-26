/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-05-23
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Create a user account with login permissions and add it to the laugis_user group and adds an entry to def_erfasser.
Call by:            -
Affected tables:	laugis.def_erfasser
Used By:            Administration
Parameters:			_username - login name for technical identification
					_passwort - passwort to use with the login
					_fullname - the real name of the user for display in LauGIS and exports
***************************************************************************************************/

DO $$
DECLARE
	_username TEXT = 'vorname.nachname';
	_fullname TEXT = 'Vorname Nachname';
	_passwort TEXT = 'sicheres Passwort';
BEGIN
	EXECUTE 'CREATE ROLE ' ||  _username::TEXT || ' WITH
		LOGIN
		NOSUPERUSER
		NOCREATEDB
		NOCREATEROLE
		INHERIT
		NOREPLICATION
		CONNECTION LIMIT -1
		PASSWORD ' || _passwort::TEXT || ';';

	EXECUTE 'GRANT laugis_user TO ' || _username || ';';

	-- one could correct 'sortierung' later
	INSERT INTO laugis.def_erfasser (name, username)
	VALUES (_fullname, _username);
END $$;
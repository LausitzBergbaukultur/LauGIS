/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-05-23
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Install sript: Create a general group role with permissions to all relevant objects.
Call by:            -
Affected tables:	-
Used By:            Administration
Parameters:			none
***************************************************************************************************/

CREATE ROLE laugis_user WITH
	NOLOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	CONNECTION LIMIT -1;
COMMENT ON ROLE laugis_user IS 'General group for all named LauGIS user.';

-- Add grants for the general role.
-- Repeat this on every new database!

GRANT USAGE ON SCHEMA laugis, lauqgis, public, quellen TO laugis_user;
GRANT ALL ON ALL TABLES IN SCHEMA laugis, lauqgis, public, quellen TO laugis_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA laugis, lauqgis, public, quellen TO laugis_user;
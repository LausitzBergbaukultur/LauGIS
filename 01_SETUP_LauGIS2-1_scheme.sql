-- VORSICHT! Nicht zum Update einer bestehenden Instanz geeignet!
--
-- Erzeugt die notwendigen Schemata für LAUGIS und das Interface LAUQGIS.
-- Erwartet eine PostgreSQL Datenbank.
-- Die Schemata 'laugis' und 'lauqgis' dürfen noch nicht vergeben sein.
-- [user] steht stellvertretend für alle berechtigten user accounts.
--
-- Stand: 2022-09-08
-- Autor: Stefan Krug
--
--------------------------------------------------------------------------------------------------------------------------------------
-- # LAUGIS
--------------------------------------------------------------------------------------------------------------------------------------

CREATE SCHEMA laugis
    AUTHORIZATION postgres;

GRANT USAGE ON SCHEMA laugis TO lwarnow;
GRANT USAGE ON SCHEMA laugis TO fdietzmann;
GRANT USAGE ON SCHEMA laugis TO bkuendiger;
GRANT USAGE ON SCHEMA laugis TO kkrepelin;
GRANT USAGE ON SCHEMA laugis TO kteschner;
GRANT USAGE ON SCHEMA laugis TO skrug;
GRANT USAGE ON SCHEMA laugis TO ttrittel;

ALTER DEFAULT PRIVILEGES IN SCHEMA laugis
GRANT DELETE ON TABLES TO lwarnow;
ALTER DEFAULT PRIVILEGES IN SCHEMA laugis
GRANT DELETE ON TABLES TO fdietzmann;
ALTER DEFAULT PRIVILEGES IN SCHEMA laugis
GRANT DELETE ON TABLES TO kkrepelin;
ALTER DEFAULT PRIVILEGES IN SCHEMA laugis
GRANT DELETE ON TABLES TO bkuendiger;
ALTER DEFAULT PRIVILEGES IN SCHEMA laugis
GRANT DELETE ON TABLES TO kteschner;
ALTER DEFAULT PRIVILEGES IN SCHEMA laugis
GRANT DELETE ON TABLES TO skrug;
ALTER DEFAULT PRIVILEGES IN SCHEMA laugis
GRANT DELETE ON TABLES TO ttrittel;

ALTER DEFAULT PRIVILEGES IN SCHEMA laugis
GRANT EXECUTE ON FUNCTIONS TO skrug;

--------------------------------------------------------------------------------------------------------------------------------------
-- # LAUGIS
--------------------------------------------------------------------------------------------------------------------------------------

CREATE SCHEMA lauqgis
    AUTHORIZATION postgres;

GRANT USAGE ON SCHEMA lauqgis TO lwarnow;
GRANT qgis_user TO lwarnow;
GRANT USAGE ON SCHEMA lauqgis TO fdietzmann;
GRANT qgis_user TO fdietzmann;
GRANT USAGE ON SCHEMA lauqgis TO kkrepelin;
GRANT qgis_user TO kkrepelin;
GRANT USAGE ON SCHEMA lauqgis TO bkuendiger;
GRANT qgis_user TO bkuendiger;
GRANT USAGE ON SCHEMA lauqgis TO kteschner;
GRANT qgis_user TO kteschner;
GRANT USAGE ON SCHEMA lauqgis TO skrug;
GRANT qgis_user TO skrug;
GRANT USAGE ON SCHEMA lauqgis TO ttrittel;
GRANT qgis_user TO ttrittel;

ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT ALL ON TABLES TO lwarnow;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT ALL ON TABLES TO fdietzmann;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT ALL ON TABLES TO kkrepelin;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT ALL ON TABLES TO bkuendiger;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT ALL ON TABLES TO kteschner;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT ALL ON TABLES TO skrug;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT ALL ON TABLES TO ttrittel;

ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT EXECUTE ON FUNCTIONS TO lwarnow;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT EXECUTE ON FUNCTIONS TO fdietzmann;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT EXECUTE ON FUNCTIONS TO kkrepelin;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT EXECUTE ON FUNCTIONS TO bkuendiger;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT EXECUTE ON FUNCTIONS TO kteschner;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT EXECUTE ON FUNCTIONS TO skrug;
ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT EXECUTE ON FUNCTIONS TO ttrittel;
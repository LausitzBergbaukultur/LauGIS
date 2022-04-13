-- VORSICHT! Nicht zum Update einer bestehenden Instanz geeignet!
--
-- Erzeugt die notwendigen Schemata für LAUGIS und das Interface LAUQGIS.
-- Erwartet eine PostgreSQL Datenbank.
-- Die Schemata 'laugis' und 'lauqgis' dürfen noch nicht vergeben sein.
-- 'qgis_user' steht stellvertretend für alle berechtigten user accounts.
--
-- Stand: 2020-04-13
-- Autor: Stefan Krug
--
--------------------------------------------------------------------------------------------------------------------------------------
-- # LAUGIS
--------------------------------------------------------------------------------------------------------------------------------------

CREATE SCHEMA laugis
    AUTHORIZATION postgres;

GRANT USAGE ON SCHEMA laugis TO qgis_user;

--------------------------------------------------------------------------------------------------------------------------------------
-- # LAUGIS
--------------------------------------------------------------------------------------------------------------------------------------

CREATE SCHEMA lauqgis
    AUTHORIZATION postgres;

GRANT USAGE ON SCHEMA lauqgis TO qgis_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT ALL ON TABLES TO qgis_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA lauqgis
GRANT EXECUTE ON FUNCTIONS TO qgis_user;
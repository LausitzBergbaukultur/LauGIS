/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-05-25
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Lists all subordniate objects for a given object and returns them as a human readable formatted string.
					Format: [Bezeichnung]([Objekt_nr])
Call by:            view lauqgis.objekte_gesamt
					view lauqgis.einzelobjekt_punkt
					view lauqgis.einzelobjekt_linie
					view lauqgis.einzelobjekt_poly
					view lauqgis.objektbereich_poly
Affected tables:	none
Used By:            Interface views and exports
Parameters:			_objekt_id - primary key of a given object in lausitz.obj_basis
***************************************************************************************************/

CREATE OR REPLACE FUNCTION laugis.read_untergeordnet(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

SELECT string_agg(COALESCE(bezeichnung || ' (' || objekt_nr || ')', ''), ' | ') AS row_value
  FROM laugis.obj_basis
  WHERE rel_objekt_nr = (SELECT objekt_nr FROM laugis.obj_basis WHERE objekt_id = _objekt_id)
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-05-31
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        s.b.
Call by:            view lauqgis.objekte_gesamt
					view lauqgis.objektbereich_poly
					view lauqgis.einzelobjekt_punkt
					view lauqgis.einzelobjekt_linie
					view lauqgis.einzelobjekt_poly
Affected tables:	none
Used By:            Interface views and exports
Parameters:			_objekt_id - primary key of a given object in lausitz.obj_basis
***************************************************************************************************/

-- Gibt für ein Objekt die aggregierten Personeneinträge zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_personen(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE 
  _ar text;
BEGIN

-- ermittle Funktion und Person für jeden Vorfall. Im Falle von 'FREITEXT' wird alt_funktion übergeben
SELECT (string_agg(REPLACE(def.bezeichnung, 'FREITEXT', rel.alt_funktion) || ': ' || COALESCE(rel.bezeichnung, ''), ' | ')) AS row_value
    FROM laugis.obj_basis AS ob
        JOIN laugis.rel_personen AS rel ON rel.ref_objekt_id = ob.objekt_id
        JOIN laugis.def_personen AS def ON rel.ref_funktion_id = def.id
        WHERE ob.objekt_id = _objekt_id
INTO _ar;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
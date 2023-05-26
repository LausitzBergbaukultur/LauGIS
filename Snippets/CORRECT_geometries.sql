/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-05-26
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Identifies and displays all invalid geometries and corrects them.
Call by:            none
Affected tables:	none
Used By:            Systems interfacing LauGIS via LauQGIS.
Parameters:			none
***************************************************************************************************/

-- identify incorrect geometries and display them side by side with a corrected version
SELECT ob.objekt_nr::text, st_collectionextract(ST_makevalid(gp.geom)) AS corrected, gp.geom AS original
FROM laugis.geo_poly gp
JOIN laugis.obj_basis ob ON
	gp.ref_objekt_id = ob.objekt_id
WHERE ST_isvalid(gp.geom) IS FALSE AND ob.geloescht IS NOT TRUE 
UNION
SELECT ob.objekt_nr::text, st_collectionextract(ST_makevalid(gl.geom)) AS corrected, gl.geom AS original
FROM laugis.geo_line gl
JOIN laugis.obj_basis ob ON
	gl.ref_objekt_id = ob.objekt_id
WHERE ST_isvalid(gl.geom) IS FALSE AND ob.geloescht IS NOT true
UNION
SELECT ob.objekt_nr::text, st_collectionextract(ST_makevalid(gp2.geom)) AS corrected, gp2.geom AS original
FROM laugis.geo_point gp2
JOIN laugis.obj_basis ob ON
	gp2.ref_objekt_id = ob.objekt_id
WHERE ST_isvalid(gp2.geom) IS FALSE AND ob.geloescht IS NOT true
UNION
-- including lwk data
SELECT 'lwk', st_collectionextract(ST_makevalid(gplwk.geom)) AS corrected, gplwk.geom AS original
FROM laugis.geo_lwk_poly gplwk
WHERE ST_isvalid(gplwk.geom) IS FALSE
UNION
SELECT 'lwk', st_collectionextract(ST_makevalid(gllwk.geom)) AS corrected, gllwk.geom AS original
FROM laugis.geo_lwk_line gllwk
WHERE ST_isvalid(gllwk.geom) IS FALSE
UNION
SELECT 'lwk', st_collectionextract(ST_makevalid(gp2lwk.geom)) AS corrected, gp2lwk.geom AS original
FROM laugis.geo_lwk_point gp2lwk
WHERE ST_isvalid(gp2lwk.geom) IS FALSE;

-- ================================================================
-- update the corrected geometries
-- check for matching geometrytype is used to avoid mismatches on damaged data
UPDATE laugis.geo_poly
SET
	geom = st_collectionextract(st_makevalid(geom))
WHERE ST_isvalid(geom) IS FALSE AND st_geometrytype(geom) = st_geometrytype(st_collectionextract(st_makevalid(geom)));

UPDATE laugis.geo_line gl
SET
	geom = st_collectionextract(ST_makevalid(geom))
WHERE ST_isvalid(geom) IS FALSE AND st_geometrytype(geom) = st_geometrytype(st_collectionextract(st_makevalid(geom)));

UPDATE laugis.geo_point gp
SET
	geom = st_collectionextract(ST_makevalid(geom))
WHERE ST_isvalid(geom) IS FALSE AND st_geometrytype(geom) = st_geometrytype(st_collectionextract(st_makevalid(geom)));

UPDATE laugis.geo_lwk_poly gp
SET
	geom = st_collectionextract(ST_makevalid(geom))
WHERE ST_isvalid(geom) IS FALSE AND st_geometrytype(geom) = st_geometrytype(st_collectionextract(st_makevalid(geom)));

UPDATE laugis.geo_lwk_line gl
SET
	geom = st_collectionextract(ST_makevalid(geom))
WHERE ST_isvalid(geom) IS FALSE AND st_geometrytype(geom) = st_geometrytype(st_collectionextract(st_makevalid(geom)));

UPDATE laugis.geo_lwk_point gp
SET
	geom = st_collectionextract(ST_makevalid(geom))
WHERE ST_isvalid(geom) IS FALSE AND st_geometrytype(geom) = st_geometrytype(st_collectionextract(st_makevalid(geom)));
/***************************************************************************************************
Author:             Alexandra Krug
Institution:		Brandenburgisches Landesamt für Denkmalpflege und Archäologisches Landesmuseum
Date:        		2023-06-30
Repository:			https://github.com/LausitzBergbaukultur/LauGIS

Description:        Combines and normalizes geographical and administrative data as a register to
					search against. Fields used are needed to describe an objects location according
					to the laugis data model.
					
					Expects a table with plot (Flurstück) geometries and with all higher administrative
					levels already prejoined. 
					~~Furthermore joins a second table with adress information
					based upon building shapes.~~ deactivated
					
					Also cleans up the source tables, adds an index to the materialized view and grants
					select permissions.
Affected tables:	- public.kreise_gemeinden_ortsteile_flur 	(administrative data on plots)
					~~ - quellen.ql_gebaeude_mit_adressen			(building layer)~~
Used By:            LauGIS update functions to determine an objects location information.
***************************************************************************************************/

-- clean up the source tables
VACUUM ANALYZE public.kreise_gemeinden_ortsteile_flur;
-- VACUUM ANALYZE quellen.ql_gebaeude_mit_adressen;

DROP MATERIALIZED VIEW IF EXISTS quellen.location_by_plot;

-- consolidates fields, corrects the geometry type and joins a building layer to determine street names
CREATE MATERIALIZED VIEW quellen.location_by_plot
AS
	SELECT kgof.fid AS id,
		kgof."name" AS kreis,
		kgof.name_2 AS gemeinde, 
		COALESCE(kgof.name_3, kgof.name_2, NULL) AS ort,
		COALESCE(kgof.regionalsprache_name_3, kgof.regionalsprache_name_2, NULL) AS sorbisch, 
		-- string_agg(DISTINCT(qgma.strasse), ' | ') AS strasse,
		kgof.gemktext AS gem,
		kgof.flur AS flur,
		kgof.zaehler AS zaehler, 
		kgof.nenner AS nenner, 
		ST_CurveToLine(kgof.geom) AS geom
	FROM public.kreise_gemeinden_ortsteile_flur kgof
		--LEFT JOIN quellen.ql_gebaeude_mit_adressen AS qgma
		--	ON ST_Intersects(kgof.geom, qgma.geom)
	GROUP BY kgof.fid;
	
-- create index on view, since the source table should be pretty static 
CREATE INDEX location_by_plot_geom_idx
  ON quellen.location_by_plot
  USING GIST (geom);

-- grant permission to role
GRANT SELECT ON TABLE quellen.location_by_plot TO laugis_user;



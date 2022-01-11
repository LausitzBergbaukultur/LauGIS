-- Die View repräsentiert die Struktur "Objektbereich"
-- Die zugehörigen Geometrie ist Multipolygon
-- Es werden die zusammenhängenden Datensätze der Tabellen obj_basis und obj_stamm angezeigt.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

CREATE OR REPLACE VIEW development.objektbereich_poly AS

SELECT objekt_id, ob.ref_objekt_id, objekt_nr, erfassungsdatum, aenderungsdatum, in_bearbeitung, beschreibung, beschreibung_ergaenzung, lagebeschreibung, quellen_literatur, notiz_intern, hida_nr, stammdaten_id, sachbegriff, bezeichnung, bauwerksname_eigenname, kategorie, erhaltungszustand, schutzstatus, nachnutzungspotential, kreis, gemeinde, ort, sorbisch, strasse, hausnummer, gem_flur, geom
	FROM development.obj_basis AS ob
	JOIN development.geo_poly AS geo ON ob.objekt_id = geo.ref_objekt_id
	JOIN development.obj_stamm AS os ON ob.objekt_id = os.ref_objekt_id
	FULL JOIN (SELECT (ARRAY[[0],[0]]) AS nullcolumn) AS sq ON 0 = ob.objekt_id -- nur als dummy Spalte gedacht
	WHERE ob.geloescht IS NOT TRUE
    AND ob.objekt_id IS NOT NULL;
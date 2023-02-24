CREATE OR REPLACE VIEW lauqgis.objekte_historie AS

SELECT hist_id, objekt_nr, rel_objekt_nr, status_bearbeitung, erfassungsdatum, aenderungsdatum, letzte_aenderung, geloescht, return_erfasser, kategorie, sachbegriff, sachbegriff_alt, beschreibung, beschreibung_ergaenzung, lagebeschreibung, return_literatur, notiz_intern, hida_nr, return_datierung, return_nutzung, return_personen, return_bilder, bilder_anmerkung, bezeichnung, bauwerksname_eigenname, schutzstatus, foerderfaehig, kreis, gemeinde, ort, sorbisch, strasse, hausnummer, gem_flur, return_blickbeziehung, techn_anlage, return_material, material_alt, return_konstruktion, konstruktion_alt, geschosszahl, achsenzahl, grundriss, return_dachform, dachform_alt, antrieb, abmessung, gewicht
	FROM laugis.obj_hist
	ORDER BY objekt_nr, letzte_aenderung DESC;
;
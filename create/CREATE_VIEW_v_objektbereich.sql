-- Die View repräsentiert die Struktur "Objektbereich"
-- Es werden die zusammenhängenden Datensätze der Tabellen obj_basis und obj_stamm angezeigt.
-- Datensätze mit Flag 'geloescht' werden nicht berücksichtigt.

CREATE OR REPLACE VIEW development.v_objektbereich AS

SELECT objekt_id, ob.ref_objekt_id, objekt_nr, erfassungsdatum, aenderungsdatum, in_bearbeitung, beschreibung, beschreibung_ergaenzung, lagebeschreibung, quellen_literatur, notiz_intern, hida_nr, stammdaten_id, sachbegriff, bezeichnung, bauwerksname_eigenname, kategorie, erhaltungszustand, schutzstatus, nachnutzungspotential, kreis, gemeinde, ort, sorbisch, strasse, hausnummer, gem_flur
FROM development.obj_basis AS ob
JOIN development.obj_stamm AS os ON ob.objekt_id = os.ref_objekt_id
WHERE ob.geloescht IS NOT TRUE;
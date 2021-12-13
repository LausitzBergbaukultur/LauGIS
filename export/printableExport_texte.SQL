-- Textprüfung Einzelobjekt

SELECT E'Objektnummer:\t' || COALESCE(onr.objekt_nr, '')
|| E'\nErfassung:\t\t' || COALESCE(bea.name, '')
|| E'\nBezeichnung:\t\t' || COALESCE(eo.bezeichnung, '')
|| E'\nEigenname:\t\t' || COALESCE(bauwerksname_eigenname, '')
|| E'\nKategorie:\t\t' || COALESCE(kat.bezeichnung, '')
|| E'\nSachbegriff:\t\t' || COALESCE(sachbegriff, '')
|| E'\nDatierung:\t\t' || COALESCE(datierung, '')
|| E'\nGrundriss:\t\t' || COALESCE(grundriss, '')
|| E'\nGeschosszahl:\t\t' || COALESCE(CAST(geschosszahl AS text), '')
|| E'\t\tAchsenzahl:\t' || COALESCE(CAST(achsenzahl AS text), '')
|| E'\nDachform:\t\t' || COALESCE(dachform, '')
|| E'\nMaterial:\t\t' || COALESCE(material, '')
|| E'\nKonstruktion / Technik: \t' || COALESCE(konstruktion_technik, '')
|| E'\nBeschreibung: ' || COALESCE(beschreibung, '')
|| E'\nBeschreibung ergänzend: ' || COALESCE(beschreibung_ergaenzend, '')
|| E'\nBlickbeziehung:\t' || COALESCE(blickbeziehung, '')
|| E'\nNotiz intern:\t' || COALESCE(notiz_intern, '')
|| E'\nErhaltungszustand:\t' || COALESCE(erh.bezeichnung, '')
|| E'\nSchutzstatus:\t\t' || COALESCE(sch.bezeichnung, '')
|| E'\nFunktion:\t\t' || COALESCE(funktion, '')
|| E'\nNachnutzungspotential:\t' || COALESCE(nn.bezeichnung, '') 
|| E'\nPerson werkausführend:\t' || COALESCE(person_werk, '')
|| E'\nSozietät werkausführend:\t' || COALESCE(soziet_werk, '')
|| E'\nPerson verantwortlich:\t' || COALESCE(person_verantw, '')
|| E'\nSozietät verantwortlich:\t' || COALESCE(soziet_verantw, '')
|| E'\nOrt:\t\t\t' || COALESCE(ort, '')
|| E'\nStraße:\t\t\t' || COALESCE(strasse, '')
|| E'\nHausnummer:\t\t' || COALESCE(hausnummer, '')
|| E'\nGemarkung/Flur:\t' || COALESCE(gem_flur, '')
|| E'\nLagebeschreibung:\t' || COALESCE(lage_beschreibung, '')
|| E'\n\n---\n\n' AS "Einzelobjekt"
FROM "Erfassung"."obj_Einzelobjekt" AS eo
	LEFT JOIN "Erfassung"."ref_Objektnummer" AS onr ON eo.objekt_nr = onr.id
	LEFT JOIN "Erfassung"."def_Erhaltungszustand" AS erh ON eo.erhaltungszustand = erh.id
	LEFT JOIN "Erfassung"."def_Kategorie" AS kat ON eo.kategorie = kat.id
	LEFT JOIN "Erfassung"."def_Nachnutzung" AS nn ON eo.nachnutzungspotential = nn.id
	LEFT JOIN "Erfassung"."def_Schutzstatus" AS sch ON eo.schutzstatus = sch.id
	LEFT JOIN "Erfassung"."def_Erfasser" AS bea ON eo.erfassung = bea.id
WHERE eo.in_bearbeitung IS false
UNION
SELECT E'Objektnummer:\t' || COALESCE(onr.objekt_nr, '')
|| E'\nErfassung:\t\t' || COALESCE(bea.name, '')
|| E'\nBezeichnung:\t\t' || COALESCE(eo.bezeichnung, '')
|| E'\nEigenname:\t\t' || COALESCE(bauwerksname_eigenname, '')
|| E'\nKategorie:\t\t' || COALESCE(kat.bezeichnung, '')
|| E'\nSachbegriff:\t\t' || COALESCE(sachbegriff, '')
|| E'\nDatierung:\t\t' || COALESCE(datierung, '')
|| E'\nGrundriss:\t\t' || COALESCE(grundriss, '')
|| E'\nGeschosszahl:\t\t' || COALESCE(CAST(geschosszahl AS text), '')
|| E'\t\tAchsenzahl:\t' || COALESCE(CAST(achsenzahl AS text), '')
|| E'\nDachform:\t\t' || COALESCE(dachform, '')
|| E'\nMaterial:\t\t' || COALESCE(material, '')
|| E'\nKonstruktion / Technik: \t' || COALESCE(konstruktion_technik, '')
|| E'\nBeschreibung: ' || COALESCE(beschreibung, '')
|| E'\nBeschreibung ergänzend: ' || COALESCE(beschreibung_ergaenzend, '')
|| E'\nBlickbeziehung:\t' || COALESCE(blickbeziehung, '')
|| E'\nNotiz intern:\t' || COALESCE(notiz_intern, '')
|| E'\nErhaltungszustand:\t' || COALESCE(erh.bezeichnung, '')
|| E'\nSchutzstatus:\t\t' || COALESCE(sch.bezeichnung, '')
|| E'\nFunktion:\t\t' || COALESCE(funktion, '')
|| E'\nNachnutzungspotential:\t' || COALESCE(nn.bezeichnung, '') 
|| E'\nPerson werkausführend:\t' || COALESCE(person_werk, '')
|| E'\nSozietät werkausführend:\t' || COALESCE(soziet_werk, '')
|| E'\nPerson verantwortlich:\t' || COALESCE(person_verantw, '')
|| E'\nSozietät verantwortlich:\t' || COALESCE(soziet_verantw, '')
|| E'\nOrt:\t\t\t' || COALESCE(ort, '')
|| E'\nStraße:\t\t\t' || COALESCE(strasse, '')
|| E'\nHausnummer:\t\t' || COALESCE(hausnummer, '')
|| E'\nGemarkung/Flur:\t' || COALESCE(gem_flur, '')
|| E'\nLagebeschreibung:\t' || COALESCE(lage_beschreibung, '')
|| E'\n\n---\n\n' AS "Einzelobjekt"
FROM "Erfassung"."obj_Einzelobjekt_line" AS eo
	LEFT JOIN "Erfassung"."ref_Objektnummer" AS onr ON eo.objekt_nr = onr.id
	LEFT JOIN "Erfassung"."def_Erhaltungszustand" AS erh ON eo.erhaltungszustand = erh.id
	LEFT JOIN "Erfassung"."def_Kategorie" AS kat ON eo.kategorie = kat.id
	LEFT JOIN "Erfassung"."def_Nachnutzung" AS nn ON eo.nachnutzungspotential = nn.id
	LEFT JOIN "Erfassung"."def_Schutzstatus" AS sch ON eo.schutzstatus = sch.id
	LEFT JOIN "Erfassung"."def_Erfasser" AS bea ON eo.erfassung = bea.id
WHERE eo.in_bearbeitung IS false
UNION
-- Textprüfung Objektbereich
SELECT E'Objektnummer:\t' || COALESCE(onr.objekt_nr, '')
|| E'\nErfassung:\t\t' || COALESCE(bea.name, '')
|| E'\nBezeichnung:\t\t' || COALESCE(eo.bezeichnung, '')
|| E'\nEigenname:\t\t' || COALESCE(bauwerksname_eigenname, '')
|| E'\nKategorie:\t\t' || COALESCE(kat.bezeichnung, '')
|| E'\nSachbegriff:\t\t' || COALESCE(sachbegriff, '')
|| E'\nDatierung:\t\t' || COALESCE(datierung, '')
|| E'\nBeschreibung: ' || COALESCE(beschreibung, '')
|| E'\nBeschreibung ergänzend: ' || COALESCE(beschreibung_ergaenzend, '')
|| E'\nBlickbeziehung:\t' || COALESCE(blickbeziehung, '')
|| E'\nNotiz intern:\t' || COALESCE(notiz_intern, '')
|| E'\nErhaltungszustand:\t' || COALESCE(erh.bezeichnung, '')
|| E'\nSchutzstatus:\t\t' || COALESCE(sch.bezeichnung, '')
|| E'\nFunktion:\t\t' || COALESCE(funktion, '')
|| E'\nNachnutzungspotential:\t' || COALESCE(nn.bezeichnung, '') 
|| E'\nPerson werkausführend:\t' || COALESCE(person_werk, '')
|| E'\nSozietät werkausführend:\t' || COALESCE(soziet_werk, '')
|| E'\nPerson verantwortlich:\t' || COALESCE(person_verantw, '')
|| E'\nSozietät verantwortlich:\t' || COALESCE(soziet_verantw, '')
|| E'\nOrt:\t\t\t' || COALESCE(ort, '')
|| E'\nStraße:\t\t\t' || COALESCE(strasse, '')
|| E'\nHausnummer:\t\t' || COALESCE(hausnummer, '')
|| E'\nGemarkung/Flur:\t' || COALESCE(gem_flur, '')
|| E'\nLagebeschreibung:\t' || COALESCE(lage_beschreibung, '')
|| E'\n\n---\n\n' AS "Objektbereich"
FROM "Erfassung"."obj_Objektbereich" AS eo
	LEFT JOIN "Erfassung"."ref_Objektnummer" AS onr ON eo.objekt_nr = onr.id
	LEFT JOIN "Erfassung"."def_Erhaltungszustand" AS erh ON eo.erhaltungszustand = erh.id
	LEFT JOIN "Erfassung"."def_Kategorie" AS kat ON eo.kategorie = kat.id
	LEFT JOIN "Erfassung"."def_Nachnutzung" AS nn ON eo.nachnutzungspotential = nn.id
	LEFT JOIN "Erfassung"."def_Schutzstatus" AS sch ON eo.schutzstatus = sch.id
	LEFT JOIN "Erfassung"."def_Erfasser" AS bea ON eo.erfassung = bea.id
WHERE eo.in_bearbeitung IS false


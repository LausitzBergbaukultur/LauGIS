## LauGIS 2.1 release notes

- API implementiert, um komplexere Operationen seitens QGIS auslösen zu können
- Funktion zum Wechsel des Objekttyps implementiert
- Funktionsleiste hinzugefügt
- Menschenlesbare Ausgabe der Schnittstellenwerte bei Erfasser*innen, Dachformen, Material, Bildern, Blickbeziehungen, Datierungen, Konstruktion, Personen und Nutzung hinzugefügt
- Skalierung der Formulare und Tabellen verbessert
- Sortierungen der geschützten Vokabulare optimiert
- div. kleinere Bugfixes und Anpassungen

## Projektbeschreibung

Im Rahmen des [Projekts zur Erfassung der lausitzer Braunkohle- & Industriekultur](https://bldam-brandenburg.de/arbeitsbereiche/bau-und-kunstdenkmalpflege/forschungen-und-projekte/erfassungsprojekt-lausitz/) werden untersuchte Objekte in einer GIS-Datenbank verzeichnet. Durch die Nutzung eines solchen Geo-Informations-Systems ist es möglich, die örtlichen Zusammenhänge der untersuchten Objekte zusätzlich zu den objektspezifischen Informationen zu erfassen und zudem vielfältige Szenarien zur Nachnutzung und Publikation der Ergebnisse zu ermöglichen. Das hierzu notwendige System zur Erfassung und Datenhaltung trägt den Namen LauGIS und wird projektbegleitend entwickelt.

Grundlage ist eine PostgreSQL-Datenbank mit PostGIS-Aufsatz. Gestaltungsschwerpunkte des Systems sind die Sicherstellung der Datenintegrität, die Nach- und Nebennutzbarkeit der Sammlung sowie Vereinfachung des Erfassungsprozesses. Zur Erfassung und Pflege der Datensätze wird [QGIS](https://github.com/qgis/QGIS) eingesetzt. QGIS-spezifische Systemteile tragen folglich die Bezeichnung LauQGIS.

[<img src=".//Dokumentation/Datenbankschema_vereinfacht.png" width="350"/>](.//Dokumentation/Datenbankschema_vereinfacht.png)

## Aufbau des Repositoriums

* [LauGIS\_data](.//LauGIS_data) - SQL-Skripte der grundlegenden Datenstruktur.
* [LauGIS\_function](.//LauGIS_function) - SQL-Skripte zur Datenverarbeitung und -aufbereitung.
* [LauQGIS\_interface](.//LauQGIS_interface) - SQL-Skripte zur Bereitstellung und Verarbeitung der LauGIS-Daten in und aus QGIS.
* [LauQGIS\_frontend](.//LauQGIS_frontend) - Pythonskripte und PYQT5-Forms zur Einbindung der LauQGIS-Interfaces in QGIS.
* [Dokumentation](.//Dokumentation) - Technik- und Datenspezifische Dokumentation.
* [Snippets](.//Snippets) - Hilfreiche Skripte, deren Anwendungsgebiet außerhalb der Kernfunktionalität liegt.

# LauGIS

## Projektbeschreibung

Im Rahmen des [Projekts zur Erfassung der lausitzer Braunkohle- & Industriekultur](https://bldam-brandenburg.de/arbeitsbereiche/bau-und-kunstdenkmalpflege/forschungen-und-projekte/erfassungsprojekt-lausitz/) werden untersuchte Objekte in einer GIS-Datenbank verzeichnet. Durch die Nutzung eines solchen Geo-Informations-Systems ist es möglich, die örtlichen Zusammenhänge der untersuchten Objekte zusätzlich zu den objektspezifischen Informationen zu erfassen und zudem vielfältige Szenarien zur Nachnutzung und Publikation der Ergebnisse zu ermöglichen. Das hierzu notwendige System zur Erfassung und Datenhaltung trägt den Namen LauGIS und wird projektbegleitend entwickelt.

---

**work in progress**

---

## LauGIS

Zu erfassende Objekte werden in einer PostgreSQL Datenbank mit PostGIS-Aufsatz gespeichert. Gestaltungsschwerpunkte des Systems sind die Sicherstellung der Datenintegrität, die Nach- und Nebennutzbarkeit der Sammlung sowie Vereinfachung des Erfassungsprozesses. Zur Erfassung der Datensätze wird [QGIS](https://github.com/qgis/QGIS) eingesetzt. Die QGIS-spezifischen Systemteile tragen dementsprechend die Bezeichnung LauQGIS.   

[<img src=".//Dokumentation/Datenbankschema_vereinfacht.png" width="350"/>](.//Dokumentation/Datenbankschema_vereinfacht.png)

## Repositorium

- [LauGIS_data](.//LauGIS_data) - SQL-Skripte der grundlegenden Datenstruktur.
- [LauGIS_function](.//LauGIS_function) - SQL-Skripte zur Datenverarbeitung und -aufbereitung.
- [LauQGIS_interface](.//LauQGIS_interface) - SQL-Skripte zur Bereitstellung und Verarbeitung der LauGIS-Daten in und aus QGIS.
- [LauQGIS_frontend](.//LauQGIS_frontend) - Pythonskripte und PYQT5-Forms zur Einbindung der LauQGIS-Interfaces in QGIS.
- [Dokumentation](.//Dokumentation) - Technik- und Datenspezifische Dokumentation.

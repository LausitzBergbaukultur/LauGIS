## Projektbeschreibung

Im Rahmen des [Projekts zur Erfassung der lausitzer Braunkohle- & Industriekultur](https://bldam-brandenburg.de/arbeitsbereiche/bau-und-kunstdenkmalpflege/forschungen-und-projekte/erfassungsprojekt-lausitz/) werden untersuchte Objekte in einer GIS-Datenbank verzeichnet. Durch die Nutzung eines solchen Geo-Informations-Systems ist es möglich, die örtlichen Zusammenhänge der untersuchten Objekte zusätzlich zu den objektspezifischen Informationen zu erfassen und zudem vielfältige Szenarien zur Nachnutzung und Publikation der Ergebnisse zu ermöglichen. Die Speicherung der Daten findet hierbei zentral auf einem PostGIS-Server statt, der einer regelmäßigen Datensicherung unterliegt. Dieser Datenbankserver ermöglicht das zeitgleiche und kollaborative Arbeiten an den Datensätzen und stellt durch automatische Prüfungen zudem die Integrität der Daten sicher. Als Fachanwendung auf Anwender:innen-Ebene kommt *QGIS* zum Einsatz, wobei die Arbeitsdaten direkt vom Datenbankserver bezogen werden.

## LauGIS

Das vorliegende Repositorium dient der Dokumentation der PostgreSQL-Datenbank.

![](.\Dokumentation\Datenbankschema_vereinfacht.png)

## LauGIS 2.2 changelog

- Objekt-Versionierung implementiert
  - `UPDATE` gegen die Schnittstellen-Views führt zu einem `INSERT` des Ausgangsdatensatzes in die Tabelle `laugis.obj_hist` und anschließend zum `UPDATE` auf `laugis.obj_basis`
  - Für das Schreiben der Historie ist die Funktion `laugis.write_obj_history` verantwortlich
  - Die Versionsgeschichte kann über die Schnittstellen-View `lauqgis.objekte_historie` eingesehen werden
- Gelöscht-Flag für die erweiterten Objekt-Daten implementiert
  - Die betroffenen Relations-Tabellen (Bilder, Blickbeziehung, Dachform, Datierung, Konstruktion, Literatur, Material, Nutzung, Personen) wurden um die Felder `geloescht`und `geleoscht_am` erweitert
  - `DELETE` gegen die Schnittstellen-Views werden abgefangen und in den entsprechenden Funktionen (`laugis.remove_bilder`, `laugis.remove_datierung`, etc. ) behandelt
  - Die betroffenen Return-Funktionen (`laugis.return_bilder`, `laugis.return_datierung`, etc.) prüfen nun gegen das Flag `geloescht`
- View `lauqgis.objekte_gesamt` hinzugefügt
  - Die Schnittstellen-View ist read-only und stellt die Gesamtheit aller nicht-gelöschten Objekte in einer menschenlesbarer Art dar
- Bildvorschau implementiert
  - Für Objekte mit hinterlegten Bildinformationen kann nun über die Menüleiste eine Bildvorschau aufgerufen werden
  - In einem modalen Dialog werden Thumbnails der hinterlegten Bilder, der zugehörige Dateiname, ein Hinweis auf interne und Titelbilder, sowie eine Schaltfläche zum Aufrufen des originalen Bildes angezeigt
  - Der Dialog skaliert je nach Bildanzahl zwischen 3 und 5 Spalten
- Ressourcenprüfung 'Bilder' implementiert
  - Der Dialog "Bilder bearbeiten" wurde um die Spalte "online" erweitert
  - Beim Öffnen des Dialogs wird auf die eingetragenen Bilder ein HTTP-Request ausgeführt und das Ergebnis in der Spalte "online" angezeigt
- Dokumentation erweitert
  - Simple Schnittstellendefinition der LauQGIS-Views hinzugefügt: [20230224_Schnittstellensignatur_LauQGIS.md](.//Dokumentation/20230224_Schnittstellensignatur_LauQGIS.md)
  - Aktualisiertes, vereinfachtes Datenbankschema hinzugefügt: [20230224_Datenbankschema_LauGIS_vereinfacht.png](.//Dokumentation/20230224_Datenbankschema_LauGIS_vereinfacht.png)
- div. kleinere Bugfixes und Anpassungen

NB: Es wurde noch kein neues Installscript für Version 2.2 erzeugt. 

## LauGIS 2.1 changelog

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

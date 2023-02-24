# Schnittstellensignatur LauQGIS 2.2

Stand: 24.02.2023
Autor: Alexandra Krug

## View objektbereich

Schema: lauqgis
Varianten: Poly, Linie
Schema der referenzierten Tabellen und Funktionen: laugis

| **Herkunft**                        | **Feldname**            | **Typ**  |                     |
| ----------------------------------- | ----------------------- | -------- | ------------------- |
| obj_basis                           | objekt_id               | integer  | PK                  |
| obj_basis                           | objekt_nr               | integer  |                     |
| obj_basis                           | rel_objekt_nr           | integer  | FK obj_basis        |
| obj_basis                           | status_bearbeitung      | smallint | FK def_bearbeitung  |
| obj_basis                           | erfassungsdatum         | date     |                     |
| obj_basis                           | aenderungsdatum         | date     |                     |
| return_erfasser(ob.objekt_id)       | return_erfasser         | json     |                     |
| read_erfasser(ob.objekt_id, true)   | read_erfasser           | text     |                     |
| obj_basis                           | kategorie               | smallint | FK def_kategorie    |
| obj_basis                           | sachbegriff             | integer  | FK def_sachbegriff  |
| obj_basis                           | sachbegriff_alt         | text     |                     |
| obj_basis                           | beschreibung            | text     |                     |
| obj_basis                           | beschreibung_ergaenzung | text     |                     |
| obj_basis                           | lagebeschreibung        | text     |                     |
| return_literatur(ob.objekt_id)      | return_literatur        | json     |                     |
| read_literatur(ob.objekt_id)        | read_literatur          | text     |                     |
| obj_basis                           | notiz_intern            | text     |                     |
| obj_basis                           | hida_nr                 | text     |                     |
| return_datierung(ob.objekt_id)      | return_datierung        | json     |                     |
| read_datierung(ob.objekt_id)        | read_datierung          | text     |                     |
| return_nutzung(ob.objekt_id)        | return_nutzung          | json     |                     |
| read_nutzung(ob.objekt_id)          | read_nutzung            | text     |                     |
| return_personen(ob.objekt_id)       | return_personen         | json     |                     |
| read_personen(ob.objekt_id)         | read_personen           | text     |                     |
| return_bilder(ob.objekt_id)         | return_bilder           | json     |                     |
| read_bilder(ob.objekt_id)           | read_bilder             | text     |                     |
| obj_basis                           | bilder_anmerkung        | text     |                     |
| obj_basis                           | bezeichnung             | text     |                     |
| obj_basis                           | bauwerksname_eigenname  | text     |                     |
| obj_basis                           | schutzstatus            | smallint | FK def_schutzstatus |
| obj_basis                           | foerderfaehig           | boolean  |                     |
| obj_basis                           | kreis                   | text     |                     |
| obj_basis                           | gemeinde                | text     |                     |
| obj_basis                           | ort                     | text     |                     |
| obj_basis                           | sorbisch                | text     |                     |
| obj_basis                           | strasse                 | text     |                     |
| obj_basis                           | hausnummer              | text     |                     |
| obj_basis                           | gem_flur                | text     |                     |
| return_blickbeziehung(ob.objekt_id) | return_blickbeziehung   | json     |                     |
| read_blickbeziehung(ob.objekt_id)   | read_blickbeziehung     | text     |                     |
| geo_poly \| geo_line                | geom                    | geometry | (multigeometry)     |
| NULL                                | api                     | text     |                     |

## View einzelobjekt

Schema: lauqgis
Varianten: Poly, Linie, Punkt
Schema der referenzierten Tabellen und Funktionen: laugis

| **Herkunft**                        | **Feldname**            | **Typ**  |                     |
| ----------------------------------- | ----------------------- | -------- | ------------------- |
| obj_basis                           | objekt_id               | integer  | PK                  |
| obj_basis                           | objekt_nr               | integer  |                     |
| obj_basis                           | rel_objekt_nr           | integer  | FK obj_basis        |
| obj_basis                           | status_bearbeitung      | smallint | FK def_bearbeitung  |
| obj_basis                           | erfassungsdatum         | date     |                     |
| obj_basis                           | aenderungsdatum         | date     |                     |
| return_erfasser(ob.objekt_id)       | return_erfasser         | json     |                     |
| read_erfasser(ob.objekt_id, true)   | read_erfasser           | text     |                     |
| obj_basis                           | kategorie               | smallint | FK def_kategorie    |
| obj_basis                           | sachbegriff             | integer  | FK def_sachbegriff  |
| obj_basis                           | sachbegriff_alt         | text     |                     |
| obj_basis                           | beschreibung            | text     |                     |
| obj_basis                           | beschreibung_ergaenzung | text     |                     |
| obj_basis                           | lagebeschreibung        | text     |                     |
| return_literatur(ob.objekt_id)      | return_literatur        | json     |                     |
| read_literatur(ob.objekt_id)        | read_literatur          | text     |                     |
| obj_basis                           | notiz_intern            | text     |                     |
| obj_basis                           | hida_nr                 | text     |                     |
| return_datierung(ob.objekt_id)      | return_datierung        | json     |                     |
| read_datierung(ob.objekt_id)        | read_datierung          | text     |                     |
| return_nutzung(ob.objekt_id)        | return_nutzung          | json     |                     |
| read_nutzung(ob.objekt_id)          | read_nutzung            | text     |                     |
| return_personen(ob.objekt_id)       | return_personen         | json     |                     |
| read_personen(ob.objekt_id)         | read_personen           | text     |                     |
| return_bilder(ob.objekt_id)         | return_bilder           | json     |                     |
| read_bilder(ob.objekt_id)           | read_bilder             | text     |                     |
| obj_basis                           | bilder_anmerkung        | text     |                     |
| obj_basis                           | bezeichnung             | text     |                     |
| obj_basis                           | bauwerksname_eigenname  | text     |                     |
| obj_basis                           | schutzstatus            | smallint | FK def_schutzstatus |
| obj_basis                           | foerderfaehig           | boolean  |                     |
| obj_basis                           | kreis                   | text     |                     |
| obj_basis                           | gemeinde                | text     |                     |
| obj_basis                           | ort                     | text     |                     |
| obj_basis                           | sorbisch                | text     |                     |
| obj_basis                           | strasse                 | text     |                     |
| obj_basis                           | hausnummer              | text     |                     |
| obj_basis                           | gem_flur                | text     |                     |
| return_blickbeziehung(ob.objekt_id) | return_blickbeziehung   | json     |                     |
| read_blickbeziehung(ob.objekt_id)   | read_blickbeziehung     | text     |                     |
| obj_tech                            | techn_anlage            | boolean  |                     |
| return_material(ob.objekt_id)       | return_material         | json     |                     |
| read_material(ob.objekt_id)         | read_material           | text     |                     |
| obj_tech                            | material_alt            | text     |                     |
| return_konstruktion(ob.objekt_id)   | return_konstruktion     | json     |                     |
| read_konstruktion(ob.objekt_id)     | read_konstruktion       | text     |                     |
| obj_tech                            | konstruktion_alt        | text     |                     |
| obj_tech                            | geschosszahl            | smallint |                     |
| obj_tech                            | achsenzahl              | smallint |                     |
| obj_tech                            | grundriss               | text     |                     |
| return_dachform(ob.objekt_id)       | return_dachform         | json     |                     |
| read_dachform(ob.objekt_id)         | read_dachform           | text     |                     |
| obj_tech                            | dachform_alt            | text     |                     |
| obj_tech                            | antrieb                 | text     |                     |
| obj_tech                            | abmessung               | text     |                     |
| obj_tech                            | gewicht                 | text     |                     |
| geo_poly \| geo_line \| geo_point   | geom                    | geometry | (multigeometry)     |
| NULL                                | api                     | text     |                     |

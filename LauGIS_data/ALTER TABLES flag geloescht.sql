ALTER TABLE IF EXISTS laugis.rel_bilder
    ADD COLUMN geloescht boolean,
    ADD COLUMN geloescht_am date;

ALTER TABLE IF EXISTS laugis.rel_blickbeziehung
    ADD COLUMN geloescht boolean,
    ADD COLUMN geloescht_am date;

ALTER TABLE IF EXISTS laugis.rel_dachform
    ADD COLUMN geloescht boolean,
    ADD COLUMN geloescht_am date;

ALTER TABLE IF EXISTS laugis.rel_datierung
    ADD COLUMN geloescht boolean,
    ADD COLUMN geloescht_am date;

ALTER TABLE IF EXISTS laugis.rel_konstruktion
    ADD COLUMN geloescht boolean,
    ADD COLUMN geloescht_am date;

ALTER TABLE IF EXISTS laugis.rel_literatur
    ADD COLUMN geloescht boolean,
    ADD COLUMN geloescht_am date;

ALTER TABLE IF EXISTS laugis.rel_material
    ADD COLUMN geloescht boolean,
    ADD COLUMN geloescht_am date;

ALTER TABLE IF EXISTS laugis.rel_nutzung
    ADD COLUMN geloescht boolean,
    ADD COLUMN geloescht_am date;

ALTER TABLE IF EXISTS laugis.rel_personen
    ADD COLUMN geloescht boolean,
    ADD COLUMN geloescht_am date;
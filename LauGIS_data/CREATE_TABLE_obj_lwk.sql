-- Bildet die Landschaftswandel-Objekte ab.
-- Wird analog zur obj_basis mit geo-Objekten verknüpft.

DROP TABLE IF EXISTS laugis.obj_lwk;
CREATE TABLE IF NOT EXISTS laugis.obj_lwk
( 	
	-- # Metadaten
	objekt_id integer PRIMARY KEY generated always as identity, -- PK
	erfassungsdatum date,			-- 9580
	aenderungsdatum date,			-- 9950
	letzte_aenderung timestamp,     -- meta zur Filterung
    geloescht bool,                 -- meta zur Filterung
    erfassung smallint,

    -- Identifikatoren
   	beschriftung text,				-- Bezeichnung und Identifikation
    jahresschnitt smallint,
    nutzungsart smallint,
    
    -- geo -> rel

    CONSTRAINT fkey_erfassung FOREIGN KEY (erfassung)
    REFERENCES laugis.def_erfasser (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

    CONSTRAINT fkey_jahresschnitt FOREIGN KEY (jahresschnitt)
    REFERENCES laugis.def_jahresschnitt (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,

    CONSTRAINT fkey_nutzungsart FOREIGN KEY (nutzungsart)
    REFERENCES laugis.def_nutzungsart (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);
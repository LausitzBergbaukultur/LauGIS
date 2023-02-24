DROP TABLE IF EXISTS laugis.obj_hist;
CREATE TABLE IF NOT EXISTS laugis.obj_hist
(     
    -- # Metadaten
    hist_id integer PRIMARY KEY generated always as identity, -- PK
    objekt_nr integer,              -- implicit ID
    rel_objekt_nr integer,     
    status_bearbeitung smallint,  
    erfassungsdatum date,     
    aenderungsdatum date,    
    letzte_aenderung timestamp,   
    geloescht bool,           
    return_erfasser text,

    -- # Deskriptoren
    kategorie smallint,
    sachbegriff integer,  
    sachbegriff_alt text,   
    beschreibung text,  
    beschreibung_ergaenzung text, 
    lagebeschreibung text,
    return_literatur text,
    notiz_intern text, 
    hida_nr text, 
    return_datierung text,
    return_nutzung text,
    return_personen text,
    return_bilder text,
    bilder_anmerkung text,   

    -- # Stammdaten
    bezeichnung text,   
    bauwerksname_eigenname text,  
    schutzstatus smallint,    
    foerderfaehig bool, 

    -- # Lokalisatoren
    kreis text, 
    gemeinde text, 
    ort text,  
    sorbisch text,  
    strasse text,   
    hausnummer text, 
    gem_flur text,  
    return_blickbeziehung text,
    
    -- # Deskriptoren allgemein
    techn_anlage bool,    
    return_material text,
    material_alt text,
    return_konstruktion text,
    konstruktion_alt text,

    -- # Deskriptoren architektonisch
    geschosszahl smallint,  
    achsenzahl smallint,  
    grundriss text,
    return_dachform text,   
    dachform_alt text,
    
    -- # Deskriptoren technische Anlage
    antrieb text,   
    abmessung text, 
    gewicht text   

);
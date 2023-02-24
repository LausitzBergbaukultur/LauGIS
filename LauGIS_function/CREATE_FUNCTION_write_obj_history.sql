-- legt einen history eintrag für ein zu änderndes objekt an

CREATE OR REPLACE FUNCTION laugis.write_obj_history(
  -- # Metadaten
  _objekt_nr integer,  
  _rel_objekt_nr integer,
  _status_bearbeitung smallint, 
  _erfassungsdatum date,
  _aenderungsdatum date, 
  _return_erfasser text,

  -- # Deskriptoren
  _kategorie smallint,  
  _sachbegriff integer, 
  _sachbegriff_alt text, 
  _beschreibung text,  
  _beschreibung_ergaenzung text, 
  _lagebeschreibung text, 
  _return_literatur text,
  _notiz_intern text,   
  _hida_nr text,
  _return_datierung text,
  _return_nutzung text,
  _return_personen text,
  _return_bilder text,
  _bilder_anmerkung text,   

  -- # Stammdaten
  _bezeichnung text, 
  _bauwerksname_eigenname text, 
  _schutzstatus smallint,
  _foerderfaehig bool, 
    
  -- # Lokalisatoren
  _kreis text, 
  _gemeinde text,  
  _ort text,  
  _sorbisch text, 
  _strasse text,  
  _hausnummer text,  
  _gem_flur text,
  _return_blickbeziehung text,

  -- # Deskriptoren allgemein
  _techn_anlage bool,    
  _return_material text,
  _material_alt text,
  _return_konstruktion text,
  _konstruktion_alt text,

  -- # Deskriptoren architektonisch
  _geschosszahl smallint,  
  _achsenzahl smallint,  
  _grundriss text,
  _return_dachform text,   
  _dachform_alt text,
    
  -- # Deskriptoren technische Anlage
  _antrieb text,   
  _abmessung text, 
  _gewicht text  
  ) 
RETURNS INTEGER AS $$

DECLARE
  _ob_id integer;
BEGIN

---------------------------------------------------------------------------------------------------------------
-- Handle obj_history entries - hist objects are always append only!
---------------------------------------------------------------------------------------------------------------
  
  INSERT INTO laugis.obj_hist(
      objekt_nr,
      rel_objekt_nr,
      status_bearbeitung,
      erfassungsdatum,
      aenderungsdatum,
      letzte_aenderung,
      geloescht,
      return_erfasser,
      -- # Deskriptoren
      kategorie,
      sachbegriff,
      sachbegriff_alt,
      beschreibung,
      beschreibung_ergaenzung,
      lagebeschreibung,
      notiz_intern,
      hida_nr,
      return_datierung,
      return_nutzung,
      return_personen,
      return_bilder,
      bilder_anmerkung,
      -- # Stammdaten
      bezeichnung,
      bauwerksname_eigenname,
      schutzstatus,
      foerderfaehig,
      -- # Lokalisatoren
      kreis,
      gemeinde,
      ort,
      sorbisch,
      strasse,
      hausnummer,
      gem_flur,
      return_blickbeziehung,
      -- # Deskriptoren allgemein
      techn_anlage,    
      return_material,
      material_alt,
      return_konstruktion,
      konstruktion_alt,
      -- # Deskriptoren architektonisch
      geschosszahl,  
      achsenzahl,  
      grundriss,
      return_dachform,   
      dachform_alt,
      -- # Deskriptoren technische Anlage
      antrieb,   
      abmessung, 
      gewicht)
    VALUES (
      _objekt_nr,
      _rel_objekt_nr,
      _status_bearbeitung,
      _erfassungsdatum,
      _aenderungsdatum,
      NOW(),
      FALSE,
      _return_erfasser,
      -- # Deskriptoren
      _kategorie,
      _sachbegriff,
      _sachbegriff_alt,
      _beschreibung,
      _beschreibung_ergaenzung,
      _lagebeschreibung,
      _notiz_intern,
      _hida_nr,
      _return_datierung,
      _return_nutzung,
      _return_personen,
      _return_bilder,
      _bilder_anmerkung,
      -- # Stammdaten
      _bezeichnung,
      _bauwerksname_eigenname,
      _schutzstatus,
      _foerderfaehig,
      -- # Lokalisatoren
      _kreis,
      _gemeinde,
      _ort,
      _sorbisch,
      _strasse,
      _hausnummer,
      _gem_flur,
      _return_blickbeziehung,
      -- # Deskriptoren allgemein
      _techn_anlage,    
      _return_material,
      _material_alt,
      _return_konstruktion,
      _konstruktion_alt,
      -- # Deskriptoren architektonisch
      _geschosszahl,  
      _achsenzahl,  
      _grundriss,
      _return_dachform,   
      _dachform_alt,
      -- # Deskriptoren technische Anlage
      _antrieb,   
      _abmessung, 
      _gewicht)
    RETURNING obj_hist.hist_id INTO _ob_id;

-- return (inserted) history id
RETURN _ob_id;

END;
$$ LANGUAGE plpgsql;
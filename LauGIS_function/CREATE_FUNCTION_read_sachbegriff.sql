-- Gibt für ein Objekt den formatierten Sachbegriff bzw. den definierten Freitext zurück (read only)

CREATE OR REPLACE FUNCTION laugis.read_sachbegriff(
  _objekt_id integer              -- pk
  ) 
RETURNS text AS $$

DECLARE
  _ar text;
  _sachbegriff integer;
BEGIN

-- select sachbegriff id to local variable
SELECT ob.sachbegriff
    FROM laugis.obj_basis AS ob
    WHERE ob.objekt_id = _objekt_id
INTO _sachbegriff; 

-- wenn Sachbegriff = Freitext, dann sachbegriff_alt übergeben
IF (_sachbegriff = 9999) THEN
    SELECT ob.sachbegriff_alt
        FROM laugis.obj_basis AS ob
        WHERE ob.objekt_id = _objekt_id
    INTO _ar;

-- wenn bekannter Sachebegriff, wird dieser formatiert und übergeben
ELSE
    SELECT 'Kat. ' || sachb.kategorie || ' - ' || COALESCE(sachb.sachbegriff_ueber || ' > ', '') || sachb.sachbegriff AS sachbegriff
        FROM lauqgis.sachbegriffe AS sachb
        WHERE sachb.id = _sachbegriff
    INTO _ar;
END IF;

RETURN _ar;

END;
$$ LANGUAGE plpgsql;
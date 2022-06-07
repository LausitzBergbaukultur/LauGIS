-- Setzt das Flag 'geloescht' auf true

CREATE OR REPLACE FUNCTION laugis.delete_lwk(_objekt_id integer)
RETURNS VOID
AS $$
BEGIN
  UPDATE laugis.obj_lwk
  SET geloescht = TRUE
  WHERE objekt_id = _objekt_id;
END;
$$ LANGUAGE plpgsql;
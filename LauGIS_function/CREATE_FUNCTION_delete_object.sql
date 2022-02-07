-- Setzt das Flag 'geloescht' auf true

CREATE OR REPLACE FUNCTION development.delete_objekt(_objekt_id integer)
RETURNS VOID
AS $$
BEGIN
  UPDATE development.obj_basis
  SET geloescht = TRUE
  WHERE objekt_id = _objekt_id;
END;
$$ LANGUAGE plpgsql;
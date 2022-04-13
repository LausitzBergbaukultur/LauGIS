-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_datierung(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_datierung
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;
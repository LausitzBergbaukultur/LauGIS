-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_material(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM laugis.rel_material
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;
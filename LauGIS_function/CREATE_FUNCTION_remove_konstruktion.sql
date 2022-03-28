-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION development.remove_konstruktion(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM development.rel_konstruktion
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;
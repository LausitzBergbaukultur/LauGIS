-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION development.remove_nutzung(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  DELETE FROM development.rel_nutzung
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;
-- löscht einen Relations-Eintrag

CREATE OR REPLACE FUNCTION laugis.remove_dachform(_rel_id integer)
RETURNS VOID
AS $$

BEGIN
  UPDATE laugis.rel_dachform
  SET geloescht = TRUE, geloescht_am = NOW()
  WHERE relation_id = _rel_id;
END;
$$ LANGUAGE plpgsql;
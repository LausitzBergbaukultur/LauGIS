-- insert/update obj_arch returning new id

CREATE OR REPLACE FUNCTION development.update_obj_anlage(
    _ref_objekt_id integer,          -- fk NOT NULL
    -- # Deskriptoren
    _antrieb text,
    _abmessung text,             
    _gewicht text,
    _material_alt text,
    _konstruktion_alt text
    ) 
RETURNS INTEGER AS $$

DECLARE 
  _ob_id integer;
  _anl_id integer;
BEGIN

---------------------------------------------------------------------------------------------------------------
-- Identify existing entries. No result -> NULL
---------------------------------------------------------------------------------------------------------------

    SELECT anlage_id 
    INTO _anl_id
    FROM development.obj_anlage
    WHERE ref_objekt_id = _ref_objekt_id
    FETCH FIRST 1 ROWS ONLY;

---------------------------------------------------------------------------------------------------------------
-- Handle obj_anlage entries
---------------------------------------------------------------------------------------------------------------

    IF (_anl_id IS NULL) THEN
        INSERT INTO development.obj_anlage(
            ref_objekt_id,
            antrieb,
            abmessung,
            gewicht,
            material_alt,
            konstruktion_alt
            )
        VALUES (
            _ref_objekt_id,
            _antrieb,
            _abmessung,
            _gewicht,
            _material_alt,
            _konstruktion_alt
            )
            RETURNING anlage_id INTO _anl_id;
    ELSE
        UPDATE development.obj_anlage
        SET
            antrieb = _antrieb,
            abmessung = _abmessung,
            gewicht = _gewicht,
            material_alt = _material_alt,
            konstruktion_alt = _konstruktion_alt
        WHERE anlage_id = _anl_id;
    END IF;

    RETURN _anl_id;

END;
$$ LANGUAGE plpgsql;
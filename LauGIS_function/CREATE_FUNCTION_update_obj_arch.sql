-- insert/update obj_arch returning new id

CREATE OR REPLACE FUNCTION development.update_obj_arch(
    _ref_objekt_id integer,          -- fk NOT NULL
    -- # Deskriptoren
    _geschosszahl smallint,          -- 5390
    _achsenzahl smallint,             -- 5392
    _grundriss text,
    _dachform_alt text,
    _material_alt text,
    _konstruktion_alt text
    ) 
RETURNS INTEGER AS $$

DECLARE 
  _ob_id integer;
  _arch_id integer;
BEGIN

---------------------------------------------------------------------------------------------------------------
-- Identify existing entries. No result -> NULL
---------------------------------------------------------------------------------------------------------------

    SELECT architektur_id 
    INTO _arch_id
    FROM development.obj_arch
    WHERE ref_objekt_id = _ref_objekt_id
    FETCH FIRST 1 ROWS ONLY;

---------------------------------------------------------------------------------------------------------------
-- Handle obj_arch entries
---------------------------------------------------------------------------------------------------------------

    IF (_arch_id IS NULL) THEN
        INSERT INTO development.obj_arch(
            ref_objekt_id,
            geschosszahl,
            achsenzahl,
            grundriss,
            dachform_alt,
            material_alt,
            konstruktion_alt
            )
        VALUES (
            _ref_objekt_id,
            _geschosszahl,
            _achsenzahl,
            _grundriss,
            _dachform_alt,
            _material_alt,
            _konstruktion_alt
            )
            RETURNING architektur_id INTO _arch_id;
    ELSE
        UPDATE development.obj_arch
        SET
            geschosszahl = _geschosszahl,
            achsenzahl = _achsenzahl,
            grundriss = _grundriss,
            dachform_alt = _dachform_alt,
            material_alt = _material_alt,
            konstruktion_alt = _konstruktion_alt
        WHERE architektur_id = _arch_id;
    END IF;

    RETURN _arch_id;

END;
$$ LANGUAGE plpgsql;
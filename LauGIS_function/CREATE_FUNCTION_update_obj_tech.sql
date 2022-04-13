-- insert/update obj_tech returning new id

CREATE OR REPLACE FUNCTION laugis.update_obj_tech(
    _ref_objekt_id integer,          -- fk NOT NULL
    _techn_anlage bool,
    -- # Deskriptoren allg
    _material_alt text,
    _konstruktion_alt text,
    -- # Deskriptoren arch
    _geschosszahl smallint,          -- 5390
    _achsenzahl smallint,             -- 5392
    _grundriss text,
    _dachform_alt text,
    -- # Deskriptoren tech
    _antrieb text,
    _abmessung text,             
    _gewicht text
    ) 
RETURNS INTEGER AS $$

DECLARE 
  _ob_id integer;
  _tech_id integer;
BEGIN

---------------------------------------------------------------------------------------------------------------
-- Identify existing entries. No result -> NULL
---------------------------------------------------------------------------------------------------------------

    SELECT tech_id 
    INTO _tech_id
    FROM laugis.obj_tech
    WHERE ref_objekt_id = _ref_objekt_id
    FETCH FIRST 1 ROWS ONLY;

---------------------------------------------------------------------------------------------------------------
-- Handle obj_arch entries
---------------------------------------------------------------------------------------------------------------

    IF (_tech_id IS NULL) THEN
        INSERT INTO laugis.obj_tech(
            ref_objekt_id,
            techn_anlage,
            material_alt,
            konstruktion_alt,
            geschosszahl,
            achsenzahl,
            grundriss,
            dachform_alt,
            antrieb,
            abmessung,             
            gewicht
            )
        VALUES (
            _ref_objekt_id,
            _techn_anlage,
            _material_alt,
            _konstruktion_alt,
            _geschosszahl,
            _achsenzahl,
            _grundriss,
            _dachform_alt,
            _antrieb,
            _abmessung,             
            _gewicht
            )
            RETURNING tech_id INTO _tech_id;
    ELSE
        UPDATE laugis.obj_tech
        SET
            techn_anlage = _techn_anlage,
            material_alt = _material_alt,
            konstruktion_alt = _konstruktion_alt,
            geschosszahl = _geschosszahl,
            achsenzahl = _achsenzahl,
            grundriss = _grundriss,
            dachform_alt = _dachform_alt,
            antrieb= _antrieb,
            abmessung = _abmessung,             
            gewicht = _gewicht
        WHERE tech_id = _tech_id;
    END IF;

    RETURN _tech_id;

END;
$$ LANGUAGE plpgsql;
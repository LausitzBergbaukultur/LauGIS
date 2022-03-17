-- insert/update obj_stamm returning new id

CREATE OR REPLACE FUNCTION development.update_obj_stamm(
    _ref_objekt_id integer,          -- fk NOT NULL
    -- # Stammdaten
    _bezeichnung text,               -- 9990
    _bauwerksname_eigenname text,    -- 5202
    _erhaltungszustand smallint,     -- fk 5210
    _schutzstatus smallint,          -- fk
    _foerderfaehig bool, 
    
    -- # Lokalisatoren
    _kreis text,                     -- 5098
    _gemeinde text,                  -- 5100
    _ort text,                       -- 5108
    _sorbisch text,                  -- 5115
    _strasse text,                   -- 5116
    _hausnummer text,                -- 5117
    _gem_flur text                   -- 5120
    ) 
RETURNS INTEGER AS $$

DECLARE 
  _ob_id integer;
  _stamm_id integer;
BEGIN

---------------------------------------------------------------------------------------------------------------
-- Identify existing entries. No result -> NULL
---------------------------------------------------------------------------------------------------------------

    SELECT stammdaten_id 
    INTO _stamm_id
    FROM development.obj_stamm
    WHERE ref_objekt_id = _ref_objekt_id
    FETCH FIRST 1 ROWS ONLY;

---------------------------------------------------------------------------------------------------------------
-- Handle obj_stamm entries
---------------------------------------------------------------------------------------------------------------

    IF (_stamm_id IS NULL) THEN
        INSERT INTO development.obj_stamm(
            ref_objekt_id,
            bezeichnung,
            bauwerksname_eigenname,
            erhaltungszustand,
            schutzstatus,
            foerderfaehig,
            kreis,
            gemeinde,
            ort,
            sorbisch,
            strasse,
            hausnummer,
            gem_flur)
        VALUES (
            _ref_objekt_id,
            _bezeichnung,
            _bauwerksname_eigenname,
            _erhaltungszustand,
            _schutzstatus,
            _foerderfaehig,
            _kreis,
            _gemeinde,
            _ort,
            _sorbisch,
            _strasse,
            _hausnummer,
            _gem_flur)
            RETURNING stammdaten_id INTO _stamm_id;
    ELSE
        UPDATE development.obj_stamm
        SET
            bezeichnung = _bezeichnung,
            bauwerksname_eigenname = _bauwerksname_eigenname,
            erhaltungszustand = _erhaltungszustand,
            schutzstatus = _schutzstatus,
            foerderfaehig = _foerderfaehig,
            kreis = _kreis,
            gemeinde = _gemeinde,
            ort = _ort,
            sorbisch = _sorbisch,
            strasse = _strasse,
            hausnummer = _hausnummer,
            gem_flur = _gem_flur
        WHERE stammdaten_id = _stamm_id;
    END IF;

    RETURN _stamm_id;

END;
$$ LANGUAGE plpgsql;
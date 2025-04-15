-- Table for habitattype
-- there is one table for all working groups 
-- This mostly only imports some of the codes from the WLTYP vocab


DROP TABLE IF EXISTS ref.tr_habitattype_hty CASCADE;
CREATE TABLE ref.tr_habitattype_hty (
  hty_id SERIAL PRIMARY KEY,
  hty_code TEXT NOT NULL UNIQUE,
  hty_description TEXT,
  hty_icesvalue character varying(4),  
  hty_icesguid uuid,
  hty_icestablesource text
);

COMMENT ON TABLE ref.tr_habitattype_hty IS 'Table of habitat types, takes from the WLTYP vocab';
COMMENT ON COLUMN ref.tr_habitattype_hty.hty_id IS 'Integer, primary key of the table';
COMMENT ON COLUMN ref.tr_habitattype_hty.hty_code IS 'The code of the habitat';
COMMENT ON COLUMN ref.tr_habitattype_hty.hty_description IS 'Definition of the lifestage';
COMMENT ON COLUMN ref.tr_habitattype_hty.hty_icesvalue IS 'Code for the lifestage in the ICES database';
COMMENT ON COLUMN ref.tr_habitattype_hty.hty_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_habitattype_hty.hty_icestablesource IS 'Source table in ICES vocab';


GRANT ALL ON ref.tr_habitattype_hty TO diaspara_admin;
GRANT SELECT ON ref.tr_habitattype_hty TO diaspara_read;


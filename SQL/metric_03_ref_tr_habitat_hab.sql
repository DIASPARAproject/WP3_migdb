-- this is a new referential

DROP TABLE IF EXISTS ref.tr_habitat_hab;
CREATE TABLE ref.tr_habitat_hab (
hab_code TEXT PRIMARY KEY,
hab_description TEXT,
hab_definition TEXT,
hab_icesvalue character varying(4),  
hab_icesguid uuid,
hab_icestablesource text);

ALTER TABLE ref.tr_habitat_hab OWNER TO diaspara_admin;
GRANT SELECT ON ref.tr_habitat_hab  TO diaspara_read;


COMMENT ON TABLE ref.tr_habitat_hab IS
 'Table of habitats from EIONET Habitats directive Art. 17 reporting in year 2018.';
COMMENT ON COLUMN ref.tr_habitat_hab.hab_code IS
 'Code for habitat';
COMMENT ON COLUMN ref.tr_habitat_hab.hab_description IS
 'Description of the habitat';
COMMENT ON COLUMN ref.tr_habitat_hab.hab_definition IS
 'Definition of the habitat';
COMMENT ON COLUMN ref.tr_habitat_hab.hab_icesvalue IS 
'Code for the habitat in the ICES database';
COMMENT ON COLUMN ref.tr_habitat_hab.hab_icesguid IS 
'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_habitat_hab.hab_icestablesource IS 
'Source table in ICES vocab';
-- Table for lifestage
-- there is one table for all working groups 
-- so this table is not inherited (otherwise two wkg could create referential for the same species)

DROP TABLE IF EXISTS ref.tr_lifestage_lfs CASCADE;
CREATE TABLE ref.tr_lifestage_lfs (
  lfs_id SERIAL PRIMARY KEY,
  lfs_code TEXT NOT NULL,
  lfs_name TEXT NOT NULL,
  lfs_spe_code character varying(3) NOT  NULL,    
  lfs_description TEXT,
  lfs_icesvalue character varying(4),  
  lfs_icesguid uuid,
  lfs_icestablesource text,
CONSTRAINT fk_lfs_spe_code FOREIGN KEY (lfs_spe_code)
  REFERENCES ref.tr_species_spe(spe_code) 
  ON DELETE CASCADE
  ON UPDATE CASCADE,
CONSTRAINT uk_lfs UNIQUE (lfs_code, lfs_spe_code)
);

COMMENT ON TABLE ref.tr_lifestage_lfs IS 'Table of lifestages';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_id IS 'Integer, primary key of the table';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_code IS 'The code of lifestage';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_name IS 'The english name of lifestage';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_spe_code IS 'The code of the species referenced from
tr_species_spe : one of SAL, ELE, TRT, ALA, ALF, SLP, RLP ';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_description IS 'Definition of the lifestage';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_icesvalue IS 'Code for the lifestage in the ICES database';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_lifestage_lfs.lfs_icestablesource IS 'Source table in ICES vocab';


GRANT ALL ON ref.tr_lifestage_lfs TO diaspara_admin;
GRANT SELECT ON ref.tr_lifestage_lfs TO diaspara_read;



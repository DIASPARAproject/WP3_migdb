-- DROP TABLE ref.tr_traitmethod_trm;

CREATE TABLE ref.tr_traitmethod_trm (
  trm_id integer PRIMARY KEY,
  trm_code text NOT NULL,
  trm_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_trm_wkg_code  FOREIGN KEY (trm_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  trm_spe_code TEXT NOT NULL,  
  CONSTRAINT fk_trm_spe_code  FOREIGN KEY (trm_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  trm_description text NULL,
  trm_definition text,
  trm_icesvalue character varying(4),  
  trm_icesguid uuid,
  trm_icestablesource text,
  CONSTRAINT uk_trm_code UNIQUE (trm_code)
);


COMMENT ON TABLE ref.tr_traitmethod_trm IS 'Table of method used to obtain a trait metric';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_id IS 'Integer, id of the method used';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_code IS 'Name of the method used';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_wkg_code IS 'Working group code';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_spe_code IS 'Species code';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_description IS 'Description of the method';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_definition IS 'Definition of the method used to obtain the metric';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_icestablesource IS 'Source table in ICES vocab';


GRANT ALL ON ref.tr_traitmethod_trm TO diaspara_admin;
GRANT SELECT ON ref.tr_traitmethod_trm TO diaspara_read; 


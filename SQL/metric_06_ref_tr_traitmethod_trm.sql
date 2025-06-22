-- DROP TABLE ref.tr_traitmethod_trm;

CREATE TABLE ref.tr_traitmethod_trm (
  mth_id integer PRIMARY KEY,
  mth_code text NOT NULL,
  mth_description text NULL,
  mth_definition text,
  mth_icesvalue character varying(4),  
  mth_icesguid uuid,
  mth_icestablesource text,
  CONSTRAINT uk_trm_code UNIQUE (mth_code)
);

COMMENT ON TABLE ref.tr_traitmethod_trm.trm_id IS 'Table of method used to obtain a trait metric';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_id IS 'Integer, id of the method used';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_code IS 'Name of the method used';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_description IS 'Description of the method';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_definition IS 'Definition of the method used to obtain the metric';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_icestablesource IS 'Source table in ICES vocab';



GRANT ALL ON ref.tr_traitmethod_trm TO diaspara_admin;
GRANT SELECT ON ref.tr_traitmethod_trm TO diaspara_read; 


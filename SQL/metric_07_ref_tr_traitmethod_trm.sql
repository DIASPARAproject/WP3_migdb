-- DROP TABLE "ref".tr_traitmethod_trm;

CREATE TABLE ref.tr_traitmethod_trm (
  trm_id integer PRIMARY KEY,
  trm_code text NOT NULL,
  trm_description text NULL,
  trm_definition text,
  trm_icesvalue character varying(4),  
  trm_icesguid uuid,
  trm_icestablesource text,
  CONSTRAINT uk_trm_code UNIQUE (trm_code)
);


COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_id IS 'Integer, id of the method used';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_code IS 'Name of the method used';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_description IS 'Description of the method';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_definition IS 'Definition of the method used to obtain the metric';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_icestablesource IS 'Source table in ICES vocab';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_individualname IS 'Name of the metric used in individual metrics';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_groupname IS 'Name of the metric used in group metrics';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_type IS 'Type of trait or metric : biology, migration or quality';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_uni_code IS 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_group IS 'Is the metric a group metric, or individual metric or can be used in both tables ?';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_min IS 'Minimum allowed value';
COMMENT ON COLUMN ref.tr_traitmethod_trm.trm_max IS 'Maximum allowed value';


GRANT ALL ON ref.tr_traitmethod_trm TO diaspara_admin;
GRANT SELECT ON ref.tr_traitmethod_trm TO diaspara_read; 


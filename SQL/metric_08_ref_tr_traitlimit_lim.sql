-- DROP TABLE "ref".tr_method_mth;

CREATE TABLE ref.tr_method_mth (
  mth_id integer PRIMARY KEY,
  mth_code text NOT NULL,
  mth_description text NULL,
  mth_definition text,
  mth_icesvalue character varying(4),  
  mth_icesguid uuid,
  mth_icestablesource text,
  CONSTRAINT uk_mth_code UNIQUE (mth_code)
);


COMMENT ON COLUMN ref.tr_method_mth.tra_id IS 'Integer, id of the method used';
COMMENT ON COLUMN ref.tr_method_mth.tra_code IS 'Name of the method used';
COMMENT ON COLUMN ref.tr_method_mth.tra_description IS 'Description of the method';
COMMENT ON COLUMN ref.tr_method_mth.tra_definition IS 'Definition of the method used to obtain the metric';
COMMENT ON COLUMN ref.tr_habitat_hab.hab_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_habitat_hab.hab_icestablesource IS 'Source table in ICES vocab';
COMMENT ON COLUMN ref.tr_method_mth.tra_individualname IS 'Name of the metric used in individual metrics';
COMMENT ON COLUMN ref.tr_method_mth.tra_groupname IS 'Name of the metric used in group metrics';
COMMENT ON COLUMN ref.tr_method_mth.tra_type IS 'Type of trait or metric : biology, migration or quality';
COMMENT ON COLUMN ref.tr_method_mth.tra_uni_code IS 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN ref.tr_method_mth.tra_group IS 'Is the metric a group metric, or individual metric or can be used in both tables ?';
COMMENT ON COLUMN ref.tr_method_mth.tra_min IS 'Minimum allowed value';
COMMENT ON COLUMN ref.tr_method_mth.tra_max IS 'Maximum allowed value';


GRANT ALL ON ref.tr_method_mth TO diaspara_admin;
GRANT SELECT ON ref.tr_method_mth TO diaspara_read; 


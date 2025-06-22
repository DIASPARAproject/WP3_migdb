-- DROP TABLE "ref".tr_tr_traitqualitative_trq;

CREATE TABLE ref.tr_tr_traitqualitative_trq 
  trq_id integer PRIMARY KEY,
  trq_code text NOT NULL,
  trq_description text NULL,
  trq_definition text,
  trq_icesvalue character varying(4),  
  trq_icesguid uuid,
  trq_icestablesource text,
  CONSTRAINT uk_trm_code UNIQUE (trq_code)
);


COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_id IS 'Integer, id of the qualitative used';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_code IS 'Name of the method used';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_description IS 'Description of the method';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_definition IS 'Definition of the method used to obtain the metric';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_icestablesource IS 'Source table in ICES vocab';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_individualname IS 'Name of the metric used in individual metrics';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_groupname IS 'Name of the metric used in group metrics';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_type IS 'Type of trait or metric : biology, migration or quality';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_uni_code IS 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_group IS 'Is the metric a group metric, or individual metric or can be used in both tables ?';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_min IS 'Minimum allowed value';
COMMENT ON COLUMN ref.tr_tr_traitqualitative_trq.trq_max IS 'Maximum allowed value';


GRANT ALL ON ref.tr_tr_traitqualitative_trq TO diaspara_admin;
GRANT SELECT ON ref.tr_tr_traitqualitative_trq TO diaspara_read; 
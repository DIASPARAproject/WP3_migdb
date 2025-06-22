-- DROP TABLE "ref".tr_trait_tra;

CREATE TABLE ref.tr_trait_tra (
  tra_id integer PRIMARY KEY,
  tra_code text NOT NULL,
  tra_description text NULL,
  tra_definition text,
  tra_icesvalue character varying(4),  
  tra_icesguid uuid,
  tra_icestablesource text,
  tra_individualname text NULL,
  tra_groupname text NULL,
  tra_type text NULL,
  tra_uni_code varchar(20) NULL,
  tra_group text NULL,
  CONSTRAINT ck_tra_group CHECK (((tra_group = 'individual'::text) OR (tra_group = 'group'::text) OR (tra_group = 'both'::text))),
  CONSTRAINT ck_tra_type CHECK (((tra_type = 'quality'::text) OR (tra_type = 'biometry'::text) OR (tra_type = 'migration'::text))),
  CONSTRAINT uk_tra_individual_name UNIQUE (tra_individualname),
  CONSTRAINT uk_tra_individual_name UNIQUE (tra_individualname),
  CONSTRAINT uk_tra_code UNIQUE (tra_code),
  CONSTRAINT fk_tra_uni_code FOREIGN KEY (tra_uni_code) 
  REFERENCES ref.tr_units_uni(uni_code) 
  ON UPDATE CASCADE ON DELETE CASCADE
);


COMMENT ON COLUMN ref.tr_trait_tra.tra_id IS 'Integer, id of the trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_code IS 'Name of the trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_description IS 'Description of the fish trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_definition IS 'Definition of the method used to obtain the metric';
COMMENT ON COLUMN ref.tr_trait_tra.tra_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_trait_tra.tra_icestablesource IS 'Source table in ICES vocab';
COMMENT ON COLUMN ref.tr_trait_tra.tra_individualname IS 'Name of the metric used in individual metrics';
COMMENT ON COLUMN ref.tr_trait_tra.tra_groupname IS 'Name of the metric used in group metrics';
COMMENT ON COLUMN ref.tr_trait_tra.tra_type IS 'Type of trait or metric : biology, migration or quality';
COMMENT ON COLUMN ref.tr_trait_tra.tra_uni_code IS 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN ref.tr_trait_tra.tra_group IS 'Is the metric a group metric, or individual metric or can be used in both tables ?';



GRANT ALL ON ref.tr_trait_tra TO diaspara_admin;
GRANT SELECT ON ref.tr_trait_tra TO diaspara_read; 


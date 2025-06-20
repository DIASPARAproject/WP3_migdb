-- DROP TABLE "ref".tr_trait_tra;

CREATE TABLE ref.tr_trait_tra (
  tra_id serial4 NOT NULL,
  tra_name text NULL,
  tra_individual_name text NULL,
  tra_description text NULL,
  tra_type text NULL,
  tra_method text NULL,
  tra_uni_code varchar(20) NULL,
  tra_group text NULL,
  tra_min numeric NULL,
  tra_max numeric NULL,
  CONSTRAINT ck_tra_group CHECK (((tra_group = 'individual'::text) OR (tra_group = 'group'::text) OR (tra_group = 'both'::text))),
  CONSTRAINT ck_tra_type CHECK (((tra_type = 'quality'::text) OR (tra_type = 'biometry'::text) OR (tra_type = 'migration'::text))),
  CONSTRAINT uk_tra_individual_name UNIQUE (tra_individual_name),
  CONSTRAINT tr_trait_tra_pkey PRIMARY KEY (tra_id),
  CONSTRAINT fk_uni_code FOREIGN KEY (tra_uni_code) 
  REFERENCES ref.tr_units_uni(uni_code) 
  ON UPDATE CASCADE ON DELETE CASCADE
);


COMMENT ON COLUMN ref.tr_trait_tra.tra_id IS 'Id of metric type';
COMMENT ON COLUMN ref.tr_trait_tra.tra_name IS 'Name of the metric';
COMMENT ON COLUMN ref.tr_trait_tra.tra_individual_name IS 'Alternative name for the metric';
COMMENT ON COLUMN ref.tr_trait_tra.tra_description IS 'Definition of metric type';
COMMENT ON COLUMN ref.tr_trait_tra.tra_type IS 'Type of metric : biology, migration or quality';
COMMENT ON COLUMN ref.tr_trait_tra.tra_method IS 'Method used to obtain metrics, note that for anguillicola prevalence or female proportion, the method has been included as a metric type, so the database requires both the metric and a metric on the method used.';
COMMENT ON COLUMN ref.tr_trait_tra.tra_uni_code IS 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN ref.tr_trait_tra.tra_group IS 'Is the metric a group metric, or individual metric or can be used in both tables ?';
COMMENT ON COLUMN ref.tr_trait_tra.tra_min IS 'Minimum allowed value';
COMMENT ON COLUMN ref.tr_trait_tra.tra_max IS 'Maximum allowed value';


GRANT ALL ON ref.tr_trait_tra TO diaspara_admin;
GRANT SELECT ON ref.tr_trait_tra TO diaspara_read; 

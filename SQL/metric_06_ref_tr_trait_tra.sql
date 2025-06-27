-- DROP TABLE ref.tr_trait_tra CASCADE;

CREATE TABLE ref.tr_trait_tra (
  tra_id integer PRIMARY KEY,
  tra_code text NOT NULL,
  tra_description text NULL, 
  tra_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_tra_wkg_code  FOREIGN KEY (tra_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  tra_spe_code TEXT NOT NULL,  
  CONSTRAINT fk_tra_spe_code  FOREIGN KEY (tra_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  tra_icestablesource text,
  tra_typemetric text NULL,
  CONSTRAINT ck_tra_typemetric CHECK (((tra_typemetric = 'Individual'::text) 
  OR (tra_typemetric = 'Group'::text) 
  OR (tra_typemetric = 'Both'::text))),
  tra_qualitativeornumeric TEXT,
  CONSTRAINT ck_tra_qualitativeornumeric CHECK ((tra_qualitativeornumeric = 'Qualitative'::text) 
  OR (tra_qualitativeornumeric = 'Numeric'::text)),
  CONSTRAINT uk_tra_code UNIQUE (tra_code)
);


COMMENT ON COLUMN ref.tr_trait_tra.tra_id IS 'Integer, id of the trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_code IS 'Name of the trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_description IS 'Description of the fish trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_definition IS 'Definition of the method used to obtain the metric';
COMMENT ON COLUMN ref.tr_trait_tra.tra_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_trait_tra.tra_icestablesource IS 'Source table in ICES vocab';
COMMENT ON COLUMN ref.tr_trait_tra.tra_typemetric IS 'Is the metric a group metric (group), or individual metric (individual) or can be used in both tables (both) ?';
COMMENT ON COLUMN ref.tr_trait_tra.tra_qualitativeornumeric IS 'Indicate variable type, either Qualitative or Numeric';



GRANT ALL ON ref.tr_trait_tra TO diaspara_admin;
GRANT SELECT ON ref.tr_trait_tra TO diaspara_read; 

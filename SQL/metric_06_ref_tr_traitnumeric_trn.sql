
CREATE TABLE ref.tr_traitnumeric_trn(  
trn_minvalue NUMERIC,
trn_maxvalue NUMERIC,
  CONSTRAINT fk_tra_wkg_code  FOREIGN KEY (tra_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_tra_spe_code  FOREIGN KEY (tra_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_tra_typemetric CHECK (((tra_typemetric = 'individual'::text) OR
  (tra_typemetric = 'group'::text) OR
  (tra_typemetric = 'both'::text))),
  CONSTRAINT uk_tra_individualname UNIQUE (tra_individualname),
  CONSTRAINT uk_tra_groupname UNIQUE (tra_groupname),
  CONSTRAINT uk_tra_code UNIQUE (tra_code),
  CONSTRAINT fk_tra_uni_code FOREIGN KEY (tra_uni_code) 
  REFERENCES ref.tr_units_uni(uni_code)   ON UPDATE CASCADE ON DELETE CASCADE
) INHERITS  (ref.tr_trait_tra);

COMMENT ON COLUMN ref.tr_trait_tra.tra_id IS 'Integer, id of the trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_code IS 'Name of the trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_description IS 'Description of the fish trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_definition IS 'Definition of the method used to obtain the metric';
COMMENT ON COLUMN ref.tr_trait_tra.tra_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_trait_tra.tra_icestablesource IS 'Source table in ICES vocab';
COMMENT ON COLUMN ref.tr_trait_tra.tra_individualname IS 'Name of the metric used in individual metrics';
COMMENT ON COLUMN ref.tr_trait_tra.tra_groupname IS 'Name of the metric used in group metrics';
COMMENT ON COLUMN ref.tr_trait_tra.tra_uni_code IS 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN ref.tr_trait_tra.tra_typemetric IS 'Is the metric a group metric (group), or individual metric (individual) or can be used in both tables (both) ?';
COMMENT ON COLUMN ref.tr_trait_tra.trn_min IS 'Minimum allowed value';
COMMENT ON COLUMN ref.tr_trait_tra.trn_max IS 'Maximum allowed value';


GRANT ALL ON ref.tr_trait_tra TO diaspara_admin;
GRANT SELECT ON ref.tr_trait_tra TO diaspara_read; 

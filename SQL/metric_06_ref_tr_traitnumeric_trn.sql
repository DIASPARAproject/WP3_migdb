-- DROP TABLE IF EXISTS ref.tr_traitnumeric_trn;
CREATE TABLE ref.tr_traitnumeric_trn(  
trn_uni_code varchar(20) NULL,
trn_minvalue NUMERIC,
trn_maxvalue NUMERIC,
  CONSTRAINT fk_tra_wkg_code  FOREIGN KEY (tra_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_tra_spe_code  FOREIGN KEY (tra_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT fk_trn_uni_code FOREIGN KEY (trn_uni_code) 
  REFERENCES ref.tr_units_uni(uni_code)   ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT uk_trn_code UNIQUE (tra_code)
) INHERITS  (ref.tr_trait_tra);

COMMENT ON COLUMN ref.tr_traitnumeric_trn.tra_id IS 'Integer, id of the trait';
COMMENT ON COLUMN ref.tr_traitnumeric_trn.tra_code IS 'Name of the trait';
COMMENT ON COLUMN ref.tr_traitnumeric_trn.tra_description IS 'Description of the fish trait';
COMMENT ON COLUMN ref.tr_traitnumeric_trn.tra_typemetric IS 'Is the metric a Group metric (group), or Individual metric (individual) or can be used in both tables (both) ?';
COMMENT ON COLUMN ref.tr_traitnumeric_trn.trn_uni_code IS 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN ref.tr_traitnumeric_trn.trn_minvalue IS 'Minimum allowed value';
COMMENT ON COLUMN ref.tr_traitnumeric_trn.trn_maxvalue IS 'Maximum allowed value';


GRANT ALL ON ref.tr_traitnumeric_trn TO diaspara_admin;
GRANT SELECT ON ref.tr_traitnumeric_trn TO diaspara_read; 


DROP TABLE IF EXISTS refeel.tr_traitnumeric_trn;
CREATE TABLE refeel.tr_traitnumeric_trn(  
  CONSTRAINT uk_refeel_tra_id UNIQUE (tra_id),
  CONSTRAINT uk_refell_tra_code UNIQUE(tra_code),
  CONSTRAINT fk_tra_wkg_code  FOREIGN KEY (tra_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_tra_spe_code  FOREIGN KEY (tra_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT fk_trn_uni_code FOREIGN KEY (trn_uni_code) 
  REFERENCES ref.tr_units_uni(uni_code)  
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT uk_trn_code UNIQUE (tra_code)
) INHERITS  (ref.tr_traitnumeric_trn);

COMMENT ON COLUMN refeel.tr_traitnumeric_trn.tra_id IS 'Integer, id of the trait';
COMMENT ON COLUMN refeel.tr_traitnumeric_trn.tra_code IS 'Name of the trait';
COMMENT ON COLUMN refeel.tr_traitnumeric_trn.tra_description IS 'Description of the fish trait';
COMMENT ON COLUMN refeel.tr_traitnumeric_trn.tra_typemetric IS 'Is the metric a Group metric (group), or Individual metric (individual) or can be used in both tables (both) ?';
COMMENT ON COLUMN refeel.tr_traitnumeric_trn.trn_uni_code IS 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN refeel.tr_traitnumeric_trn.trn_minvalue IS 'Minimum allowed value';
COMMENT ON COLUMN refeel.tr_traitnumeric_trn.trn_maxvalue IS 'Maximum allowed value';


GRANT ALL ON refeel.tr_traitnumeric_trn TO diaspara_admin;
GRANT SELECT ON refeel.tr_traitnumeric_trn TO diaspara_read; 
DROP TABLE IF EXISTS refnas.tr_traitnumeric_trn;
CREATE TABLE refnas.tr_traitnumeric_trn(  
  CONSTRAINT uk_refnas_num_tra_id UNIQUE (tra_id),
  CONSTRAINT uk_refnas_tra_code UNIQUE(tra_code),
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

COMMENT ON COLUMN refnas.tr_traitnumeric_trn.tra_id IS
 'Integer, id of the trait';
COMMENT ON COLUMN refnas.tr_traitnumeric_trn.tra_code IS 
'Name of the trait';
COMMENT ON COLUMN refnas.tr_traitnumeric_trn.tra_description IS
 'Description of the fish trait';
COMMENT ON COLUMN refnas.tr_traitnumeric_trn.tra_typemetric IS
 'Is the metric a Group metric (group), or Individual metric (individual) 
or can be used in both tables (both) ?';
COMMENT ON COLUMN refnas.tr_traitnumeric_trn.trn_uni_code IS
 'Unit used, references tr_unit_uni';
COMMENT ON COLUMN refnas.tr_traitnumeric_trn.trn_minvalue IS
 'Minimum allowed value';
COMMENT ON COLUMN refnas.tr_traitnumeric_trn.trn_maxvalue IS 
'Maximum allowed value';


GRANT ALL ON refnas.tr_traitnumeric_trn TO diaspara_admin;
GRANT SELECT ON refnas.tr_traitnumeric_trn TO diaspara_read; 
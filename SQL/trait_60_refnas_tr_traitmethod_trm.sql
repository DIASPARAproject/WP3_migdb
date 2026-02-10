DROP TABLE IF EXISTS refnas.tr_traitmethod_trm;
CREATE TABLE refnas.tr_traitmethod_trm (
  CONSTRAINT uk_refnas_tm_id UNIQUE (trm_id),
  CONSTRAINT uk_refnas_tm_code UNIQUE (trm_code),
  CONSTRAINT fk_trm_wkg_code  FOREIGN KEY (trm_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_trm_spe_code  FOREIGN KEY (trm_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT uk_trm_code UNIQUE (trm_code)
) INHERITS (ref.tr_traitmethod_trm);


COMMENT ON TABLE refnas.tr_traitmethod_trm IS 
'Table of method used to obtain a trait metric';
COMMENT ON COLUMN refnas.tr_traitmethod_trm.trm_id IS 
'Integer, id of the method used';
COMMENT ON COLUMN refnas.tr_traitmethod_trm.trm_code IS 
'Name of the method used';
COMMENT ON COLUMN refnas.tr_traitmethod_trm.trm_wkg_code IS 
'Working group code';
COMMENT ON COLUMN refnas.tr_traitmethod_trm.trm_spe_code IS 
'Species code';
COMMENT ON COLUMN refnas.tr_traitmethod_trm.trm_description IS 
'Description of the method';



GRANT ALL ON refnas.tr_traitmethod_trm TO diaspara_admin;
GRANT SELECT ON refnas.tr_traitmethod_trm TO diaspara_read; 


DROP TABLE IF EXISTS refnas.tr_traitqualitative_trq;
CREATE TABLE refnas.tr_traitqualitative_trq (
  CONSTRAINT uk_refnas_qal_tra_id UNIQUE (tra_id),
  CONSTRAINT uk_refnas_qal_tra_code UNIQUE(tra_code),
  CONSTRAINT fk_tra_wkg_code  FOREIGN KEY (tra_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_tra_spe_code  FOREIGN KEY (tra_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT
  ) INHERITS (ref.tr_traitqualitative_trq);


COMMENT ON TABLE refnas.tr_traitqualitative_trq IS 
'Table of qualitative trait parameters';

GRANT ALL ON refnas.tr_traitqualitative_trq TO diaspara_admin;
GRANT SELECT ON refnas.tr_traitqualitative_trq TO diaspara_read; 



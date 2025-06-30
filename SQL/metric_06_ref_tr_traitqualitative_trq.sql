-- DROP TABLE IF EXISTS ref.tr_traitqualitative_trq CASCADE;

CREATE TABLE ref.tr_traitqualitative_trq (
  CONSTRAINT fk_tra_wkg_code  FOREIGN KEY (tra_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_tra_spe_code  FOREIGN KEY (tra_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT uk_trq_code UNIQUE (tra_code)
  ) INHERITS (ref.tr_trait_tra);


COMMENT ON TABLE ref.tr_traitqualitative_trq IS 'Table of qualitative trait parameters';

GRANT ALL ON ref.tr_traitqualitative_trq TO diaspara_admin;
GRANT SELECT ON ref.tr_traitqualitative_trq TO diaspara_read; 

DROP TABLE IF EXISTS refeel.tr_traitqualitative_trq;
CREATE TABLE refeel.tr_traitqualitative_trq (
  CONSTRAINT uk_refeel_tra_id UNIQUE (tra_id),
  CONSTRAINT uk_refeel_tra_code UNIQUE(tra_code),
  CONSTRAINT fk_tra_wkg_code  FOREIGN KEY (tra_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_tra_spe_code  FOREIGN KEY (tra_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT
  ) INHERITS (ref.tr_traitqualitative_trq);


COMMENT ON TABLE refeel.tr_traitqualitative_trq IS 'Table of qualitative trait parameters';

GRANT ALL ON refeel.tr_traitqualitative_trq TO diaspara_admin;
GRANT SELECT ON refeel.tr_traitqualitative_trq TO diaspara_read; 

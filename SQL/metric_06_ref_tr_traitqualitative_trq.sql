-- DROP TABLE IF EXISTS ref.tr_traitqualitative_trq;

CREATE TABLE ref.tr_traitqualitative_trq (
  CONSTRAINT fk_tra_wkg_code  FOREIGN KEY (tra_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_tra_spe_code  FOREIGN KEY (tra_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_tra_uni_code FOREIGN KEY (tra_uni_code) 
  REFERENCES ref.tr_units_uni(uni_code)   ON UPDATE CASCADE ON DELETE CASCADE
  ) INHERITS (ref.tr_trait_tra);


COMMENT ON TABLE ref.tr_traitqualitative_trq IS 'Table of qualitative trait parameters';

GRANT ALL ON ref.tr_traitqualitative_trq TO diaspara_admin;
GRANT SELECT ON ref.tr_traitqualitative_trq TO diaspara_read; 



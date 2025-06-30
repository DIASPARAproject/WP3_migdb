-- DROP TABLE "ref".tr_traitvaluequal_qal CASCADE;

CREATE TABLE ref.tr_traitvaluequal_qal(
  qal_id INTEGER,
  qal_trq_code TEXT NOT NULL,
  CONSTRAINT fk_qal_trq_code 
  FOREIGN KEY (qal_trq_code)
  REFERENCES ref.tr_traitqualitative_trq(tra_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  qal_code text NOT NULL,
  qal_description text NULL,
  qal_spe_code TEXT NOT NULL,
  CONSTRAINT fk_qal_spe_code  FOREIGN KEY (qal_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  qal_wkg_code TEXT NOT NULL,
  CONSTRAINT fk_qal_wkg_code  FOREIGN KEY (qal_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,  
  CONSTRAINT uk_qal_code UNIQUE (qal_code, qal_trq_code,qal_wkg_code)
);


COMMENT ON COLUMN ref.tr_traitvaluequal_qal.qal_id IS 'Integer, id of the qualitative used';
COMMENT ON COLUMN ref.tr_traitvaluequal_qal.qal_code IS 'Code of the qualitative trait';
COMMENT ON COLUMN ref.tr_traitvaluequal_qal.qal_description IS 'Description of the method';

GRANT ALL ON ref.tr_traitvaluequal_qal TO diaspara_admin;
GRANT SELECT ON ref.tr_traitvaluequal_qal TO diaspara_read; 

DROP TABLE IF EXISTS refeel.tr_traitvaluequal_qal;
CREATE TABLE refeel.tr_traitvaluequal_qal(
  CONSTRAINT uk_qal_id UNIQUE (qal_id),
  CONSTRAINT fk_qal_trq_code 
  FOREIGN KEY (qal_trq_code)
  REFERENCES refeel.tr_traitqualitative_trq(tra_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT uk_refeel_qal_code UNIQUE (qal_code, qal_trq_code)
) INHERITS (ref.tr_traitvaluequal_qal);


COMMENT ON COLUMN refeel.tr_traitvaluequal_qal.qal_id IS 'Integer, id of the qualitative used';
COMMENT ON COLUMN refeel.tr_traitvaluequal_qal.qal_code IS 'Code of the qualitative trait';
COMMENT ON COLUMN refeel.tr_traitvaluequal_qal.qal_description IS 'Description of the method';

GRANT ALL ON refeel.tr_traitvaluequal_qal TO diaspara_admin;
GRANT SELECT ON refeel.tr_traitvaluequal_qal TO diaspara_read; 
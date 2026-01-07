-- DROP TABLE IF EXISTS ref.tr_traitvaluequal_trv CASCADE;

CREATE TABLE ref.tr_traitvaluequal_trv(
  trv_id INTEGER,
  trv_trq_code TEXT NOT NULL,
  CONSTRAINT fk_trv_trq_code 
  FOREIGN KEY (trv_trq_code)
  REFERENCES ref.tr_traitqualitative_trq(tra_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  trv_code text NOT NULL ,
  trv_description text NULL,
  trv_spe_code TEXT NOT NULL,
  CONSTRAINT fk_trv_spe_code  FOREIGN KEY (trv_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  trv_wkg_code TEXT NOT NULL,
  CONSTRAINT fk_trv_wkg_code  FOREIGN KEY (trv_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,  
  CONSTRAINT uk_trv_code UNIQUE (trv_code, trv_trq_code,trv_wkg_code)
);


COMMENT ON COLUMN ref.tr_traitvaluequal_trv.trv_id IS
 'Integer, id of the qualitative used';
COMMENT ON COLUMN ref.tr_traitvaluequal_trv.trv_code IS
 'Code of the qualitative trait';
COMMENT ON COLUMN ref.tr_traitvaluequal_trv.trv_description IS
 'Description of the method';

GRANT ALL ON ref.tr_traitvaluequal_trv TO diaspara_admin;
GRANT SELECT ON ref.tr_traitvaluequal_trv TO diaspara_read; 

DROP TABLE IF EXISTS refeel.tr_traitvaluequal_trv CASCADE;
CREATE TABLE refeel.tr_traitvaluequal_trv(
  CONSTRAINT uk_trv_id UNIQUE (trv_id),
  CONSTRAINT fk_trv_trq_code 
  FOREIGN KEY (trv_trq_code)
    REFERENCES refeel.tr_traitqualitative_trq(tra_code)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT uk_refeel_trv_code UNIQUE (trv_code, trv_trq_code)
) INHERITS (ref.tr_traitvaluequal_trv);


COMMENT ON COLUMN refeel.tr_traitvaluequal_trv.trv_id IS
 'Integer, id of the qualitative used';
COMMENT ON COLUMN refeel.tr_traitvaluequal_trv.trv_code IS
 'Code of the qualitative trait';
COMMENT ON COLUMN refeel.tr_traitvaluequal_trv.trv_description IS
 'Description of the method';

GRANT ALL ON refeel.tr_traitvaluequal_trv TO diaspara_admin;
GRANT SELECT ON refeel.tr_traitvaluequal_trv TO diaspara_read; 
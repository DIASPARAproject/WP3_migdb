

DROP TABLE IF EXISTS refnas.tr_traitvaluequal_trv CASCADE;
CREATE TABLE refnas.tr_traitvaluequal_trv(
  CONSTRAINT uk_trv_id UNIQUE (trv_id),
  CONSTRAINT fk_trv_trq_code 
  FOREIGN KEY (trv_trq_code)
    REFERENCES refnas.tr_traitqualitative_trq(tra_code)
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT uk_refnas_trv_code UNIQUE (trv_code, trv_trq_code)
) INHERITS (ref.tr_traitvaluequal_trv);


COMMENT ON COLUMN refnas.tr_traitvaluequal_trv.trv_id IS
 'Integer, id of the qualitative used';
COMMENT ON COLUMN refnas.tr_traitvaluequal_trv.trv_code IS
 'Code of the qualitative trait';
COMMENT ON COLUMN refnas.tr_traitvaluequal_trv.trv_description IS
 'Description of the method';

GRANT ALL ON refnas.tr_traitvaluequal_trv TO diaspara_admin;
GRANT SELECT ON refnas.tr_traitvaluequal_trv TO diaspara_read; 
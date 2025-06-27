-- DROP TABLE "ref".tr_traitvaluequal_qal;

CREATE TABLE ref.tr_traitvaluequal_qal(
  qal_id INTEGER,
  qal_trq_code TEXT NOT NULL,
  CONSTRAINT fk_qal_trq_code 
  FOREIGN KEY (qal_trq_code)
  REFERENCES ref.tr_traitqualitative_trq(tra_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  qal_code text NOT NULL,
  qal_description text NULL,
  qal_definition text,
  CONSTRAINT uk_qal_code UNIQUE (qal_code)
);


COMMENT ON COLUMN ref.tr_traitvaluequal_qal.qal_id IS 'Integer, id of the qualitative used';
COMMENT ON COLUMN ref.tr_traitvaluequal_qal.qal_code IS 'Code of the qualitative traitvalue';
COMMENT ON COLUMN ref.tr_traitvaluequal_qal.qal_description IS 'Description of the method';




GRANT ALL ON ref.tr_traitvaluequal_qal TO diaspara_admin;
GRANT SELECT ON ref.tr_traitvaluequal_qal TO diaspara_read; 
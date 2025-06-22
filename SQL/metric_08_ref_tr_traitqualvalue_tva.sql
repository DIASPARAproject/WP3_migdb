-- DROP TABLE "ref".tr_traitvaluequal_qal;

CREATE TABLE ref.tr_traitvaluequal_qal
  qal_id,
  qal_trq_code TEXT NOT NULL,
  CONSTRAINT fk_qal_trq_code 
  FOREIGN KEY (qal_trq_code)
  REFERENCES ref.tr_tratqualitative_trq(trq_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  qal_code text NOT NULL,
  qal_description text NULL,
  qal_definition text,
  qal_icesvalue character varying(4),  
  qal_icesguid uuid,
  qal_icestablesource text,
  CONSTRAINT uk_trm_code UNIQUE (qal_code)
);


COMMENT ON COLUMN ref.tr_tr_traitvaluequal_qal.qal_id IS 'Integer, id of the qualitative used';
COMMENT ON COLUMN ref.tr_tr_traitvaluequal_qal.qal_code IS 'Code of the qualitative traitvalue';
COMMENT ON COLUMN ref.tr_tr_traitvaluequal_qal.qal_description IS 'Description of the method';
COMMENT ON COLUMN ref.tr_tr_traitvaluequal_qal.qal_definition IS 'Definition of the method used to obtain the metric';
COMMENT ON COLUMN ref.tr_tr_traitvaluequal_qal.qal_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_tr_traitvaluequal_qal.qal_icestablesource IS 'Source table in ICES vocab';



GRANT ALL ON ref.tr_tr_traitvaluequal_qal TO diaspara_admin;
GRANT SELECT ON ref.tr_tr_traitvaluequal_qal TO diaspara_read; 
-- Table for quality

DROP TABLE IF EXISTS ref.tr_quality_qal CASCADE;
CREATE  TABLE ref.tr_quality_qal (
  qal_code int4 NOT NULL,
  qal_description text NULL,
  qal_definition text NULL,
  qal_kept bool  NULL,
    CONSTRAINT tr_quality_qal_pkey PRIMARY KEY (qal_code)
);
COMMENT ON TABLE ref.tr_quality_qal IS 'Table of quality rating, 1 = good quality, 2 = modified 4 = warnings, 0 = missing, 18 , 19 ... deprecated data in 2018, 2019 ...';
COMMENT ON COLUMN ref.tr_quality_qal.qal_code IS 'Data quality code';
COMMENT ON COLUMN ref.tr_quality_qal.qal_description IS 'Data quality description';
COMMENT ON COLUMN ref.tr_quality_qal.qal_definition IS 'Definition of the quality code';
COMMENT ON COLUMN ref.tr_quality_qal.qal_kept IS 'Are the data with this score kept for analysis';

GRANT ALL ON ref.tr_quality_qal TO diaspara_admin;
GRANT SELECT ON ref.tr_quality_qal TO diaspara_read;




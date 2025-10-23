-- Table of estimation methods when databasis is Estimated

DROP TABLE IF EXISTS ref.tr_databasis_dtb CASCADE;
CREATE  TABLE ref.tr_databasis_dtb (
  dtb_id int4 PRIMARY KEY,
  dtb_code TEXT NOT NULL CONSTRAINT uk_dtb_code UNIQUE, 
  dtb_description text NULL,
  dtb_icesvalue TEXT,  
  dtb_icesguid uuid,
  dtb_icestablesource text
);
COMMENT ON TABLE ref.tr_databasis_dtb IS 'Table of data basis';
COMMENT ON COLUMN ref.tr_databasis_dtb.dtb_code IS 'Data basis  code';
COMMENT ON COLUMN ref.tr_databasis_dtb.dtb_description IS 'Data basis description';
COMMENT ON COLUMN ref.tr_databasis_dtb.dtb_icesvalue IS 'Code (Key) of the Data basis in ICES';
COMMENT ON COLUMN ref.tr_databasis_dtb.dtb_icesguid IS 'UUID (guid) of ICES ';
COMMENT ON COLUMN ref.tr_databasis_dtb.dtb_icestablesource IS 'Source table in ICES';

GRANT ALL ON ref.tr_databasis_dtb TO diaspara_admin;
GRANT SELECT ON ref.tr_databasis_dtb TO diaspara_read;



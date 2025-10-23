-- Table of estimation methods when databasis is Estimated

DROP TABLE IF EXISTS ref.tr_estimationmethod_esm CASCADE;
CREATE  TABLE ref.tr_estimationmethod_esm (
  esm_id int4 PRIMARY KEY,
  esm_code TEXT NOT NULL CONSTRAINT uk_esm_code UNIQUE, 
  esm_description text NULL,
  esm_wkg_code TEXT NOT NULL,
CONSTRAINT fk_esm_wkg_code  FOREIGN KEY (esm_wkg_code)
REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
ON UPDATE CASCADE ON DELETE RESTRICT,
  esm_icesvalue TEXT,  
  esm_icesguid uuid,
  esm_icestablesource text
);
COMMENT ON TABLE ref.tr_estimationmethod_esm IS 'Table of table estimation method, provided when databasis (dtb_code) correspond to Estimated';
COMMENT ON COLUMN ref.tr_estimationmethod_esm.esm_code IS 'Estimation method code';
COMMENT ON COLUMN ref.tr_estimationmethod_esm.esm_description IS 'Estimation method  description';
COMMENT ON COLUMN ref.tr_estimationmethod_esm.esm_icesvalue IS 'Code (Key) of the Estimation method in ICES';
COMMENT ON COLUMN ref.tr_estimationmethod_esm.esm_icesguid IS 'UUID (guid) of ICES ';
COMMENT ON COLUMN ref.tr_estimationmethod_esm.esm_icestablesource IS 'Source table in ICES';
COMMENT ON COLUMN ref.tr_estimationmethod_esm.esm_wkg_code 
IS 'Code of the working group, one of WGBAST, WGEEL, WGNAS, WKTRUTTA';
GRANT ALL ON ref.tr_estimationmethod_esm TO diaspara_admin;
GRANT SELECT ON ref.tr_estimationmethod_esm TO diaspara_read;



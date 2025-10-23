-- Table for quality

DROP TABLE IF EXISTS ref.tr_datasource_dts CASCADE;
CREATE  TABLE ref.tr_datasource_dts (
  dts_id int4 PRIMARY KEY,
  dts_code TEXT NOT NULL CONSTRAINT uk_dts_code UNIQUE, 
  dts_description text NULL,
  dts_icesvalue TEXT,  
  dts_icesguid uuid,
  dts_icestablesource text
);
COMMENT ON TABLE ref.tr_datasource_dts IS 'Table of data source values, e.g. logbooks, Expert value ...';
COMMENT ON COLUMN ref.tr_datasource_dts.dts_code IS 'Data srouce code';
COMMENT ON COLUMN ref.tr_datasource_dts.dts_description IS 'Data source description';
COMMENT ON COLUMN ref.tr_datasource_dts.dts_icesvalue IS 'Code (Key) of the time period in ICES db';
COMMENT ON COLUMN ref.tr_datasource_dts.dts_icesguid IS 'UUID (guid) of ICES, you can access by pasting ';
COMMENT ON COLUMN ref.tr_datasource_dts.dts_icestablesource IS 'Source table in ICES';

GRANT ALL ON ref.tr_datasource_dts TO diaspara_admin;
GRANT SELECT ON ref.tr_datasource_dts TO diaspara_read;



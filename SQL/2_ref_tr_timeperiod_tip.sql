-- maturity table code


DROP TABLE IF EXISTS ref.tr_timeperiod_tip CASCADE;
CREATE TABLE  ref.tr_timeperiod_tip (
  tip_id SERIAL PRIMARY KEY,
  tip_code TEXT NOT NULL CONSTRAINT uk_tip_code UNIQUE, 
  tip_description TEXT,
  tip_icesvalue TEXT,  
  tip_icesguid uuid,
  tip_icestablesource text
);

COMMENT ON TABLE ref.tr_timeperiod_tip IS 'Table of time periods';
COMMENT ON COLUMN ref.tr_timeperiod_tip.tip_id IS 'Integer, primary key of the table';
COMMENT ON COLUMN ref.tr_timeperiod_tip.tip_code IS 'The code of time period';
COMMENT ON COLUMN ref.tr_timeperiod_tip.tip_description IS 'Definition of the time period';
COMMENT ON COLUMN ref.tr_timeperiod_tip.tip_icesvalue IS 'Code (Key) of the time period in ICES db';
COMMENT ON COLUMN ref.tr_timeperiod_tip.tip_icesguid IS 'UUID (guid) of ICES, you can access by pasting ';
COMMENT ON COLUMN ref.tr_timeperiod_tip.tip_icestablesource IS 'Source table in ICES';
GRANT ALL ON ref.tr_timeperiod_tip TO diaspara_admin;
GRANT SELECT ON ref.tr_timeperiod_tip TO diaspara_read;


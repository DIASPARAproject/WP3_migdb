DROP TABLE IF EXISTS dat.t_serannual_san CASCADE;
CREATE TABLE dat.t_serannual_san (
san_svc_id UUID,
CONSTRAINT fk_san_svc_id FOREIGN KEY (san_svc_id)
  REFERENCES ref.tr_seriesvocab_svc (svc_id) 
  ON UPDATE CASCADE ON DELETE CASCADE, 
san_id SERIAL NOT NULL,
CONSTRAINT c_uk_san_id UNIQUE (san_id, san_wkg_code),
san_value NUMERIC NULL,
san_year INTEGER NOT NULL,
CONSTRAINT uk_san_year_svc UNIQUE(san_year, san_svc_id),
san_comment TEXT NULL, 
san_effort NUMERIC NULL,
san_datelastupdate DATE NOT NULL,
san_qal_id INTEGER NOT NULL,
san_qal_comment TEXT, 
san_wkg_code TEXT NOT NULL,  
CONSTRAINT fk_san_wkg_code  FOREIGN KEY (san_wkg_code)
REFERENCES "ref".tr_icworkinggroup_wkg(wkg_code),
san_ver_code TEXT NOT NULL,
CONSTRAINT fk_san_ver_code FOREIGN KEY (san_ver_code)
REFERENCES ref.tr_version_ver(ver_code)
);
  


COMMENT ON TABLE dat.t_serannual_san IS 'Table of annual abundance data for series in dat.t_series_ser, these are recruitment or silver eel run data.  This table is inherited. It means that the data in dat is fed by
the content of the tables in datfeel, datnas, datbast ';

COMMENT ON COLUMN dat.t_serannual_san.san_svc_id IS 'UUID, identifier of the series, primary key, references the table ref.tr_seriesvocab_svc (svc_id)';
COMMENT ON COLUMN dat.t_serannual_san.san_id IS 'INTEGER, autoincremented, unique for one working group';
COMMENT ON COLUMN dat.t_serannual_san.san_year IS 'Year of monitoring, note that for some of the series this corresponds to the main migration season, 
For glass eel, months from september y-1 to august y should be denoted year y / For silver eel, months from june y to may y+1 should be denoted year y / For yellow eels, use the calendar year), see the series metadata for more details.';
COMMENT ON COLUMN dat.t_serannual_san.san_comment IS 'Comment on the annual value of the series';
COMMENT ON COLUMN dat.t_serannual_san.san_effort IS 'Eventually a measure of effort to collect the series, e.g. number of nr haul, nr fyke.day,
check the t_metadataannual table for the unit used';
COMMENT ON COLUMN dat.t_serannual_san.san_datelastupdate IS 'Date of last update on the annual data';
COMMENT ON COLUMN dat.t_serannual_san.san_qal_id IS 'Quality ID code of the series';
COMMENT ON COLUMN dat.t_serannual_san.san_qal_comment IS 'Comment related to data quality, e.g. why this year the series should not be used, or used with caution.';
COMMENT ON COLUMN dat.t_serannual_san.san_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';
COMMENT ON COLUMN dat.t_serannual_san.san_ver_code IS 'Version code sourced from ref.tr_version_ver the data call e.g. NAS_2025dc_2020, wgeel_2016, wkemp_2025';


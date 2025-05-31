--DROP TABLE IF EXISTS dateel.t_serannual_san;

CREATE TABLE dateel.t_serannual_san (
CONSTRAINT fk_san_svc_id FOREIGN KEY (san_svc_id)
  REFERENCES ref.tr_seriesvocab_svc (svc_id) 
  ON UPDATE CASCADE ON DELETE CASCADE, 
CONSTRAINT c_uk_san_id UNIQUE (san_id, san_wkg_code), 
CONSTRAINT fk_san_wkg_code  FOREIGN KEY (san_wkg_code)
REFERENCES ref.tr_icworkinggroup_wkg(wkg_code),
CONSTRAINT fk_san_ver_code FOREIGN KEY (san_ver_code)
REFERENCES refeel.tr_version_ver(ver_code),
CONSTRAINT uk_san_year_svc UNIQUE(san_year, san_svc_id)
) INHERITS (dat.t_serannual_san);
  


COMMENT ON TABLE dateel.t_serannual_san IS 'Table of annual abundance data for series in dat.t_series_ser, these are recruitment or silver eel run data.  This table is inherited. It means that the data in dat is fed by
the content of the tables in datfeel, datnas, datbast';

COMMENT ON COLUMN dateel.t_serannual_san.san_svc_id IS 'UUID, identifier of the series, primary key, references the table ref.tr_seriesvocab_svc (svc_id)';
COMMENT ON COLUMN dateel.t_serannual_san.san_id IS 'INTEGER, autoincremented, unique for one working group';
COMMENT ON COLUMN dateel.t_serannual_san.san_year IS 'Year of monitoring, note that for some of the series this corresponds to the main migration season, 
For glass eel, months from september y-1 to august y should be denoted year y / For silver eel, months from june y to may y+1 should be denoted year y / For yellow eels, use the calendar year), see the series metadata for more details.';
COMMENT ON COLUMN dateel.t_serannual_san.san_comment IS 'Comment on the annual value of the series';
COMMENT ON COLUMN dateel.t_serannual_san.san_effort IS 'Eventually a measure of effort to collect the series, e.g. number of nr haul, nr fyke.day,
check the t_metadataannual table for the unit used';
COMMENT ON COLUMN dateel.t_serannual_san.san_datelastupdate IS 'Date of last update on the annual data';
COMMENT ON COLUMN dateel.t_serannual_san.san_qal_id IS 'Quality ID code of the series';
COMMENT ON COLUMN dateel.t_serannual_san.san_qal_comment IS 'Comment related to data quality, e.g. why this year the series should not be used, or used with caution.';
COMMENT ON COLUMN dateel.t_serannual_san.san_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';
COMMENT ON COLUMN dateel.t_serannual_san.san_ver_code IS 'Version code sourced from ref.tr_version_ver the data call e.g. NAS_2025dc_2020, wgeel_2016, wkemp_2025';


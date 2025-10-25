--DROP TABLE IF EXISTS datbast.t_serannual_san;

CREATE TABLE datbast.t_serannual_san (
 san_agegroup TEXT,
CONSTRAINT ck_san_agegroup CHECK (san_agegroup IS NULL OR san_agegroup='0+' OR san_agegroup = '>0+' OR san_agegroup ='all'),
CONSTRAINT ck_san_wkg_code CHECK (san_wkg_code = 'WGBAST'),
CONSTRAINT fk_san_ser_id FOREIGN KEY (san_ser_id)
  REFERENCES datbast.t_series_ser (ser_id) 
  ON UPDATE CASCADE ON DELETE CASCADE, 
CONSTRAINT c_uk_san_id UNIQUE (san_id, san_wkg_code), 
CONSTRAINT fk_san_wkg_code  FOREIGN KEY (san_wkg_code)
REFERENCES ref.tr_icworkinggroup_wkg(wkg_code),
CONSTRAINT fk_san_ver_code FOREIGN KEY (san_ver_code)
REFERENCES refbast.tr_version_ver(ver_code),
CONSTRAINT uk_san_year_svc UNIQUE(san_year, san_ser_id, san_agegroup)
) INHERITS (dat.t_serannual_san);
  
ALTER TABLE datbast.t_series_ser ALTER COLUMN ser_wkg_code SET DEFAULT 'WGBAST';  

COMMENT ON TABLE datbast.t_serannual_san IS 'Table of annual abundance data for series in datbast.t_series_ser, electrofishing series or trap data';
COMMENT ON COLUMN datbast.t_serannual_san.san_ser_id IS 'UUID, identifier of the series, primary key, references the table ref.tr_seriesvocab_svc (svc_id)';
COMMENT ON COLUMN datbast.t_serannual_san.san_id IS 'INTEGER, autoincremented, unique for one working group';
COMMENT ON COLUMN datbast.t_serannual_san.san_year IS 'Year of monitoring, note that for some of the series this corresponds to the main migration season';
COMMENT ON COLUMN datbast.t_serannual_san.san_agegroup IS 'Age group of fish.';
COMMENT ON COLUMN datbast.t_serannual_san.san_comment IS 'Comment on the annual value of the series';
COMMENT ON COLUMN datbast.t_serannual_san.san_effort IS 'Eventually a measure of effort to collect the series, e.g. number of nr haul, nr fyke.day,
check the t_metadataannual table for the unit used';
COMMENT ON COLUMN datbast.t_serannual_san.san_datelastupdate IS 'Date of last update on the annual data';
COMMENT ON COLUMN datbast.t_serannual_san.san_qal_id IS 'Quality ID code of the series';
COMMENT ON COLUMN datbast.t_serannual_san.san_qal_comment IS 'Comment related to data quality, e.g. why this year the series should not be used, or used with caution.';
COMMENT ON COLUMN datbast.t_serannual_san.san_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';
COMMENT ON COLUMN datbast.t_serannual_san.san_ver_code IS 'Version code sourced from ref.tr_version_ver the data call e.g. NAS_2025dc_2020, wgeel_2016, wkemp_2025';


GRANT ALL ON datbast.t_serannual_san TO diaspara_admin;
GRANT SELECT ON datbast.t_serannual_san TO diaspara_read; 
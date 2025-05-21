-- DROP TABLE dat.t_series_ser;

CREATE TABLE dat.t_series_ser (
  ser_svc_id uuid ,
  CONSTRAINT fk_ser_svc_id FOREIGN KEY (ser_svc_code)
  REFERENCES ref.tr_seriesvocab_svc (svc_id) 
  ON UPDATE CASCADE ON DELETE RESTRICT,  
  CONSTRAINT t_series_ser_pkey PRIMARY KEY (ser_svc_id),
  ser_code text NOT NULL,
  CONSTRAINT uk_ser_code UNIQUE,
  ser_name text NULL,
  CONSTRAINT uk_ser_code UNIQUE,
  ser_spe_code TEXT NULL,
  CONSTRAINT fk_ser_spe_code FOREIGN KEY (ser_spe_code) 
  REFERENCES "ref".tr_species_spe(spe_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT ,
  ser_lfs_code TEXT NULL,
  CONSTRAINT fk_ser_lfs_code_ser_spe_code FOREIGN KEY (ser_lfs_code, ser_spe_code)
  REFERENCES "ref".tr_lifestage_lfs (lfs_code, lfs_spe_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,  
  ser_are_code TEXT NOT NULL,
  CONSTRAINT fk_ser_are_code FOREIGN KEY (ser_are_code)
    REFERENCES "ref".tr_area_are (are_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  ser_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_ser_wkg_code  FOREIGN KEY (ser_wkg_code)
  REFERENCES "ref".tr_icworkinggroup_wkg(wkg_code),
  ser_ver_code TEXT NOT NULL,
  CONSTRAINT fk_ser_ver_code FOREIGN KEY (ser_ver_code)
  REFERENCES ref.tr_version_ver(ver_code),
  geom geometry NULL,
  ser_x NUMERIC NULL,
  ser_y NUMERIC NULL);
  

COMMENT ON TABLE dat.t_series_ser IS 'Table of time series, or sampling data identifier. This corresponds to a multi-annual data collection design.
It can correspond to time series data or individual metrics collection or both. This table is inherited. It means that the data in ref is fed by
the content of the tables in refeel, refnas, refbast... ';
COMMENT ON COLUMN dat.t_series_ser.ser_svc_id IS 'UUID, identifier of the series, primary key, references the table ref.tr_seriesvocab_svc (svc_id)';
COMMENT ON COLUMN dat.t_series_ser.ser_code IS 'Code of the series';
COMMENT ON COLUMN dat.t_series_ser.ser_name IS 'Name of the series';
COMMENT ON COLUMN dat.t_series_ser.ser_spe_code  IS 'Species, one of SAL, ELE, TRT, ALA, ALF, SLP, RLP  ... references ref.tr_species_spe, the species can be null but
it should correspond to the main species target by the sampling';
COMMENT ON COLUMN dat.t_series_ser.ser_lfs_code  IS 'Life stage see tr_lifestage_lfs,Code of the lifestage see tr_lifestage_lfs,  the constraint is set on 
both lfs_code, and lfs_spe_code (as two species can have the same lifestage code. The lifestage can be NULL but it should correspond to the main lifestage targeted by the series;';
COMMENT ON COLUMN dat.t_series_ser.ser_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';
COMMENT ON COLUMN dat.t_series_ser.ser_ver_code IS 'Version code sourced from ref.tr_version_ver the data call e.g. NAS_2025dc_2020, wgeel_2016, wkemp_2025';';
COMMENT ON COLUMN dat.t_series_ser.geom IS 'Series geometry column';
COMMENT ON COLUMN dat.t_series_ser.ser_x IS 'Longitude, EPSG 4326';
COMMENT ON COLUMN dat.t_series_ser.ser_x IS 'Latitude, EPSG 4326';
GRANT ALL ON ref.t_series_ser TO diaspara_admin;
GRANT SELECT ON ref.t_series_ser TO diaspara_read; 


DROP TABLE IF EXISTS dateel.t_series_ser;
CREATE TABLE dateel.t_series_ser (
 CONSTRAINT fk_ser_svc_id FOREIGN KEY (ser_svc_id)
  REFERENCES ref.tr_seriesvocab_svc (svc_id) 
  ON UPDATE CASCADE ON DELETE RESTRICT,  
  CONSTRAINT uk_ser_svc_id UNIQUE (ser_svc_id),
  CONSTRAINT uk_ser_code UNIQUE (ser_code),
  CONSTRAINT uk_ser_name UNIQUE (ser_name),
  CONSTRAINT fk_ser_spe_code FOREIGN KEY (ser_spe_code) 
    REFERENCES ref.tr_species_spe(spe_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT ,
  CONSTRAINT fk_ser_lfs_code_ser_spe_code FOREIGN KEY (ser_lfs_code, ser_spe_code)
    REFERENCES ref.tr_lifestage_lfs (lfs_code, lfs_spe_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,  
  CONSTRAINT fk_ser_are_code FOREIGN KEY (ser_are_code)
    REFERENCES ref.tr_area_are (are_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_ser_wkg_code  FOREIGN KEY (ser_wkg_code)
   REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
       ON UPDATE CASCADE ON DELETE RESTRICT,   
  CONSTRAINT fk_ser_ver_code FOREIGN KEY (ser_ver_code)
  REFERENCES refeel.tr_version_ver(ver_code)
      ON UPDATE CASCADE ON DELETE RESTRICT,  
    CONSTRAINT fk_station_code FOREIGN KEY (ser_station_code) 
  REFERENCES "ref"."StationDictionary" ("Station_Code")
  ON UPDATE CASCADE ON DELETE CASCADE,
   CONSTRAINT fk_ser_hty_code FOREIGN KEY(ser_hty_code)
  REFERENCES ref.tr_habitattype_hty (hty_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_ser_gea_code FOREIGN KEY (ser_gea_code)
  REFERENCES ref.tr_gear_gea(gea_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_ser_annual_effort_uni_code 
  FOREIGN KEY(ser_annual_effort_uni_code)
  REFERENCES ref.tr_units_uni(uni_code)
  ON UPDATE CASCADE ON DELETE RESTRICT  
) inherits (dat.t_series_ser);

-- In the wgeel schema the default is WGEEL
ALTER TABLE dateel.t_series_ser ALTER COLUMN ser_wkg_code SET DEFAULT 'WGEEL';  

COMMENT ON TABLE dateel.t_series_ser IS 'Table of time series, or sampling data identifier. This corresponds to a multi-annual data collection design.
It can correspond to time series data or individual metrics collection or both. This table is inherited from dat ';
COMMENT ON COLUMN dateel.t_series_ser.ser_svc_id IS 'UUID, identifier of the series, primary key, references the table ref.tr_seriesvocab_svc (svc_id)';
COMMENT ON COLUMN dat.t_series_ser.ser_station_code IS
'Station code see StationDictionary, this table contains elements about monitoring purpose (PURMP), stationGovernance, ProgramGovernance, 
station_activefromdate, stationactiveuntildate, latitude, latituderange, longitude, longituderange, MSAT ';
COMMENT ON COLUMN dateel.t_series_ser.ser_code IS 'Code of the series or sampling. If the sampling scheme does
 not already exist, please provide a code starting with emu name and few letters, or for recruitment, standing yellow stock, or silver
eel series a code with short name of the series, this must be 3-4 letters + stage name, e.g. VilG, LiffGY, FremS, the first letter is capitalised and the stage name too.';
COMMENT ON COLUMN dateel.t_series_ser.ser_name IS 'Name of the series';
COMMENT ON COLUMN dateel.t_series_ser.ser_spe_code  IS 'Species, one of SAL, ELE, TRT, ALA, ALF, SLP, RLP  ... references ref.tr_species_spe, the species can be null but
it should correspond to the main species target by the sampling';
COMMENT ON COLUMN dateel.t_series_ser.ser_lfs_code  IS 'Life stage see tr_lifestage_lfs,Code of the lifestage see tr_lifestage_lfs,  the constraint is set on 
both lfs_code, and lfs_spe_code (as two species can have the same lifestage code. The lifestage can be NULL but it should correspond to the main lifestage targeted by the series;';
COMMENT ON COLUMN dateel.t_series_ser.ser_wkg_code IS 'Code of the working group, one of
WGEEL';
COMMENT ON COLUMN dateel.t_series_ser.ser_ver_code IS 'Version of the data usually corresponding to the data call e.g. dc_2020, wgeel_2016, wkemp_2025';
COMMENT ON COLUMN dateel.t_series_ser.geom IS 'Series geometry column';
COMMENT ON COLUMN dat.t_series_ser.ser_description IS 'Sem description should comply with column svc_description in the vocabulary. Quick concise description of the series. Should include species, stage targeted, location and gear. e.g. Glass eel monitoring in the Vilaine estuary (France) with a trapping ladder.';
COMMENT ON COLUMN dat.t_series_ser.ser_hty_code IS 'Code of the habitat type, one of MO (marine open), MC (Marine coastal), T (Transitional water), FW (Freshwater), null accepted';
COMMENT ON COLUMN dat.t_series_ser.ser_are_code IS 'Code of the area, areas are geographical sector most often corresponding to stock units, see tr_area_are.';
COMMENT ON COLUMN dat.t_series_ser.ser_gea_code IS 'Code of the gear used, see tr_gear_gea';
COMMENT ON COLUMN dat.t_series_ser.ser_ccm_wso_id IS 'Code of the main catchment in the CCM database, are_code can be used also.';
COMMENT ON COLUMN dat.t_series_ser.ser_distanceseakm IS 'Distance to the sea, the centroid of the different sites can be used if a series is made of several stations.';
COMMENT ON COLUMN dat.t_series_ser.ser_stocking IS 'Boolean, Is there restocking (for eel) or artifical reproduction in the river / basin, affecting the series ? ';
COMMENT ON COLUMN dat.t_series_ser.ser_stockingcomment IS 'Comment on stocking';
COMMENT ON COLUMN dat.t_series_ser.ser_protocol IS 'Describe sampling protocol for annual, group metrics, individual metrics';

GRANT ALL ON dateel.t_series_ser TO diaspara_admin;
GRANT SELECT ON dateel.t_series_ser TO diaspara_read; 


 
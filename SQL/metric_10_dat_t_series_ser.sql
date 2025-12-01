--DROP TABLE IF EXISTS dat.t_series_ser CASCADE;

CREATE TABLE dat.t_series_ser (
  ser_id uuid PRIMARY KEY,
  ser_code text NOT NULL,
  CONSTRAINT uk_ser_code UNIQUE (ser_code),
  ser_name TEXT NOT NULL,
  --CONSTRAINT uk_ser_name UNIQUE (ser_name),
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
  ser_cou_code TEXT NOT NULL,
  CONSTRAINT fk_ser_cou_code FOREIGN KEY (ser_cou_code)
  REFERENCES ref.tr_country_cou(cou_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_ser_wltyp_code FOREIGN KEY( ser_wltyp_code)
  REFERENCES ref."WLTYP"("Key") 
  ON UPDATE CASCADE ON DELETE RESTRICT,
  ser_hab_code TEXT NULL,
  CONSTRAINT fk_ser_habitat_code FOREIGN KEY(ser_hab_code)
  REFERENCES ref.tr_habitat_hab (hab_code)
  ON UPDATE CASCADE ON DELETE RESTRICT, 
  ser_gea_code TEXT NULL,
  CONSTRAINT fk_ser_gea_code FOREIGN KEY (ser_gea_code)
  REFERENCES ref.tr_gear_gea(gea_code)
  ON UPDATE CASCADE ON DELETE CASCADE,  
  ser_fiw_code TEXT,
  CONSTRAINT fk_ser_fiw_code FOREIGN KEY (ser_fiw_code)
  REFERENCES ref.tr_fishway_fiw(fiw_code)
  ON UPDATE CASCADE ON DELETE CASCADE,  
  ser_mon_code TEXT,
  CONSTRAINT fk_ser_mon_code FOREIGN KEY (ser_mon_code)
  REFERENCES ref.tr_monitoring_mon(mon_code)
  ON UPDATE CASCADE ON DELETE CASCADE,  
  ser_uni_code varchar(20), 
  CONSTRAINT fk_ser_uni_code FOREIGN KEY (ser_uni_code)
  REFERENCES ref.tr_units_uni(uni_code)
  ON DELETE CASCADE ON UPDATE CASCADE,
  ser_effort_uni_code varchar(20),
  CONSTRAINT fk_ser_effort_uni_code FOREIGN KEY (ser_effort_uni_code)
  REFERENCES ref.tr_units_uni(uni_code)
  ON DELETE CASCADE  ON UPDATE CASCADE,
  ser_description TEXT NULL,
  ser_locationdescription TEXT NULL,
  ser_wltyp_code TEXT NULL,
  ser_stocking boolean NULL,
  ser_stockingcomment TEXT NULL,
  ser_protocol TEXT NULL,
  ser_samplingstrategy TEXT NULL,  
  ser_datarightsholder TEXT NULL,
  ser_datelastupdate DATE NOT NULL,
  geom geometry NULL);

COMMENT ON TABLE dat.t_series_ser IS 
'Table of time series, or sampling data identifier. This corresponds to a multi-annual data collection design.
It can correspond to time series data or individual metrics collection or both. This table is inherited. It means that the data in ref is fed by
the content of the tables in refeel, refnas, refbast... Note this table is joined to  StationDictionary, which contains elements about monitoring purpose (PURMP), stationGovernance, ProgramGovernance, 
station_activefromdate, stationactiveuntildate, latitude, latituderange, longitude, longituderange, MSAT. Check that the table content is consistent';
COMMENT ON COLUMN dat.t_series_ser.ser_id IS 
'UUID, identifier of the series, primary key';
COMMENT ON COLUMN dat.t_series_ser.ser_code IS 
'Code of the series';
COMMENT ON COLUMN dat.t_series_ser.ser_name IS 
'Name of the series';
COMMENT ON COLUMN dat.t_series_ser.ser_spe_code  IS 
'Species, one of SAL, ELE, TRT, ALA, ALF, SLP, RLP  ... references ref.tr_species_spe, the species can be null but
it should correspond to the main species target by the sampling';
COMMENT ON COLUMN dat.t_series_ser.ser_lfs_code  IS 
'Life stage see tr_lifestage_lfs,Code of the lifestage see tr_lifestage_lfs,  the constraint is set on 
both lfs_code, and lfs_spe_code (as two species can have the same lifestage code. The lifestage can be NULL but it should correspond to the main lifestage targeted by the series;';
COMMENT ON COLUMN dat.t_series_ser.ser_wkg_code IS 
'Code of the working group, one of WGBAST, WGEEL, WGNAS, WKTRUTTA';
COMMENT ON COLUMN dat.t_series_ser.ser_ver_code IS 
'Version code referencing tr_version_ver the data call e.g. NAS_2025dc_2020, wgeel_2016, wkemp_2025';
COMMENT ON COLUMN dat.t_series_ser.ser_cou_code IS
 'Code of the country';
COMMENT ON COLUMN dat.t_series_ser.ser_wltyp_code IS 
'Code of the habitat type, one of MO (marine open), MC (Marine coastal), T (Transitional water), FW (Freshwater), null accepted';
COMMENT ON COLUMN dat.t_series_ser.ser_hab_code IS 
'Code of the habitat, see tr_habitat_hab';
COMMENT ON COLUMN dat.t_series_ser.ser_are_code IS 
'Code of the area, areas are geographical sector most often corresponding to stock units, see tr_area_are.';
COMMENT ON COLUMN dat.t_series_ser.ser_uni_code IS 
'Unit for the value reported in annual table, if the series reports annual data in Kg or Number use kg or number.';
COMMENT ON COLUMN dat.t_series_ser.ser_effort_uni_code IS 
'Annual data collection effort unit code, used for the effort column in annual data';
COMMENT ON COLUMN dat.t_series_ser.ser_description IS 
'Concise description of the series. Should include species, stage targeted, location and gear. e.g. Glass eel monitoring in the Vilaine estuary (France) with a trapping ladder.';
COMMENT ON COLUMN dat.t_series_ser.ser_locationdescription IS
 'This should provide a description of the site, e.g. if ist far inland, in the middle of a river, near a dam etc. Also please specify the adjectant marine region (Baltic, North Sea) etc.
(e.g.  "Bresle river trap 3 km from the sea" or IYFS/IBTS sampling in the Skagerrak-Kattegat"';
COMMENT ON COLUMN dat.t_series_ser.ser_gea_code IS
 'Code of the gear used, see tr_gear_gea';
COMMENT ON COLUMN dat.t_series_ser.ser_fiw_code IS
 'Code the fishway, eg PO for pool type fishway';
COMMENT ON COLUMN dat.t_series_ser.ser_mon_code IS
 'Code the Monitoring device, eg SO for Sonar';
COMMENT ON COLUMN dat.t_series_ser.ser_stocking IS
 'Boolean, Is there restocking (for eel) or artifical reproduction in the river / basin, affecting the series ? ';
COMMENT ON COLUMN dat.t_series_ser.ser_stockingcomment IS
 'Comment on stocking';
COMMENT ON COLUMN dat.t_series_ser.ser_protocol IS
 'Describe sampling protocol';
COMMENT ON COLUMN dat.t_series_ser.ser_samplingstrategy IS
 'Describe sampling strategy';
COMMENT ON COLUMN dat.t_series_ser.ser_datarightsholder IS
 'Code of the data rights holder of the series, this field will be used in DATSU to acknowledge the source of data';
COMMENT ON COLUMN dat.t_series_ser.ser_datelastupdate IS
 'Last modification in the series, from a trigger';
COMMENT ON COLUMN dat.t_series_ser.geom IS
 'Series geometry column EPSG 4326, can be more detailed than the geometry for station';


GRANT ALL ON dat.t_series_ser TO diaspara_admin;
GRANT SELECT ON dat.t_series_ser TO diaspara_read; 


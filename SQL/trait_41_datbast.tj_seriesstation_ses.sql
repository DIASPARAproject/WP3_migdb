DROP TABLE IF EXISTS datbast.tj_seriesstation_ses; 
CREATE TABLE datbast.tj_seriesstation_ses (
 CONSTRAINT fk_ses_ser_id FOREIGN KEY (ses_ser_id)
    REFERENCES datbast.t_series_ser (ser_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
 CONSTRAINT uk_ses_ser_id UNIQUE (ses_ser_id) ,
  CONSTRAINT fk_station_code FOREIGN KEY (ses_station_code) 
  REFERENCES "ref"."StationDictionary" ("Station_Code")   
  ) inherits (dat.tj_seriesstation_ses);
  

GRANT ALL ON datbast.tj_seriesstation_ses TO diaspara_admin;
GRANT SELECT ON datbast.tj_seriesstation_ses TO diaspara_read; 
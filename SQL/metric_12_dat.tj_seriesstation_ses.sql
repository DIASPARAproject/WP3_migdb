DROP TABLE IF EXISTS dat.tj_seriesstation_ses; 
CREATE TABLE dat.tj_seriesstation_ses (
 ses_ser_id uuid PRIMARY KEY,
 CONSTRAINT fk_ses_ser_id FOREIGN KEY (ses_ser_id)
    REFERENCES dat.t_series_ser (ser_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
 CONSTRAINT uk_ses_ser_id UNIQUE (ses_ser_id) ,
 ses_station_code INTEGER NULL,
  CONSTRAINT fk_station_code FOREIGN KEY (ses_station_code) 
  REFERENCES "ref"."StationDictionary" ("Station_Code")   
  );
  

DROP TABLE IF EXISTS(dat.tj_seriesstation_ses); 
CREATE TABLE dat.tj_seriesstation_ses (
 ses_svc_id uuid PRIMARY KEY,
 CONSTRAINT fk_ses_svc_id FOREIGN KEY (ses_svc_code)
    REFERENCES ref.tr_seriesvocab_svc (svc_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
 CONSTRAINT uk_ses_svc_id UNIQUE (sem_svc_id) ,
 station_code INTEGER NULL
  CONSTRAINT fk_station_code FOREIGN KEY (ser_station_code) 
  REFERENCES "ref"."StationDictionary" ("Station_Code")   
  );
  

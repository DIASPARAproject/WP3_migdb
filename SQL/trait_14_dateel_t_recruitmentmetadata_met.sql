 -- notes I will need ref. tr_emu_emu for legacy with this table.
 -- but as the table will not be placed in the db
 -- I'm not programming foreign keys
 -- see
--DROP TABLE IF EXISTS dateel.t_recruitmentmetadata_met ;
CREATE TABLE dateel.t_recruitmentmetadata_met (
 met_ser_id uuid PRIMARY KEY,
 -- the following constraint ensure 1:1 relation to series
 CONSTRAINT fk_met_ser_id FOREIGN KEY (met_ser_id)
    REFERENCES dat.t_series_ser (ser_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
 CONSTRAINT uk_mrt_ser_id UNIQUE (met_ser_id) ,
met_sam_id int4 NULL,
--CONSTRAINT fk_met_sam_id FOREIGN KEY (met_sam_id) 
--   REFERENCES ref.tr_samplingtype_sam(sam_id)
 --  ON UPDATE CASCADE ON DELETE CASCADE,
   -- this one is a legacy from the old db, for this table
   -- intended only for WGEEL I'll not change it
met_emu_nameshort varchar(20) NOT NULL,
--CONSTRAINT fk_emu FOREIGN KEY (met_emu_nameshort,met_cou_code) 
--REFERENCES ref.tr_emu_emu(emu_nameshort,emu_cou_code)
--ON UPDATE CASCADE ON DELETE CASCADE,
met_qal_id INTEGER,
--FOREIGN KEY (met_qal_id) 
--REFERENCES  ref.tr_quality_qal(qal_id),
-- currently tr_quality_qal is only in ref (with values from wgeel) not refeel check ??
met_mixturegy BOOLEAN,
met_wetted_above NUMERIC,
met_wetted_total NUMERIC,
met_surfacebasin_upstream NUMERIC,
met_surfacebasin NUMERIC,
met_distanceseakm numeric NULL,
met_marinearea TEXT,
met_start_year INTEGER,
met_end_year INTEGER,
met_duration INTEGER,
met_missing INTEGER,
met_individual_length BOOLEAN,
met_individual_mass BOOLEAN,
met_conversion BOOLEAN,
met_conversion_comment BOOLEAN,
met_raw_to_reported TEXT,
met_internal_issues BOOLEAN,
met_internal_issues_comment TEXT,
met_other BOOLEAN,
met_other_comment TEXT,
met_restocking BOOLEAN,
met_restocking_comment TEXT,
met_barrier BOOLEAN,
met_barrier_comment TEXT,
met_mortality BOOLEAN,
met_mortality_comment TEXT,
met_ext_issues BOOLEAN,
met_ext_issues_comment TEXT,
met_environment BOOLEAN,
met_environment_comment TEXT)


GRANT ALL ON dateel.t_recruitmentmetadata_met TO diaspara_admin;
GRANT SELECT ON dateel.t_recruitmentmetadata_met TO diaspara_read; 


 -- notes I will need ref. tr_emu_emu for legacy with this table.

CREATE TABLE dat.t_seriesmetadata_met (
 met_svc_id uuid PRIMARY KEY,
 -- the following constraint ensure 1:1 relation to series
 CONSTRAINT fk_met_svc_id FOREIGN KEY (met_svc_id)
    REFERENCES ref.tr_seriesvocab_svc (svc_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
 CONSTRAINT uk_sem_svc_id UNIQUE (met_svc_id) ,
met_sam_id int4 NULL,
CONSTRAINT fk_met_sam_id FOREIGN KEY (met_sam_id) 
   REFERENCES ref.tr_samplingtype_sam(sam_id)
   ON UPDATE CASCADE ON DELETE CASCADE,
   -- this one is a legacy from the old db, for this table
   -- intended only for WGEEL I'll not change it
met_emu_nameshort varchar(20) NOT NULL,
CONSTRAINT fk_emu FOREIGN KEY (met_emu_nameshort,met_cou_code) 
REFERENCES ref.tr_emu_emu(emu_nameshort,emu_cou_code)
ON UPDATE CASCADE ON DELETE CASCADE,
met_qal_id INTEGER,
FOREIGN KEY (met_qal_id) 
REFERENCES  ref.tr_quality_qal(qal_id),
-- currently tr_quality_qal is only in ref (with values from wgeel) not refeel check ??
met_mixturegy boolean,
met_wetted_above NUMERIC,
met_wetted_total NUMERIC,
met_surfacebasin_upstream NUMERIC,
met_surfacebasin NUMERIC,
met_distanceseakm numeric NULL,
met_marinearea TEXT,
met_wso_id INTEGER,

)



COMMENT ON COLUMN dat.t_seriesmetadata_met.met_sam_id IS 'The sampling type corresponds to trap partial, trap total, commercial CPUE, commercial catch, etc., see tr_samplingtype_sam (sam_id)';
COMMENT ON COLUMN dat.t_seriesmetadata_met.met_emu_nameshort IS 'The EMU code'
COMMENT ON COLUMN dat.t_seriesmetadata_met.
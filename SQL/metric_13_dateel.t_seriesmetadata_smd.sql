CREATE TABLE dateel.t_seriesmetadata_sem (
 CONSTRAINT fk_sem_svc_id FOREIGN KEY (sem_svc_id)
    REFERENCES ref.tr_seriesvocab_svc (svc_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
 CONSTRAINT uk_sem_svc_id UNIQUE (sem_svc_id),
  CONSTRAINT fk_sem_hty_code FOREIGN KEY(sem_hty_code)
  REFERENCES ref.tr_habitattype_hty (hty_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_sem_are_code FOREIGN KEY (sem_are_code)
  REFERENCES ref.tr_area_are(are_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_ser_gea_code FOREIGN KEY (sem_gea_code)
  REFERENCES ref.tr_gear_gea(gea_code)
  ON UPDATE CASCADE ON DELETE CASCADE) INHERITS (dat.t_seriesmetadata_sem);
  COMMENT ON TABLE dat.t_seriesmetadata_sem IS 'Metadata for series, records in tr_seriesvocal_svc, t_series_ser, and
t_seriesmetadata are unique, they could be in a single table (on row). A series can have different type of data, annual series
in t_serannual_san, groupmetrics related to one year or migration season in t_serannual_san, and individual metrics.
Individual metrics and group metrics can have their own metadata. So this table of metadata, is one of the three
possible in the metricdb database.';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_svc_id IS 'UUID, identifier of the series, primary key, references the table ref.tr_seriesvocab_svc (svc_id)';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_datebegin IS 'Beginning date to which this metadata applies. Change in sampling scheme, sampling gear ... protocol will require a new entry';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_dateend IS 'Ending data to which this metadataapplies, leave NULL if the current metadata still holds.';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_description IS 'Sem description should comply with column svc_description in the vocabulary. Quick concise description of the series. Should include species, stage targeted, location and gear. e.g. Glass eel monitoring in the Vilaine estuary (France) with a trapping ladder.';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_hty_code IS 'Code of the habitat type, one of MO (marine open), MC (Marine coastal), T (Transitional water), FW (Freshwater), null accepted';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_are_code IS 'Code of the area, areas are geographical sector most often corresponding to stock units, see tr_area_are.';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_gea_code IS 'Code of the gear used, see tr_gear_gea';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_ccm_wso_id IS 'Code of the main catchment in the CCM database, are_code can be used also.';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_distanceseakm IS 'Distance to the sea, the centroid of the different sites can be used if a series is made of several stations.';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_stocking IS 'Boolean, Is there restocking (for eel) or artifical reproduction in the river / basin, affecting the series ? ';
COMMENT ON COLUMN dat.t_seriesmetadata_sem.sem_stockingcomment IS 'Comment on stocking';









-- comments on how to format the series for eel

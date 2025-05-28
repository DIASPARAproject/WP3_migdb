--

CREATE TABLE dat.t_seriesmetadata_sem (
 sem_svc_id uuid PRIMARY KEY,
 CONSTRAINT fk_sem_svc_id FOREIGN KEY (sem_svc_code)
    REFERENCES ref.tr_seriesvocab_svc (svc_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
 CONSTRAIN uk_sem_svc_id UNIQUE (sem_svc_id) ,
 sem_description TEXT NULL,
 sem_qal_id int4 NULL,
 sem_qal_comment TEXT NULL,
 sem_uni_code varchar(20) NULL,
  CONSTRAINT fk_sem_uni_code FOREIGN KEY(sem_uni_code)
  REFERENCES ref.tr_unit_uni(uni_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  sem_hty_code varchar(2) NULL,
  CONSTRAINT fk_sem_hty_code FOREIGN KEY(sem_hty_code)
  REFERENCES ref.tr_habitattype_hty
  ON UPDATE CASCADE ON DELETE RESTRICT,
  sem_locationdescription text NULL,
  sem_are_code TEXT NULL,
  CONSTRAINT c_fk_sem_are_code FOREIGN KEY (sem_are_code)
  REFERENCES ref.tr_area_are(are_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  sem_sam_id int4 NULL,
  sem_ccm_wso_id _int4 NULL, 
  sem_distanceseakm numeric NULL)

  
  
  
  CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(geom) = 2)),
  CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(geom) = 4326)),

  CONSTRAINT t_series_sem_pkey PRIMARY KEY (sem_id),

  CONSTRAINT c_fk_area_code FOREIGN KEY (sem_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_cou_code FOREIGN KEY (sem_cou_code) REFERENCES "ref".tr_country_cou(cou_code),
  CONSTRAINT c_fk_emu FOREIGN KEY (sem_emu_nameshort,sem_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code),
  CONSTRAINT c_fk_hty_code FOREIGN KEY (sem_hty_code) REFERENCES "ref".tr_habitattype_hty(hty_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_lfs_code FOREIGN KEY (sem_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qal_id FOREIGN KEY (sem_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sam_id FOREIGN KEY (sem_sam_id) REFERENCES "ref".tr_samplingtype_sam(sam_id),
  CONSTRAINT c_fk_sem_dts_datasource FOREIGN KEY (sem_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource),
  CONSTRAINT c_fk_sem_effort_uni_code FOREIGN KEY (sem_effort_uni_code) REFERENCES "ref".tr_units_uni(uni_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_tblcodeid FOREIGN KEY (sem_tblcodeid) REFERENCES "ref".tr_station("tblCodeID") ON UPDATE CASCADE,
  CONSTRAINT c_fk_typ_id FOREIGN KEY (sem_typ_id) REFERENCES "ref".tr_typeseries_typ(typ_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_uni_code FOREIGN KEY (sem_uni_code) REFERENCES "ref".tr_units_uni(uni_code),
  CONSTRAINT t_series_sem_ser_sam_gear_fkey FOREIGN KEY (ser_sam_gear) REFERENCES "ref".tr_gear_gea(gea_id)
);
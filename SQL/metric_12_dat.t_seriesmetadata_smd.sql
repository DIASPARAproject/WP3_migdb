



ser_comment text NULL,
  ser_uni_code varchar(20) NULL,
  ser_hty_code varchar(2) NULL,
  ser_locationdescription text NULL,
  ser_emu_nameshort varchar(20) NULL,
  ser_cou_code varchar(2) NULL,
  ser_area_division varchar(254) NULL,
  ser_tblcodeid int4 NULL,

  geom public.geometry NULL,
  ser_sam_id int4 NULL,
  ser_qal_id int4 NULL,
  ser_qal_comment text NULL,
  ser_ccm_wso_id _int4 NULL,
  ser_dts_datasource varchar(100) NULL,
  ser_distanceseakm numeric NULL,
  ser_method text NULL,
  ser_sam_gear int4 NULL,
  ser_restocking bool NULL,
  
  
  
  CONSTRAINT enforce_dims_the_geom CHECK ((st_ndims(geom) = 2)),
  CONSTRAINT enforce_srid_the_geom CHECK ((st_srid(geom) = 4326)),

  CONSTRAINT t_series_ser_pkey PRIMARY KEY (ser_id),

  CONSTRAINT c_fk_area_code FOREIGN KEY (ser_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_cou_code FOREIGN KEY (ser_cou_code) REFERENCES "ref".tr_country_cou(cou_code),
  CONSTRAINT c_fk_emu FOREIGN KEY (ser_emu_nameshort,ser_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code),
  CONSTRAINT c_fk_hty_code FOREIGN KEY (ser_hty_code) REFERENCES "ref".tr_habitattype_hty(hty_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_lfs_code FOREIGN KEY (ser_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qal_id FOREIGN KEY (ser_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_sam_id FOREIGN KEY (ser_sam_id) REFERENCES "ref".tr_samplingtype_sam(sam_id),
  CONSTRAINT c_fk_ser_dts_datasource FOREIGN KEY (ser_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource),
  CONSTRAINT c_fk_ser_effort_uni_code FOREIGN KEY (ser_effort_uni_code) REFERENCES "ref".tr_units_uni(uni_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_tblcodeid FOREIGN KEY (ser_tblcodeid) REFERENCES "ref".tr_station("tblCodeID") ON UPDATE CASCADE,
  CONSTRAINT c_fk_typ_id FOREIGN KEY (ser_typ_id) REFERENCES "ref".tr_typeseries_typ(typ_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_uni_code FOREIGN KEY (ser_uni_code) REFERENCES "ref".tr_units_uni(uni_code),
  CONSTRAINT t_series_ser_ser_sam_gear_fkey FOREIGN KEY (ser_sam_gear) REFERENCES "ref".tr_gear_gea(gea_id)
);
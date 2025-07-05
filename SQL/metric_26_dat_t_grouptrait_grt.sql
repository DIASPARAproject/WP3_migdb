
-- DROP TABLE IF EXISTS dat.t_grouptrait_grt CASCADE;


CREATE TABLE dat.t_grouptrait_grt (
  grt_ser_id uuid,
 CONSTRAINT fk_grt_ser_id FOREIGN KEY (grt_ser_id)
    REFERENCES dat.t_series_ser (ser_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
  grt_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_grt_wkg_code  FOREIGN KEY (grt_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  grt_spe_code TEXT NOT NULL,  
  CONSTRAINT fk_grt_spe_code  FOREIGN KEY (grt_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  grt_id serial4 NOT NULL,
  grt_gr_id int4 NOT NULL,
  CONSTRAINT fk_grt_gr_id FOREIGN KEY (grt_gr_id, grt_wkg_code) 
  REFERENCES dat.t_group_gr(gr_id,gr_wkg_code) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  grt_tra_code TEXT NOT NULL,
  CONSTRAINT fk_grt_tra_code FOREIGN KEY (grt_tra_code) 
  REFERENCES ref.tr_trait_tra(tra_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  grt_value numeric NULL,
  grt_trv_code TEXT,
  CONSTRAINT fk_grt_trv_tra_code FOREIGN KEY (grt_trv_code, grt_tra_code,grt_wkg_code)
  REFERENCES ref.tr_traitvaluequal_trv(trv_code, trv_trq_code, trv_wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  grt_trm_code TEXT,
  CONSTRAINT fk_grt_trm_code FOREIGN KEY (grt_trm_code)
  REFERENCES ref.tr_traitmethod_trm(trm_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  grt_last_update date DEFAULT CURRENT_DATE NOT NULL,
  grt_qal_code int4 NULL,
    CONSTRAINT fk_grt_qal_id FOREIGN KEY (grt_qal_code) 
  REFERENCES ref.tr_quality_qal(qal_code) ON UPDATE CASCADE,
  grt_ver_code TEXT NOT NULL,
  CONSTRAINT fk_grt_ver_code FOREIGN KEY (grt_ver_code)
  REFERENCES ref.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT uk_grt_gr UNIQUE (grt_gr_id, grt_trm_code, grt_wkg_code),
  CONSTRAINT t_grouptrait_grt_pkey PRIMARY KEY (grt_id, grt_wkg_code),
  CONSTRAINT ck_qualitative_or_numeric CHECK 
  (
  (grt_value IS NULL AND grt_trv_code IS NOT NULL) OR
  (grt_value IS NOT NULL AND grt_trv_code IS  NULL)
  )
);
CREATE INDEX dat_t_grouptrait_grt_idx ON dat.t_grouptrait_grt USING btree (grt_gr_id);

GRANT ALL ON dat.t_grouptrait_grt TO diaspara_admin;
GRANT SELECT ON dat.t_grouptrait_grt TO diaspara_read; 

DROP TABLE IF EXISTS  dateel.t_grouptrait_grt;
CREATE TABLE dateel.t_grouptrait_grt (
 CONSTRAINT fk_grt_ser_id FOREIGN KEY (grt_ser_id)
    REFERENCES dateel.t_series_ser (ser_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_grt_wkg_code  FOREIGN KEY (grt_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_grt_spe_code  FOREIGN KEY (grt_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_grt_gr_id FOREIGN KEY (grt_gr_id, grt_wkg_code) 
  REFERENCES dateel.t_group_gr(gr_id,gr_wkg_code) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_grt_tra_code FOREIGN KEY (grt_tra_code) 
  REFERENCES refeel.tg_trait_tra(tra_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_grt_trv_tra_code FOREIGN KEY (grt_trv_code, grt_tra_code) 
  -- unlike in dat.t_grouptrait_grt this one does not take ref TO wkgcode, no need AS we are in dateel
  REFERENCES refeel.tr_traitvaluequal_trv(trv_code, trv_trq_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_grt_trm_code FOREIGN KEY (grt_trm_code)
  REFERENCES refeel.tr_traitmethod_trm(trm_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_grt_qal_id FOREIGN KEY (grt_qal_code) 
  REFERENCES ref.tr_quality_qal(qal_code) ON UPDATE CASCADE,
  CONSTRAINT fk_grt_ver_code FOREIGN KEY (grt_ver_code)
  REFERENCES refeel.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT uk_trv_gr_id_trv_tra_code UNIQUE(grt_gr_id,grt_tra_code)
) INHERITS (dat.t_grouptrait_grt);
CREATE INDEX dateel_t_grouptrait_grt_idx ON dateel.t_grouptrait_grt USING btree (grt_gr_id);
GRANT ALL ON dateel.t_grouptrait_grt TO diaspara_admin;
GRANT SELECT ON dateel.t_grouptrait_grt TO diaspara_read; 


COMMENT ON TABLE dateel.t_grouptrait_grt IS 'Table joining groups and traits';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_ser_id IS 'Series UUID';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_wkg_code IS 'Working group on of WGEEL, WGNAS, WGBAST ...';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_spe_code IS 'Species code here ANG';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_id IS 'ID, integer, unique for wkg_code';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_gr_id IS 'ID of the group';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_tra_code IS 'Code of the trait, e.g. Lengthmm';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_value IS 'Value for numeric';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_trv_code IS 'Value for qualitative see refeel.tr_traitvaluequal_trv';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_trm_code IS 'Method see refeel.tr_traimethod_trm';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_last_update IS 'date last update';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_qal_code IS 'Quality code references ref.tr_quality_qal';
COMMENT ON COLUMN dateel.t_grouptrait_grt.grt_ver_code IS 'version e.g. WGEEL_2024_1';

-- TODO trigger on date
-- TODO
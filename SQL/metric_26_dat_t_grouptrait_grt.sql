
-- DROP TABLE IF EXISTS dat.t_grouptrait_grt;


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
  grt_value numeric NOT NULL,
  grt_trv_code TEXT,
  CONSTRAINT fk_grt_qal_code FOREIGN KEY (grt_trv_code)
  REFERENCES ref.tr_traitvaluequal_trv(trv_code)
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
  CONSTRAINT ck_uk_grt_gr UNIQUE (grt_gr_id, grt_trm_code, grt_wkg_code),
  CONSTRAINT t_grouptrait_grt_pkey PRIMARY KEY (grt_id, grt_wkg_code)
);
CREATE INDEX t_grt_group_gr_idx ON dat.t_grouptrait_grt USING btree (grt_gr_id);

GRANT ALL ON dat.t_grouptrait_grt TO diaspara_admin;
GRANT SELECT ON dat.t_grouptrait_grt TO diaspara_read; 



CREATE TABLE dateel.t_grouptrait_grt (
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
  grt_value numeric NOT NULL,
  grt_trv_code TEXT,
  CONSTRAINT fk_grt_qal_code FOREIGN KEY (grt_trv_code)
  REFERENCES ref.tr_traitvaluequal_trv(trv_code)
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
  CONSTRAINT ck_uk_grt_gr UNIQUE (grt_gr_id, grt_trm_code, grt_wkg_code),
  CONSTRAINT t_grouptrait_grt_pkey PRIMARY KEY (grt_id, grt_wkg_code)
) INHERITS (dat.t_grouptrait_grt);
CREATE INDEX t_grt_group_gr_idx ON dat.t_grouptrait_grt USING btree (grt_gr_id);

GRANT ALL ON dat.t_grouptrait_grt TO diaspara_admin;
GRANT SELECT ON dat.t_grouptrait_grt TO diaspara_read; 




-- Table Triggers TODO
/*
CREATE TRIGGER check_grt_mty_is_group AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_grouptrait_meg FOR EACH ROW EXECUTE FUNCTION grt_mty_is_group();
CREATE TRIGGER update_grt_last_update BEFORE
INSERT
    OR
UPDATE
    ON
    datawg.t_grouptrait_meg FOR EACH ROW EXECUTE FUNCTION grt_last_update();
*/
  

-- DROP TABLE datawg.t_grouptrait_grt;


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
  CONSTRAINT fk_grt_gr_id FOREIGN KEY (grt_gr_id) 
  REFERENCES dat.t_group_gr(gr_id) 
  ON DELETE CASCADE ON UPDATE CASCADE,
  grt_tra_code TEXT NOT NULL,
  CONSTRAINT fk_grt_tra_code FOREIGN KEY (grt_tra_code) 
  REFERENCES refeel.tr_trait_tra(tra_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  grt_value numeric NOT NULL,
  grt_qal_code TEXT,
  CONSTRAINT fk_grt_qal_code FOREIGN KEY (grt_qal_code)
  REFERENCES refeel.tr_traitqualitative_trq(qal_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  grt_trm_code TEXT, 
  grt_last_update date DEFAULT CURRENT_DATE NOT NULL,
  grt_qal_id int4 NULL,
  grt_ver_code TEXT NOT NULL,
  CONSTRAINT fk_grt_ver_code FOREIGN KEY (grt_ver_code)
  REFERENCES ref.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_uk_grt_gr UNIQUE (grt_gr_id, grt_mty_id, grt_wkg_code),
  CONSTRAINT t_grouptrait_grt_pkey PRIMARY KEY (grt_id, grt_wkg_code),



  CONSTRAINT fk_grt_qal_id FOREIGN KEY (grt_qal_id) 
  REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE
);
CREATE INDEX t_grt_group_gr_idx ON dat.t_grouptrait_meg USING btree (grt_gr_id);

GRANT ALL ON dat.t_grouptrait_meg TO diaspara_admin;
GRANT SELECT ON dat.t_grouptrait_meg TO diaspara_read; 



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
  
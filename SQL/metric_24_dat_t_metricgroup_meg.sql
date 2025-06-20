
-- DROP TABLE datawg.t_group_gr;


CREATE TABLE dat.t_metricgroup_meg (
  meg_ser_id uuid,
 CONSTRAINT fk_meg_ser_id FOREIGN KEY (meg_ser_id)
    REFERENCES dat.t_series_ser (ser_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
  meg_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_meg_wkg_code  FOREIGN KEY (meg_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  meg_id serial4 NOT NULL,
  meg_gr_id int4 NOT NULL,
  CONSTRAINT fk_meg_gr_id FOREIGN KEY (meg_gr_id) 
  REFERENCES dat.t_group_gr(gr_id) 
  ON DELETE CASCADE ON UPDATE CASCADE,
  meg_mty_id int4 NOT NULL,
  CONSTRAINT fk_meg_mty_id FOREIGN KEY (meg_mty_id) 
  REFERENCES ref.tr_metrictype_mty(mty_id)
  ON UPDATE CASCADE,
  meg_value numeric NOT NULL,
  meg_last_update date DEFAULT CURRENT_DATE NOT NULL,
  meg_qal_id int4 NULL,
  meg_ver_code TEXT NOT NULL,
  CONSTRAINT fk_meg_ver_code FOREIGN KEY (meg_ver_code)
  REFERENCES ref.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_uk_meg_gr UNIQUE (meg_gr_id, meg_mty_id, meg_wkg_code),
  CONSTRAINT t_metricgroup_meg_pkey PRIMARY KEY (meg_id, meg_wkg_code),



  CONSTRAINT fk_meg_qal_id FOREIGN KEY (meg_qal_id) 
  REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE
);
CREATE INDEX t_meg_group_gr_idx ON dat.t_metricgroup_meg USING btree (meg_gr_id);

GRANT ALL ON dat.t_metricgroup_meg TO diaspara_admin;
GRANT SELECT ON dat.t_metricgroup_meg TO diaspara_read; 



-- Table Triggers TODO
/*
CREATE TRIGGER check_meg_mty_is_group AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_metricgroup_meg FOR EACH ROW EXECUTE FUNCTION meg_mty_is_group();
CREATE TRIGGER update_meg_last_update BEFORE
INSERT
    OR
UPDATE
    ON
    datawg.t_metricgroup_meg FOR EACH ROW EXECUTE FUNCTION meg_last_update();
*/
  
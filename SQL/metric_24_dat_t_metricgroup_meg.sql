
-- DROP TABLE datawg.t_group_gr;


CREATE TABLE dat.t_metricgroup_meg (
  meg_ser_id uuid
 CONSTRAINT fk_meg_ser_id FOREIGN KEY (meg_svc_id)
    REFERENCES dat.t_series_ser (svc_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
  meg_id serial4 NOT NULL,
  meg_gr_id int4 NOT NULL,
  meg_mty_id int4 NOT NULL,
  meg_value numeric NOT NULL,
  meg_last_update date DEFAULT CURRENT_DATE NOT NULL,
  meg_qal_id int4 NULL,
  meg_dts_datasource varchar(100) NULL,
  CONSTRAINT ck_uk_meg_gr UNIQUE (meg_gr_id, meg_mty_id),
  CONSTRAINT t_metricgroup_meg_pkey PRIMARY KEY (meg_id),
  CONSTRAINT fk_meg_dts_datasource FOREIGN KEY (meg_dts_datasource) REFERENCES "ref".tr_datasource_dts(dts_datasource) ON UPDATE CASCADE,
  CONSTRAINT fk_meg_gr_id FOREIGN KEY (meg_gr_id) REFERENCES datawg.t_group_gr(gr_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_meg_mty_id FOREIGN KEY (meg_mty_id) REFERENCES "ref".tr_metrictype_mty(mty_id) ON UPDATE CASCADE,
  CONSTRAINT fk_meg_qal_id FOREIGN KEY (meg_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE
);
CREATE INDEX t_meg_group_gr_fkey ON datawg.t_metricgroup_meg USING btree (meg_gr_id);

-- Table Triggers

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

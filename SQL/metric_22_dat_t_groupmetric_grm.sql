--DROP TABLE dat.t_metadataannual_man

CREATE TABLE dat.t_metadataannual_man (
man_svc_id uuid
 CONSTRAINT fk_man_svc_id FOREIGN KEY (man_svc_id)
    REFERENCES ref.tr_seriesvocab_svc (svc_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
 man_datebegin date NULL,
 man_dateend date NULL,
 man_effort_uni_code varchar(20) NULL,
  CONSTRAINT fk_man_effort_uni_code FOREIGN KEY(man_effort_uni_code)
  REFERENCES ref.tr_unit_uni(uni_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,  
  man_method text NULL,
  man_sam_gear int4 NULL


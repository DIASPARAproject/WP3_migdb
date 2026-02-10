DROP TABLE IF EXISTS datnas.t_fish_fi;
CREATE TABLE datnas.t_fish_fi (
  CONSTRAINT fk_fi_ser_id FOREIGN KEY (fi_ser_id)
  REFERENCES datnas.t_series_ser (ser_id) 
  ON UPDATE CASCADE ON DELETE CASCADE, 
  CONSTRAINT fk_fi_wkg_code  FOREIGN KEY (fi_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT t_fish_fi_pkey PRIMARY KEY (fi_id, fi_wkg_code),
  CONSTRAINT fk_fi_spe_code FOREIGN KEY (fi_spe_code) 
  REFERENCES ref.tr_species_spe(spe_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_fi_lfs_code_fi_spe_code FOREIGN KEY (fi_lfs_code, fi_spe_code)
  REFERENCES ref.tr_lifestage_lfs (lfs_code, lfs_spe_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT ck_fi_date_fi_year CHECK (((fi_date IS NOT NULL) OR (fi_year IS NOT NULL))),
  CONSTRAINT fk_gr_ver_code FOREIGN KEY (fi_ver_code)
  REFERENCES refnas.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT  
) INHERITS (dat.t_fish_fi);
 

GRANT ALL ON datnas.t_fish_fi TO diaspara_admin;
GRANT SELECT ON datnas.t_fish_fi TO diaspara_read;  

GRANT ALL ON SEQUENCE t_fish_fi_fi_id_seq TO diaspara_admin;    
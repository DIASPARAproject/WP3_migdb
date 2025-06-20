
-- DROP TABLE dateel.t_group_gr;

CREATE TABLE dateel.t_group_gr (
  CONSTRAINT fk_gr_wkg_code  FOREIGN KEY (gr_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT t_group_gr_pkey PRIMARY KEY (gr_id, gr_wkg_code), 
  CONSTRAINT fk_gr_ver_code FOREIGN KEY (grser_ver_code)
  REFERENCES ref.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT
) INHERITS (dat.t_group_gr);




DROP TABLE IF EXISTS dateel.t_metadata_met;

CREATE TABLE dateel.t_metadata_met(
 CONSTRAINT t_metadata_met_pkey PRIMARY KEY(met_var, met_spe_code),
 CONSTRAINT fk_met_spe_code FOREIGN KEY (met_spe_code)
  REFERENCES ref.tr_species_spe(spe_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,
 CONSTRAINT ck_met_spe_code CHECK (met_spe_code='ANG'),
 CONSTRAINT fk_met_wkg_code FOREIGN KEY (met_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT ck_met_wkg_code CHECK (met_wkg_code='WGEEL'),
  CONSTRAINT fk_met_ver_code FOREIGN KEY (met_ver_code)
  REFERENCES refeel.tr_version_ver(ver_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_met_oty_code FOREIGN KEY (met_oty_code) 
  REFERENCES ref.tr_objecttype_oty (oty_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_met_nim_code FOREIGN KEY (met_nim_code) 
  REFERENCES ref.tr_nimble_nim (nim_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,  
  CONSTRAINT fk_met_mtr_code FOREIGN KEY (met_mtr_code)
  REFERENCES ref.tr_metric_mtr(mtr_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_met_uni_code FOREIGN KEY (met_uni_code)
  REFERENCES ref.tr_units_uni(uni_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_met_cat_code FOREIGN KEY (met_cat_code)
  REFERENCES ref.tr_category_cat(cat_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_met_des_code FOREIGN KEY (met_des_code)
  REFERENCES ref.tr_destination_des(des_code)
  ON UPDATE CASCADE ON DELETE RESTRICT
)
INHERITS (dat.t_metadata_met);



--  COMMENTS FOR WGEEL

COMMENT ON TABLE dateel.t_metadata_met IS 
'Table (metadata) of each variable (parameter) in the wgeel database.';
COMMENT ON COLUMN dateel.t_metadata_met.met_var 
IS 'Variable code, primary key on both met_spe_code and met_var.';
COMMENT ON COLUMN dateel.t_metadata_met.met_spe_code 
IS 'Species, ANG primary key on both met_spe_code and met_var.';
COMMENT ON COLUMN dateel.t_metadata_met.met_ver_code 
IS 'Code on the version of the model, see table refeel.tr_version_ver.';
COMMENT ON COLUMN dateel.t_metadata_met.met_oty_code 
IS 'Object type, single_value, vector, matrix see table tr_objecttype_oty.';
COMMENT ON COLUMN dateel.t_metadata_met.met_nim_code 
IS 'Nimble type, one of data, constant, output, other.';
COMMENT ON COLUMN dateel.t_metadata_met.met_dim 
IS 'Dimension of the Nimble variable, use {10, 100, 100} 
to insert the description of an array(10,100,100).';
COMMENT ON COLUMN dateel.t_metadata_met.met_dimname 
IS 'Dimension of the variable in Nimble, use {''year'', ''stage'', ''area''}.';
COMMENT ON COLUMN dateel.t_metadata_met.met_modelstage 
IS 'Currently one of fit, other, First year.';
COMMENT ON COLUMN dateel.t_metadata_met.met_type 
IS 'Type of data in the variable, homewatercatches, InitialISation first year,
abundance ....';
COMMENT ON COLUMN dateel.t_metadata_met.met_location 
IS 'Describe process with geographical information';
COMMENT ON COLUMN dateel.t_metadata_met.met_fishery 
IS 'Description of the fishery.';
COMMENT ON COLUMN dateel.t_metadata_met.met_des_code 
IS 'Destination of the fish, e.g. Released (alive), Seal damage,
Removed (from the environment), references table tr_destination_des., this is currently only used by WGBAST,
so can be kept NULL';
COMMENT ON COLUMN dateel.t_metadata_met.met_uni_code 
IS 'Unit, dateelerences table tr_unit_uni.';
COMMENT ON COLUMN dateel.t_metadata_met.met_cat_code 
IS 'Broad category of data or parameter, 
catch, effort, biomass, mortality, count ...dateelerences table tr_category_cat.';
COMMENT ON COLUMN dateel.t_metadata_met.met_mtr_code 
IS 'Code of the metric, dateelerences tr_metric_mtr, Estimate, Bound, SD, CV ....';
COMMENT ON COLUMN dateel.t_metadata_met.met_definition 
IS 'Definition of the metric.';
COMMENT ON COLUMN dateel.t_metadata_met.met_deprecated
IS'Is the variable still used ?';



ALTER TABLE dateel.t_metadata_met OWNER TO diaspara_admin;
GRANT SELECT ON dateel.t_metadata_met TO diaspara_read;



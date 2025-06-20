
DROP TABLE IF EXISTS dat.t_metadata_met CASCADE;
CREATE TABLE dat.t_metadata_met (
  met_var TEXT NOT NULL,
  met_spe_code character varying(3) NOT  NULL,
  met_wkg_code TEXT NOT NULL,
  met_ver_code TEXT NULL,
  met_oty_code TEXT NOT NULL,
  met_nim_code TEXT NOT NULL,
  met_dim integer ARRAY,
  met_dimname TEXT ARRAY,
  met_modelstage TEXT NULL, 
  met_type TEXT NULL,
  met_location TEXT NULL,
  met_fishery TEXT NULL,
  met_mtr_code TEXT NULL,
  met_des_code TEXT NULL,
  met_uni_code TEXT NULL,
  met_cat_code TEXT NULL,
  met_definition TEXT NULL, 
  met_deprecated BOOLEAN DEFAULT FALSE,
  CONSTRAINT t_metadata_met_pkey PRIMARY KEY(met_var, met_spe_code),
  CONSTRAINT fk_met_spe_code FOREIGN KEY (met_spe_code)
  REFERENCES ref.tr_species_spe(spe_code) 
  ON DELETE CASCADE
  ON UPDATE CASCADE,
    CONSTRAINT fk_met_wkg_code FOREIGN KEY (met_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code) 
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT fk_met_ver_code FOREIGN KEY (met_ver_code)
  REFERENCES ref.tr_version_ver(ver_code) 
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT fk_met_oty_code FOREIGN KEY (met_oty_code) 
  REFERENCES ref.tr_objecttype_oty (oty_code) ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT fk_met_nim_code FOREIGN KEY (met_nim_code) 
  REFERENCES ref.tr_nimble_nim (nim_code) ON DELETE CASCADE
  ON UPDATE CASCADE,  
  CONSTRAINT fk_met_mtr_code FOREIGN KEY (met_mtr_code)
  REFERENCES ref.tr_metric_mtr(mtr_code)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT fk_met_uni_code FOREIGN KEY (met_uni_code)
  REFERENCES ref.tr_units_uni(uni_code)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT fk_met_cat_code FOREIGN KEY (met_cat_code)
  REFERENCES ref.tr_category_cat(cat_code)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT fk_met_des_code FOREIGN KEY (met_des_code)
  REFERENCES ref.tr_destination_des(des_code)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
COMMENT ON TABLE dat.t_metadata_met IS 
'Table (metadata) of each variable (parameter) in the database.';
COMMENT ON COLUMN dat.t_metadata_met.met_var 
IS 'Variable code, primary key on both met_spe_code and met_var.';
COMMENT ON COLUMN dat.t_metadata_met.met_spe_code 
IS 'Species, ANG, SAL, TRT ... primary key on both met_spe_code and met_var.';
COMMENT ON COLUMN dat.t_metadata_met.met_ver_code 
IS 'Code on the version of the model, see table tr_version_ver.';
COMMENT ON COLUMN dat.t_metadata_met.met_oty_code 
IS 'Object type, single_value, vector, matrix see table tr_objecttype_oty.';
COMMENT ON COLUMN dat.t_metadata_met.met_nim_code 
IS 'Nimble type, one of data, constant, output, other.';
COMMENT ON COLUMN dat.t_metadata_met.met_dim 
IS 'Dimension of the Nimble variable, use {10, 100, 100} 
to insert the description of an array(10,100,100).';
COMMENT ON COLUMN dat.t_metadata_met.met_dimname 
IS 'Dimension of the variable in Nimble, use {''year'', ''stage'', ''area''}.';
COMMENT ON COLUMN dat.t_metadata_met.met_modelstage 
IS 'Currently one of fit, other, First year.';
COMMENT ON COLUMN dat.t_metadata_met.met_type 
IS 'Type of data in the variable, homewatercatches, InitialISation first year,
abundance ....';
COMMENT ON COLUMN dat.t_metadata_met.met_location 
IS 'Describe process at sea, e.g. Btw. FAR - GLD fisheries, or Aft. Gld fISheries.';
COMMENT ON COLUMN dat.t_metadata_met.met_fishery 
IS 'Description of the fishery.';
COMMENT ON COLUMN dat.t_metadata_met.met_des_code 
IS 'Outcome of the fish, e.g. Released (alive), Seal damage,
Removed (from the environment), references table tr_destination_des.';
COMMENT ON COLUMN dat.t_metadata_met.met_uni_code 
IS 'Unit, references table tr_unit_uni.';
COMMENT ON COLUMN dat.t_metadata_met.met_cat_code 
IS 'Broad category of data or parameter, 
catch, effort, biomass, mortality, count ...references table tr_category_cat.';
COMMENT ON COLUMN dat.t_metadata_met.met_mtr_code 
IS 'Code of the metric, references tr_metric_mtr, Estimate, Bound, SD, CV ....';
COMMENT ON COLUMN dat.t_metadata_met.met_definition 
IS 'Definition of the metric.';
COMMENT ON COLUMN dat.t_metadata_met.met_deprecated
IS'Is the variable still used ?';

GRANT ALL ON dat.t_metadata_met TO diaspara_admin;
GRANT SELECT ON dat.t_metadata_met TO diaspara_read;




/*
SELECT * FROM refsalmoglob."database" JOIN
datnas.t_metadata_met AS tmm ON tmm.met_var = var_mod
WHERE "year" IS NULL
*/

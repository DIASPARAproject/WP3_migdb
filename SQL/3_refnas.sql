
DROP TABLE IF EXISTS refnas.tr_version_ver CASCADE;
CREATE TABLE refnas.tr_version_ver() inherits (ref.tr_version_ver);

ALTER TABLE refnas.tr_version_ver ADD CONSTRAINT ver_code_pkey PRIMARY KEY (ver_code);
ALTER TABLE refnas.tr_version_ver ADD CONSTRAINT  fk_ver_spe_code FOREIGN KEY (ver_spe_code) 
REFERENCES ref.tr_species_spe(spe_code)
ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON TABLE refnas.tr_version_ver
IS 'Table of data or variable version, essentially one datacall or advice, inherits ref.tr_version_ver';

COMMENT ON COLUMN refnas.tr_version_ver.ver_version 
IS 'Version code, stockkey-year-version.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_year 
IS 'Year of assessement.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_spe_code 
IS 'Species code e.g. 'SAL' references tr_species_spe.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_stockkeylabel 
IS 'Ver_stockkeylabel e.g. ele.2737.nea.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_datacalldoi 
IS 'Data call DOI, find a way to retrieve that information 
and update this comment';
COMMENT ON COLUMN refnas.tr_version_ver.ver_version 
IS 'Version code in original database, eg 2,4 for wgnas, dc_2020 for wgeel.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_description 
IS 'Description of the data call / version.';
GRANT ALL ON refnas.tr_version_ver TO diaspara_admin;
GRANT SELECT ON refnas.tr_version_ver TO diaspara_read;


-- values inserted in chunk tr_version_ver insert


DROP TABLE IF EXISTS refnas.tr_metadata_met;

CREATE TABLE refnas.tr_metadata_met(met_oldversion numeric)
INHERITS (ref.tr_metadata_met);


-- ADDING CONSTRAINTS

ALTER TABLE refnas.tr_metadata_met ADD
 CONSTRAINT t_metadata_met_pkey PRIMARY KEY(met_var, met_spe_code);
 
ALTER TABLE refnas.tr_metadata_met ADD 
  CONSTRAINT fk_met_spe_code FOREIGN KEY (met_spe_code)
  REFERENCES ref.tr_species_spe(spe_code) 
  ON DELETE CASCADE
  ON UPDATE CASCADE;

 ALTER TABLE refnas.tr_metadata_met ADD
    CONSTRAINT ck_met_spe_code CHECK (met_spe_code='SAL'); 

 ALTER TABLE refnas.tr_metadata_met ADD
    CONSTRAINT fk_met_wkg_code FOREIGN KEY (met_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code) 
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE refnas.tr_metadata_met ADD
    CONSTRAINT ck_met_wkg_code CHECK (met_wkg_code='WGNAS');

ALTER TABLE refnas.tr_metadata_met ADD
  CONSTRAINT fk_met_ver_code FOREIGN KEY (met_ver_code)
  REFERENCES refnas.tr_version_ver(ver_code) 
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE refnas.tr_metadata_met ADD
  CONSTRAINT fk_met_oty_code FOREIGN KEY (met_oty_code) 
  REFERENCES ref.tr_objecttype_oty (oty_code) ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE refnas.tr_metadata_met ADD
  CONSTRAINT fk_met_nim_code FOREIGN KEY (met_nim_code) 
  REFERENCES ref.tr_nimble_nim (nim_code) ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE refnas.tr_metadata_met ADD  
  CONSTRAINT fk_met_mtr_code FOREIGN KEY (met_mtr_code)
  REFERENCES ref.tr_metric_mtr(mtr_code)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE refnas.tr_metadata_met ADD
  CONSTRAINT fk_met_uni_code FOREIGN KEY (met_uni_code)
  REFERENCES ref.tr_units_uni(uni_code)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE refnas.tr_metadata_met ADD
  CONSTRAINT fk_met_cat_code FOREIGN KEY (met_cat_code)
  REFERENCES ref.tr_category_cat(cat_code)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE refnas.tr_metadata_met ADD
  CONSTRAINT fk_met_des_code FOREIGN KEY (met_des_code)
  REFERENCES ref.tr_destination_des(des_code)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
--  COMMENTS FOR WGNAS


COMMENT ON TABLE refnas.tr_metadata_met IS 
'Table (metadata) of each variable (parameter) in the wgnas database.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_var 
IS 'Variable code, primary key on both met_spe_code and met_var.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_spe_code 
IS 'Species, SAL primary key on both met_spe_code and met_var.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_ver_code 
IS 'Code on the version of the model, see table tr_version_ver.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_oty_code 
IS 'Object type, single_value, vector, matrix see table tr_objecttype_oty.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_nim_code 
IS 'Nimble type, one of data, constant, output, other.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_dim 
IS 'Dimension of the Nimble variable, use {10, 100, 100} 
to insert the description of an array(10,100,100).';
COMMENT ON COLUMN refnas.tr_metadata_met.met_dimname 
IS 'Dimension of the variable in Nimble, use {''year'', ''stage'', ''area''}.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_modelstage 
IS 'Currently one of fit, other, First year.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_type 
IS 'Type of data in the variable, homewatercatches, InitialISation first year,
abundance ....';
COMMENT ON COLUMN refnas.tr_metadata_met.met_location 
IS 'Describe process at sea, e.g. Btw. FAR - GLD fisheries, or Aft. Gld fISheries.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_fishery 
IS 'Description of the fishery.';
COMMENT ON COLUMN ref.tr_metadata_met.met_des_code 
IS 'Destination of the fish, e.g. Released (alive), Seal damage,
Removed (from the environment), references table tr_destination_des., this is currently only used by WGBAST,
so can be kept NULL';
COMMENT ON COLUMN refnas.tr_metadata_met.met_uni_code 
IS 'Unit, refnaserences table tr_unit_uni.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_cat_code 
IS 'Broad category of data or parameter, 
catch, effort, biomass, mortality, count ...refnaserences table tr_category_cat.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_mtr_code 
IS 'Code of the metric, refnaserences tr_metric_mtr, Estimate, Bound, SD, CV ....';
COMMENT ON COLUMN refnas.tr_metadata_met.met_definition 
IS 'Definition of the metric.';
COMMENT ON COLUMN refnas.tr_metadata_met.met_deprecated
IS'Is the variable still used ?';


GRANT ALL ON refnas.tr_metadata_met TO diaspara_admin;
GRANT SELECT ON refnas.tr_metadata_met TO diaspara_read;





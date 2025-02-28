
-- the code is here : SQL/tr_metadata_met.sql
-- we first create all referential tables then the metadata itself

DROP TABLE IF EXISTS ref.tr_objecttype_oty CASCADE;
CREATE TABLE ref.tr_objecttype_oty (
oty_code TEXT PRIMARY KEY,
oty_description TEXT
);

INSERT INTO ref.tr_objecttype_oty VALUES ('Single_value', 'Single value');
INSERT INTO ref.tr_objecttype_oty VALUES ('Vector', 'One dimension vector');
INSERT INTO ref.tr_objecttype_oty VALUES ('Matrix', 'Two dimensions matrix');
INSERT INTO ref.tr_objecttype_oty VALUES ('Array', 'Three dimensions array');

COMMENT ON TABLE ref.tr_objecttype_oty IS 
'Table indicating the dimensions of the object stored in the model, 
single value, vector, matrix, array';

COMMENT ON COLUMN ref.tr_objecttype_oty.oty_code IS 
'code of the object type, single_value, vector, ...';

COMMENT ON COLUMN ref.tr_objecttype_oty.oty_code IS 'description of the object type';
GRANT ALL ON ref.tr_objecttype_oty TO diaspara_admin;
GRANT SELECT ON ref.tr_objecttype_oty TO diaspara_read;
--nimble

DROP TABLE IF EXISTS ref.tr_nimble_nim CASCADE;
CREATE TABLE ref.tr_nimble_nim (
nim_code TEXT PRIMARY KEY,
nim_description TEXT
);

COMMENT ON TABLE ref.tr_nimble_nim IS 
'Indicate the type of data, parameter constant, parameter estimate, output, other ...';
-- Note this is a mix of nimble and status, which mean the same....

INSERT INTO ref.tr_nimble_nim VALUES ('Data', 'Data entry to the model');
INSERT INTO ref.tr_nimble_nim 
VALUES ('Parameter constant', 'Parameter input to the model');
INSERT INTO ref.tr_nimble_nim 
VALUES ('Parameter estimate', 'Parameter input to the model');
INSERT INTO ref.tr_nimble_nim 
VALUES ('Output', 'Output from the model, derived quantity');
-- Do we want another type here ?
--INSERT INTO ref.tr_nimble_nim VALUES ('observation', 'Observation not used in the model');
INSERT INTO ref.tr_nimble_nim 
VALUES ('Other', 'Applies currently to conservation limits');
GRANT ALL ON ref.tr_nimble_nim TO diaspara_admin;
GRANT SELECT ON ref.tr_nimble_nim TO diaspara_read;

-- It seems to me that metadata should contain information about historical 
-- variables, so I'm moving this from the main table and adding to metadata
-- some variables might get deprecated in time. 
-- Unless they get a new version this might not change
-- I have removed reference to stockkey as there are several stock keys
-- for the work of WGNAS
DROP TABLE IF EXISTS ref.tr_version_ver CASCADE;
CREATE TABLE ref.tr_version_ver(
ver_code TEXT PRIMARY KEY,
ver_year INTEGER NOT NULL,
ver_spe_code CHARACTER VARYING(3),
--ver_stockkey INTEGER NOT NULL, 
ver_stockkeylabel TEXT,
---ver_stockadvicedoi TEXT NOT NULL,
ver_datacalldoi TEXT NULL,
ver_version INTEGER NOT NULL,
ver_description TEXT,
CONSTRAINT fk_ver_spe_code FOREIGN KEY (ver_spe_code) 
REFERENCES ref.tr_species_spe(spe_code)
ON UPDATE CASCADE ON DELETE CASCADE
);
COMMENT ON TABLE ref.tr_version_ver
IS 'Table of data or variable version, essentially one datacall or advice.';
COMMENT ON COLUMN ref.tr_version_ver.ver_version 
IS 'Version code, stockkey-year-version.';
COMMENT ON COLUMN ref.tr_version_ver.ver_year 
IS 'Year of assessement.';
COMMENT ON COLUMN ref.tr_version_ver.ver_spe_code 
IS 'Species code e.g. ''ele'' references tr_species_spe.';
--COMMENT ON COLUMN ref.tr_version_ver.ver_stockkey 
--IS 'Stockkey (integer) from the stock database.';
COMMENT ON COLUMN ref.tr_version_ver.ver_stockkeylabel 
IS 'Ver_stockkeylabel e.g. ele.2737.nea.';
--COMMENT ON COLUMN ref.tr_version_ver.ver_stockadvicedoi 
--IS 'Advice DOI corresponding to column adviceDOI 
--when using icesASD::getAdviceViewRecord().';
COMMENT ON COLUMN ref.tr_version_ver.ver_datacalldoi 
IS 'Data call DOI, find a way to retreive that information 
and update this comment';
COMMENT ON COLUMN ref.tr_version_ver.ver_version 
IS 'Version code in original database, eg 2,4 for wgnas, dc_2020 for wgeel.';
COMMENT ON COLUMN ref.tr_version_ver.ver_description 
IS 'Description of the data call / version.';
GRANT ALL ON ref.tr_version_ver TO diaspara_admin;
GRANT SELECT ON ref.tr_version_ver TO diaspara_read;
-- metric 

DROP TABLE IF EXISTS  ref.tr_metric_mtr CASCADE;
CREATE TABLE ref.tr_metric_mtr(
mtr_code TEXT PRIMARY KEY,
mtr_description TEXT
);


INSERT INTO ref.tr_metric_mtr VALUES
('Estimate' , 'Estimate');
INSERT INTO ref.tr_metric_mtr VALUES
('Index', 'Index');
INSERT INTO ref.tr_metric_mtr VALUES
('Bound', 'Either min or max');
INSERT INTO ref.tr_metric_mtr VALUES
('Hyperparameter', 'Hyperparameter (prior)');
INSERT INTO ref.tr_metric_mtr VALUES
('SD', 'Standard deviation');
INSERT INTO ref.tr_metric_mtr VALUES
('CV', 'Coefficient of variation');
INSERT INTO ref.tr_metric_mtr VALUES
('Precision', 'Inverse of variance');
INSERT INTO ref.tr_metric_mtr VALUES
('Mean', 'Mean');
INSERT INTO ref.tr_metric_mtr VALUES 
('Min','Minimum');
INSERT INTO ref.tr_metric_mtr VALUES 
('Max','Maximum');

GRANT ALL ON ref.tr_metric_mtr TO diaspara_admin;
GRANT SELECT ON ref.tr_metric_mtr TO diaspara_read;
COMMENT ON TABLE ref.tr_metric_mtr IS 
'Table metric describe the type of parm used, Index, Bound ...';

-- tr_category_cat

DROP TABLE IF EXISTS ref.tr_category_cat CASCADE;
CREATE TABLE ref.tr_category_cat (
cat_code TEXT PRIMARY KEY,
cat_description TEXT
);

INSERT INTO ref.tr_category_cat VALUES 
('Catch', 'Catch, including recreational and commercial catch.');
INSERT INTO ref.tr_category_cat VALUES (
'Effort', 'Parameter measuring fishing effort.');
INSERT INTO ref.tr_category_cat VALUES (
'Biomass', 'Biomass of fish either in number or weight.');
INSERT INTO ref.tr_category_cat VALUES (
'Mortality', 'Mortality either expressed in year-1 (instantaneous rate) 
as F in exp(-FY) but can also be harvest rate.');
INSERT INTO ref.tr_category_cat VALUES (
'Release', 'Release or restocking.');
INSERT INTO ref.tr_category_cat VALUES (
'Density', 'Fish density.');
INSERT INTO ref.tr_category_cat VALUES (
'Count', 'Count or abundance or number of fish.');
INSERT INTO ref.tr_category_cat VALUES (
'Conservation limit', 'Limit of conservation in Number or Number of eggs.');
INSERT INTO ref.tr_category_cat VALUES (
'Life trait', 'Life trait parameterized in model, e.g. growth parameter, 
fecundity rate ...');

COMMENT ON TABLE ref.tr_category_cat IS 
'Broad category of data or parameter, catch, effort, biomass, mortality, count ...,
 more details in the table ref.tr_parameter_parm e.g. commercial catch,
recreational catch are found in the parameter value and definition and unit, 
this list is intended to be short.';

GRANT ALL ON ref.tr_category_cat TO diaspara_admin;
GRANT SELECT ON ref.tr_category_cat TO diaspara_read;

DROP TABLE IF EXISTS ref.tr_destination_des CASCADE;
CREATE TABLE ref.tr_destination_des (
des_code TEXT PRIMARY KEY,
des_description TEXT
);

COMMENT ON TABLE ref.tr_destination_des IS 
'Table of fish destination. When dealing with fish, e.g. in landings,what is the future of the fish, e.g. Released (alive), Seal damage, 
Removed (from the environment)'; 
INSERT INTO ref.tr_destination_des VALUES 
('Removed', 'Removed from the environment, e.g. caught and kept');
INSERT INTO ref.tr_destination_des VALUES (
'Seal damaged', 'Seal damage');
INSERT INTO ref.tr_destination_des VALUES (
'Discarded', 'Discards');
INSERT INTO ref.tr_destination_des VALUES (
'Released', 'Released alive');


GRANT ALL ON ref.tr_destination_des TO diaspara_admin;
GRANT SELECT ON ref.tr_destination_des TO diaspara_read;





DROP TABLE IF EXISTS ref.tr_metadata_met CASCADE;
CREATE TABLE ref.tr_metadata_met (
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
COMMENT ON TABLE ref.tr_metadata_met IS 
'Table (metadata) of each variable (parameter) in the database.';
COMMENT ON COLUMN ref.tr_metadata_met.met_var 
IS 'Variable code, primary key on both met_spe_code and met_var.';
COMMENT ON COLUMN ref.tr_metadata_met.met_spe_code 
IS 'Species, ANG, SAL, TRT ... primary key on both met_spe_code and met_var.';
COMMENT ON COLUMN ref.tr_metadata_met.met_ver_code 
IS 'Code on the version of the model, see table tr_version_ver.';
COMMENT ON COLUMN ref.tr_metadata_met.met_oty_code 
IS 'Object type, single_value, vector, matrix see table tr_objecttype_oty.';
COMMENT ON COLUMN ref.tr_metadata_met.met_nim_code 
IS 'Nimble type, one of data, constant, output, other.';
COMMENT ON COLUMN ref.tr_metadata_met.met_dim 
IS 'Dimension of the Nimble variable, use {10, 100, 100} 
to insert the description of an array(10,100,100).';
COMMENT ON COLUMN ref.tr_metadata_met.met_dimname 
IS 'Dimension of the variable in Nimble, use {''year'', ''stage'', ''area''}.';
COMMENT ON COLUMN ref.tr_metadata_met.met_modelstage 
IS 'Currently one of fit, other, First year.';
COMMENT ON COLUMN ref.tr_metadata_met.met_type 
IS 'Type of data in the variable, homewatercatches, InitialISation first year,
abundance ....';
COMMENT ON COLUMN ref.tr_metadata_met.met_location 
IS 'Describe process at sea, e.g. Btw. FAR - GLD fisheries, or Aft. Gld fISheries.';
COMMENT ON COLUMN ref.tr_metadata_met.met_fishery 
IS 'Description of the fishery.';
COMMENT ON COLUMN ref.tr_metadata_met.met_des_code 
IS 'Outcome of the fish, e.g. Released (alive), Seal damage,
Removed (from the environment), references table tr_destination_des.';
COMMENT ON COLUMN ref.tr_metadata_met.met_uni_code 
IS 'Unit, references table tr_unit_uni.';
COMMENT ON COLUMN ref.tr_metadata_met.met_cat_code 
IS 'Broad category of data or parameter, 
catch, effort, biomass, mortality, count ...references table tr_category_cat.';
COMMENT ON COLUMN ref.tr_metadata_met.met_mtr_code 
IS 'Code of the metric, references tr_metric_mtr, Estimate, Bound, SD, CV ....';
COMMENT ON COLUMN ref.tr_metadata_met.met_definition 
IS 'Definition of the metric.';
COMMENT ON COLUMN ref.tr_metadata_met.met_deprecated
IS'Is the variable still used ?';

GRANT ALL ON ref.tr_metadata_met TO diaspara_admin;
GRANT SELECT ON ref.tr_metadata_met TO diaspara_read;
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
INSERT INTO ref.tr_category_cat VALUES (
'Other', 'Other variable/ parameter used in the model other than the previous categories, 
origin distribution of catches, proportions, parameters setting the beginning and ending dates....');
COMMENT ON TABLE ref.tr_category_cat IS 
'Broad category of data or parameter, catch, effort, biomass, mortality, count ...,
 more details in the table ref.tr_parameter_parm e.g. commercial catch,
recreational catch are found in the parameter value and definition and unit, 
this list is intended to be short.';

GRANT ALL ON ref.tr_category_cat TO diaspara_admin;
GRANT SELECT ON ref.tr_category_cat TO diaspara_read;
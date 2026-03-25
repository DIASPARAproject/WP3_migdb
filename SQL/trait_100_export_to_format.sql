SELECT * FROM dateel.t_series_ser WHERE ser_cou_code = 'FR';

SELECT
'FI' AS "RecordType",
ser_cou_code AS "Country",
2025 AS "Year",
ser_spe_code AS "Species",
ser_wkg_code AS "WorkingGroup",
ser_ver_code AS "Version",
1001 AS DatarightsHolder -- check with Maria
FROM dateel.t_series_ser
WHERE ser_code IN ('GiTCG','VacG','BresGY','BreS') LIMIT 1



SELECT 
'SS' AS "RecordType",
ser_code AS "SamplingSchemeID",
10777 AS "StationCode", -- check with Maria
ser_fiw_code AS "Fishway",
ser_mon_code AS "MonitoringDevice",
ser_spe_code AS "Species",
ser_lfs_code AS "LifeStage",
ser_are_code AS "Area",
ser_gea_code AS "Gear",
ser_stocking AS "RestockingFlag",
'https://doi.org/10.17895/ices.pub.30488120' AS DOI  --check with Maria
FROM dateel.t_series_ser
WHERE ser_code IN ('GiTCG','VacG','BresGY','BreS')

-- RecordType  GroupID   SamplingSchemeID  Year  AgeClass  LifeStage LifeStageProportion NumberofIndividuals MeanAge MeanLength  MeanWeight  SexDeterminationMethod  FemaleProportion  DifferentiatedProportion  AnguillicolaProportion  AnguillicolaIntensity AnguillicolaMethod  MuscleLipidPercentage MuscleLipidMeasurementMethod  6PCB  TEQ EVEXProportion  HVAProportion ChemicalParameters  MeanConcentration Comment                     

SELECT 
'GM' AS "RecordType",
gr_gr_id AS "GroupID",
gr_ser_id AS "SamplingSchemeID",
gr_year AS "Year",
NULL AS "AgeClass",
gr_lfs_code AS "LifeStage",
LifeStageProportion,
gr_number AS "NumberofIndividuals",
--MeanAge MeanLength  MeanWeight  SexDeterminationMethod  FemaleProportion  DifferentiatedProportion  AnguillicolaProportion  AnguillicolaIntensity AnguillicolaMethod  MuscleLipidPercentage MuscleLipidMeasurementMethod  6PCB  TEQ EVEXProportion  HVAProportion ChemicalParameters  MeanConcentration 
gr_comment AS "Comments",            
gr_sex_code AS "Sex"
FROM dateel.t_series_ser 
JOIN dateel.t_group_gr ON gr_ser_id = ser_id
JOIN dateel.t_grouptrait_grt ON grt_gr_id = gr_id
WHERE ser_code IN ('GiTCG','VacG','BresGY','BreS')


gr_lastupdate AS ""
gr_ver_code AS "Version"
grt_ser_id AS "SamplingSchemeID"
grt_wkg_code AS "WorkingGroup"
grt_spe_code AS "Species"



ser_wkg_code AS "WorkingGroup",
ser_ver_code AS "Version",
ser_hab_code AS "HabitatCode",



ser_uni_code AS "Unit"
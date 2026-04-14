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
gr_id AS "GroupID",
gr_ser_id AS "SamplingSchemeID",
gr_year AS "Year",
NULL AS "AgeClass",
gr_lfs_code AS "LifeStage",
gr_number AS "NumberofIndividuals",
gr_comment AS "Comments",            
gr_sex_code AS "Sex",
grt_tra_code,
grt_value,
grt_trm_code,
grt_trv_code
FROM dateel.t_series_ser 
JOIN dateel.t_group_gr ON gr_ser_id = ser_id 
JOIN dateel.t_grouptrait_grt ON grt_gr_id = gr_id 
WHERE ser_code IN ('GiTCG','VacG','BresGY','BreS')


SELECT 
'IM' AS "RecordType",
*
FROM dateel.t_series_ser 
JOIN dateel.t_fish_fi ON fi_ser_id = ser_id 
JOIN dateel.t_indivtrait_int ON int_fi_id=fi_id
WHERE ser_code IN ('GiTCG','VacG','BresGY','BreS')



SELECT 
'IM' AS "RecordType",
CASE WHEN fi_date IS NULL THEN fi_year 
     ELSE fi_year END AS "Year",
ser_code AS "SamplingSchemeID",
fi_idsource AS "FishID",
fi_lfs_code AS "LifeStage",
CASE WHEN fi_date IS NULL THEN NULL 
ELSE extract('MONTH' FROM fi_date)
END AS "Month",
CASE WHEN fi_date IS NULL THEN NULL 
ELSE extract('DAY' FROM fi_date)
END AS "Day",
fi_x_4326 AS "DecimalLongitude",
fi_y_4326 AS "DecimalLatitude",
int_tra_code,
int_value,
int_trv_code,
int_trm_code,
fi_comment AS "Comments"
FROM dateel.t_series_ser 
JOIN dateel.t_fish_fi ON fi_ser_id = ser_id 
JOIN dateel.t_indivtrait_int ON int_fi_id=fi_id
WHERE ser_code IN ('GiTCG','VacG','BresGY','BreS')






WHERE ser_code IN 

gr_lastupdate AS ""
gr_ver_code AS "Version"
grt_ser_id AS "SamplingSchemeID"
grt_wkg_code AS "WorkingGroup"
grt_spe_code AS "Species"



ser_wkg_code AS "WorkingGroup",
ser_ver_code AS "Version",
ser_hab_code AS "HabitatCode",



ser_uni_code AS "Unit"
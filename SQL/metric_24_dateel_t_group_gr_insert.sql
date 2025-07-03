/*
SELECT DISTINCT gr_dts_datasource 
FROM datwgeel.t_groupseries_grser
*/

DELETE FROM dateel.t_group_gr;
INSERT INTO dateel.t_group_gr
(gr_id, gr_ser_id, gr_gr_id, gr_wkg_code, gr_spe_code, gr_lfs_code, gr_year, gr_number, gr_comment, gr_lastupdate, gr_ver_code)
SELECT 
gr_id,
tss2.ser_id ,
NULL AS gr_gr_id,
'WGEEL' AS gr_wkg_code,
'ANG' AS gr_spe_code,
tss.ser_lfs_code AS gr_lfs_code,
gr_year,
gr_number,
gr_comment,
gr_lastupdate,
CASE WHEN gr_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN gr_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN gr_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN gr_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN gr_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN gr_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS gr_ver_code
FROM  datwgeel.t_groupseries_grser grser
JOIN datwgeel.t_series_ser AS tss ON grser_ser_id = ser_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= ser_nameshort; --2681



INSERT INTO dateel.t_group_gr
(gr_id, gr_ser_id, gr_gr_id, gr_wkg_code,  gr_spe_code, gr_lfs_code, gr_year, gr_number, gr_comment, gr_lastupdate, gr_ver_code)
SELECT 
gr_id, 
tss2.ser_id  AS gr_ser_id,
NULL AS gr_gr_id,
'WGEEL' AS gr_wkg_code,
'ANG' AS gr_spe_code,
grsa_lfs_code AS gr_lfs_code,
gr_year,
gr_number,
gr_comment,
gr_lastupdate,
CASE WHEN gr_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN gr_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN gr_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN gr_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN gr_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN gr_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS gr_ver_code
FROM  datwgeel.t_groupsamp_grsa 
JOIN datwgeel.t_samplinginfo_sai AS tss ON grsa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= sai_id::text; --798




-- INSERT Males AND Females WITH gr_gr_id

DROP SEQUENCE IF EXISTS seq_group;
CREATE TEMPORARY SEQUENCE seq_group;
SELECT setval('seq_group', (SELECT max(gr_id) FROM dateel.t_group_gr)); -- 13741

-- Males with gr_id from series (subgroupsample)

INSERT INTO dateel.t_group_gr
(gr_id, 
gr_ser_id, 
gr_gr_id, 
gr_wkg_code,  
gr_spe_code, 
gr_sex_code, 
gr_lfs_code, 
gr_year, 
gr_number, 
gr_comment, 
gr_lastupdate,
gr_ver_code)
SELECT 
nextval('seq_group') AS gr_id, 
tss2.ser_id  AS gr_ser_id,
grser.gr_id AS gr_gr_id,
'WGEEL' AS gr_wkg_code,
'ANG' AS gr_spe_code,
'M' AS gr_sex_code,
tss.ser_lfs_code AS gr_lfs_code,
gr_year,
gr_number,
gr_comment,
gr_lastupdate,
CASE WHEN gr_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN gr_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN gr_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN gr_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN gr_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN gr_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS gr_ver_code
FROM  
datwgeel.t_metricgroupseries_megser 
JOIN datwgeel.t_groupseries_grser grser ON meg_gr_id = gr_id
JOIN datwgeel.t_series_ser AS tss ON grser_ser_id = ser_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= ser_nameshort
WHERE meg_mty_id IN (18,19,20); --409

# Females WITH gr_gr_id series (subgroupsample)


INSERT INTO dateel.t_group_gr
(gr_id, 
gr_ser_id, 
gr_gr_id, 
gr_wkg_code,  
gr_spe_code, 
gr_sex_code, 
gr_lfs_code, 
gr_year, 
gr_number, 
gr_comment, 
gr_lastupdate,
gr_ver_code)
SELECT 
nextval('seq_group') AS gr_id, 
tss2.ser_id  AS gr_ser_id,
grser.gr_id AS gr_gr_id,
'WGEEL' AS gr_wkg_code,
'ANG' AS gr_spe_code,
'F' AS gr_sex_code,
tss.ser_lfs_code AS gr_lfs_code,
gr_year,
gr_number,
gr_comment,
gr_lastupdate,
CASE WHEN gr_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN gr_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN gr_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN gr_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN gr_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN gr_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS gr_ver_code
FROM  
datwgeel.t_metricgroupseries_megser 
JOIN datwgeel.t_groupseries_grser grser ON meg_gr_id = gr_id
JOIN datwgeel.t_series_ser AS tss ON grser_ser_id = ser_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= ser_nameshort
WHERE meg_mty_id IN (21,22,23); --553

# males from sampling


INSERT INTO dateel.t_group_gr
(gr_id, 
gr_ser_id, 
gr_gr_id, 
gr_wkg_code,  
gr_spe_code, 
gr_sex_code, 
gr_lfs_code, 
gr_year, 
gr_number, 
gr_comment, 
gr_lastupdate,
gr_ver_code)
SELECT 
nextval('seq_group') AS gr_id, 
tss2.ser_id  AS gr_ser_id,
grsa.gr_id AS gr_gr_id,
'WGEEL' AS gr_wkg_code,
'ANG' AS gr_spe_code,
'M' AS gr_sex_code,
grsa_lfs_code,
gr_year,
gr_number,
gr_comment,
gr_lastupdate,
CASE WHEN gr_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN gr_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN gr_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN gr_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN gr_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN gr_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS gr_ver_code
FROM  
datwgeel.t_metricgroupsamp_megsa 
JOIN datwgeel.t_groupsamp_grsa  grsa ON meg_gr_id = gr_id
JOIN datwgeel.t_samplinginfo_sai AS tss ON grsa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code=  sai_id::text
WHERE meg_mty_id IN (18,19,20); --544

# Females from sampling


INSERT INTO dateel.t_group_gr
(gr_id, 
gr_ser_id, 
gr_gr_id, 
gr_wkg_code,  
gr_spe_code, 
gr_sex_code, 
gr_lfs_code, 
gr_year, 
gr_number, 
gr_comment, 
gr_lastupdate,
gr_ver_code)
SELECT 
nextval('seq_group') AS gr_id, 
tss2.ser_id  AS gr_ser_id,
grsa.gr_id AS gr_gr_id,
'WGEEL' AS gr_wkg_code,
'ANG' AS gr_spe_code,
'F' AS gr_sex_code,
grsa_lfs_code AS gr_lfs_code,
gr_year,
gr_number,
gr_comment,
gr_lastupdate,
CASE WHEN gr_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN gr_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN gr_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN gr_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN gr_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN gr_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS gr_ver_code
FROM  
datwgeel.t_metricgroupsamp_megsa 
JOIN datwgeel.t_groupsamp_grsa  grsa ON meg_gr_id = gr_id
JOIN datwgeel.t_samplinginfo_sai AS tss ON grsa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code=  sai_id::text
WHERE meg_mty_id IN (21,22,23); --1183


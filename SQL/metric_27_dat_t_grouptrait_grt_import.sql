
/*
 * Insert numeric for group - series 
 */
DELETE FROM dateel.t_grouptrait_grt;

INSERT INTO dateel.t_grouptrait_grt
(grt_ser_id, 
grt_wkg_code, 
grt_spe_code, 
grt_id, 
grt_gr_id, 
grt_tra_code, 
grt_value, 
grt_trv_code, 
grt_trm_code, 
grt_last_update, 
grt_qal_code, 
grt_ver_code)
-- extract method from table
-- this will extract 3 columns, meg_gr_id, meg_method_anguillicola and meg_method_sex
WITH a1 AS (
SELECT meg_gr_id,
       meg_value AS meg_method_sex 
FROM datwgeel.t_metricgroupseries_megser 
WHERE meg_mty_id = 27
AND meg_value IS NOT NULL),
 a2 AS (
 SELECT meg_gr_id,
       meg_value AS meg_method_anguillicola 
FROM datwgeel.t_metricgroupseries_megser 
WHERE meg_mty_id = 28
AND meg_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.meg_gr_id, a2.meg_gr_id)  AS meg_gr_id,
meg_method_sex,
meg_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.meg_gr_id = a2.meg_gr_id)
-- Insert select query
SELECT 
tss2.ser_id AS grt_ser_id,
'WGEEL' AS grt_wkg_code,
'ANG' AS grt_spe_code,
meg_id AS grt_id, 
megser.meg_gr_id AS grt_gr_id, 
CASE WHEN meg_mty_id = 1 THEN 'Lengthmm'
WHEN meg_mty_id = 2 THEN 'Weightg'
WHEN meg_mty_id = 3 THEN 'Ageyear'
WHEN meg_mty_id = 6 THEN 'Female_proportion'
WHEN meg_mty_id = 7 THEN 'Differentiated_proportion'
WHEN meg_mty_id = 8 THEN 'Anguillicola_proportion'
WHEN meg_mty_id = 9 THEN 'Anguillicola_intensity'
WHEN meg_mty_id = 10 THEN 'Muscle_lipid'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid' -- different method see method
WHEN meg_mty_id = 12 THEN 'Sum_6_pcb'
WHEN meg_mty_id = 13 THEN 'Evex_proportion'
WHEN meg_mty_id = 14 THEN 'Hva_proportion'
WHEN meg_mty_id = 15 THEN 'Pb'
WHEN meg_mty_id = 16 THEN 'Hg'
WHEN meg_mty_id = 17 THEN 'Cd'
WHEN meg_mty_id = 24 THEN 'G_in_gy_proportion'
WHEN meg_mty_id = 25 THEN 'S_in_ys_proportion'
WHEN meg_mty_id = 26 THEN 'Teq'
ELSE 'problem' END AS grt_tra_code,
meg_value AS grt_value, 
NULL AS grt_trv_code, -- there ARE NO qualitative VALUES FOR GROUP metrics
CASE WHEN meg_mty_id = 10 THEN 'Muscle_lipid_fatmeter'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid_gravimeter' -- different method see method
WHEN meg_mty_id = 6 AND meg_method_sex = 1 THEN 'Gonadal_inspection'
WHEN meg_mty_id = 6 AND meg_method_sex = 0 THEN 'Length_based_sex'
WHEN meg_mty_id = 8 AND meg_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN meg_mty_id = 8 AND meg_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
WHEN meg_mty_id = 9 AND meg_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN meg_mty_id = 9 AND meg_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
ELSE NULL END AS grt_trm_code,
meg_last_update AS grt_last_update, 
meg_qal_id AS grt_qal_code, 
CASE WHEN meg_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN meg_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN meg_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN meg_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN meg_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN meg_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS grt_ver_code
FROM datwgeel.t_metricgroupseries_megser megser
JOIN datwgeel.t_groupseries_grser grser ON megser.meg_gr_id = gr_id
JOIN datwgeel.t_series_ser AS tss ON grser_ser_id = ser_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= ser_nameshort
LEFT JOIN mm ON megser.meg_gr_id = mm.meg_gr_id -- joining subquery
WHERE meg_mty_id IN (1,2,3,6,7,8,9,10,11,12,13,14,15,16,17,24,25,26); --4194




/*
 * Insert numeric for group - sampling
 * Some values have both gravimeter and fatmeter, gravimeter chosen.
 */


INSERT INTO dateel.t_grouptrait_grt
(grt_ser_id, 
grt_wkg_code, 
grt_spe_code, 
grt_id, 
grt_gr_id, 
grt_tra_code, 
grt_value, 
grt_trv_code, 
grt_trm_code, 
grt_last_update, 
grt_qal_code, 
grt_ver_code)
-- extract method from table
-- this will extract 3 columns, meg_gr_id, meg_method_anguillicola and meg_method_sex
WITH a1 AS (
SELECT meg_gr_id,
       meg_value AS meg_method_sex 
FROM datwgeel.t_metricgroupsamp_megsa megsa
WHERE meg_mty_id = 27
AND meg_value IS NOT NULL),
 a2 AS (
 SELECT meg_gr_id,
       meg_value AS meg_method_anguillicola 
FROM datwgeel.t_metricgroupsamp_megsa megsa 
WHERE meg_mty_id = 28
AND meg_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.meg_gr_id, a2.meg_gr_id)  AS meg_gr_id,
meg_method_sex,
meg_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.meg_gr_id = a2.meg_gr_id)
-- Insert select query
SELECT 
tss2.ser_id AS grt_ser_id,
'WGEEL' AS grt_wkg_code,
'ANG' AS grt_spe_code,
meg_id AS grt_id, 
megsa.meg_gr_id AS grt_gr_id, 
CASE WHEN meg_mty_id = 1 THEN 'Lengthmm'
WHEN meg_mty_id = 2 THEN 'Weightg'
WHEN meg_mty_id = 3 THEN 'Ageyear'
WHEN meg_mty_id = 6 THEN 'Female_proportion'
WHEN meg_mty_id = 7 THEN 'Differentiated_proportion'
WHEN meg_mty_id = 8 THEN 'Anguillicola_proportion'
WHEN meg_mty_id = 9 THEN 'Anguillicola_intensity'
WHEN meg_mty_id = 10 THEN 'Muscle_lipid'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid' -- different method see method
WHEN meg_mty_id = 12 THEN 'Sum_6_pcb'
WHEN meg_mty_id = 13 THEN 'Evex_proportion'
WHEN meg_mty_id = 14 THEN 'Hva_proportion'
WHEN meg_mty_id = 15 THEN 'Pb'
WHEN meg_mty_id = 16 THEN 'Hg'
WHEN meg_mty_id = 17 THEN 'Cd'
WHEN meg_mty_id = 24 THEN 'G_in_gy_proportion'
WHEN meg_mty_id = 25 THEN 'S_in_ys_proportion'
WHEN meg_mty_id = 26 THEN 'Teq'
ELSE 'problem' END AS grt_tra_code,
meg_value AS grt_value, 
NULL AS grt_trv_code, -- there ARE NO qualitative VALUES FOR GROUP metrics
CASE WHEN meg_mty_id = 10 THEN 'Muscle_lipid_fatmeter'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid_gravimeter' -- different method see method
WHEN meg_mty_id = 6 AND meg_method_sex = 1 THEN 'Gonadal_inspection'
WHEN meg_mty_id = 6 AND meg_method_sex = 0 THEN 'Length_based_sex'
WHEN meg_mty_id = 8 AND meg_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN meg_mty_id = 8 AND meg_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
WHEN meg_mty_id = 9 AND meg_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN meg_mty_id = 9 AND meg_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
ELSE NULL END AS grt_trm_code,
meg_last_update AS grt_last_update, 
meg_qal_id AS grt_qal_code, 
CASE WHEN meg_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN meg_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN meg_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN meg_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN meg_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN meg_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS grt_ver_code
FROM datwgeel.t_metricgroupsamp_megsa megsa
JOIN datwgeel.t_groupsamp_grsa  ON megsa.meg_gr_id = gr_id
JOIN datwgeel.t_samplinginfo_sai AS tss ON grsa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= sai_id::text
LEFT JOIN mm ON megsa.meg_gr_id = mm.meg_gr_id -- joining subquery
WHERE meg_mty_id IN (1,2,3,6,7,8,9,11,12,13,14,15,16,17,24,25,26); --3028


-- Insert only fatmeter where gravimeter does not exist

INSERT INTO dateel.t_grouptrait_grt
(grt_ser_id, 
grt_wkg_code, 
grt_spe_code, 
grt_id, 
grt_gr_id, 
grt_tra_code, 
grt_value, 
grt_trv_code, 
grt_trm_code, 
grt_last_update, 
grt_qal_code, 
grt_ver_code)
WITH a1 AS (
SELECT meg_gr_id,
       meg_value AS meg_method_sex 
FROM datwgeel.t_metricgroupsamp_megsa megsa
WHERE meg_mty_id = 27
AND meg_value IS NOT NULL),
 a2 AS (
 SELECT meg_gr_id,
       meg_value AS meg_method_anguillicola 
FROM datwgeel.t_metricgroupsamp_megsa megsa 
WHERE meg_mty_id = 28
AND meg_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.meg_gr_id, a2.meg_gr_id)  AS meg_gr_id,
meg_method_sex,
meg_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.meg_gr_id = a2.meg_gr_id),
-- Insert select query
fatmeter AS (
SELECT 
tss2.ser_id AS grt_ser_id,
'WGEEL' AS grt_wkg_code,
'ANG' AS grt_spe_code,
meg_id AS grt_id, 
megsa.meg_gr_id AS grt_gr_id, 
CASE WHEN meg_mty_id = 1 THEN 'Lengthmm'
WHEN meg_mty_id = 2 THEN 'Weightg'
WHEN meg_mty_id = 3 THEN 'Ageyear'
WHEN meg_mty_id = 6 THEN 'Female_proportion'
WHEN meg_mty_id = 7 THEN 'Differentiated_proportion'
WHEN meg_mty_id = 8 THEN 'Anguillicola_proportion'
WHEN meg_mty_id = 9 THEN 'Anguillicola_intensity'
WHEN meg_mty_id = 10 THEN 'Muscle_lipid'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid' -- different method see method
WHEN meg_mty_id = 12 THEN 'Sum_6_pcb'
WHEN meg_mty_id = 13 THEN 'Evex_proportion'
WHEN meg_mty_id = 14 THEN 'Hva_proportion'
WHEN meg_mty_id = 15 THEN 'Pb'
WHEN meg_mty_id = 16 THEN 'Hg'
WHEN meg_mty_id = 17 THEN 'Cd'
WHEN meg_mty_id = 24 THEN 'G_in_gy_proportion'
WHEN meg_mty_id = 25 THEN 'S_in_ys_proportion'
WHEN meg_mty_id = 26 THEN 'Teq'
ELSE 'problem' END AS grt_tra_code,
meg_value AS grt_value, 
NULL AS grt_trv_code, -- there ARE NO qualitative VALUES FOR GROUP metrics
CASE WHEN meg_mty_id = 10 THEN 'Muscle_lipid_fatmeter'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid_gravimeter' -- different method see method
WHEN meg_mty_id = 6 AND meg_method_sex = 1 THEN 'Gonadal_inspection'
WHEN meg_mty_id = 6 AND meg_method_sex = 0 THEN 'Length_based_sex'
WHEN meg_mty_id = 8 AND meg_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN meg_mty_id = 8 AND meg_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
WHEN meg_mty_id = 9 AND meg_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN meg_mty_id = 9 AND meg_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
ELSE NULL END AS grt_trm_code,
meg_last_update AS grt_last_update, 
meg_qal_id AS grt_qal_code, 
CASE WHEN meg_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN meg_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN meg_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN meg_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN meg_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN meg_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS grt_ver_code
FROM datwgeel.t_metricgroupsamp_megsa megsa
JOIN datwgeel.t_groupsamp_grsa  ON megsa.meg_gr_id = gr_id
JOIN datwgeel.t_samplinginfo_sai AS tss ON grsa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= sai_id::text
LEFT JOIN mm ON megsa.meg_gr_id = mm.meg_gr_id -- joining subquery
WHERE meg_mty_id = 10)
SELECT * FROM fatmeter WHERE  grt_gr_id NOT IN 
(SELECT grt_gr_id FROM dateel.t_grouptrait_grt WHERE grt_tra_code = 'Muscle_lipid')
; --23





-- GROUP metrics FOR males sampling
SELECT count(*) FROM  datwgeel.t_metricgroupsamp_megsa megsa
WHERE meg_mty_id IN (18,19,20);--544



INSERT INTO dateel.t_grouptrait_grt
(grt_ser_id, 
grt_wkg_code, 
grt_spe_code, 
grt_id, 
grt_gr_id, 
grt_tra_code, 
grt_value, 
grt_trv_code, 
grt_trm_code, 
grt_last_update, 
grt_qal_code, 
grt_ver_code)
-- extract method from table
-- this will extract 3 columns, meg_gr_id, meg_method_anguillicola and meg_method_sex
WITH a1 AS (
SELECT meg_gr_id,
       meg_value AS meg_method_sex 
FROM datwgeel.t_metricgroupsamp_megsa megsa
WHERE meg_mty_id = 27
AND meg_value IS NOT NULL),
 a2 AS (
 SELECT meg_gr_id,
       meg_value AS meg_method_anguillicola 
FROM datwgeel.t_metricgroupsamp_megsa megsa 
WHERE meg_mty_id = 28
AND meg_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.meg_gr_id, a2.meg_gr_id)  AS meg_gr_id,
meg_method_sex,
meg_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.meg_gr_id = a2.meg_gr_id)
-- Insert select query
SELECT DISTINCT ON (meg_id)
tss2.ser_id AS grt_ser_id,
'WGEEL' AS grt_wkg_code,
'ANG' AS grt_spe_code,
meg_id AS grt_id, 
gr.gr_id AS grt_gr_id, 
CASE WHEN meg_mty_id IN (18, 21) THEN 'Lengthmm'
WHEN meg_mty_id IN (19,22) THEN 'Weightg'
WHEN meg_mty_id IN (20,23) THEN 'Ageyear'
ELSE 'problem' END AS grt_tra_code,
meg_value AS grt_value, 
NULL AS grt_trv_code, -- there ARE NO qualitative VALUES FOR GROUP metrics
CASE WHEN meg_mty_id = 10 THEN 'Muscle_lipid_fatmeter'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid_gravimeter' -- different method see method
WHEN meg_method_sex = 1 THEN 'Gonadal_inspection'
WHEN meg_method_sex = 0 THEN 'Length_based_sex'
ELSE NULL END AS grt_trm_code,
meg_last_update AS grt_last_update, 
meg_qal_id AS grt_qal_code, 
CASE WHEN meg_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN meg_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN meg_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN meg_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN meg_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN meg_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS grt_ver_code
FROM datwgeel.t_metricgroupsamp_megsa megsa
JOIN datwgeel.t_groupsamp_grsa grsa  ON megsa.meg_gr_id = grsa.gr_id
JOIN datwgeel.t_samplinginfo_sai AS tss ON grsa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= sai_id::text
LEFT JOIN mm ON megsa.meg_gr_id = mm.meg_gr_id -- joining subquery
JOIN (SELECT gr_id, gr_ser_id, gr_year, gr_lfs_code FROM dateel.t_group_gr WHERE gr_sex_code = 'M') gr
ON (gr.gr_ser_id, COALESCE(gr.gr_year,1), gr_lfs_code) = ( tss2.ser_id, COALESCE(grsa.gr_year,1),grsa.grsa_lfs_code)
WHERE meg_mty_id IN (18,19,20); --544 Cédric pi fort

-- GROUP metrics FOR females   sampling
SELECT count(*) FROM  datwgeel.t_metricgroupseries_megser megsa
WHERE meg_mty_id IN (21,22,23);--553

INSERT INTO dateel.t_grouptrait_grt
(grt_ser_id, 
grt_wkg_code, 
grt_spe_code, 
grt_id, 
grt_gr_id, 
grt_tra_code, 
grt_value, 
grt_trv_code, 
grt_trm_code, 
grt_last_update, 
grt_qal_code, 
grt_ver_code)
-- extract method from table
-- this will extract 3 columns, meg_gr_id, meg_method_anguillicola and meg_method_sex
WITH a1 AS (
SELECT meg_gr_id,
       meg_value AS meg_method_sex 
FROM datwgeel.t_metricgroupsamp_megsa megsa
WHERE meg_mty_id = 27
AND meg_value IS NOT NULL),
 a2 AS (
 SELECT meg_gr_id,
       meg_value AS meg_method_anguillicola 
FROM datwgeel.t_metricgroupsamp_megsa megsa 
WHERE meg_mty_id = 28
AND meg_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.meg_gr_id, a2.meg_gr_id)  AS meg_gr_id,
meg_method_sex,
meg_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.meg_gr_id = a2.meg_gr_id)
-- Insert select query
SELECT DISTINCT ON (meg_id)
tss2.ser_id AS grt_ser_id,
'WGEEL' AS grt_wkg_code,
'ANG' AS grt_spe_code,
meg_id AS grt_id, 
gr.gr_id AS grt_gr_id, 
CASE WHEN meg_mty_id IN (18, 21) THEN 'Lengthmm'
WHEN meg_mty_id IN (19,22) THEN 'Weightg'
WHEN meg_mty_id IN (20,23) THEN 'Ageyear'
ELSE 'problem' END AS grt_tra_code,
meg_value AS grt_value, 
NULL AS grt_trv_code, -- there ARE NO qualitative VALUES FOR GROUP metrics
CASE WHEN meg_mty_id = 10 THEN 'Muscle_lipid_fatmeter'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid_gravimeter' -- different method see method
WHEN meg_method_sex = 1 THEN 'Gonadal_inspection'
WHEN meg_method_sex = 0 THEN 'Length_based_sex'
ELSE NULL END AS grt_trm_code,
meg_last_update AS grt_last_update, 
meg_qal_id AS grt_qal_code, 
CASE WHEN meg_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN meg_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN meg_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN meg_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN meg_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN meg_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS grt_ver_code
FROM datwgeel.t_metricgroupsamp_megsa megsa
JOIN datwgeel.t_groupsamp_grsa grsa  ON megsa.meg_gr_id = grsa.gr_id
JOIN datwgeel.t_samplinginfo_sai AS tss ON grsa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= sai_id::text
LEFT JOIN mm ON megsa.meg_gr_id = mm.meg_gr_id -- joining subquery
JOIN (SELECT gr_id, gr_ser_id, gr_year, gr_lfs_code FROM dateel.t_group_gr WHERE gr_sex_code = 'F') gr
ON (gr.gr_ser_id, COALESCE(gr.gr_year,1), gr_lfs_code) = ( tss2.ser_id, COALESCE(grsa.gr_year,1),grsa.grsa_lfs_code)
WHERE meg_mty_id IN (21,22,23); --1183

-- GROUP metrics for males series

INSERT INTO dateel.t_grouptrait_grt
(grt_ser_id, 
grt_wkg_code, 
grt_spe_code, 
grt_id, 
grt_gr_id, 
grt_tra_code, 
grt_value, 
grt_trv_code, 
grt_trm_code, 
grt_last_update, 
grt_qal_code, 
grt_ver_code)
-- extract method from table
-- this will extract 3 columns, meg_gr_id, meg_method_anguillicola and meg_method_sex
WITH a1 AS (
SELECT meg_gr_id,
       meg_value AS meg_method_sex 
FROM datwgeel.t_metricgroupseries_megser megser
WHERE meg_mty_id = 27
AND meg_value IS NOT NULL),
 a2 AS (
 SELECT meg_gr_id,
       meg_value AS meg_method_anguillicola 
FROM datwgeel.t_metricgroupseries_megser megser 
WHERE meg_mty_id = 28
AND meg_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.meg_gr_id, a2.meg_gr_id)  AS meg_gr_id,
meg_method_sex,
meg_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.meg_gr_id = a2.meg_gr_id)
-- Insert select query
SELECT DISTINCT ON (meg_id)
tss2.ser_id AS grt_ser_id,
'WGEEL' AS grt_wkg_code,
'ANG' AS grt_spe_code,
meg_id AS grt_id, 
gr.gr_id AS grt_gr_id, 
CASE WHEN meg_mty_id IN (18, 21) THEN 'Lengthmm'
WHEN meg_mty_id IN (19,22) THEN 'Weightg'
WHEN meg_mty_id IN (20,23) THEN 'Ageyear'
ELSE 'problem' END AS grt_tra_code,
meg_value AS grt_value, 
NULL AS grt_trv_code, -- there ARE NO qualitative VALUES FOR GROUP metrics
CASE WHEN meg_mty_id = 10 THEN 'Muscle_lipid_fatmeter'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid_gravimeter' -- different method see method
WHEN meg_method_sex = 1 THEN 'Gonadal_inspection'
WHEN meg_method_sex = 0 THEN 'Length_based_sex'
ELSE NULL END AS grt_trm_code,
meg_last_update AS grt_last_update, 
meg_qal_id AS grt_qal_code, 
CASE WHEN meg_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN meg_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN meg_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN meg_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN meg_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN meg_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS grt_ver_code
FROM datwgeel.t_metricgroupseries_megser megser
JOIN datwgeel.t_groupseries_grser grser ON megser.meg_gr_id = gr_id
JOIN datwgeel.t_series_ser AS tss ON grser_ser_id = ser_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= ser_nameshort
LEFT JOIN mm ON megser.meg_gr_id = mm.meg_gr_id -- joining subquery
JOIN (SELECT gr_id, gr_ser_id, gr_year, gr_lfs_code FROM dateel.t_group_gr WHERE gr_sex_code = 'M') gr
ON (gr.gr_ser_id, COALESCE(gr.gr_year,1), gr_lfs_code) = ( tss2.ser_id, COALESCE(grser.gr_year,1),tss.ser_lfs_code)
WHERE meg_mty_id IN (18,19,20); --409

-- GROUP metrics for females series
SELECT count(*) FROM  datwgeel.t_metricgroupseries_megser megser
WHERE meg_mty_id IN (21,22,23);--553

INSERT INTO dateel.t_grouptrait_grt
(grt_ser_id, 
grt_wkg_code, 
grt_spe_code, 
grt_id, 
grt_gr_id, 
grt_tra_code, 
grt_value, 
grt_trv_code, 
grt_trm_code, 
grt_last_update, 
grt_qal_code, 
grt_ver_code)
-- extract method from table
-- this will extract 3 columns, meg_gr_id, meg_method_anguillicola and meg_method_sex
WITH a1 AS (
SELECT meg_gr_id,
       meg_value AS meg_method_sex 
FROM datwgeel.t_metricgroupseries_megser megser
WHERE meg_mty_id = 27
AND meg_value IS NOT NULL),
 a2 AS (
 SELECT meg_gr_id,
       meg_value AS meg_method_anguillicola 
FROM datwgeel.t_metricgroupseries_megser megser 
WHERE meg_mty_id = 28
AND meg_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.meg_gr_id, a2.meg_gr_id)  AS meg_gr_id,
meg_method_sex,
meg_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.meg_gr_id = a2.meg_gr_id)
-- Insert select query
SELECT DISTINCT ON (meg_id)
tss2.ser_id AS grt_ser_id,
'WGEEL' AS grt_wkg_code,
'ANG' AS grt_spe_code,
meg_id AS grt_id, 
gr.gr_id AS grt_gr_id, 
CASE WHEN meg_mty_id IN (18, 21) THEN 'Lengthmm'
WHEN meg_mty_id IN (19,22) THEN 'Weightg'
WHEN meg_mty_id IN (20,23) THEN 'Ageyear'
ELSE 'problem' END AS grt_tra_code,
meg_value AS grt_value, 
NULL AS grt_trv_code, -- there ARE NO qualitative VALUES FOR GROUP metrics
CASE WHEN meg_mty_id = 10 THEN 'Muscle_lipid_fatmeter'
WHEN meg_mty_id = 11 THEN 'Muscle_lipid_gravimeter' -- different method see method
WHEN meg_method_sex = 1 THEN 'Gonadal_inspection'
WHEN meg_method_sex = 0 THEN 'Length_based_sex'
ELSE NULL END AS grt_trm_code,
meg_last_update AS grt_last_update, 
meg_qal_id AS grt_qal_code, 
CASE WHEN meg_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN meg_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN meg_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN meg_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN meg_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN meg_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS grt_ver_code
FROM datwgeel.t_metricgroupseries_megser megser
JOIN datwgeel.t_groupseries_grser grser ON megser.meg_gr_id = gr_id
JOIN datwgeel.t_series_ser AS tss ON grser_ser_id = ser_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= ser_nameshort
LEFT JOIN mm ON megser.meg_gr_id = mm.meg_gr_id -- joining subquery
JOIN (SELECT gr_id, gr_ser_id, gr_year, gr_lfs_code FROM dateel.t_group_gr WHERE gr_sex_code = 'F') gr
ON (gr.gr_ser_id, COALESCE(gr.gr_year,1), gr_lfs_code) = ( tss2.ser_id, COALESCE(grser.gr_year,1),tss.ser_lfs_code)
WHERE meg_mty_id IN (21,22,23); --553



;
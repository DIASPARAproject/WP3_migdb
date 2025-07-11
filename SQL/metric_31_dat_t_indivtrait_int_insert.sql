
/*
 * Insert numeric for indiv - series 
 */
DELETE FROM dateel.t_indivtrait_int;

INSERT INTO dateel.t_indivtrait_int
(int_ser_id, 
int_wkg_code, 
int_spe_code, 
int_id, 
int_fi_id, 
int_tra_code, 
int_value, 
int_trv_code, 
int_trm_code, 
int_last_update, 
int_qal_code, 
int_ver_code)
WITH a1 AS (
SELECT mei_fi_id,
       mei_value AS mei_method_sex 
FROM datwgeel.t_metricindsamp_meisa meisa
WHERE mei_mty_id = 27
AND mei_value IS NOT NULL),
 a2 AS (
 SELECT mei_fi_id,
       mei_value AS mei_method_anguillicola 
FROM datwgeel.t_metricindsamp_meisa meisa 
WHERE mei_mty_id = 28
AND mei_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.mei_fi_id, a2.mei_fi_id)  AS mei_fi_id,
mei_method_sex,
mei_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.mei_fi_id = a2.mei_fi_id)
SELECT 
tss2.ser_id AS int_ser_id,
'WGEEL' AS int_wkg_code,
'ANG' AS int_spe_code,
fi_id AS int_id, 
meiser.mei_fi_id AS int_fi_id, 
CASE WHEN mei_mty_id = 1 THEN 'Lengthmm'
WHEN mei_mty_id = 2 THEN 'Weightg'
WHEN mei_mty_id = 3 THEN 'Ageyear'
WHEN mei_mty_id = 4 THEN 'Eye_diam_meanmm'
WHEN mei_mty_id = 5 THEN 'Pectoral_lengthmm'
WHEN mei_mty_id = 9 THEN 'Anguillicola_intensity'
WHEN mei_mty_id = 11 THEN 'Muscle_lipid' -- IF fatmeter insert later only if gravimeter does not exists
WHEN mei_mty_id = 12 THEN 'Sum_6_pcb'
WHEN mei_mty_id = 15 THEN 'Pb'
WHEN mei_mty_id = 16 THEN 'Hg'
WHEN mei_mty_id = 17 THEN 'Cd'
WHEN mei_mty_id = 26 THEN 'Teq'
ELSE 'problem' END AS int_tra_code,
mei_value AS int_value, 
NULL AS int_trv_code, -- there ARE NO qualitative VALUES FOR GROUP metrics
CASE WHEN mei_mty_id = 11 THEN 'Muscle_lipid_gravimeter' -- different method see METHOD
WHEN mei_mty_id = 9 AND mei_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN mei_mty_id = 9 AND mei_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
ELSE NULL END AS int_trm_code,
mei_last_update AS int_last_update, 
mei_qal_id AS int_qal_code, 
CASE WHEN mei_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN mei_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN mei_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN mei_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN mei_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN mei_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS int_ver_code
FROM datwgeel.t_metricindseries_meiser meiser
JOIN datwgeel.t_fishseries_fiser fiser ON meiser.mei_fi_id = fi_id
JOIN datwgeel.t_series_ser AS tss ON fiser_ser_id = ser_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= ser_nameshort
LEFT JOIN mm ON meiser.mei_fi_id = mm.mei_fi_id -- joining subquery
WHERE mei_mty_id IN (1,2,3,4,5,9,11,12,15,16,17,26); --1145525


--10 Muscle lipid fatmeter




INSERT INTO dateel.t_indivtrait_int
(int_ser_id, 
int_wkg_code, 
int_spe_code, 
int_id, 
int_fi_id, 
int_tra_code, 
int_value, 
int_trv_code, 
int_trm_code, 
int_last_update, 
int_qal_code, 
int_ver_code)
WITH fatmeter AS (
SELECT 
tss2.ser_id AS int_ser_id,
'WGEEL' AS int_wkg_code,
'ANG' AS int_spe_code,
fi_id AS int_id, 
meiser.mei_fi_id AS int_fi_id, 
CASE WHEN mei_mty_id = 10 THEN  'Muscle_lipid' 
ELSE 'problem' END AS int_tra_code,
mei_value AS int_value, 
NULL AS int_trv_code, 
CASE WHEN mei_mty_id = 10 THEN 'Muscle_lipid_fatmeter' -- different method see method
ELSE NULL END AS int_trm_code,
mei_last_update AS int_last_update, 
mei_qal_id AS int_qal_code, 
CASE WHEN mei_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN mei_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN mei_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN mei_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN mei_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN mei_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS int_ver_code
FROM datwgeel.t_metricindseries_meiser meiser
JOIN datwgeel.t_fishseries_fiser fiser ON meiser.mei_fi_id = fi_id
JOIN datwgeel.t_series_ser AS tss ON fiser_ser_id = ser_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= ser_nameshort
WHERE mei_mty_id IN (10))
SELECT * FROM fatmeter WHERE  int_fi_id NOT IN 
(SELECT int_fi_id FROM dateel.t_indivtrait_int WHERE int_tra_code = 'Muscle_lipid')
; --0

/*
 * Insert numeric for  - sampling
 * Some values have both gravimeter and fatmeter, gravimeter chosen.
 */


INSERT INTO dateel.t_indivtrait_int
(int_ser_id, 
int_wkg_code, 
int_spe_code, 
int_id, 
int_fi_id, 
int_tra_code, 
int_value, 
int_trv_code, 
int_trm_code, 
int_last_update, 
int_qal_code, 
int_ver_code)
WITH a1 AS (
SELECT mei_fi_id,
       mei_value AS mei_method_sex 
FROM datwgeel.t_metricindsamp_meisa meisa
WHERE mei_mty_id = 27
AND mei_value IS NOT NULL),
 a2 AS (
 SELECT mei_fi_id,
       mei_value AS mei_method_anguillicola 
FROM datwgeel.t_metricindsamp_meisa meisa 
WHERE mei_mty_id = 28
AND mei_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.mei_fi_id, a2.mei_fi_id)  AS mei_fi_id,
mei_method_sex,
mei_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.mei_fi_id = a2.mei_fi_id)
SELECT 
tss2.ser_id AS int_ser_id,
'WGEEL' AS int_wkg_code,
'ANG' AS int_spe_code,
mei_id AS int_id, 
meisa.mei_fi_id AS int_fi_id, 
CASE WHEN mei_mty_id = 1 THEN 'Lengthmm'
WHEN mei_mty_id = 2 THEN 'Weightg'
WHEN mei_mty_id = 3 THEN 'Ageyear'
WHEN mei_mty_id = 4 THEN 'Eye_diam_meanmm'
WHEN mei_mty_id = 5 THEN 'Pectoral_lengthmm'
WHEN mei_mty_id = 9 THEN 'Anguillicola_intensity'
WHEN mei_mty_id = 11 THEN 'Muscle_lipid' -- IF fatmeter insert later only if gravimeter does not exists
WHEN mei_mty_id = 12 THEN 'Sum_6_pcb'
WHEN mei_mty_id = 15 THEN 'Pb'
WHEN mei_mty_id = 16 THEN 'Hg'
WHEN mei_mty_id = 17 THEN 'Cd'
WHEN mei_mty_id = 26 THEN 'Teq'
ELSE 'problem' END AS int_tra_code,
mei_value AS int_value, 
NULL AS int_trv_code,
CASE WHEN mei_mty_id = 11 THEN 'Muscle_lipid_gravimeter' -- different method see METHOD
WHEN mei_mty_id = 9 AND mei_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN mei_mty_id = 9 AND mei_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
ELSE NULL END AS int_trm_code,
mei_last_update AS int_last_update, 
mei_qal_id AS int_qal_code, 
CASE WHEN mei_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN mei_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN mei_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN mei_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN mei_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN mei_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS int_ver_code
FROM datwgeel.t_metricindsamp_meisa meisa
JOIN datwgeel.t_fishsamp_fisa  ON meisa.mei_fi_id = fi_id
JOIN datwgeel.t_samplinginfo_sai AS tss ON fisa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= sai_id::TEXT
LEFT JOIN mm ON meisa.mei_fi_id = mm.mei_fi_id -- joining subquery
WHERE mei_mty_id IN (1,2,3,4,5,9,11,12,15,16,17,26); --298005


-- Insert only fatmeter where gravimeter does not exist

INSERT INTO dateel.t_indivtrait_int
(int_ser_id, 
int_wkg_code, 
int_spe_code, 
int_id, 
int_fi_id, 
int_tra_code, 
int_value, 
int_trv_code, 
int_trm_code, 
int_last_update, 
int_qal_code, 
int_ver_code)
WITH fatmeter AS (
SELECT 
tss2.ser_id AS int_ser_id,
'WGEEL' AS int_wkg_code,
'ANG' AS int_spe_code,
mei_id AS int_id, 
meisa.mei_fi_id AS int_fi_id, 
CASE WHEN mei_mty_id = 10 THEN  'Muscle_lipid' 
ELSE 'problem' END AS int_tra_code,
mei_value AS int_value, 
NULL AS int_trv_code, -- there ARE NO qualitative VALUES FOR GROUP metrics
CASE WHEN mei_mty_id = 10 THEN 'Muscle_lipid_fatmeter' -- different method see method
ELSE NULL END AS int_trm_code,
mei_last_update AS int_last_update, 
mei_qal_id AS int_qal_code, 
CASE WHEN mei_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN mei_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN mei_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN mei_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN mei_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN mei_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS int_ver_code
FROM datwgeel.t_metricindsamp_meisa meisa
JOIN datwgeel.t_fishsamp_fisa  ON meisa.mei_fi_id = fi_id
JOIN datwgeel.t_samplinginfo_sai AS tss ON fisa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= sai_id::text
WHERE mei_mty_id = 10)
SELECT * FROM fatmeter WHERE  int_fi_id NOT IN 
(SELECT int_fi_id FROM dateel.t_indivtrait_int WHERE int_tra_code = 'Muscle_lipid')
; --100



-- Qualitative traits series


INSERT INTO dateel.t_indivtrait_int
(int_ser_id, 
int_wkg_code, 
int_spe_code, 
int_id, 
int_fi_id, 
int_tra_code, 
int_value, 
int_trv_code, 
int_trm_code, 
int_last_update, 
int_qal_code, 
int_ver_code)
WITH a1 AS (
SELECT mei_fi_id,
       mei_value AS mei_method_sex 
FROM datwgeel.t_metricindseries_meiser 
WHERE mei_mty_id = 27
AND mei_value IS NOT NULL),
 a2 AS (
 SELECT mei_fi_id,
       mei_value AS mei_method_anguillicola 
FROM datwgeel.t_metricindseries_meiser 
WHERE mei_mty_id = 28
AND mei_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.mei_fi_id, a2.mei_fi_id)  AS mei_fi_id,
mei_method_sex,
mei_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.mei_fi_id = a2.mei_fi_id)
SELECT 
tss2.ser_id AS int_ser_id,
'WGEEL' AS int_wkg_code,
'ANG' AS int_spe_code,
fi_id AS int_id, 
meiser.mei_fi_id AS int_fi_id, 
CASE 
WHEN mei_mty_id = 6 THEN 'Sex'
WHEN mei_mty_id = 7 THEN 'Is_differentiated'
WHEN mei_mty_id = 8 THEN 'Anguillicola_presence'
WHEN mei_mty_id = 13 THEN 'Evex_presence'
WHEN mei_mty_id = 14 THEN 'Hva_presence'
ELSE 'problem' END AS int_tra_code,
NULL AS int_value, 
CASE 
WHEN mei_mty_id = 6 AND mei_value = 1 THEN 'F'
WHEN mei_mty_id = 6 AND mei_value = 0 THEN 'M'
WHEN mei_mty_id = 7 AND mei_value = 1 THEN 'Y'
WHEN mei_mty_id = 7 AND mei_value = 0 THEN 'N'
WHEN mei_mty_id = 8 AND mei_value = 1 THEN 'Y'
WHEN mei_mty_id = 8 AND mei_value = 0 THEN 'N'
WHEN mei_mty_id = 13 AND mei_value= 1 THEN 'Y' 
WHEN mei_mty_id = 13 AND mei_value= 0 THEN 'N'
WHEN mei_mty_id = 14 AND mei_value= 1 THEN 'Y' 
WHEN mei_mty_id = 14 AND mei_value= 0 THEN 'N'
ELSE NULL END AS int_trv_code,
CASE 
WHEN mei_mty_id = 6 AND mei_method_sex = 1 THEN 'Gonadal_inspection'
WHEN mei_mty_id = 6 AND mei_method_sex = 0 THEN 'Length_based_sex'
WHEN mei_mty_id = 8 AND mei_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN mei_mty_id = 8 AND mei_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
ELSE NULL END AS int_trm_code,
mei_last_update AS int_last_update, 
mei_qal_id AS int_qal_code, 
CASE WHEN mei_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN mei_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN mei_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN mei_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN mei_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN mei_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS int_ver_code
FROM datwgeel.t_metricindseries_meiser meiser
JOIN datwgeel.t_fishseries_fiser fiser ON meiser.mei_fi_id = fi_id
JOIN datwgeel.t_series_ser AS tss ON fiser_ser_id = ser_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= ser_nameshort
LEFT JOIN mm ON meiser.mei_fi_id = mm.mei_fi_id -- joining subquery
WHERE mei_mty_id IN (6,7,8,13,14); --189327 (pigment stage is not yet in the db)

-- Qualitative trait sampling


INSERT INTO dateel.t_indivtrait_int
(int_ser_id, 
int_wkg_code, 
int_spe_code, 
int_id, 
int_fi_id, 
int_tra_code, 
int_value, 
int_trv_code, 
int_trm_code, 
int_last_update, 
int_qal_code, 
int_ver_code)
-- extract method from table
-- this will extract 3 columns, mei_fi_id, mei_method_anguillicola and mei_method_sex
WITH a1 AS (
SELECT mei_fi_id,
       mei_value AS mei_method_sex 
FROM datwgeel.t_metricindsamp_meisa meisa
WHERE mei_mty_id = 27
AND mei_value IS NOT NULL),
 a2 AS (
 SELECT mei_fi_id,
       mei_value AS mei_method_anguillicola 
FROM datwgeel.t_metricindsamp_meisa meisa 
WHERE mei_mty_id = 28
AND mei_value IS NOT NULL),
mm AS (
SELECT coalesce(a1.mei_fi_id, a2.mei_fi_id)  AS mei_fi_id,
mei_method_sex,
mei_method_anguillicola
FROM  a1 FULL OUTER JOIN a2 ON a1.mei_fi_id = a2.mei_fi_id)
-- Insert select query
SELECT 
tss2.ser_id AS int_ser_id,
'WGEEL' AS int_wkg_code,
'ANG' AS int_spe_code,
mei_id AS int_id, 
meisa.mei_fi_id AS int_fi_id, 
CASE 
WHEN mei_mty_id = 6 THEN 'Sex'
WHEN mei_mty_id = 7 THEN 'Is_differentiated'
WHEN mei_mty_id = 8 THEN 'Anguillicola_presence'
WHEN mei_mty_id = 13 THEN 'Evex_presence'
WHEN mei_mty_id = 14 THEN 'Hva_presence'
ELSE 'problem' END AS int_tra_code,
NULL AS int_value, 
CASE 
WHEN mei_mty_id = 6 AND mei_value = 1 THEN 'F'
WHEN mei_mty_id = 6 AND mei_value = 0 THEN 'M'
WHEN mei_mty_id = 7 AND mei_value = 1 THEN 'Y'
WHEN mei_mty_id = 7 AND mei_value = 0 THEN 'N'
WHEN mei_mty_id = 8 AND mei_value = 1 THEN 'Y'
WHEN mei_mty_id = 8 AND mei_value = 0 THEN 'N'
WHEN mei_mty_id = 13 AND mei_value= 1 THEN 'Y' 
WHEN mei_mty_id = 13 AND mei_value= 0 THEN 'N'
WHEN mei_mty_id = 14 AND mei_value= 1 THEN 'Y' 
WHEN mei_mty_id = 14 AND mei_value= 0 THEN 'N'
ELSE NULL END AS int_trv_code,
CASE 
WHEN mei_mty_id = 6 AND mei_method_sex = 1 THEN 'Gonadal_inspection'
WHEN mei_mty_id = 6 AND mei_method_sex = 0 THEN 'Length_based_sex'
WHEN mei_mty_id = 8 AND mei_method_anguillicola = 1 THEN 'Anguillicola_stereomicroscope_count'
WHEN mei_mty_id = 8 AND mei_method_anguillicola = 0 THEN 'Anguillicola_visual_count'
ELSE NULL END AS int_trm_code,
mei_last_update AS int_last_update, 
mei_qal_id AS int_qal_code, 
CASE WHEN mei_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN mei_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN mei_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN mei_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN mei_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN mei_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS int_ver_code
FROM datwgeel.t_metricindsamp_meisa meisa
JOIN datwgeel.t_fishsamp_fisa  ON meisa.mei_fi_id = fi_id
JOIN datwgeel.t_samplinginfo_sai AS tss ON fisa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= sai_id::TEXT
LEFT JOIN mm ON meisa.mei_fi_id = mm.mei_fi_id -- joining subquery
WHERE mei_mty_id IN (6,7,8,13,14); --163914 (pigment stage is not yet in the db)








/*
SELECT DISTINCT gr_dts_datasource 
FROM datwgeel.t_groupseries_grser
*/


INSERT INTO dateel.t_group_gr
(gr_id, gr_ser_id, gr_gr_id, gr_wkg_code, gr_year, gr_number, gr_comment, gr_lastupdate, gr_ver_code)
SELECT 
gr_id,
tss2.ser_id ,
NULL AS gr_gr_id,
'WGEEL' AS gr_wkg_code,
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
(gr_id, gr_gr_id, gr_wkg_code, gr_year, gr_number, gr_comment, gr_lastupdate, gr_ver_code)
SELECT 
gr_id, 
NULL AS gr_gr_id,
'WGEEL' AS gr_wkg_code,
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
FROM datwgeel.t_groupsamp_grsa;


-- TODO INSERT Males AND Females WITH gr_gr_id


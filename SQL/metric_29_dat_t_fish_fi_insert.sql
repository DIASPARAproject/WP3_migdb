

-- insert from series
INSERT INTO dateel.t_fish_fi
(fi_id, 
fi_ser_id, 
fi_wkg_code, 
fi_spe_code, 
fi_lfs_code, 
fi_date, 
fi_year, 
fi_comment, 
fi_lastupdate, 
fi_idsource,
fi_ver_code,
fi_x_4326,
fi_y_4326,
fi_geom)
SELECT 
fi_id, 
tss2.ser_id AS fi_ser_id,
'WGEEL' AS fi_wkg_code,
'ANG' AS fi_spe_code,
fi_lfs_code,
fi_date,
fi_year, 
fi_comment,
fi_lastupdate, 
fi_id_cou AS fi_idsource,
CASE WHEN fi_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN fi_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN fi_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN fi_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN fi_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN fi_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS fi_ver_code,
st_x(tss.geom),
st_y(tss.geom),
tss.geom
FROM datwgeel.t_fishseries_fiser 
JOIN datwgeel.t_series_ser tss ON ser_id = fiser_ser_id 
JOIN dat.t_series_ser tss2 ON ser_code = ser_nameshort ; --757787

-- Insert from sampling

INSERT INTO dateel.t_fish_fi
(fi_id, 
fi_ser_id, 
fi_wkg_code, 
fi_spe_code, 
fi_lfs_code, 
fi_date, 
fi_year, 
fi_comment, 
fi_lastupdate, 
fi_idsource,
fi_ver_code,
fi_x_4326,
fi_y_4326,
fi_geom)
SELECT 
fi_id, 
tss2.ser_id AS fi_ser_id,
'WGEEL' AS fi_wkg_code,
'ANG' AS fi_spe_code,
CASE WHEN fi_lfs_code = 'NA' THEN 'YS' ELSE fi_lfs_code END AS fi_lfs_code,
fi_date,
fi_year, 
fi_comment,
fi_lastupdate, 
fi_id_cou AS fi_idsource,
CASE WHEN fi_dts_datasource = 'dc_2019' THEN 'WGEEL-2019-1'
     WHEN fi_dts_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN fi_dts_datasource ='dc_2021' THEN 'WGEEL-2021-1'
     WHEN fi_dts_datasource ='dc_2022' THEN 'WGEEL-2022-1'
     WHEN fi_dts_datasource ='dc_2023' THEN 'WGEEL-2023-1'
     WHEN fi_dts_datasource ='dc_2024' THEN 'WGEEL-2024-1'
     ELSE 'WGEEL-2018-1' END AS fi_ver_code,
fisa_x_4326,
fisa_y_4326,
fisa_geom
FROM  datwgeel.t_fishsamp_fisa 
JOIN datwgeel.t_samplinginfo_sai AS tss ON fisa_sai_id = sai_id
JOIN dateel.t_series_ser AS tss2 ON ser_code= sai_id::text;  --98545


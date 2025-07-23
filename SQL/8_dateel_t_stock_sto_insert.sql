
INSERT INTO dateel.t_stock_sto
(sto_id, sto_met_var, sto_year, sto_spe_code, sto_value, sto_are_code, 
sto_cou_code, sto_lfs_code, sto_hty_code, sto_fia_code, sto_qal_code, 
sto_qal_comment, sto_comment, sto_datelastupdate, sto_mis_code, 
sto_dta_code, sto_wkg_code)
WITH emu_cou AS (
SELECT  are_code AS are_cou_code, emu_nameshort FROM refwgeel.tr_emu_emu 
JOIN refeel.tr_area_are on are_code = emu_cou_code
WHERE emu_nameshort ilike '%_total'
),
 emu_emu AS (
SELECT  are_code AS are_emu_code, emu_nameshort FROM refwgeel.tr_emu_emu 
JOIN refeel.tr_area_are on are_code = emu_nameshort
WHERE emu_nameshort NOT ilike '%total'
)
SELECT  
nextval('dat.t_stock_sto_sto_id_seq'::regclass) AS sto_id
, m.met_var AS sto_met_var
, e.eel_year AS sto_year
, 'ANG' AS  sto_spe_code
, e.eel_value AS sto_value
, CASE WHEN e.eel_emu_nameshort ilike '%total' THEN are_cou_code
  ELSE are_emu_code 
  END AS sto_are_code
, e.eel_cou_code AS sto_cou_code 
, e.eel_lfs_code  AS sto_lfs_code
, e.eel_hty_code AS  sto_hty_code
, NULL AS sto_fia_code -- fishing area
, e.eel_qal_id AS sto_qal_code -- see later TO INSERT deprecated values
, e.eel_qal_comment AS sto_qal_comment 
, e.eel_comment AS sto_comment
, e.eel_datelastupdate AS sto_datelastupdate
, e.eel_missvaluequal AS sto_mis_code
, 'Public' AS sto_dta_code
, 'WGEEL' AS sto_wkg_code
FROM datwgeel.t_eelstock_eel e 
JOIN dateel.t_metadata_met m ON m.met_type::int = e.eel_typ_id
LEFT JOIN emu_emu ON emu_emu.emu_nameshort = eel_emu_nameshort
LEFT JOIN emu_cou ON emu_cou.emu_nameshort = eel_emu_nameshort
WHERE eel_qal_id IN (0,1,2,3,4)
AND eel_hty_code NOT IN ('T','M','C') -- 43171


-- Treat COU_total values for marine stock => most often no divisison



-- TODO eel_percent
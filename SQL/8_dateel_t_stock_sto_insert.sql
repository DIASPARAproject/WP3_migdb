DELETE FROM dateel.t_stock_sto;
INSERT INTO dateel.t_stock_sto
(sto_id, sto_met_var, sto_year, sto_spe_code, sto_value, sto_are_code, 
sto_cou_code, sto_lfs_code, sto_hty_code,  sto_qal_code, 
sto_qal_comment, sto_comment, sto_datelastupdate, sto_mis_code, 
sto_dta_code, sto_wkg_code, sto_ver_code)
SELECT
eel_id AS  sto_id
, m.met_var AS sto_met_var
, e.eel_year AS sto_year
, '127186' AS  sto_spe_code
, e.eel_value AS sto_value
, CASE WHEN e.eel_emu_nameshort ilike '%total' THEN eel_cou_code
       WHEN e.eel_emu_nameshort IS NULL THEN eel_cou_code 
ELSE e.eel_emu_nameshort END AS sto_are_code
, e.eel_cou_code AS sto_cou_code 
, e.eel_lfs_code  AS sto_lfs_code
, CASE 
      WHEN e.eel_hty_code = 'AL' THEN NULL
      WHEN e.eel_hty_code = 'F' THEN 'FW'
      WHEN e.eel_hty_code = 'MO' THEN 'MO'
      WHEN e.eel_hty_code = 'C' THEN 'MC'
      WHEN e.eel_hty_code = 'T' THEN 'T'
      WHEN e.eel_hty_code IS NULL THEN NULL
      ELSE 'TROUBLE' END AS sto_hty_code
--, NULL AS sto_fia_code -- fishing area
, e.eel_qal_id AS sto_qal_code -- see later TO INSERT deprecated values
, e.eel_qal_comment AS sto_qal_comment 
, e.eel_comment AS sto_comment
, e.eel_datelastupdate AS sto_datelastupdate
, e.eel_missvaluequal AS sto_mis_code
, 'Public' AS sto_dta_code
, 'WGEEL' AS sto_wkg_code
, CASE
     WHEN e.eel_datasource = 'wgeel_2016' THEN 'WGEEL-2016-1'  
     WHEN e.eel_datasource = 'dc_2017' THEN 'WGEEL-2017-1'
     WHEN e.eel_datasource = 'weel_2017' THEN 'WGEEL-2017-2'     
     WHEN e.eel_datasource = 'dc_2018' THEN 'WGEEL-2018-1'
     WHEN e.eel_datasource = 'dc_2019' THEN 'WGEEL-2019-1'     
     WHEN e.eel_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN e.eel_datasource = 'dc_2021' THEN 'WGEEL-2021-1'
     WHEN e.eel_datasource = 'dc_2022' THEN 'WGEEL-2022-1'
     WHEN e.eel_datasource = 'dc_2023' THEN 'WGEEL-2023-1'
     WHEN e.eel_datasource = 'dc_2024' THEN 'WGEEL-2024-1'
     WHEN e.eel_datasource = 'wkemp_2025' THEN 'WGEEL-2025-1'
     ELSE 'TROUBLE AND THIS SHOULD FAIL' END AS sto_ver_code
FROM datwgeel.t_eelstock_eel e 
JOIN dateel.t_metadata_met m ON m.met_type::int = e.eel_typ_id
WHERE eel_qal_id IN (0,1,2,3,4)
AND eel_hty_code NOT IN ('T','M','C') 
AND eel_missvaluequal != 'ND'
AND eel_typ_id != 16 -- habitat surface 
; -- 28247

/*
SELECT distinct eel_datasource FROM datwgeel.t_eelstock_eel as t 
SELECT distinct eel_hty_code FROM datwgeel.t_eelstock_eel 
SELECT * FROM  datwgeel.t_eelstock_eel 
WHERE eel_missvaluequal = 'ND'
AND eel_qal_id IN (0,1,2,3,4); --123 lines not kept
*/


-- OK I can remove for all T
 
 
INSERT INTO dateel.t_stock_sto
(sto_id, sto_met_var, sto_year, sto_spe_code, sto_value, sto_are_code, 
sto_cou_code, sto_lfs_code, sto_hty_code,  sto_qal_code, 
sto_qal_comment, sto_comment, sto_datelastupdate, sto_mis_code, 
sto_dta_code, sto_wkg_code, sto_ver_code)
SELECT
eel_id AS sto_id
, m.met_var AS sto_met_var
, e.eel_year AS sto_year
, '127186' AS  sto_spe_code
, e.eel_value AS sto_value
, CASE WHEN e.eel_emu_nameshort ilike '%total' THEN eel_cou_code
       WHEN e.eel_emu_nameshort IS NULL THEN eel_cou_code 
ELSE e.eel_emu_nameshort END AS sto_are_code
, e.eel_cou_code AS sto_cou_code 
, e.eel_lfs_code  AS sto_lfs_code
, CASE 
      WHEN e.eel_hty_code = 'AL' THEN NULL
      WHEN e.eel_hty_code = 'F' THEN 'FW'
      WHEN e.eel_hty_code = 'MO' THEN 'MO'
      WHEN e.eel_hty_code = 'C' THEN 'MC'
      WHEN e.eel_hty_code = 'T' THEN 'T'
      WHEN e.eel_hty_code IS NULL THEN NULL
      ELSE 'TROUBLE' END AS sto_hty_code
--, NULL AS sto_fia_code -- fishing area
, e.eel_qal_id AS sto_qal_code -- see later TO INSERT deprecated values
, e.eel_qal_comment AS sto_qal_comment 
, e.eel_comment AS sto_comment
, e.eel_datelastupdate AS sto_datelastupdate
, e.eel_missvaluequal AS sto_mis_code
, 'Public' AS sto_dta_code
, 'WGEEL' AS sto_wkg_code
, CASE
     WHEN e.eel_datasource = 'wgeel_2016' THEN 'WGEEL-2016-1'  
     WHEN e.eel_datasource = 'dc_2017' THEN 'WGEEL-2017-1'
     WHEN e.eel_datasource = 'weel_2017' THEN 'WGEEL-2017-2'     
     WHEN e.eel_datasource = 'dc_2018' THEN 'WGEEL-2018-1'
     WHEN e.eel_datasource = 'dc_2019' THEN 'WGEEL-2019-1'     
     WHEN e.eel_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN e.eel_datasource = 'dc_2021' THEN 'WGEEL-2021-1'
     WHEN e.eel_datasource = 'dc_2022' THEN 'WGEEL-2022-1'
     WHEN e.eel_datasource = 'dc_2023' THEN 'WGEEL-2023-1'
     WHEN e.eel_datasource = 'dc_2024' THEN 'WGEEL-2024-1'
     WHEN e.eel_datasource = 'wkemp_2025' THEN 'WGEEL-2025-1'
     ELSE 'TROUBLE AND THIS SHOULD FAIL' END AS sto_ver_code
FROM datwgeel.t_eelstock_eel e 
JOIN dateel.t_metadata_met m ON m.met_type::int = e.eel_typ_id
WHERE eel_qal_id IN (0,1,2,3,4)
AND eel_hty_code IN ('T') 
AND  eel_typ_id != 16 
AND eel_missvaluequal != 'ND' ; -- 12303


-----------------------------------------------------------------------------------------------------------------------------
 -- Do we have MO data ? 
 -----------------------------------------------------------------------------------------------------------------------------
SELECT * FROM  datwgeel.t_eelstock_eel  WHERE eel_hty_code = 'MO';--15600
SELECT * FROM  datwgeel.t_eelstock_eel  WHERE eel_hty_code = 'MO' and eel_value is not NULL
AND eel_qal_id in (1,2,3,4) ;
--26 (typ 8 and 9 there are releases for the rhone, no marine division.
-- So except for these 26 lines all data are MC.
-- I asked to Guirec, he will fix this in the database. So there should no longer be any marine Open data in the DB.


-- this is only for some data in MO (FR_Rhon) I'm inserting it now
SELECT *
FROM datwgeel.t_eelstock_eel e 
JOIN dateel.t_metadata_met m ON m.met_type::int = e.eel_typ_id
WHERE eel_qal_id IN (0,1,2,3,4)
AND eel_hty_code IN ('MO') 
AND eel_value is not NULL 
AND eel_missvaluequal != 'ND';
 
INSERT INTO dateel.t_stock_sto
(sto_id, sto_met_var, sto_year, sto_spe_code, sto_value, sto_are_code, 
sto_cou_code, sto_lfs_code, sto_hty_code, sto_qal_code, 
sto_qal_comment, sto_comment, sto_datelastupdate, sto_mis_code, 
sto_dta_code, sto_wkg_code, sto_ver_code)
SELECT
eel_id AS sto_id
, m.met_var AS sto_met_var
, e.eel_year AS sto_year
, '127186' AS  sto_spe_code
, e.eel_value AS sto_value
, CASE WHEN eel_emu_nameshort = 'FR_Rhon' THEN '37.1.2.7' 
  ELSE 'STOP' END AS sto_are_code
, e.eel_cou_code AS sto_cou_code 
, e.eel_lfs_code  AS sto_lfs_code
, CASE 
      WHEN e.eel_hty_code = 'AL' THEN NULL
      WHEN e.eel_hty_code = 'F' THEN 'FW'
      WHEN e.eel_hty_code = 'MO' THEN 'MO'
      WHEN e.eel_hty_code = 'C' THEN 'MC'
      WHEN e.eel_hty_code = 'T' THEN 'T'
      WHEN e.eel_hty_code IS NULL THEN NULL
      ELSE 'TROUBLE' END AS sto_hty_code
--, NULL AS sto_fia_code -- fishing area
, e.eel_qal_id AS sto_qal_code -- see later TO INSERT deprecated values
, e.eel_qal_comment AS sto_qal_comment 
, e.eel_comment AS sto_comment
, e.eel_datelastupdate AS sto_datelastupdate
, e.eel_missvaluequal AS sto_mis_code
, 'Public' AS sto_dta_code
, 'WGEEL' AS sto_wkg_code
, CASE
     WHEN e.eel_datasource = 'wgeel_2016' THEN 'WGEEL-2016-1'  
     WHEN e.eel_datasource = 'dc_2017' THEN 'WGEEL-2017-1'
     WHEN e.eel_datasource = 'weel_2017' THEN 'WGEEL-2017-2'     
     WHEN e.eel_datasource = 'dc_2018' THEN 'WGEEL-2018-1'
     WHEN e.eel_datasource = 'dc_2019' THEN 'WGEEL-2019-1'     
     WHEN e.eel_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN e.eel_datasource = 'dc_2021' THEN 'WGEEL-2021-1'
     WHEN e.eel_datasource = 'dc_2022' THEN 'WGEEL-2022-1'
     WHEN e.eel_datasource = 'dc_2023' THEN 'WGEEL-2023-1'
     WHEN e.eel_datasource = 'dc_2024' THEN 'WGEEL-2024-1'
     WHEN e.eel_datasource = 'wkemp_2025' THEN 'WGEEL-2025-1'
     ELSE 'TROUBLE AND THIS SHOULD FAIL' END AS sto_ver_code
FROM datwgeel.t_eelstock_eel e 
JOIN dateel.t_metadata_met m ON m.met_type::int = e.eel_typ_id
WHERE eel_qal_id IN (0,1,2,3,4)
AND eel_hty_code IN ('MO') 
AND eel_value is not NULL; --26




-----------------------------------------------------------------------------------------------------------------------------
-- Coastal waters, in which case do we have more than one eel_area_division for one emu, one lifestage code, one type ?
-----------------------------------------------------------------------------------------------------------------------------


with dupl AS (
SELECT *, count(eel_area_division)  OVER (PARTITION BY eel_typ_id, eel_emu_nameshort,  eel_year, eel_lfs_code)
 FROM  datwgeel.t_eelstock_eel 
  WHERE eel_hty_code = 'C' 
  AND eel_value is not NULL
  AND eel_qal_id in (1,2,3,4))
  SELECT * FROM dupl WHERE count>1; --98
-- OK so I have landings for SE_East, DK_Mari, and NO_total. In all those cases I can use the country level
 
-----------------------------------------------------------------------------------------------------------------------------
-- Coastal waters, in which case do we have one value per eel_area_division for one emu, one lifestage code, one type ?
-- Are there countries where more than one EMU is reported ?
-----------------------------------------------------------------------------------------------------------------------------
  
with dupl AS (
SELECT *, count(eel_area_division)  OVER (PARTITION BY eel_typ_id, eel_emu_nameshort,  eel_year, eel_lfs_code)
 FROM  datwgeel.t_eelstock_eel 
  WHERE eel_hty_code = 'C' 
  AND eel_value is not NULL
  AND eel_qal_id in (1,2,3,4)
  AND eel_typ_id !=16)
  SELECT * FROM dupl WHERE count=1
  ORDER BY eel_emu_nameshort, eel_typ_id;


  -- BE_Sche is 27.4.c typ_id 6 (rec)
  -- DE_Eide is always 27.4.b, typ_id 4 (com) and 6 (rec)
  -- DE_Schl is always 27.3.b, c, typ id 4 6 and 9 (release OG and G)
  -- => DE_Warn is always 27.3.d except for habitat where it is reported as 27.3.b,c o I'm not importing typ_id 16 (habitat), typ_id 4 and 6
  -- DK_Inla  1 value in 2021 eel_id 569486, typ_id 4 Y dc_2024 => removed below
SELECT * FROM datwgeel.t_eelstock_eel 
  WHERE 
  eel_value is not NULL
  AND eel_qal_id in (1,2,3,4)
  AND eel_typ_id = 4
  AND eel_cou_code = 'DK'
  AND eel_lfs_code = 'Y'

  
  -- Dk_Mari is always 27.3.b, c, Y or S, typ_id 4

  -- DK_total is always 27.3.b, c typ_id 6, eel_lfs (Y, YS) , 2017-2022 
  -- EE_West is always 27.3.d, typ_id 4 (com) YS
  -- ES_Murc is always 37.1.1, typ_id 4 (com) YS
  -- !! ES_Vale On value G in, typ_id 4 in 2021 dc_2021 (OK should be T)

    SELECT *
 FROM  datwgeel.t_eelstock_eel 
  WHERE 
  eel_value is not NULL
  AND eel_qal_id in (1,2,3,4)
  AND eel_typ_id = 4
  AND eel_emu_nameshort = 'ES_Vale'
  AND eel_lfs_code = 'G'

  -- FI_Finl is always 27.3.d typ_id 4, 6, 9

  -- GR_EaMT is always 37.3.1 
  -- GR_NorW is always 37.2.2
  -- GR_WePe is always 37.2.2 
  -- !! GR_total is reporting both with an without eel_area_division for GR_total => Mail sent
  -- LT_Lith / Lt_total change an make it consistent ? 
  -- LV_latv is always  37.3.d  4, 6
  -- !! NL_Neth is always 27.4.c except for two lines where I have nulls, mail sent for check to Tessa
  -- !! NO_Total is always 27.7.a (wrong)
  -- except for 3 yellow lines in 2021-2023 where it becomes 37.3.a => mail sent
  -- PL_Oder and PL_Vist are all 37.3.d 4,8,9
  -- !! SE East is always reporting 27.3.d, 27.3b,c (Baltic this is consistent with emu_def ) but it is reporting 27.3.a which it shouldn't
  -- SE WE  is always reporting 27.3.a 
  -- Sl_total is always reporting 37.2.1
  -- TN_EC is always reporting 37.2.2 
  -- TN_NE is always reporting 37.1.3 
  -- TN_SO is always reporting 37.2.2
  -- Change for tunisia ? Should be Inland for the lagoons...; 
  
-- so Greece, Poland are reporting two rows with different EMUs. For Greece and Poland make the sum.
-- Tunisia is also reporting more than one EMU for 37.2.2 but this 



-----------------------------------------------------
-- Coastal water not reported with eel_area_division
-----------------------------------------------------
SELECT * 
 FROM  datwgeel.t_eelstock_eel 
  WHERE eel_hty_code = 'C' 
  AND eel_area_division IS NULL
  AND eel_value is not NULL
  AND eel_qal_id in (1,2,3,4)
  AND eel_typ_id !=16
   ORDER BY eel_emu_nameshort, eel_typ_id, eel_lfs_code, eel_year; --1061




-- DE_Eide 8 G 2020-2022 (value 0)
-- DE_Eide 8 OG 1985-2022 (value 0)
-- DE_Eide 8 Y 1985-2022 (value 0)
-- DE_Eide 9 (same)  should be  27.4.b
-- DE_Schl 1985-2022 OG 0 and then values => Should be  27.3.b, c
-- DE_Warn should be 27.3.d

-- DK Mari 2016 2024 8 - 9 OG

SELECT * 
 FROM  datwgeel.t_eelstock_eel 
  WHERE eel_value is not NULL
  AND eel_qal_id in (1,2,3,4)
  AND eel_typ_id IN (8,9)
  AND eel_cou_code = 'DK'
   ORDER BY eel_emu_nameshort, eel_typ_id, eel_lfs_code, eel_year;

-- DK total says ICES subdivision 21 22 23 24 (not tin the list) this comment shows that divisions reported were not division. I guess this is the Baltic sea... So I guess I could use 27.3.b, c
-- Mail sent to Michael 25/07 for check...

-- EE_West should always be  27.3.d
-- missing values for 6 lines (4, 6) Mail sent to Paul
SELECT * 

 FROM  datwgeel.t_eelstock_eel 
  WHERE eel_value is not NULL
  AND eel_qal_id in (1,2,3,4)
  AND eel_cou_code = 'EE'  
   ORDER BY eel_emu_nameshort, eel_typ_id, eel_lfs_code, eel_year;
 
 SELECT * FROM  datwgeel.t_eelstock_eel 
  WHERE eel_value is not NULL
  AND eel_qal_id in (1,2,3,4)
  AND eel_cou_code = 'EE'  
  AND eel_hty_code IS NOT NULL
  AND eel_typ_id= 11
  ORDER BY eel_emu_nameshort, eel_typ_id, eel_lfs_code, eel_year;

-- remove duplicates for aquaculture (2002 to 2016) some qal_id 3, in fact data are entered with or without habitat, so we have duplicated values.

-- SE Mail sent to Josefin and Rob

SELECT * FROM 
 datwgeel.t_eelstock_eel 
  WHERE eel_value is not NULL
  AND eel_qal_id in (1,2,3,4)
  AND eel_hty_code = 'C'
  AND eel_emu_nameshort = 'SE_total'



-- Check transitional waters 4, 6 in 2019 and 4 2020 2023 YS





-- see database_edition_2025.sql in wgeel for query
  


  



with dupl AS (
SELECT *, count(eel_area_division)  OVER (PARTITION BY eel_typ_id, eel_emu_nameshort,  eel_year, eel_lfs_code)
 FROM  datwgeel.t_eelstock_eel 
  WHERE eel_hty_code = 'T'   
  AND eel_value is not NULL
  AND eel_qal_id in (1,2,3,4))
  SELECT * FROM dupl WHERE count>1; --2

-- OK there is a duplicate with qal_id 3 for ES_Cata ES G T 37.1.1

with dupl AS (
SELECT *, count(eel_area_division)  OVER (PARTITION BY eel_typ_id, eel_emu_nameshort,  eel_year, eel_lfs_code)
 FROM  datwgeel.t_eelstock_eel 
  WHERE eel_hty_code = 'T'   
  AND eel_value is not NULL
  AND eel_qal_id in (1,2,3,4))
  SELECT * FROM dupl WHERE count=1; --1254

with dupl AS (
SELECT *, count(eel_area_division)  OVER (PARTITION BY eel_typ_id, eel_emu_nameshort,  eel_year, eel_lfs_code)
 FROM  datwgeel.t_eelstock_eel 
  WHERE eel_hty_code = 'T'   
  AND eel_value is not NULL
  AND eel_qal_id in (1,2,3,4))
  SELECT DISTINCT ON (eel_typ_id, eel_emu_nameshort, eel_lfs_code, eel_area_division) eel_typ_id, eel_emu_nameshort, eel_lfs_code, eel_area_division  FROM dupl 
 ; --1254  
 
------------------------------------------------------------------
-- insert coastal waters where eel_area_division is not NULL
 ------------------------------------------------------------------
 
 DROP TABLE tempo.emu_div;
 CREATE TABLE tempo.emu_div AS 
 SELECT DISTINCT ON (eel_cou_code, eel_emu_nameshort, eel_area_division) 
 eel_cou_code, eel_emu_nameshort, 
  eel_area_division,   
  NULL AS area_code
 FROM  datwgeel.t_eelstock_eel 
  WHERE eel_value is not NULL
  AND eel_qal_id in (1,2,3,4)
  AND eel_area_division IS NOT NULL
  order by (eel_emu_nameshort);--21
  UPDATE tempo.emu_div set area_code = eel_area_division 
  WHERE eel_emu_nameshort IN
  (SELECT emu_nameshort from refwgeel.tr_emusplit_ems where emu_sea like '%A%' OR emu_sea = 'N9');-- 38


  SELECT * FROM datwgeel.t_eelstock_eel WHERE eel_emu_nameshort='IT_Pugl' AND eel_area_division='37.2.2' 
   SELECT * FROM datwgeel.t_eelstock_eel WHERE eel_emu_nameshort='NO_total' AND eel_area_division='27.7.a'  
DELETE FROM tempo.emu_div WHERE eel_emu_nameshort='IT_Pugl' AND eel_area_division='37.2.2'; -- just one line in T no pb
UPDATE tempo.emu_div
  SET area_code='37.2.1.17'
  WHERE eel_emu_nameshort='AL_total' AND eel_area_division='37.2.2';
UPDATE tempo.emu_div
  SET area_code='27.3.b, c'
  WHERE eel_emu_nameshort='DK_total' AND eel_area_division='27.3.b, c';
UPDATE tempo.emu_div
  SET area_code='37.1.1.4'
  WHERE eel_emu_nameshort='DZ_total' AND eel_area_division='37.1.1';
UPDATE tempo.emu_div
  SET area_code='37.3.2.26'
  WHERE eel_emu_nameshort='EG_total' AND eel_area_division='37.3.2';
UPDATE tempo.emu_div
  SET area_code='37.3.1.22'
  WHERE eel_emu_nameshort='GR_EaMT' AND eel_area_division='37.3.1';
UPDATE tempo.emu_div
  SET area_code='37.2.2.20'
  WHERE eel_emu_nameshort='GR_NorW' AND eel_area_division='37.2.2';
UPDATE tempo.emu_div
  SET area_code='37.2.2.20'
  WHERE eel_emu_nameshort='GR_WePe' AND eel_area_division='37.2.2';
UPDATE tempo.emu_div
  SET area_code='37.2.1.17'
  WHERE eel_emu_nameshort='HR_total' AND eel_area_division='37.2.1';
UPDATE tempo.emu_div
  SET area_code='37.2.1.17'
  WHERE eel_emu_nameshort='IT_Emil' AND eel_area_division='37.2.1';
UPDATE tempo.emu_div
  SET area_code='37.2.1.17'
  WHERE eel_emu_nameshort='IT_Frio' AND eel_area_division='37.2.1';
UPDATE tempo.emu_div
  SET area_code='37.2.1.17'
  WHERE eel_emu_nameshort='IT_Lazi' AND eel_area_division='37.1.3';
UPDATE tempo.emu_div
  SET area_code='37.2.1.17'
  WHERE eel_emu_nameshort='IT_Pugl' AND eel_area_division='37.2.1';
UPDATE tempo.emu_div
  SET area_code='37.3.1.112'
  WHERE eel_emu_nameshort='IT_Sard' AND eel_area_division='37.1.3';
UPDATE tempo.emu_div
  SET area_code='37.1.3.9'
  WHERE eel_emu_nameshort='IT_Tosc' AND eel_area_division='37.1.3';
UPDATE tempo.emu_div
  SET area_code='37.2.1.17'
  WHERE eel_emu_nameshort='IT_Vene' AND eel_area_division='37.2.1';
UPDATE tempo.emu_div
  SET area_code='37.2.1.17'
  WHERE eel_emu_nameshort='SI_total' AND eel_area_division='37.2.1';
UPDATE tempo.emu_div
  SET area_code='37.2.2.13'
  WHERE eel_emu_nameshort='TN_EC' AND eel_area_division='37.2.2';
UPDATE tempo.emu_div
  SET area_code='37.1.3.12'
  WHERE eel_emu_nameshort='TN_NE' AND eel_area_division='37.1.3';
UPDATE tempo.emu_div
  SET area_code='37.1.3.12'
  WHERE eel_emu_nameshort='TN_Nor' AND eel_area_division='37.1.3';
UPDATE tempo.emu_div
  SET area_code='37.2.2.14'
  WHERE eel_emu_nameshort='TN_SO' AND eel_area_division='37.2.2';

DELETE FROM tempo.emu_div
  WHERE eel_emu_nameshort='ES_Mino' AND eel_area_division='37.1.1';
DELETE FROM tempo.emu_div
  WHERE eel_emu_nameshort='ES_Vale' AND eel_area_division='37.1.2';
DELETE FROM tempo.emu_div
  WHERE eel_emu_nameshort='IT_Pugl' AND eel_area_division='37.2.2';
UPDATE tempo.emu_div
  SET area_code='37.1.1.5'
  WHERE eel_emu_nameshort='ES_Bale' AND eel_area_division='37.1.1';
UPDATE tempo.emu_div
  SET area_code='37.1.1.6'
  WHERE eel_emu_nameshort='ES_Cata' AND eel_area_division='37.1.1';
UPDATE tempo.emu_div
  SET area_code='27.9.a'
  WHERE eel_emu_nameshort='ES_Minh' AND eel_area_division='27.9.a';
UPDATE tempo.emu_div
  SET area_code='27.9.a'
  WHERE eel_emu_nameshort='ES_Mino' AND eel_area_division='27.9.a';
UPDATE tempo.emu_div
  SET area_code='37.1.1.6'
  WHERE eel_emu_nameshort='ES_Vale' AND eel_area_division='37.1.1';
UPDATE tempo.emu_div
  SET area_code='37.1.1.1'
  WHERE eel_emu_nameshort='ES_Murc' ;
UPDATE tempo.emu_div
  SET area_code='27.3.d'
  WHERE eel_emu_nameshort='LT_total' AND eel_area_division='27.3.d';
UPDATE tempo.emu_div
  SET area_code='27.3.a'
  WHERE eel_emu_nameshort='NO_total' AND eel_area_division='27.3.a';
UPDATE tempo.emu_div
  SET area_code='27.4.a'
  WHERE eel_emu_nameshort='NO_total' AND eel_area_division='27.4.a';
UPDATE tempo.emu_div
  SET area_code='27.2.a'
  WHERE eel_emu_nameshort='NO_total' AND eel_area_division='27.7.a';
UPDATE tempo.emu_div
  SET area_code='27.3.d'
  WHERE eel_emu_nameshort='PL_total' AND eel_area_division='27.3.d';
UPDATE tempo.emu_div
  SET eel_area_division='27.9.a',area_code='27.9.a'
  WHERE eel_emu_nameshort='PT_total' AND eel_area_division='27.9.a';
UPDATE tempo.emu_div
  SET area_code='27.3.d'
  WHERE eel_emu_nameshort='SE_Ea_o' AND eel_area_division='27.3.d';
UPDATE tempo.emu_div
  SET area_code='27.3.d'
  WHERE eel_emu_nameshort='SE_So_o' AND eel_area_division='27.3.d';
UPDATE tempo.emu_div
  SET area_code='37.3.1.22'
  WHERE eel_emu_nameshort='GR_total' AND eel_area_division='37.3.1' ;
  

 
 

  

  
  
INSERT INTO tempo.emu_div (eel_cou_code,eel_emu_nameshort,area_code)
  VALUES ('EE','EE_West','27.3.d')
INSERT INTO tempo.emu_div (eel_cou_code,eel_emu_nameshort,area_code)
  VALUES ('EE','EE_West','27.3.d')  

INSERT INTO dateel.t_stock_sto
(sto_id, sto_met_var, sto_year, sto_spe_code, sto_value, sto_are_code, 
sto_cou_code, sto_lfs_code, sto_hty_code,  sto_qal_code, 
sto_qal_comment, sto_comment, sto_datelastupdate, sto_mis_code, 
sto_dta_code, sto_wkg_code, sto_ver_code)
SELECT
eel_id AS sto_id
, m.met_var AS sto_met_var
, e.eel_year AS sto_year
, '127186' AS  sto_spe_code
, e.eel_value AS sto_value
, emu_div.area_code AS sto_are_code
--, e.eel_area_division 
, e.eel_cou_code AS sto_cou_code 
, e.eel_lfs_code  AS sto_lfs_code
, CASE 
      WHEN e.eel_hty_code = 'AL' THEN NULL
      WHEN e.eel_hty_code = 'F' THEN 'FW'
      WHEN e.eel_hty_code = 'MO' THEN 'MO'
      WHEN e.eel_hty_code = 'C' THEN 'MC'
      WHEN e.eel_hty_code = 'T' THEN 'T'
      WHEN e.eel_hty_code IS NULL THEN NULL
      ELSE 'TROUBLE' END AS sto_hty_code
--, NULL AS sto_fia_code -- fishing area
, e.eel_qal_id AS sto_qal_code 
, e.eel_qal_comment AS sto_qal_comment 
, e.eel_comment AS sto_comment
, e.eel_datelastupdate AS sto_datelastupdate
, e.eel_missvaluequal AS sto_mis_code
, 'Public' AS sto_dta_code
, 'WGEEL' AS sto_wkg_code
, CASE
     WHEN e.eel_datasource = 'wgeel_2016' THEN 'WGEEL-2016-1'  
     WHEN e.eel_datasource = 'dc_2017' THEN 'WGEEL-2017-1'
     WHEN e.eel_datasource = 'weel_2017' THEN 'WGEEL-2017-2'     
     WHEN e.eel_datasource = 'dc_2018' THEN 'WGEEL-2018-1'
     WHEN e.eel_datasource = 'dc_2019' THEN 'WGEEL-2019-1'     
     WHEN e.eel_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN e.eel_datasource = 'dc_2021' THEN 'WGEEL-2021-1'
     WHEN e.eel_datasource = 'dc_2022' THEN 'WGEEL-2022-1'
     WHEN e.eel_datasource = 'dc_2023' THEN 'WGEEL-2023-1'
     WHEN e.eel_datasource = 'dc_2024' THEN 'WGEEL-2024-1'
     WHEN e.eel_datasource = 'wkemp_2025' THEN 'WGEEL-2025-1'
     ELSE 'TROUBLE AND THIS SHOULD FAIL' END AS sto_ver_code
FROM datwgeel.t_eelstock_eel e 
JOIN dateel.t_metadata_met m ON m.met_type::int = e.eel_typ_id
LEFT JOIN tempo.emu_div ON (emu_div.eel_emu_nameshort,emu_div.eel_area_division) = (e.eel_emu_nameshort, e.eel_area_division)
WHERE eel_qal_id IN (0,1,2,3,4)
AND e.eel_hty_code ='C'
AND e.eel_value IS NOT NULL
AND e.eel_area_division IS NOT NULL; -- 1295

--------------------------------------------------------
-- insert coastal waters where eel_area_division is NULL
--------------------------------------------------------

CREATE TABLE tempo.emu_null AS SELECT * FROM tempo.emu_div WHERE
eel_emu_nameshort IN (SELECT DISTINCT eel_emu_nameshort FROM
datwgeel.t_eelstock_eel e 
WHERE e.eel_qal_id IN (0,1,2,3,4)
AND e.eel_hty_code ='C'
AND e.eel_value IS NOT NULL
AND e.eel_area_division IS NULL)

-- See joplin, I have to make some choice, the best for SE_East, DK, and NO would be to split values per eel_hty
-- and not have any null values.
DELETE FROM tempo.emu_null
  WHERE eel_emu_nameshort='DK_Mari' AND eel_area_division='27.3.a';
DELETE FROM tempo.emu_null
  WHERE eel_emu_nameshort='DK_Mari' AND eel_area_division='27.4.b';
DELETE FROM tempo.emu_null
  WHERE eel_emu_nameshort='DE_Warn' AND eel_area_division='27.3.b, c';
DELETE FROM tempo.emu_null
  WHERE eel_emu_nameshort='SE_East' AND eel_area_division='27.3.a';
DELETE FROM tempo.emu_null
  WHERE eel_emu_nameshort='SE_East' AND eel_area_division='27.3.b, c';
DELETE FROM tempo.emu_null
  WHERE eel_emu_nameshort='NO_total' AND eel_area_division='27.4.a';
DELETE FROM tempo.emu_null
  WHERE eel_emu_nameshort='NO_total' AND eel_area_division='27.7.a';



INSERT INTO dateel.t_stock_sto
(sto_id, sto_met_var, sto_year, sto_spe_code, sto_value, sto_are_code, 
sto_cou_code, sto_lfs_code, sto_hty_code,  sto_qal_code, 
sto_qal_comment, sto_comment, sto_datelastupdate, sto_mis_code, 
sto_dta_code, sto_wkg_code, sto_ver_code)
SELECT
eel_id AS sto_id
, m.met_var AS sto_met_var
, e.eel_year AS sto_year
, '127186' AS  sto_spe_code
, e.eel_value AS sto_value
, emu_null.area_code AS sto_are_code
--, e.eel_area_division 
--, e.eel_emu_nameshort
, e.eel_cou_code AS sto_cou_code 
, e.eel_lfs_code  AS sto_lfs_code
, CASE 
      WHEN e.eel_hty_code = 'AL' THEN NULL
      WHEN e.eel_hty_code = 'F' THEN 'FW'
      WHEN e.eel_hty_code = 'MO' THEN 'MO'
      WHEN e.eel_hty_code = 'C' THEN 'MC'
      WHEN e.eel_hty_code = 'T' THEN 'T'
      WHEN e.eel_hty_code IS NULL THEN NULL
      ELSE 'TROUBLE' END AS sto_hty_code
--, NULL AS sto_fia_code -- fishing area
, e.eel_qal_id AS sto_qal_code 
, e.eel_qal_comment AS sto_qal_comment 
, e.eel_comment AS sto_comment
, e.eel_datelastupdate AS sto_datelastupdate
, e.eel_missvaluequal AS sto_mis_code
, 'Public' AS sto_dta_code
, 'WGEEL' AS sto_wkg_code
, CASE
     WHEN e.eel_datasource = 'wgeel_2016' THEN 'WGEEL-2016-1'  
     WHEN e.eel_datasource = 'dc_2017' THEN 'WGEEL-2017-1'
     WHEN e.eel_datasource = 'weel_2017' THEN 'WGEEL-2017-2'     
     WHEN e.eel_datasource = 'dc_2018' THEN 'WGEEL-2018-1'
     WHEN e.eel_datasource = 'dc_2019' THEN 'WGEEL-2019-1'     
     WHEN e.eel_datasource = 'dc_2020' THEN 'WGEEL-2020-1'
     WHEN e.eel_datasource = 'dc_2021' THEN 'WGEEL-2021-1'
     WHEN e.eel_datasource = 'dc_2022' THEN 'WGEEL-2022-1'
     WHEN e.eel_datasource = 'dc_2023' THEN 'WGEEL-2023-1'
     WHEN e.eel_datasource = 'dc_2024' THEN 'WGEEL-2024-1'
     WHEN e.eel_datasource = 'wkemp_2025' THEN 'WGEEL-2025-1'
     ELSE 'TROUBLE AND THIS SHOULD FAIL' END AS sto_ver_code
FROM datwgeel.t_eelstock_eel e 
JOIN dateel.t_metadata_met m ON m.met_type::int = e.eel_typ_id
LEFT JOIN tempo.emu_null ON (emu_null.eel_emu_nameshort) = (e.eel_emu_nameshort)
WHERE eel_qal_id IN (0,1,2,3,4)
AND e.eel_hty_code ='C'
AND e.eel_value IS NOT NULL
AND e.eel_area_division IS NULL
AND e. eel_emu_nameshort != 'SE_total'; -- 1057

SELECT * FROM datwgeel.t_eelstock_eel WHERE eel_id ='567218';

SELECT * FROM datwgeel.t_eelstock_eel WHERE 
eel_qal_id IN (0,1,2,3,4)
AND eel_hty_code ='C'
AND eel_value IS NOT NULL
AND eel_area_division IS NULL
AND eel_emu_nameshort = 'SE_total'; --4 lines


-- TODO eel_percent
-- TODO see later TO INSERT deprecated values



SELECT DISTINCT version FROM public."database"
SELECT DISTINCT version FROM public."database_archive"
SELECT DISTINCT area FROM public."database_archive" ORDER BY area
SELECT DISTINCT location FROM public."database_archive"

SELECT DISTINCT var_mod FROM public."database" WHERE location = 'delayed spawners'
SELECT DISTINCT var_mod FROM public."database_archive" WHERE location = 'main'
SELECT * FROM public."database_archive" WHERE location = 'main'

SELECT * FROM public."database_archive" WHERE location = 'main'

SELECT count(*) FROM public."database"; -- 50076
SELECT count(*) FROM public.database_archive ; -- 391563


WITH n_data AS (
SELECT count(*) n,  "year", "type", age, area, "location", var_mod FROM public.database_archive
GROUP BY   "year", "type", age, area, "location", var_mod)
SELECT DISTINCT n FROM n_data WHERE n>1 ORDER BY n DESC;  -- 2 to 14 repetitions
 

-- When sereral repetitions are there, they have different data_time
WITH n_data AS (
SELECT count(*) n,  "year", "type", age, area, "location", var_mod, "date_time" FROM public.database_archive
GROUP BY   "year", "type", age, area, "location", var_mod, "date_time")
SELECT DISTINCT n FROM n_data ORDER BY n DESC;  


WITH n_data AS (
SELECT count(*) n, "year", "type", age, area, "location", var_mod FROM public.database
GROUP BY  "year", "type", age, area, "location", var_mod)
SELECT * FROM n_data WHERE n>1 ORDER BY n DESC


-- Is area necessary ?

WITH n_data AS (
SELECT count(*) n, "year", "type", age, "location", var_mod FROM public.database
GROUP BY  "year", "type", age,  "location", var_mod)
SELECT * FROM n_data WHERE n>1 ORDER BY n DESC



SELECT DISTINCT life_stage FROM public.metadata

"ref".tr_metrictype_mty

CREATEDB -U postgres migdb

CREATE TABLE "ref".tr_pararmeter_parm (
  parm_id serial4 NOT NULL,
  parm_name TEXT NOT NULL UNIQUE,
  parm_species TEXT
  parm_description text NULL,
  parm_uni_code varchar(20) NULL,
  CONSTRAINT parm_pkey PRIMARY KEY (typ_id),
  CONSTRAINT c_fk_parm_uni_code FOREIGN KEY (typ_uni_code) REFERENCES "ref".tr_units_uni(uni_code) ON UPDATE CASCADE
);



SELECT * FROM DATABASE WHERE var_mod='p_smolt_gamma_pr'


SELECT * FROM public.metadata AS m WHERE definition ILIKE '%female%'

SELECT * FROM public.metadata AS m WHERE var_mod LIKE '%eggs%'

SELECT * FROM public.metadata AS m WHERE nimble = 'other'



-- testing for version

With checklarger as (SELECT count(*) c, version, area, var_mod, year 
FROM public.database
group by version, area, var_mod, year)
SELECT * FROM checklarger where c >5;

SELECT * FROM public.DATABASE WHERE var_mod = 'eggs' AND VERSION = 10 AND area ='NI_FB' AND YEAR = 1972
-- OK it's two ages

SELECT * FROM public.DATABASE WHERE var_mod = 'omega' AND area ='SF' ;
-- OK pour celui location est rentré comme area (c'est le seul)

SELECT * FROM public.DATABASE WHERE var_mod = 'p_smolt' AND area ='SF' ;

-- here it's 6 because we have 6 ages.

With checklarger as (SELECT count(*) c,  area, var_mod, "year", "location",age
FROM public.database
group by version, area, var_mod, "year", "location", age)
SELECT * FROM checklarger where c= 1;

ALTER TABLE "database" ADD CONSTRAINT c_uk_area_varmod_year_location_age UNIQUE  (area, var_mod, "year", "location", age);
ALTER TABLE "database_archive" ADD CONSTRAINT c_uk_archive_version_area_varmod_year_location_age UNIQUE  ("version", area, var_mod, "year", "location", age);


SELECT * FROM database_archive
WHERE  area= 'EW'
AND var_mod = 'p_C8_NEC_3_far_mu'
AND "year" = 1976
AND "location" = 'FAR - by SU'
AND age ='2SW'

SELECT version()

SELECT * FROM database WHERE YEAR IS NULL; -- 905 lines


SELECT * FROM DATABASE WHERE var_mod = 'mu_N1_pr'
SELECT * FROM DATABASE WHERE var_mod = 'omega'

 WITH uk AS (SELECT DISTINCT age, var_mod FROM DATABASE),
 W AS (SELECT *, count (*) OVER (PARTITION BY var_mod) AS n FROM uk)
 SELECT * FROM W  WHERE n> 1
 
 ALTER SEQUENCE dat.t_stock_sto_sto_id_seq RESTART WITH 1;
 DELETE FROM datnas.t_stock_sto;
 INSERT INTO datnas.t_stock_sto
(sto_id, sto_met_var, sto_year, sto_spe_code, sto_value, sto_are_code, 
sto_cou_code, sto_lfs_code, sto_hty_code, sto_fia_code, sto_qal_code, 
sto_qal_comment, sto_comment, sto_datelastupdate, sto_mis_code, 
sto_dta_code, sto_wkg_code,sto_add_code)
SELECT 
nextval('dat.t_stock_sto_sto_id_seq'::regclass) AS sto_id
, d.var_mod AS sto_met_var
, d.year AS sto_year
, 'SAL' AS  sto_spe_code
, d.value AS sto_value
, d.area AS sto_are_code
, NULL AS sto_cou_code -- OK can be NULL
, CASE WHEN m.life_stage = 'Eggs' THEN 'E'
    WHEN m.life_stage = 'Adult' THEN 'A'
    WHEN m.life_stage = 'Multiple' THEN 'AL'
    WHEN m.life_stage = 'Adults' THEN 'A'
    WHEN m.life_stage = 'Smolts' THEN 'SM'
    WHEN m.life_stage = 'Non mature' THEN 'PS' -- IS THAT RIGHT ?
    WHEN m.life_stage = 'PFA' THEN 'PS' -- No VALUES
    WHEN m.life_stage = 'Spawners' THEN 'A' -- No values
    WHEN m.life_stage = '_' THEN '_'
   ELSE 'TROUBLE' END AS sto_lfs_code 
, NULL AS sto_hty_code
, NULL AS sto_fia_code -- fishing area
, 1 AS sto_qal_code -- see later TO INSERT deprecated values
, NULL AS sto_qal_comment 
, NULL AS sto_comment
, date(d.date_time) AS sto_datelastupdate
, NULL AS sto_mis_code
, 'Public' AS sto_dta_code
, 'WGNAS' AS sto_wkg_code
, CASE WHEN d.var_mod IN ('eggs','p_smolt', 'p_smolt_pr', 'prop_female') THEN d.age
       WHEN d.var_mod IN ('omega') THEN d.LOCATION
       END AS sto_add_code
FROM refsalmoglob."database" d JOIN
refsalmoglob.metadata m ON m.var_mod = d.var_mod; --45076


SELECT *
FROM refsalmoglob."database" d JOIN
refsalmoglob.metadata m ON m.var_mod = d.var_mod


SELECT * FROM refsalmoglob.metadata WHERE life_stage='PFA'

SELECT * FROM refsalmoglob.DATABASE WHERE var_mod = 'logN4';

SELECT * FROM refsalmoglob.DATABASE WHERE var_mod = 'omega';


SELECT * FROM datnas.t_metadata_met WHERE met_var = 'log_C5_NAC_2_lbnf_oth_sd'
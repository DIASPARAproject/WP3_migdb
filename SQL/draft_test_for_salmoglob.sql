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
-- OK pour celui location est rentr� comme area (c'est le seul)

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


SELECT * FROM 

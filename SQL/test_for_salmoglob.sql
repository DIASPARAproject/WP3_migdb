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
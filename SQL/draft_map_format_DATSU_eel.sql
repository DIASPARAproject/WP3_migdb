SELECT table_schema, table_name, column_name
  FROM information_schema.columns
 WHERE table_schema  ='dateel'
   AND table_name   in ('t_fish_fi' ,'t_group_gr' ,'t_grouptrait_grt' ,'t_indivtrait_int' ,'t_serannual_san' ,'t_series_ser'
)   ORDER BY table_name, ordinal_position;


WITH sumup AS(
SELECT ser_cou_code AS "Country", 
       count (*) AS nbyear,
       ser_code
       FROM dateel.t_series_ser
       JOIN dateel.t_serannual_san ON san_ser_id = ser_id
       GROUP BY "Country", ser_code)
SELECT * FROM sumup ORDER BY "Country", nbyear desc;

BE YserG
DE EmsGn DoElY
DK VidaG RibS
ES EbroG OriaG NalS
FI VaakS KotkS VesiY
GB BannGY GiBS LeeY BeeG
GR NorwS ArgY WepeS
IE ErneGY BurS ShaAGY 
IT PogoS TibeG PobeY
LT CurlS AlauS CurlY
LV DaugY LilS DaugS
NL RhDOG IjsY RhIjG
NO SkaY ImsaGY ImsaS
PL VisY
PT MiPoG MonY MonS
SE GotaY YFS2G KavlS


# Dump referientials to server 28/04/25
pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table ref.tr_trait_tra -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table 'ref."EDMO"' -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table 'ref."EDMO"' -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table 'ref."PRGOV"' --table 'ref."PURPM"' --table 'ref."SemanticRelation"' --table 'ref."Station_DTYPE"' -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table 'ref."WLTYP"' --table 'ref."MSTAT"' --table 'ref."Deprecated"' --table 'ref."StationDictionary"' -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table ref.tr_fishway_fiw --table ref.tr_gear_gea --table ref.tr_habitattype_hty --table ref.tr_monitoring_mon --table ref.tr_sex_sex --table ref.tr_traitmethod_trm --table ref.tr_traitnumeric_trn --table ref.tr_traitqualitative_trq --table ref.tr_traitvaluequal_trv  --table ref.tr_habitatlevel_hab -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table ref.tr_version_ver --table refnas.tg_additional_add --table refnas.tr_version_ver -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara


pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table ref.tr_habitat_hab -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara


pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table ref.tr_quality_qal -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara -c "DROP SCHEMA dat CASCADE;"

psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara -c "DROP SCHEMA datnas CASCADE;"



pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --schema dat --schema datnas -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara


pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --schema dat --schema datnas-v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara -c "DROP SCHEMA refeel CASCADE;"


psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara -c "DROP SCHEMA dateel CASCADE;"


psql --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara -c "ALTER TABLE dateel.t_series_ser ALTER COLUMN ser_are_code drop not null;"


pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --schema refeel --schema dateel -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara


pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --schema dateel -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara


psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara



DROP TABLE IF EXISTS dateel.t_grouptrait_grt CASCADE;
DROP TABLE IF EXISTS dateel.t_indivtrait_int CASCADE;
DROP TABLE IF EXISTS dateel.t_fish_fi CASCADE;
DROP TABLE IF EXISTS dateel.t_group_gr CASCADE;
DROP TABLE IF EXISTS dateel.tj_seriesstation_ses CASCADE;
DROP TABLE IF EXISTS dateel.t_recruitmentmetadata_met CASCADE;
DROP TABLE IF EXISTS dateel.t_serannual_san CASCADE;
DROP TABLE IF EXISTS dateel.t_series_ser CASCADE;
\q

# I have needed to drop non null constraint that are inherited from dat


psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

ALTER TABLE dat.t_series_ser ALTER COLUMN ser_are_code DROP NOT NULL;
ALTER TABLE dat.t_series_ser ALTER COLUMN ser_cou_code DROP NOT NULL;

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table dateel.t_series_ser --table dateel.t_serannual_san --table dateel.t_recruitmentmetadata_met --table dateel.tj_seriesstation_ses -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table dateel.t_series_ser --table dateel.t_serannual_san --table dateel.t_recruitmentmetadata_met --table dateel.tj_seriesstation_ses -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara


pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table dateel.t_group_gr --table dateel.t_fish_fi --table dateel.t_indivtrait_int --table dateel.t_grouptrait_grt -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara


# dump structure from dam
pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/damdb --schema nomenclature --schema dbmig -v | 
pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/damdb --schema dbmig -f "C:/temp/dam.sql" 
psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara -f "C:/temp/dam.sql" 



# dump local table to the server
pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}:5433/diaspara --table temp_t_stock_sto_n1 | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara


C:/"Program Files"/PostgreSQL/14/bin/pg_dump -U postgres --table temp_t_stock_sto_n1 -Fc -v -f test.dump diaspara

C:/"Program Files"/PostgreSQL/14/bin/pg_restore -U postgres -h db.mercure.eaux-et-vilaine.bzh -d diaspara  test.dump
pg_restore -U postgres -h localhost -d diaspara  test.dump

# dump server to local

pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara --schema ref --schema refbast --schema refeel --schema refnas -Fc -v "C:/temp/diaspara0.backup"
pg_restore --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara "C:/temp/diaspara0.backup"
pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara --schema dat --schema catbast --schema dateel --schema datnas -Fc -v -f "C:/temp/diaspara1.backup"
pg_restore --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara "C:/temp/diaspara1.backup"
pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara  --schema datbast -Fc -v -f "C:/temp/diaspara1.backup"
pg_restore --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara "C:/temp/diaspara1.backup"

pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara  --schema dam --schema nomenclature --schema dam_france --schema dattrutta --schema electrofishing -Fc -v -f "C:/temp/diaspara2.backup"
pg_restore --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara "C:/temp/diaspara2.backup"
psql --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara
#CREATE EXTENSION IF NOT EXISTS ""uuid-ossp"

pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara  --schema h_adriatic --schema h_baltic22to26 --schema h_baltic27to29_32 --schema h_baltic30to31 --schema h_barents --schema h_biscayiberian --schema h_blacksea  -Fc -v -f "C:/temp/diaspara3.backup"
pg_restore --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara "C:/temp/diaspara3.backup"


pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara  --schema h_celtic --schema h_iceland --schema h_medcentral --schema h_medeast --schema h_medwest --schema h_norwegian --schema h_nseanorth  -Fc -v -f "C:/temp/diaspara4.backup"
pg_restore --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara "C:/temp/diaspara4.backup"

pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara  --schema h_nseasouth --schema h_nseauk --schema h_southatlantic --schema h_southmedcentral --schema h_southmedeast --schema h_southmedwest --schema h_svalbard  -Fc -v -f "C:/temp/diaspara5.backup"
pg_restore --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara "C:/temp/diaspara5.backup"

pg_dump --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara  --schema tempo -Fc -v -f "C:/temp/diaspara6.backup"
pg_restore --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara "C:/temp/diaspara6.backup"

psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara -c "drop table datbast.t_stock_sto;"

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --table datbast.t_stock_sto -Fc -f "C:/temp/datbast.t_stock_sto" | pg_restore --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara C:/temp/datbast.t_stock_sto
# there is a problem in having the schema tempo mandatory...

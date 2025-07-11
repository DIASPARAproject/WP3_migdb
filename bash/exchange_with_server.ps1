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

pg_dump --dbname=postgresql://${env:userlocal}:${env:passlocal}@${env:hostdiaspara}/diaspara --schema refeel --schema dateel -v | psql --dbname=postgresql://${env:usermercure}:${env:passmercure}@${env:hostmercure}/diaspara
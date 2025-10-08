-- connect as superuser
CREATE EXTENSION IF NOT EXISTS postgres_fdw;


CREATE SERVER wgeel_data_wrapper
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'wgeel');

--DROP SERVER wgnas_data_wrapper CASCADE;
CREATE SERVER wgnas_data_wrapper
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'salmoglob');

CREATE SERVER eda_data_wrapper
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'eda2.3');
 
CREATE USER MAPPING FOR USER
  SERVER wgeel_data_wrapper
  OPTIONS (user 'postgres', password 'postgres', updatable 'false');
  
CREATE USER MAPPING FOR USER
  SERVER wgnas_data_wrapper
  OPTIONS (user 'postgres', password 'postgres');

CREATE USER MAPPING FOR USER
  SERVER eda_data_wrapper
  OPTIONS (user 'postgres', password 'postgres');

 
CREATE SCHEMA refwgeel;
IMPORT FOREIGN SCHEMA ref    
    FROM SERVER wgeel_data_wrapper
    INTO refwgeel;
  
  
GRANT ALL PRIVILEGES ON SCHEMA refwgeel TO diaspara_admin;

CREATE SCHEMA datwgeel;
IMPORT FOREIGN SCHEMA datawg    
    FROM SERVER wgeel_data_wrapper
    INTO datwgeel;
  
  
GRANT ALL PRIVILEGES ON SCHEMA datwgeel TO diaspara_admin;


CREATE SCHEMA refsalmoglob;
IMPORT FOREIGN SCHEMA public    
    FROM SERVER wgnas_data_wrapper
    INTO refsalmoglob;
  
GRANT ALL PRIVILEGES ON SCHEMA refsalmoglob TO diaspara_admin;
GRANT USAGE ON SCHEMA refsalmoglob TO diaspara_read;

CREATE SCHEMA dateda;
IMPORT FOREIGN SCHEMA france    
	LIMIT TO (tr_lagunes, tr_zoneifremer_zif)
    FROM SERVER eda_data_wrapper
    INTO dateda;
  
  
GRANT ALL PRIVILEGES ON SCHEMA dateda TO diaspara_admin;
SELECT * FROM pg_stat_get_activity(NULL::integer) 


ALTER FOREIGN TABLE datwgeel.t_eelstock_eel OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_series_ser OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_fish_fi OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_group_gr OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_groupsamp_grsa OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_groupseries_grser OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_metricgroup_meg OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_metricgroupsamp_megsa OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_metricgroupseries_megser OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_metricind_mei OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_metricindsamp_meisa OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_metricindseries_meiser OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_seriesglm_sgl OPTIONS (ADD updatable 'false');
ALTER FOREIGN TABLE datwgeel.t_samplinginfo_sai OPTIONS (ADD updatable 'false');

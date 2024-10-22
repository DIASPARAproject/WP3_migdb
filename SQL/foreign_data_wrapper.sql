-- connect as superuser
CREATE EXTENSION IF NOT EXISTS postgres_fdw;


CREATE SERVER wgeel_data_wrapper
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'wgeel');
  
-- 
CREATE USER MAPPING FOR USER
  SERVER wgeel_data_wrapper
  OPTIONS (user 'postgres', password 'postgres');
  

CREATE SCHEMA refwgeel;
IMPORT FOREIGN SCHEMA ref    
    FROM SERVER wgeel_data_wrapper
    INTO refwgeel;
    
GRANT ALL PRIVILEGES ON SCHEMA refwgeel TO diaspara_admin;

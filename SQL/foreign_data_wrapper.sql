-- connect as superuser
CREATE EXTENSION IF NOT EXISTS postgres_fdw;


CREATE SERVER wgeel_data_wrapper
  FOREIGN DATA WRAPPER postgres_fdw
  OPTIONS (host 'localhost', port '5432', dbname 'wgeel');
  
-- adapter avec user password pour geola
CREATE USER MAPPING FOR USER
  SERVER wgeel_data_wrapper
  OPTIONS (user 'postgres', password 'postgres');
  

CREATE SCHEMA refwgeel;
IMPORT FOREIGN SCHEMA ref    
    FROM SERVER wgeel_data_wrapper
    INTO refwgeel;
    
-- JOIN WITH limit lm_id 622
-- test is 2154

-- TODO dans R select randomly.
--  TODO recuperer point central idsegment pour creer geom point des pseudo absences

   
-- création table segments_distance (dans public)
  
-- copie de la table de l'autre serveur
DROP TABLE IF EXISTS montepomi.t_limite_lm;
CREATE TABLE montepomi.t_limite_lm AS SELECT * FROM geol.t_limite_lm; --940--1005 22/11
CREATE INDEX ON montepomi.t_limite_lm USING gist(geom); 
CREATE INDEX ON montepomi.t_limite_lm USING btree(lm_id);   

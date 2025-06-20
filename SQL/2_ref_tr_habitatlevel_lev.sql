--DROP TABLE IF EXISTS ref.tr_habitatlevel_lev CASCADE;

CREATE TABLE ref.tr_habitatlevel_lev(
   lev_code TEXT PRIMARY KEY,
   lev_description TEXT  
);

COMMENT ON TABLE ref.tr_habitatlevel_lev 
IS 'Table of geographic levels stock, complex, country, region, basin, river,
the specific order depend according to working groups.';

GRANT ALL ON ref.tr_habitatlevel_lev TO diaspara_admin;
GRANT SELECT ON ref.tr_habitatlevel_lev TO diaspara_read; 

--DROP TABLE IF EXISTS ref.tr_missvalueqal_mis CASCADE;

CREATE TABLE ref.tr_missvalueqal_mis(
   mis_code TEXT PRIMARY KEY,
   mis_description TEXT NOT NULL,  
   mis_definition TEXT);
   
GRANT ALL ON ref.tr_missvalueqal_mis TO diaspara_admin;
GRANT SELECT ON ref.tr_missvalueqal_mis TO diaspara_read;

COMMENT ON TABLE ref.tr_missvalueqal_mis IS 'Table showing the qualification when value is missing, NC, NP, NR.';
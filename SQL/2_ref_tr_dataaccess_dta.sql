--DROP TABLE IF EXISTS ref.tr_dataaccess_dta CASCADE;
CREATE TABLE ref.tr_dataaccess_dta(
   dta_code TEXT PRIMARY KEY,
   dta_description TEXT  
);
GRANT ALL ON ref.tr_dataaccess_dta  TO diaspara_admin;
GRANT SELECT ON ref.tr_dataaccess_dta TO diaspara_read;
COMMENT ON TABLE ref.tr_dataaccess_dta 
IS 'Table with two values, Public or Restricted access.';
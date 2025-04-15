-- before working there should have been these constraints in the salmoglob DB

 ALTER TABLE "database" 
ADD CONSTRAINT c_uk_area_varmod_year_location_age UNIQUE  (area, var_mod, "year", "location", age);
ALTER TABLE "database_archive" ADD CONSTRAINT c_uk_archive_version_area_varmod_year_location_age 
UNIQUE  ("version", area, var_mod, "year", "location", age);

-- For the archive db, the constraint is not working meaning that we have duplicated values

SELECT DISTINCT met_nim_code FROM refnas.tr_metadata_met
JOIN refsalmoglob."database" ON var_mod = met_var
WHERE  met_cat_code ='Other'


SELECT * FROM refnas.tr_metadata_met WHERE met_var LIKE '%mu%'
SELECT DISTINCT met_modelstage FROM refnas.tr_metadata_met

-- This will create the main table to hold the stock data
-- I'm currenlty putting foreign key to ref but this is just for show because this table
-- will only contain inherited valeus



DROP TABLE IF EXISTS dat.t_stock_sto CASCADE;
CREATE TABLE dat.t_stock_sto (
  sto_id SERIAL NOT NULL,
  sto_met_var TEXT NOT NULL, 
  sto_year INT4 NULL,
  sto_spe_code VARCHAR(3) NOT NULL,
  CONSTRAINT fk_sto_met_var_met_spe_code
    FOREIGN KEY (sto_met_var, sto_spe_code) REFERENCES "ref".tr_metadata_met(met_var,met_spe_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  sto_value NUMERIC NULL,
  sto_are_code TEXT NOT NULL,
  CONSTRAINT fk_sto_are_code FOREIGN KEY (sto_are_code)
    REFERENCES "ref".tr_area_are (are_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  -- NOTE : here I'm referencing the code because it's more easy to grasp than a number, but the id is the primary key.
  -- should work stil but requires a unique constraint on code (which we have set).
  sto_cou_code VARCHAR(2) NULL,
  CONSTRAINT fk_sto_cou_code FOREIGN KEY (sto_cou_code)
    REFERENCES "ref".tr_country_cou (cou_code)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  sto_lfs_code TEXT NOT NULL,
  CONSTRAINT fk_sto_lfs_code_sto_spe_code FOREIGN KEY (sto_lfs_code, sto_spe_code)
    REFERENCES "ref".tr_lifestage_lfs (lfs_code, lfs_spe_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  sto_hty_code VARCHAR(2) NULL, 
  CONSTRAINT fk_hty_code FOREIGN KEY (sto_hty_code)
    REFERENCES "ref".tr_habitattype_hty(hty_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  sto_fia_code TEXT NULL,
  CONSTRAINT fk_sto_fia_code FOREIGN KEY(sto_fia_code)
    REFERENCES "ref".tr_fishingarea_fia(fia_code)
    ON UPDATE CASCADE ON DELETE RESTRICT, 
  sto_qal_code INT4 NOT NULL,
  CONSTRAINT fk_sto_qal_code FOREIGN KEY (sto_qal_code)
    REFERENCES "ref".tr_quality_qal(qal_code)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  sto_qal_comment TEXT NULL,
  sto_comment TEXT NULL,
  sto_datelastupdate date NULL,
  sto_mis_code VARCHAR(2) NULL,
  CONSTRAINT fk_sto_mis_code FOREIGN KEY (sto_mis_code)
  REFERENCES "ref".tr_missvalueqal_mis (mis_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  sto_dta_code TEXT DEFAULT 'Public' NULL,
  CONSTRAINT fk_dta_code FOREIGN KEY (sto_dta_code)
  REFERENCES "ref".tr_dataaccess_dta(dta_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,
  sto_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_sto_wkg_code  FOREIGN KEY (sto_wkg_code)
  REFERENCES "ref".tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT c_uk_sto_id_sto_wkg_code UNIQUE (sto_id, sto_wkg_code),
  CONSTRAINT ck_notnull_value_and_qal_code CHECK ((((sto_qal_code IS NULL) AND (sto_value IS NOT NULL)) OR 
  ((sto_qal_code IS NOT NULL) AND (sto_value IS NULL))))
  -- We removed qual_id = 0
  -- CONSTRAINT ck_qal_id_and_missvalue CHECK (((eel_missvaluequal IS NULL) OR (eel_qal_id <> 0))),
  -- TODO CHECK LATER HOW TO DEAL WITH DEPRECATED
  -- CONSTRAINT ck_removed_typid CHECK (((COALESCE(eel_qal_id, 1) > 5) OR (eel_typ_id <> ALL (ARRAY[12, 7, 5])))),
);

-- TODO : there should be a trigger to insert the date on daughter tables

COMMENT ON TABLE dat.t_stock_sto IS 
'Table including the stock data from the different schema, dateel, datnas.... This table should be empty,
 it''s getting its content by inheritance from other tables in other schema, will probably be created
 by a view in SQL server';
COMMENT ON COLUMN dat.t_stock_sto.sto_id IS 'Integer serial identifying. Only unique in this table
when looking at the pair, sto_id, sto_wkg_code';
COMMENT ON COLUMN dat.t_stock_sto.sto_met_var IS 'Name of the variable in the database, this was previously named
var_mod in the salmoglob database and eel_typ_id in the wgeel database, there is a unicity constraint based
on the pair of column sto_spe_code, sto_met_code';
-- note if we end up with a single table, then the constraint will  have to be set
-- on sto_wkg_code, sto_spe_code and sto_met_code.
COMMENT ON COLUMN dat.t_stock_sto.sto_year IS 'Year';
COMMENT ON COLUMN dat.t_stock_sto.sto_value IS 'Value if null then provide a value in sto_mis_code to explain why not provided';
COMMENT ON COLUMN dat.t_stock_sto.sto_are_code IS 'Code of the area, areas are geographical sector most often corresponding to stock units, 
see tr_area_are.';
COMMENT ON COLUMN dat.t_stock_sto.sto_cou_code IS 'Code of the country see tr_country_cou, not null';
COMMENT ON COLUMN dat.t_stock_sto.sto_lfs_code IS 'Code of the lifestage see tr_lifestage_lfs, Not null, the constraint is set on 
both lfs_code, and lfs_spe_code (as two species can have the same lifestage code.';
COMMENT ON COLUMN dat.t_stock_sto.sto_hty_code IS 'Code of the habitat type, one of MO (marine open), MC (Marine coastal), 
T (Transitional water), FW (Freshwater), null accepted';
COMMENT ON COLUMN dat.t_stock_sto.sto_fia_code IS 'For marine area, code of the ICES area (table tr_fishingarea_fia), Null accepted';
COMMENT ON COLUMN dat.t_stock_sto.sto_qal_code IS 'Code of data quality (1 good quality, 2 modified by working group, 
3 bad quality (not used), 4 dubious, 18, 19 ... historical data not used. 
Not null, Foreign key set to tr_quality_qal';
COMMENT ON COLUMN dat.t_stock_sto.sto_qal_comment IS 'Comment for the quality, for instance explaining why a data is qualified as good or dubious.';
COMMENT ON COLUMN dat.t_stock_sto.sto_comment IS 'Comment on the value';
COMMENT ON COLUMN dat.t_stock_sto.sto_datelastupdate IS 'Last update of the data';
COMMENT ON COLUMN dat.t_stock_sto.sto_mis_code IS 'When no value are given in sto_value, justify why with, NC (not collected), NP (Not pertinent), NR (Not reported),
references table tr_missvalueqal_mis, should be null if value is provided (can''t have both).';
COMMENT ON COLUMN dat.t_stock_sto.sto_dta_code IS 'Access to data, default is ''Public''';
COMMENT ON COLUMN dat.t_stock_sto.sto_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';


-- trigger on date
DROP FUNCTION datawg.update_eel_last_update();
CREATE OR REPLACE FUNCTION dat.update_sto_datelastupdate()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.sto_datelastupdate = now()::date;
    RETURN NEW; 
END;
$function$
;


CREATE TRIGGER update_sto_datelastupdate BEFORE
INSERT
    OR
UPDATE
    ON
    dat.t_stock_sto FOR EACH ROW EXECUTE FUNCTION dat.update_sto_datelastupdate();

/*
 * 
 * TODO CHECK THOSE TRIGGERS FOR WGEEL
 */
  
  /*
CREATE TRIGGER trg_check_no_ices_area AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION datawg.check_no_ices_area();
CREATE TRIGGER trg_check_the_stage AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION datawg.check_the_stage();

CREATE TRIGGER trg_check_emu_whole_aquaculture AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION datawg.checkemu_whole_country();
  */
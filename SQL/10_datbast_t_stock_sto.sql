
-- CREATE A TABLE INHERITED FROM dat.t_stock_sto.
-- Table dat.stock_sto only gets data by inheritance.
-- Here we have to build the constraints again.

DROP TABLE IF EXISTS datbast.t_stock_sto;
CREATE TABLE datbast.t_stock_sto (
    sto_gear_code text,
  CONSTRAINT fk_sto_gear_code
    FOREIGN KEY (sto_gear_code) REFERENCES  ref.tr_gear_gea(gea_code)
    ON UPDATE CASCADE ON DELETE RESTRICT,  
    sto_tip_code TEXT,
    FOREIGN KEY (sto_tip_code) REFERENCES  ref.tr_timeperiod_tip(tip_code)
    ON UPDATE CASCADE ON DELETE RESTRICT,  
    sto_timeperiod integer,
  CONSTRAINT fk_sto_met_var_met_spe_code
    FOREIGN KEY (sto_met_var, sto_spe_code) REFERENCES datbast.t_metadata_met(met_var,met_spe_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_sto_are_code FOREIGN KEY (sto_are_code)
    REFERENCES refeel.tr_area_are (are_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_sto_cou_code FOREIGN KEY (sto_cou_code)
    REFERENCES ref.tr_country_cou (cou_code)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_sto_lfs_code_sto_spe_code FOREIGN KEY (sto_lfs_code, sto_spe_code)
    REFERENCES ref.tr_lifestage_lfs (lfs_code, lfs_spe_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_hty_code FOREIGN KEY (sto_hty_code)
    REFERENCES ref.tr_habitattype_hty(hty_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  --CONSTRAINT fk_sto_fia_code FOREIGN KEY(sto_fia_code)
  --  REFERENCES ref.tr_fishingarea_fia(fia_code)
  --  ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT fk_sto_qal_code FOREIGN KEY (sto_qal_code)
    REFERENCES ref.tr_quality_qal(qal_code)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_sto_mis_code FOREIGN KEY (sto_mis_code)
  REFERENCES ref.tr_missvalueqal_mis (mis_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_dta_code FOREIGN KEY (sto_dta_code)
  REFERENCES ref.tr_dataaccess_dta(dta_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT fk_sto_wkg_code  FOREIGN KEY (sto_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT c_uk_sto_id_sto_wkg_code UNIQUE (sto_id, sto_wkg_code),
  CONSTRAINT ck_notnull_value_and_mis_code CHECK ((((sto_mis_code IS NULL) AND (sto_value IS NOT NULL)) OR 
  ((sto_mis_code IS NOT NULL) AND (sto_value IS NULL)))),
   CONSTRAINT ck_sto_timeperiod CHECK (sto_timeperiod IS NULL OR sto_timeperiod >0)
)
inherits (dat.t_stock_sto) ;

-- This table will always be for WGBAST

ALTER TABLE datbast.t_stock_sto ALTER COLUMN sto_spe_code SET DEFAULT NULL;
ALTER TABLE datbast.t_stock_sto ADD CONSTRAINT ck_spe_code CHECK (sto_spe_code='SAL' OR sto_spe_code='TRT');
ALTER TABLE datbast.t_stock_sto ALTER COLUMN sto_wkg_code SET DEFAULT 'WGBAST';
ALTER TABLE datbast.t_stock_sto ADD CONSTRAINT ck_wkg_code CHECK (sto_wkg_code='WGBAST');



ALTER TABLE datbast.t_stock_sto OWNER TO diaspara_admin;
GRANT ALL ON TABLE datbast.t_stock_sto TO diaspara_read;




COMMENT ON TABLE datbast.t_stock_sto IS 
'Table including the stock data in schema datbast.... This table feeds the dat.t_stock_sto table by inheritance. It corresponds
to the catch excel table in the original WGBAST database.';
COMMENT ON COLUMN datbast.t_stock_sto.sto_id IS 'Integer serial identifying. Only unique in this table
when looking at the pair, sto_id, sto_wkg_code';
COMMENT ON COLUMN datbast.t_stock_sto.sto_gear_code IS 'Code of the gear used, this column is specific to WGBAST, e.g. it only appears in wgbast.t_stock_sto not in dat.t_stock_sto';
COMMENT ON COLUMN datbast.t_stock_sto.sto_tip_code IS 'Code of the time period used, one of "MON" = month,"HYR" = half of year,"QTR" = quarter,"YR" = Year  this column is specific to WGBAST, e.g. it only appears in wgbast.t_stock_sto not in dat.t_stock_sto';
COMMENT ON COLUMN datbast.t_stock_sto.sto_tip_code IS 'An integer giving the value of the time period used';
COMMENT ON COLUMN datbast.t_stock_sto.sto_met_var IS 'Name of the variable in the database, this is a mixture for f_type, value type (effort E, Number N, Weight W), and species e.g. COMM_N_TRT, see databast.t_metadata_met.met_var, there is a unicity constraint based
on the pair of column sto_spe_code, sto_met_var';
-- note if we end up with a single table, then the constraint will  have to be set
-- on sto_wkg_code, sto_spe_code and sto_met_code.
COMMENT ON COLUMN datbast.t_stock_sto.sto_year IS 'Year';
COMMENT ON COLUMN datbast.t_stock_sto.sto_value IS 'Value if null then provide a value in sto_mis_code to explain why not provided';
COMMENT ON COLUMN datbast.t_stock_sto.sto_are_code IS 'Code of the area, areas are geographical sector most often corresponding to stock units, 
see tr_area_are.';
COMMENT ON COLUMN datbast.t_stock_sto.sto_cou_code IS 'Code of the country see tr_country_cou, not null';
COMMENT ON COLUMN datbast.t_stock_sto.sto_lfs_code IS 'Code of the lifestage see tr_lifestage_lfs, Not null, the constraint is set on 
both lfs_code, and lfs_spe_code (as two species can have the same lifestage code.';
COMMENT ON COLUMN datbast.t_stock_sto.sto_hty_code IS 'Code of the habitat type, one of MO (marine open), MC (Marine coastal), 
T (Transitional water), FW (Freshwater), null accepted';
COMMENT ON COLUMN datbast.t_stock_sto.sto_qal_code IS 'Code of data quality (1 good quality, 2 modified by working group, 
3 bad quality (not used), 4 dubious, 18, 19 ... historical data not used. 
Not null, Foreign key set to tr_quality_qal';
COMMENT ON COLUMN datbast.t_stock_sto.sto_qal_comment IS 'Comment for the quality, for instance explaining why a data is qualified as good or dubious.';
COMMENT ON COLUMN datbast.t_stock_sto.sto_comment IS 'Comment on the value';
COMMENT ON COLUMN datbast.t_stock_sto.sto_datelastupdate IS 'Last update of the data';
COMMENT ON COLUMN datbast.t_stock_sto.sto_mis_code IS 'When no value are given in sto_value, justify why with, NC (not collected), NP (Not pertinent), NR (Not reported),
references table tr_missvalueqal_mis, should be null if value is provided (can''t have both).';
COMMENT ON COLUMN datbast.t_stock_sto.sto_dta_code IS 'Access to data, default is ''Public''';
COMMENT ON COLUMN datbast.t_stock_sto.sto_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';
COMMENT ON COLUMN datbast.t_stock_sto.sto_ver_code IS 'Version code, references refbast.tr_version_ver, code like WGBAST-2025-1, all historical data set to  WGBAST-2024-1';

-- trigger on date
DROP FUNCTION IF EXISTS datbast.update_sto_datelastupdate CASCADE;
CREATE OR REPLACE FUNCTION datbast.update_sto_datelastupdate()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.sto_datelastupdate = now()::date;
    RETURN NEW; 
END;
$function$
;

ALTER FUNCTION datbast.update_sto_datelastupdate() OWNER TO diaspara_admin;


CREATE TRIGGER update_sto_datelastupdate BEFORE
INSERT
    OR
UPDATE
    ON
    datbast.t_stock_sto FOR EACH ROW EXECUTE FUNCTION datbast.update_sto_datelastupdate();



-- trigger to check consistency between sto_timeperiod and sto_tip_code
-- Mon
CREATE OR REPLACE FUNCTION datbast.check_time_period()
 RETURNS TRIGGER 
 LANGUAGE plpgsql
AS $check_time_period$
BEGIN
   -- sto_timeperiod is always positive or NULL
   -- if sto_tip_code = "YR" keep sto_timeperiod NULL
    IF (NEW.sto_tip_code = 'YR' AND NEW.sto_timeperiod > 0) THEN
    RAISE EXCEPTION 'sto_timeperiod should be NULL(empty) when the code for time period (sto_tip_code) is YR (year), the year is filled in column sto_year';
    END IF;
     -- if sto_tip_code = "QTR" check 1 2 3 or 4
    IF (NEW.sto_tip_code = 'QTR' AND NEW.sto_timeperiod > 4) THEN
    RAISE EXCEPTION 'sto_timeperiod should be 1, 2, 3 or 4 for quarters';
    END IF; 
    -- half of year is one or two        
    IF (NEW.sto_tip_code = 'HYR' AND NEW.sto_timeperiod > 2) THEN
    RAISE EXCEPTION 'sto_timeperiod should be 1 (first half) 2 (second half) when the code for time period (sto_tip_code) is HYR (half of year)' ;
    END IF;
    -- half of year is one or two        
    IF (NEW.sto_tip_code = 'MON' AND NEW.sto_timeperiod > 12) THEN
    RAISE EXCEPTION 'sto_timeperiod should be 1 to 12 when the code for timeperiod (sto_tip_code) is MON (Month)';
    END IF;
    RETURN NEW; 
END;
$check_time_period$;

ALTER FUNCTION datbast.check_time_period() OWNER TO diaspara_admin;


CREATE TRIGGER trg_check_time_period BEFORE
INSERT
    OR
UPDATE
    ON
    datbast.t_stock_sto FOR EACH ROW EXECUTE FUNCTION datbast.check_time_period();



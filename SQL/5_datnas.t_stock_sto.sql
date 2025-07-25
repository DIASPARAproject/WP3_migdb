
-- CREATE A TABLE INHERITED FROM dat.t_stock_sto.
-- Table dat.stock_sto only gets data by inheritance.
-- Here we have to build the constraints again.

DROP TABLE IF EXISTS datnas.t_stock_sto;
CREATE TABLE datnas.t_stock_sto (
   sto_add_code TEXT NULL,
   CONSTRAINT fk_sto_add_code FOREIGN KEY (sto_add_code) 
   REFERENCES refnas.tg_additional_add (add_code), 
  CONSTRAINT fk_sto_met_var_met_spe_code
    FOREIGN KEY (sto_met_var, sto_spe_code) REFERENCES datnas.t_metadata_met(met_var,met_spe_code) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_sto_are_code FOREIGN KEY (sto_are_code)
    REFERENCES refnas.tr_area_are (are_code) 
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
  CONSTRAINT fk_sto_fia_code FOREIGN KEY(sto_fia_code)
    REFERENCES ref.tr_fishingarea_fia(fia_code)
    ON UPDATE CASCADE ON DELETE RESTRICT, 
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
  ((sto_mis_code IS NOT NULL) AND (sto_value IS NULL))))
)
inherits (dat.t_stock_sto) ;

-- This table will always be for SALMON and WGNAS

ALTER TABLE datnas.t_stock_sto ALTER COLUMN sto_spe_code SET DEFAULT 'SAL';
ALTER TABLE datnas.t_stock_sto ADD CONSTRAINT ck_spe_code CHECK (sto_spe_code='SAL');
ALTER TABLE datnas.t_stock_sto ALTER COLUMN sto_wkg_code SET DEFAULT 'WGNAS';
ALTER TABLE datnas.t_stock_sto ADD CONSTRAINT ck_wkg_code CHECK (sto_wkg_code='WGNAS');



ALTER TABLE datnas.t_stock_sto OWNER TO diaspara_admin;
GRANT ALL ON TABLE datnas.t_stock_sto TO diaspara_read;







COMMENT ON TABLE datnas.t_stock_sto IS 
'Table including the stock data in schema datnas.... This table feeds the dat.t_stock_sto table by inheritance. It corresponds
to the database table in the original WGNAS database.';
COMMENT ON COLUMN datnas.t_stock_sto.sto_id IS 'Integer serial identifying. Only unique in this table
when looking at the pair, sto_id, sto_wkg_code';
COMMENT ON COLUMN datnas.t_stock_sto.sto_met_var IS 'Name of the variable in the database, this was previously named
var_mod in the salmoglob database and eel_typ_id in the wgeel database, there is a unicity constraint based
on the pair of column sto_spe_code, sto_met_code';
-- note if we end up with a single table, then the constraint will  have to be set
-- on sto_wkg_code, sto_spe_code and sto_met_code.
COMMENT ON COLUMN datnas.t_stock_sto.sto_year IS 'Year';
COMMENT ON COLUMN datnas.t_stock_sto.sto_value IS 'Value if null then provide a value in sto_mis_code to explain why not provided';
COMMENT ON COLUMN datnas.t_stock_sto.sto_are_code IS 'Code of the area, areas are geographical sector most often corresponding to stock units, 
see tr_area_are.';
COMMENT ON COLUMN datnas.t_stock_sto.sto_cou_code IS 'Code of the country see tr_country_cou, not null';
COMMENT ON COLUMN datnas.t_stock_sto.sto_lfs_code IS 'Code of the lifestage see tr_lifestage_lfs, Not null, the constraint is set on 
both lfs_code, and lfs_spe_code (as two species can have the same lifestage code.';
COMMENT ON COLUMN datnas.t_stock_sto.sto_hty_code IS 'Code of the habitat type, one of MO (marine open), MC (Marine coastal), 
T (Transitional water), FW (Freshwater), null accepted';
COMMENT ON COLUMN datnas.t_stock_sto.sto_fia_code IS 'For marine area, code of the ICES area (table tr_fishingarea_fia), Null accepted';
COMMENT ON COLUMN datnas.t_stock_sto.sto_qal_code IS 'Code of data quality (1 good quality, 2 modified by working group, 
3 bad quality (not used), 4 dubious, 18, 19 ... historical data not used. 
Not null, Foreign key set to tr_quality_qal';
COMMENT ON COLUMN datnas.t_stock_sto.sto_qal_comment IS 'Comment for the quality, for instance explaining why a data is qualified as good or dubious.';
COMMENT ON COLUMN datnas.t_stock_sto.sto_comment IS 'Comment on the value';
COMMENT ON COLUMN datnas.t_stock_sto.sto_datelastupdate IS 'Last update of the data';
COMMENT ON COLUMN datnas.t_stock_sto.sto_mis_code IS 'When no value are given in sto_value, justify why with, NC (not collected), NP (Not pertinent), NR (Not reported),
references table tr_missvalueqal_mis, should be null if value is provided (can''t have both).';
COMMENT ON COLUMN datnas.t_stock_sto.sto_dta_code IS 'Access to data, default is ''Public''';
COMMENT ON COLUMN datnas.t_stock_sto.sto_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';
COMMENT ON COLUMN datnas.t_stock_sto.sto_add_code IS 'Additional code in the extra dimension of the table, corresponds to area or age,
collated in table tg_additional_add';


-- trigger on date
DROP FUNCTION IF EXISTS datnas.update_sto_datelastupdate;
CREATE OR REPLACE FUNCTION datnas.update_sto_datelastupdate()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.sto_datelastupdate = now()::date;
    RETURN NEW; 
END;
$function$
;
ALTER FUNCTION datnas.update_sto_datelastupdate() OWNER TO diaspara_admin;

CREATE TRIGGER update_sto_datelastupdate BEFORE
INSERT
    OR
UPDATE
    ON
    datnas.t_stock_sto FOR EACH ROW EXECUTE FUNCTION datnas.update_sto_datelastupdate();


-- fix after change in wgeel
/*
SELECT * FROM refnas.tr_version_ver
UPDATE datnas.t_stock_sto SET sto_ver_code = 'WGNAS-2024-1'; -- 45076
*/

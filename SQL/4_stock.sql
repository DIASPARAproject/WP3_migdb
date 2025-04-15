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




CREATE TABLE dat.t_stock_sto (
  sto_id serial4 NOT NULL,
  sto_met_var NOT NULL CONSTRAINT fk_sto_met_var FOREIGN KEY REFERENCES "ref".tr_metadata_met(met_var) ,
  sto_year int4 NULL,
  sto_value numeric NULL,
  sto_are_code TEXT NOT NULL 
  CONSTRAINT fk_sto_are_code FOREIGN KEY REFERENCES "ref".tr_area_are(are_code) 
  ON UPDATE CASCADE ON DELETE CASCADE,
  -- NOTE : here I'm referencing the code because it's more easy to grasp than a number, but the id is the primary key.
  -- should work stil but requires a unique constraint on code (which we have set).
  sto_cou_code varchar(2) NULL
  CONSTRAINT fk_sto_cou_code FOREIGN KEY 
  REFERENCES "ref".tr_country_cou (cou_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  sto_lfs_code TEXT NOT NULL CONSTRAINT fk_sto_lfs_code FOREIGN KEY 
  REFERENCES "ref".tr_lifestage_lfs (lfs_code) 
  ON UPDATE CASCADE ON DELETE CASCADE,
  sto_hty_code varchar(2) NULL CONSTRAINT fk_hty_code FOREIGN KEY (sto_hty_code)
  REFERENCES "ref".tr_habitattype_hty(hty_code) 
  ON UPDATE CASCADE ON DELETE CASCADE,
  eel_area_division varchar(254) NULL,
  eel_qal_id int4 NOT NULL,
  eel_qal_comment text NULL,
  eel_comment text NULL,
  eel_datelastupdate date NULL,
  eel_missvaluequal varchar(2) NULL,
  eel_datasource varchar(100) NULL,
  eel_dta_code text DEFAULT 'Public'::text NULL,
  sto_wkg_code text NOT NULL
  CONSTRAINT ck_eel_missvaluequal CHECK ((((eel_missvaluequal)::text = 'NP'::text) OR ((eel_missvaluequal)::text = 'NR'::text) OR ((eel_missvaluequal)::text = 'NC'::text) OR ((eel_missvaluequal)::text = 'ND'::text))),
  CONSTRAINT ck_notnull_value_and_missvalue CHECK ((((eel_missvaluequal IS NULL) AND (eel_value IS NOT NULL)) OR ((eel_missvaluequal IS NOT NULL) AND (eel_value IS NULL)))),
  CONSTRAINT ck_qal_id_and_missvalue CHECK (((eel_missvaluequal IS NULL) OR (eel_qal_id <> 0))),
  CONSTRAINT ck_removed_typid CHECK (((COALESCE(eel_qal_id, 1) > 5) OR (eel_typ_id <> ALL (ARRAY[12, 7, 5])))),
  CONSTRAINT t_eelstock_eel_pkey PRIMARY KEY (eel_id),
  CONSTRAINT c_fk_area_code FOREIGN KEY (eel_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_cou_code FOREIGN KEY (eel_cou_code) REFERENCES "ref".tr_country_cou(cou_code),
  CONSTRAINT c_fk_eel_dta_code FOREIGN KEY (eel_dta_code) REFERENCES "ref".tr_dataaccess_dta(dta_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_emu FOREIGN KEY (eel_emu_nameshort,eel_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code),
  CONSTRAINT ,
  CONSTRAINT c_fk_lfs_code FOREIGN KEY (eel_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qal_id FOREIGN KEY (eel_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_typ_id FOREIGN KEY (eel_typ_id) REFERENCES "ref".tr_typeseries_typ(typ_id) ON UPDATE CASCADE
);

COMMENT ON TABLE dat.t_stock_sto IS 
'Table including the stock data from the different schema, dateel, datnas.... This table should be empty, as there are no
constraints set and it''s getting its content by inheritance from other tables in other schema';
COMMENT ON COLUMN dat.t_stock_sto.sto_id IS 'Integer serial identifying. Only unique in this table
when looking at the pair, sto_id, sto_wkg_code';
COMMENT ON COLUMN dat.t_stock_sto.sto_met_var IS 'Name of the variable in the database, this was previously named
var_mod in the salmoglob database and eel_typ_id in the wgeel database';
COMMENT ON COLUMN dat.t_stock_sto.sto_year IS 'Year';
COMMENT ON COLUMN dat.t_stock_sto.sto_value IS 'Value';
COMMENT ON COLUMN dat.t_stock_sto_sto_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';

IS 'Variable code, primary key on both met_spe_code and met_var.';
COMMENT ON COLUMN ref.tr_metadata_met.met_spe_code 
COMMENT ON COLUMN sto_id



-- HERE IS THE CODE TO CREATE THE MAIN STOCK TABLE FOR WEEL

-- DROP TABLE datawg.t_eelstock_eel;

CREATE TABLE datawg.t_eelstock_eel (
  eel_id serial4 NOT NULL,
  eel_typ_id int4 NOT NULL,
  eel_year int4 NOT NULL,
  eel_value numeric NULL,
  eel_emu_nameshort varchar(20) NOT NULL,
  eel_cou_code varchar(2) NULL, -- we don't need that one IF we have an emu
  eel_lfs_code varchar(2) NOT NULL,
  eel_hty_code varchar(2) NULL,
  eel_area_division varchar(254) NULL,
  eel_qal_id int4 NOT NULL,
  eel_qal_comment text NULL,
  eel_comment text NULL,
  eel_datelastupdate date NULL,
  eel_missvaluequal varchar(2) NULL,
  eel_datasource varchar(100) NULL,
  eel_dta_code text DEFAULT 'Public'::text NULL,
  CONSTRAINT ck_eel_missvaluequal CHECK ((((eel_missvaluequal)::text = 'NP'::text) OR ((eel_missvaluequal)::text = 'NR'::text) OR ((eel_missvaluequal)::text = 'NC'::text) OR ((eel_missvaluequal)::text = 'ND'::text))),
  CONSTRAINT ck_notnull_value_and_missvalue CHECK ((((eel_missvaluequal IS NULL) AND (eel_value IS NOT NULL)) OR ((eel_missvaluequal IS NOT NULL) AND (eel_value IS NULL)))),
  CONSTRAINT ck_qal_id_and_missvalue CHECK (((eel_missvaluequal IS NULL) OR (eel_qal_id <> 0))),
  CONSTRAINT ck_removed_typid CHECK (((COALESCE(eel_qal_id, 1) > 5) OR (eel_typ_id <> ALL (ARRAY[12, 7, 5])))),
  CONSTRAINT t_eelstock_eel_pkey PRIMARY KEY (eel_id),
  CONSTRAINT c_fk_area_code FOREIGN KEY (eel_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_cou_code FOREIGN KEY (eel_cou_code) REFERENCES "ref".tr_country_cou(cou_code),
  CONSTRAINT c_fk_eel_dta_code FOREIGN KEY (eel_dta_code) REFERENCES "ref".tr_dataaccess_dta(dta_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_emu FOREIGN KEY (eel_emu_nameshort,eel_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code),
  CONSTRAINT c_fk_hty_code FOREIGN KEY (eel_hty_code) REFERENCES "ref".tr_habitattype_hty(hty_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_lfs_code FOREIGN KEY (eel_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qal_id FOREIGN KEY (eel_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_typ_id FOREIGN KEY (eel_typ_id) REFERENCES "ref".tr_typeseries_typ(typ_id) ON UPDATE CASCADE
);
CREATE UNIQUE INDEX idx_eelstock_1 ON datawg.t_eelstock_eel USING btree (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id, eel_area_division) WHERE ((eel_hty_code IS NOT NULL) AND (eel_area_division IS NOT NULL));
CREATE UNIQUE INDEX idx_eelstock_2 ON datawg.t_eelstock_eel USING btree (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_qal_id, eel_area_division) WHERE ((eel_hty_code IS NULL) AND (eel_area_division IS NOT NULL));
CREATE UNIQUE INDEX idx_eelstock_3 ON datawg.t_eelstock_eel USING btree (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_hty_code, eel_qal_id) WHERE ((eel_hty_code IS NOT NULL) AND (eel_area_division IS NULL));
CREATE UNIQUE INDEX idx_eelstock_4 ON datawg.t_eelstock_eel USING btree (eel_year, eel_lfs_code, eel_emu_nameshort, eel_typ_id, eel_qal_id) WHERE ((eel_hty_code IS NULL) AND (eel_area_division IS NULL));

-- Table Triggers

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
CREATE TRIGGER update_eel_time BEFORE
INSERT
    OR
UPDATE
    ON
    datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION datawg.update_eel_last_update();
CREATE TRIGGER trg_check_emu_whole_aquaculture AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_eelstock_eel FOR EACH ROW EXECUTE FUNCTION datawg.checkemu_whole_country();
DROP SCHEMA IF EXISTS dat CASCADE;
CREATE SCHEMA dat;
GRANT SELECT ON SCHEMA dat TO diaspara_read;
ALTER SCHEMA dat OWNER TO diaspara_admin;
COMMENT ON SCHEMA dat IS 'SCHEMA common to all migratory fish, filled by inheritance;'

DROP SCHEMA IF EXISTS datang CASCADE;
CREATE SCHEMA datang;
GRANT SELECT ON SCHEMA datang TO diaspara_read;
ALTER SCHEMA datang OWNER TO diaspara_admin;
COMMENT ON SCHEMA dat IS 'SCHEMA for wgeel;'

DROP SCHEMA IF EXISTS datnas CASCADE;
CREATE SCHEMA datnas;
GRANT SELECT ON SCHEMA datnas TO diaspara_read;
ALTER SCHEMA datnas OWNER TO diaspara_admin;
COMMENT ON SCHEMA dat IS 'SCHEMA for wgtrutta;'

DROP SCHEMA IF EXISTS datbast CASCADE;
CREATE SCHEMA datbast;
GRANT SELECT ON SCHEMA datbast TO diaspara_read;
ALTER SCHEMA datbast OWNER TO diaspara_admin;
COMMENT ON SCHEMA datbast IS 'SCHEMA for wgbast;'

DROP SCHEMA IF EXISTS dattrt CASCADE;
CREATE SCHEMA dattrt;
GRANT SELECT ON SCHEMA dattrt TO diaspara_read;
ALTER SCHEMA dattrt OWNER TO diaspara_admin;


CREATE TABLE dat.t_mig_mig (
  mig_id serial4 NOT NULL,
  mig_met_var TEXT NOT NULL,
  mig_spe_code CHARACTER VARYING(3) NOT NULL,
  mig_wkg_code TEXT NOT NULL,
  mig_year int4 NOT NULL,
  mig_value numeric NULL,
  mig_area_id NOT NULL,
  mig_missvaluequal varchar(2) NULL,
  mig_cou_code varchar(2) NULL,
  mig_lfs_code varchar(2) NOT NULL,
  mig_hty_code varchar(2) NULL,
  mig_area_division varchar(254) NULL,
  mig_qal_id int4 NOT NULL,
  mig_qal_comment text NULL,
  mig_comment text NULL,
  mig_datelastupdate date NULL,  
  mig_datasource varchar(100) NULL,
  mig_dta_code text DEFAULT 'Public'::text NULL,
  CONSTRAINT ck_mig_missvaluequal CHECK ((((mig_missvaluequal)::text = 'NP'::text) OR ((mig_missvaluequal)::text = 'NR'::text) OR ((mig_missvaluequal)::text = 'NC'::text) OR ((mig_missvaluequal)::text = 'ND'::text))),
  CONSTRAINT ck_notnull_value_and_missvalue CHECK ((((mig_missvaluequal IS NULL) AND (mig_value IS NOT NULL)) OR ((mig_missvaluequal IS NOT NULL) AND (mig_value IS NULL)))),
  CONSTRAINT c_fk_mig_met_var FOREIGN KEY (mig_met_var) REFRENCES "ref".tr_metadata_met(met_var) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT c_fk_mig_wkg_code  TODO
  CONSTRAINT c_fk_mig_spe_code FOREIGN KEY (mig_spe_code) REFERENCES "ref".tr_species_spe(spe_code) ON UPDATE CASCADE,
  CONSTRAINT ck_qal_id_and_missvalue CHECK (((mig_missvaluequal IS NULL) OR (mig_qal_id <> 0))),
  CONSTRAINT ck_removed_typid CHECK (((COALESCE(mig_qal_id, 1) > 5) OR (mig_typ_id <> ALL (ARRAY[12, 7, 5])))),
  CONSTRAINT t_migstock_mig_pkey PRIMARY KEY (mig_id),
  CONSTRAINT c_fk_area_code FOREIGN KEY (mig_area_division) REFERENCES "ref".tr_faoareas(f_division) ON UPDATE CASCADE,
  CONSTRAINT c_fk_cou_code FOREIGN KEY (mig_cou_code) REFERENCES "ref".tr_country_cou(cou_code),
  CONSTRAINT c_fk_mig_dta_code FOREIGN KEY (mig_dta_code) REFERENCES "ref".tr_dataaccess_dta(dta_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_emu FOREIGN KEY (mig_emu_nameshort,mig_cou_code) REFERENCES "ref".tr_emu_emu(emu_nameshort,emu_cou_code),
  CONSTRAINT c_fk_hty_code FOREIGN KEY (mig_hty_code) REFERENCES "ref".tr_habitattype_hty(hty_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_lfs_code FOREIGN KEY (mig_lfs_code) REFERENCES "ref".tr_lifestage_lfs(lfs_code) ON UPDATE CASCADE,
  CONSTRAINT c_fk_qal_id FOREIGN KEY (mig_qal_id) REFERENCES "ref".tr_quality_qal(qal_id) ON UPDATE CASCADE,
  CONSTRAINT c_fk_typ_id FOREIGN KEY (mig_typ_id) REFERENCES "ref".tr_typeseries_typ(typ_id) ON UPDATE CASCADE
);
CREATE UNIQUE INDEX idx_migstock_1 ON datawg.t_migstock_mig USING btree (mig_year, mig_lfs_code, mig_emu_nameshort, mig_typ_id, mig_hty_code, mig_qal_id, mig_area_division) WHERE ((mig_hty_code IS NOT NULL) AND (mig_area_division IS NOT NULL));
CREATE UNIQUE INDEX idx_migstock_2 ON datawg.t_migstock_mig USING btree (mig_year, mig_lfs_code, mig_emu_nameshort, mig_typ_id, mig_qal_id, mig_area_division) WHERE ((mig_hty_code IS NULL) AND (mig_area_division IS NOT NULL));
CREATE UNIQUE INDEX idx_migstock_3 ON datawg.t_migstock_mig USING btree (mig_year, mig_lfs_code, mig_emu_nameshort, mig_typ_id, mig_hty_code, mig_qal_id) WHERE ((mig_hty_code IS NOT NULL) AND (mig_area_division IS NULL));
CREATE UNIQUE INDEX idx_migstock_4 ON datawg.t_migstock_mig USING btree (mig_year, mig_lfs_code, mig_emu_nameshort, mig_typ_id, mig_qal_id) WHERE ((mig_hty_code IS NULL) AND (mig_area_division IS NULL));

COMMENT ON TABLE dat.
-- Table Triggers

CREATE TRIGGER trg_check_no_ices_area AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_migstock_mig FOR EACH ROW EXECUTE FUNCTION check_no_ices_area();
CREATE TRIGGER trg_check_the_stage AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_migstock_mig FOR EACH ROW EXECUTE FUNCTION check_the_stage();
CREATE TRIGGER update_mig_time BEFORE
INSERT
    OR
UPDATE
    ON
    datawg.t_migstock_mig FOR EACH ROW EXECUTE FUNCTION update_mig_last_update();
CREATE TRIGGER trg_check_emu_whole_aquaculture AFTER
INSERT
    OR
UPDATE
    ON
    datawg.t_migstock_mig FOR EACH ROW EXECUTE FUNCTION checkemu_whole_country();
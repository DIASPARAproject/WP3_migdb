
-- DROP TABLE IF EXISTS dat.t_indivtrait_int CASCADE;


CREATE TABLE dat.t_indivtrait_int (
  int_ser_id uuid,
 CONSTRAINT fk_int_ser_id FOREIGN KEY (int_ser_id)
    REFERENCES dat.t_series_ser (ser_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,  
  int_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_int_wkg_code  FOREIGN KEY (int_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  int_spe_code TEXT NOT NULL,  
  CONSTRAINT fk_int_spe_code  FOREIGN KEY (int_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  int_id serial4 NOT NULL,
  int_fi_id int4 NOT NULL,
  CONSTRAINT fk_int_fi_id FOREIGN KEY (int_fi_id, int_wkg_code) 
  REFERENCES dat.t_fish_fi(fi_id,fi_wkg_code) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  int_tra_code TEXT NOT NULL,
  CONSTRAINT fk_int_tra_code FOREIGN KEY (int_tra_code) 
  REFERENCES ref.tr_trait_tra(tra_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  int_value numeric NULL,
  int_trv_code TEXT,
  CONSTRAINT fk_int_trv_tra_code FOREIGN KEY (int_trv_code, int_tra_code,int_wkg_code)
  REFERENCES ref.tr_traitvaluequal_trv(trv_code, trv_trq_code, trv_wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  int_trm_code TEXT,
  CONSTRAINT fk_int_trm_code FOREIGN KEY (int_trm_code)
  REFERENCES ref.tr_traitmethod_trm(trm_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  int_last_update date DEFAULT CURRENT_DATE NOT NULL,
  int_qal_code int4 NULL,
    CONSTRAINT fk_int_qal_id FOREIGN KEY (int_qal_code) 
  REFERENCES ref.tr_quality_qal(qal_code) ON UPDATE CASCADE,
  int_ver_code TEXT NOT NULL,
  CONSTRAINT fk_int_ver_code FOREIGN KEY (int_ver_code)
  REFERENCES ref.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT uk_int_fi UNIQUE (int_fi_id, int_trm_code, int_wkg_code),
  CONSTRAINT t_indivtrait_int_pkey PRIMARY KEY (int_id, int_wkg_code),
  CONSTRAINT ck_qualitative_or_numeric CHECK 
  (
  (int_value IS NULL AND int_trv_code IS NOT NULL) OR
  (int_value IS NOT NULL AND int_trv_code IS  NULL)
  )
);
CREATE INDEX dat_t_indivtrait_int_idx ON dat.t_indivtrait_int USING btree (int_fi_id);

GRANT ALL ON dat.t_indivtrait_int TO diaspara_admin;
GRANT SELECT ON dat.t_indivtrait_int TO diaspara_read; 

DROP TABLE IF EXISTS  dateel.t_indivtrait_int;
CREATE TABLE dateel.t_indivtrait_int (
 CONSTRAINT fk_int_ser_id FOREIGN KEY (int_ser_id)
    REFERENCES dateel.t_series_ser (ser_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_int_wkg_code  FOREIGN KEY (int_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_spe_code  FOREIGN KEY (int_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_fi_id FOREIGN KEY (int_fi_id, int_wkg_code) 
  REFERENCES dateel.t_fish_fi(fi_id,fi_wkg_code) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_int_tra_code FOREIGN KEY (int_tra_code) 
  REFERENCES refeel.tg_trait_tra(tra_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_trv_tra_code FOREIGN KEY (int_trv_code, int_tra_code) 
  -- unlike in dat.t_indivtrait_int this one does not take ref TO wkgcode, no need AS we are in dateel
  REFERENCES refeel.tr_traitvaluequal_trv(trv_code, trv_trq_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_trm_code FOREIGN KEY (int_trm_code)
  REFERENCES refeel.tr_traitmethod_trm(trm_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_qal_id FOREIGN KEY (int_qal_code) 
  REFERENCES ref.tr_quality_qal(qal_code) ON UPDATE CASCADE,
  CONSTRAINT fk_int_ver_code FOREIGN KEY (int_ver_code)
  REFERENCES refeel.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT uk_trv_fi_id_trv_tra_code UNIQUE(int_fi_id,int_tra_code)
) INHERITS (dat.t_indivtrait_int);
CREATE INDEX dateel_t_indivtrait_int_idx ON dateel.t_indivtrait_int USING btree (int_fi_id);

GRANT ALL ON dateel.t_indivtrait_int TO diaspara_admin;
GRANT SELECT ON dateel.t_indivtrait_int TO diaspara_read; 


COMMENT ON TABLE dateel.t_indivtrait_int IS
 'Table joining fish and traits';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_ser_id IS
 'Series UUID';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_wkg_code IS
 'Working ind on of WGEEL, WGNAS, WGBAST ...';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_spe_code IS
 'Species code here ''127186''';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_id IS
 'ID, integer, unique for wkg_code';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_fi_id IS
 'ID of the fish';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_tra_code IS
 'Code of the trait, e.g. Lengthmm';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_value IS
 'Value for numeric';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_trv_code IS
 'Value for qualitative see refeel.tr_traitvaluequal_trv';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_trm_code IS
 'Method see refeel.tr_traimethod_trm';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_last_update IS 'date last update';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_qal_code IS
 'Quality code references ref.tr_quality_qal';
COMMENT ON COLUMN dateel.t_indivtrait_int.int_ver_code IS
 'version e.g. WGEEL_2024_1';

-- TODO trigger on date

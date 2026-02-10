

GRANT ALL ON dat.t_indivtrait_int TO diaspara_admin;
GRANT SELECT ON dat.t_indivtrait_int TO diaspara_read; 

DROP TABLE IF EXISTS  datnas.t_indivtrait_int;
CREATE TABLE datnas.t_indivtrait_int (
 CONSTRAINT fk_int_ser_id FOREIGN KEY (int_ser_id)
    REFERENCES datnas.t_series_ser (ser_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_int_wkg_code  FOREIGN KEY (int_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_spe_code  FOREIGN KEY (int_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_fi_id FOREIGN KEY (int_fi_id, int_wkg_code) 
  REFERENCES datnas.t_fish_fi(fi_id,fi_wkg_code) 
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_int_tra_code FOREIGN KEY (int_tra_code) 
  REFERENCES refnas.tg_trait_tra(tra_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_trv_tra_code FOREIGN KEY (int_trv_code, int_tra_code) 
  -- unlike in dat.t_indivtrait_int this one does not take ref TO wkgcode, no need AS we are in datnas
  REFERENCES refnas.tr_traitvaluequal_trv(trv_code, trv_trq_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_trm_code FOREIGN KEY (int_trm_code)
  REFERENCES refnas.tr_traitmethod_trm(trm_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_int_qal_id FOREIGN KEY (int_qal_code) 
  REFERENCES ref.tr_quality_qal(qal_code) ON UPDATE CASCADE,
  CONSTRAINT fk_int_ver_code FOREIGN KEY (int_ver_code)
  REFERENCES refnas.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT uk_trv_fi_id_trv_tra_code UNIQUE(int_fi_id,int_tra_code)
) INHERITS (dat.t_indivtrait_int);

CREATE INDEX datnas_t_indivtrait_int_idx ON datnas.t_indivtrait_int USING btree (int_fi_id);

GRANT ALL ON datnas.t_indivtrait_int TO diaspara_admin;
GRANT SELECT ON datnas.t_indivtrait_int TO diaspara_read; 


COMMENT ON TABLE datnas.t_indivtrait_int IS
 'Table joining fish and traits';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_ser_id IS
 'Series UUID';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_wkg_code IS
 'Working ind on of WGEEL, WGNAS, WGBAST ...';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_spe_code IS
 'Species code here ''127186''';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_id IS
 'ID, integer, unique for wkg_code';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_fi_id IS
 'ID of the fish';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_tra_code IS
 'Code of the trait, e.g. Lengthmm';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_value IS
 'Value for numeric';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_trv_code IS
 'Value for qualitative see refnas.tr_traitvaluequal_trv';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_trm_code IS
 'Method see refnas.tr_traimethod_trm';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_last_update IS 'date last update';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_qal_code IS
 'Quality code references ref.tr_quality_qal';
COMMENT ON COLUMN datnas.t_indivtrait_int.int_ver_code IS
 'version e.g. WGEEL_2024_1';

-- TODO trigger on date

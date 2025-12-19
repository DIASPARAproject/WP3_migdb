--DROP TABLE IF EXISTS ref.tr_species_spe;
CREATE TABLE ref.tr_species_spe (
     spe_code CHARACTER VARYING(3) PRIMARY KEY,
     spe_commonnname TEXT,
     spe_scientificname TEXT,
     spe_codeaphia numeric NOT NULL,
     spe_description TEXT);
COMMENT ON TABLE ref.tr_species_spe IS 'Table of species code';
GRANT ALL ON TABLE ref.tr_species_spe to diaspara_admin;
GRANT SELECT ON TABLE ref.tr_species_spe to diaspara_read;

-- 19/12/2025 finally we need TO use AFIAID
-- we also remove TRT as a species 

DELETE FROM "ref".tr_species_spe  WHERE spe_code='TRT';


ALTER TABLE ref.tr_species_spe ALTER column spe_code type TEXT;


ALTER TABLE "ref"."tr_lifestage_lfs" ALTER COLUMN lfs_spe_code TYPE TEXT;

-- 19/12/2025 finally we need TO use AFIAID
-- we also remove TRT as a species 

ALTER TABLE dat.t_metadata_met ALTER COLUMN met_spe_code TYPE TEXT;

ALTER TABLE dat.t_stock_sto ALTER COLUMN sto_spe_code TYPE TEXT;

 ALTER TABLE datnas.t_metadata_met DROP
    CONSTRAINT ck_met_spe_code;
 
 ALTER TABLE datnas.t_stock_sto DROP CONSTRAINT 
ck_spe_code;

ALTER TABLE datbast.t_metadata_met DROP CONSTRAINT ck_met_spe_code;

ALTER TABLE dateel.t_metadata_met DROP CONSTRAINT ck_met_spe_code;

ALTER TABLE datnas.t_stock_sto DROP CONSTRAINT ck_spe_code;

ALTER TABLE dateel.t_stock_sto DROP CONSTRAINT ck_spe_code;

ALTER TABLE datbast.t_stock_sto DROP CONSTRAINT ck_spe_code;

UPDATE ref.tr_species_spe SET spe_code = spe_codeaphia; 


ALTER TABLE datnas.t_metadata_met ADD
    CONSTRAINT ck_met_spe_code   
    CHECK (met_spe_code='127186'); 

ALTER TABLE datnas.t_stock_sto ADD CONSTRAINT 
ck_sto_spe_code CHECK (sto_spe_code='127186');
  
ALTER TABLE datbast.t_metadata_met 
ADD CONSTRAINT ck_met_spe_code CHECK 
 (met_spe_code='127186' OR met_spe_code='127187');
 
 ALTER TABLE datbast.t_stock_sto ADD CONSTRAINT 
ck_sto_spe_code CHECK  (sto_spe_code='127186' OR sto_spe_code='127187');
 
ALTER TABLE dateel.t_metadata_met 
ADD CONSTRAINT ck_met_spe_code CHECK (met_spe_code='126281');

ALTER TABLE datbast.t_stock_sto 
ADD CONSTRAINT ck_spe_code 
CHECK (sto_spe_code='127186' OR sto_spe_code='127187');
 
COMMENT ON COLUMN datbast.t_metadata_met.met_spe_code 
IS 'Species aphiaID, text ''127186'' salmo salar OR ''127187'' for Salmo trutta primary key on both met_spe_code and met_var.';

COMMENT ON COLUMN dateel.t_metadata_met.met_spe_code 
IS 'Species, ''126281'' primary key on both met_spe_code and met_var.';

ALTER TABLE dateel.t_stock_sto ALTER COLUMN sto_spe_code SET DEFAULT '126281';
ALTER TABLE datnas.t_stock_sto ALTER COLUMN sto_spe_code SET DEFAULT '127186';
-- no default for datbast

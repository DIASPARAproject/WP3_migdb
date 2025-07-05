-- DROP TABLE ref.tr_trait_tra CASCADE;

CREATE TABLE ref.tr_trait_tra (
  tra_id integer PRIMARY KEY,
  tra_code text NOT NULL,
  tra_description text NULL, 
  tra_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_tra_wkg_code  FOREIGN KEY (tra_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  tra_spe_code TEXT NOT NULL,  
  CONSTRAINT fk_tra_spe_code  FOREIGN KEY (tra_spe_code)
  REFERENCES ref.tr_species_spe(spe_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  tra_typemetric text NULL,
  CONSTRAINT ck_tra_typemetric CHECK (((tra_typemetric = 'Individual'::text) 
  OR (tra_typemetric = 'Group'::text) 
  OR (tra_typemetric = 'Both'::text))),
  tra_qualitativeornumeric TEXT,
  CONSTRAINT ck_tra_qualitativeornumeric CHECK ((tra_qualitativeornumeric = 'Qualitative'::text) 
  OR (tra_qualitativeornumeric = 'Numeric'::text)),
  CONSTRAINT uk_tra_code UNIQUE (tra_code)
);


COMMENT ON COLUMN ref.tr_trait_tra.tra_id IS 'Integer, id of the trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_code IS 'Name of the trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_description IS 'Description of the fish trait';
COMMENT ON COLUMN ref.tr_trait_tra.tra_typemetric IS 'Is the metric a group metric (group), or individual metric (individual) or can be used in both tables (both) ?';
COMMENT ON COLUMN ref.tr_trait_tra.tra_qualitativeornumeric IS 'Indicate variable type, either Qualitative or Numeric';



GRANT ALL ON ref.tr_trait_tra TO diaspara_admin;
GRANT SELECT ON ref.tr_trait_tra TO diaspara_read; 

/*
note The refeel.tg_trait_tra actually contains physically all parms and that's not the case of
ref.tr_trait_tra which only gets those by inheritance.
refeel.tg_trait_tra must be created after insertion in tr_traitnumeric_trn
and tr_traitqualitative_trq
*/

CREATE TABLE refeel.tg_trait_tra AS (
SELECT  
  tra_id,
  tra_code,
  tra_description, 
  tra_wkg_code,  
  tra_spe_code , 
  tra_typemetric,
  tra_qualitativeornumeric FROM 
  refeel.tr_traitnumeric_trn
UNION
SELECT  
  tra_id,
  tra_code,
  tra_description, 
  tra_wkg_code,  
  tra_spe_code , 
  tra_typemetric,
  tra_qualitativeornumeric FROM 
  refeel.tr_traitqualitative_trq);
ALTER TABLE refeel.tg_trait_tra 
ADD  CONSTRAINT uk_tra_code UNIQUE (tra_code);

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
C
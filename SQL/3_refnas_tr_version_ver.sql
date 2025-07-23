
DROP TABLE IF EXISTS refnas.tr_version_ver CASCADE;
CREATE TABLE refnas.tr_version_ver() inherits (ref.tr_version_ver);

ALTER TABLE refnas.tr_version_ver ADD CONSTRAINT ver_code_pkey PRIMARY KEY (ver_code);
ALTER TABLE refnas.tr_version_ver ADD CONSTRAINT  fk_ver_spe_code FOREIGN KEY (ver_spe_code) 
REFERENCES ref.tr_species_spe(spe_code)
ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON TABLE refnas.tr_version_ver
IS 'Table of data or variable version, essentially one datacall or advice, inherits ref.tr_version_ver';

COMMENT ON COLUMN refnas.tr_version_ver.ver_code 
IS 'Version code, stockkey-year-version.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_year 
IS 'Year of assessement.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_spe_code 
IS 'Species code e.g. 'SAL' references tr_species_spe.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_stockkeylabel 
IS 'Ver_stockkeylabel e.g. ele.2737.nea.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_datacalldoi 
IS 'Data call DOI, find a way to retrieve that information 
and update this comment';
COMMENT ON COLUMN refnas.tr_version_ver.ver_version 
IS 'Version code in original database, eg 2,4 for wgnas, dc_2020 for wgeel.';
COMMENT ON COLUMN refnas.tr_version_ver.ver_description 
IS 'Description of the data call / version.';
GRANT ALL ON refnas.tr_version_ver TO diaspara_admin;
GRANT SELECT ON refnas.tr_version_ver TO diaspara_read;




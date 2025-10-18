
DROP TABLE IF EXISTS refbast.tr_version_ver CASCADE;
CREATE TABLE refbast.tr_version_ver() inherits (ref.tr_version_ver);

ALTER TABLE refbast.tr_version_ver ADD CONSTRAINT ver_code_pkey PRIMARY KEY (ver_code);
ALTER TABLE refbast.tr_version_ver ADD CONSTRAINT  fk_ver_spe_code FOREIGN KEY (ver_spe_code) 
REFERENCES ref.tr_species_spe(spe_code)
ON UPDATE CASCADE ON DELETE CASCADE;

COMMENT ON TABLE refbast.tr_version_ver
IS 'Table of data or variable version, essentially one datacall or advice, inherits ref.tr_version_ver';

COMMENT ON COLUMN refbast.tr_version_ver.ver_code 
IS 'Version code, stockkey-year-version.';
COMMENT ON COLUMN refbast.tr_version_ver.ver_year 
IS 'Year of assessement.';
COMMENT ON COLUMN refbast.tr_version_ver.ver_spe_code 
IS 'Species code left NULL for WGBAST as the data call references several species';
COMMENT ON COLUMN refbast.tr_version_ver.ver_stockkeylabel 
IS 'Ver_stockkeylabel e.g. ele.2737.nea.';
COMMENT ON COLUMN refbast.tr_version_ver.ver_datacalldoi 
IS 'Data call DOI, find a way to retrieve that information 
and update this comment';
COMMENT ON COLUMN refbast.tr_version_ver.ver_version 
IS 'Version code corresponding to numbering of the versions';
COMMENT ON COLUMN refbast.tr_version_ver.ver_description 
IS 'Description of the data call / version.';
GRANT ALL ON refbast.tr_version_ver TO diaspara_admin;
GRANT SELECT ON refbast.tr_version_ver TO diaspara_read;




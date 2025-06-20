-- It seems to me that metadata should contain information about historical 
-- variables, so I'm moving this from the main table and adding to metadata
-- some variables might get deprecated in time. 
-- Unless they get a new version this might not change
-- I have removed reference to stockkey as there are several stock keys
-- for the work of WGNAS
DROP TABLE IF EXISTS ref.tr_version_ver CASCADE;
CREATE TABLE ref.tr_version_ver(
ver_code TEXT PRIMARY KEY,
ver_year INTEGER NOT NULL,
ver_spe_code CHARACTER VARYING(3),
CONSTRAINT fk_ver_spe_code FOREIGN KEY (ver_spe_code) 
REFERENCES ref.tr_species_spe(spe_code)
ON UPDATE CASCADE ON DELETE RESTRICT,
ver_wkg_code TEXT NOT NULL,
CONSTRAINT fk_ver_wkg_code  FOREIGN KEY (ver_wkg_code)
REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
ON UPDATE CASCADE ON DELETE RESTRICT,
--ver_stockkey INTEGER NOT NULL, 
ver_stockkeylabel TEXT,
---ver_stockadvicedoi TEXT NOT NULL,
ver_datacalldoi TEXT NULL,
ver_version INTEGER NOT NULL,
ver_description TEXT
);
COMMENT ON TABLE ref.tr_version_ver
IS 'Table of data or variable version, essentially one datacall or advice.';
COMMENT ON COLUMN ref.tr_version_ver.ver_version 
IS 'Version code, stockkey-year-version.';
COMMENT ON COLUMN ref.tr_version_ver.ver_year 
IS 'Year of assessement.';
COMMENT ON COLUMN ref.tr_version_ver.ver_spe_code 
IS 'Species code e.g. ''ele'' references tr_species_spe.';
COMMENT ON COLUMN ref.tr_version_ver.ver_wkg_code 
IS 'Code of the working group, one of WGBAST, WGEEL, WGNAS, WKTRUTTA';
--COMMENT ON COLUMN ref.tr_version_ver.ver_stockkey 
--IS 'Stockkey (integer) from the stock database.';
COMMENT ON COLUMN ref.tr_version_ver.ver_stockkeylabel 
IS 'Ver_stockkeylabel e.g. ele.2737.nea.';
--COMMENT ON COLUMN ref.tr_version_ver.ver_stockadvicedoi 
--IS 'Advice DOI corresponding to column adviceDOI 
--when using icesASD::getAdviceViewRecord().';
COMMENT ON COLUMN ref.tr_version_ver.ver_datacalldoi 
IS 'Data call DOI, find a way to retreive that information 
and update this comment';
COMMENT ON COLUMN ref.tr_version_ver.ver_version 
IS 'Version code in original database, eg 2,4 for wgnas, dc_2020 for wgeel.';
COMMENT ON COLUMN ref.tr_version_ver.ver_description 
IS 'Description of the data call / version.';

GRANT ALL ON ref.tr_version_ver TO diaspara_admin;
GRANT SELECT ON ref.tr_version_ver TO diaspara_read;


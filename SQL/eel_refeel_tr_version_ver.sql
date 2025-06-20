
DROP TABLE IF EXISTS refeel.tr_version_ver CASCADE;
CREATE TABLE refeel.tr_version_ver() inherits (ref.tr_version_ver);

ALTER TABLE refeel.tr_version_ver ADD CONSTRAINT ver_code_pkey PRIMARY KEY (ver_code);
ALTER TABLE refeel.tr_version_ver ADD CONSTRAINT  fk_ver_spe_code FOREIGN KEY (ver_spe_code) 
REFERENCES ref.tr_species_spe(spe_code)
ON UPDATE CASCADE ON DELETE CASCADE;




-- values 
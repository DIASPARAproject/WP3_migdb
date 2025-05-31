DROP TABLE IF EXISTS ref.tr_gear_gea;
CREATE TABLE ref.tr_gear_gea (
  gea_id serial4 NOT NULL,
  gea_code text NOT NULL,
  gea_description text NULL,
  gea_icesvalue varchar(4) NULL,
  gea_icesguid uuid NULL,
  gea_icestablesource text NULL,
  CONSTRAINT tr_gear_gea_pkey PRIMARY KEY (gea_id),
  CONSTRAINT uk_gea_code UNIQUE (gea_code)
);
COMMENT ON TABLE ref.tr_gear_gea IS 'Table of fishing gears coming from FAO https://openknowledge.fao.org/server/api/core/bitstreams/830259c5-cbba-49f8-ae0d-819cd54356d3/content';
COMMENT ON COLUMN ref.tr_gear_gea.gea_id IS 'Id of the gear internal serial';
COMMENT ON COLUMN ref.tr_gear_gea.gea_issscfg_code IS 'Isssfg code of the gear';
COMMENT ON COLUMN ref.tr_gear_gea.gea_description IS 'English name of the gear';
COMMENT ON COLUMN ref.tr_maturity_mat.mat_icesvalue IS 'Code (Key) of the maturity in ICES db';
COMMENT ON COLUMN ref.tr_maturity_mat.mat_icesguid IS 'UUID (guid) of ICES, you can access by pasting ';
GRANT ALL ON ref.tr_gear_gea TO diaspara_admin;
GRANT SELECT ON ref.tr_gear_gea TO diaspara_read;
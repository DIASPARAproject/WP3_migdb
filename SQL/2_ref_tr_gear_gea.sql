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





-- manual code to merge tr_gear_with ICES DB


UPDATE ref.tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='PS'
  WHERE gea_id=1;
UPDATE ref.tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='SB'
  WHERE gea_id=4;
UPDATE ref.tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='SBV'
  WHERE gea_id=5;
UPDATE ref.tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='TBB'
  WHERE gea_id=7;
UPDATE ref.tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='LLS'
  WHERE gea_id=45;
UPDATE ref.tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='LLD'
  WHERE gea_id=46;
UPDATE ref.tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='LTL'
  WHERE gea_id=49;
UPDATE ref.tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='LX'
  WHERE gea_id=50;
UPDATE ref.tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='MIS'
  WHERE gea_id=59;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue='HMD'
	WHERE gea_id=20;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue='LA'
	WHERE gea_id=27;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue='GND'
	WHERE gea_id=30;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue='GNC'
	WHERE gea_id=31;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue=''
	WHERE gea_id=32;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue='GRT'
	WHERE gea_id=33;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue='GTN'
	WHERE gea_id=34;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue='FPO'
	WHERE gea_id=37;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue='FYK'
	WHERE gea_id=38;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType',gea_icesvalue='LHP'
	WHERE gea_id=43;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType'
	WHERE gea_id=1;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType'
	WHERE gea_id=4;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType'
	WHERE gea_id=5;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType'
	WHERE gea_id=7;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType'
	WHERE gea_id=45;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType'
	WHERE gea_id=46;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType'
	WHERE gea_id=49;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType'
	WHERE gea_id=50;
UPDATE "ref".tr_gear_gea
	SET gea_icestablesource='GearType'
	WHERE gea_id=59; --28
UPDATE "ref".tr_gear_gea
  SET gea_icestablesource='GearType'
  WHERE gea_id=7;
UPDATE "ref".tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='OTB'
  WHERE gea_id=8;
UPDATE "ref".tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='OTT'
  WHERE gea_id=10;
UPDATE "ref".tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='PTB'
  WHERE gea_id=11;
UPDATE "ref".tr_gear_gea
  SET gea_icestablesource='GearType',gea_icesvalue='OTM'
  WHERE gea_id=13;


ALTER TABLE tr_gear_gea SET gea_code 

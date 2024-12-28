-- CREATE REFERENTIAL TABLES

/*
This is a comment
*/
DROP schema if exists "ref" CASCADE;
CREATE schema "ref";
GRANT ALL PRIVILEGES ON SCHEMA "ref" TO diaspara_admin ;
GRANT ALL PRIVILEGES ON SCHEMA public TO diaspara_read ;
GRANT ALL PRIVILEGES ON SCHEMA refwgeel TO diaspara_admin ;
GRANT CONNECT ON DATABASE "dbmig" TO diaspara_read;
ALTER DATABASE "dbmig" OWNER TO diaspara_admin;

CREATE SCHEMA refeel;
ALTER SCHEMA refeel OWNER TO diaspara_admin;
CREATE SCHEMA refnas;
ALTER SCHEMA refnas OWNER TO diaspara_admin;
CREATE SCHEMA refbast;
ALTER SCHEMA refbast OWNER TO diaspara_admin;
CREATE SCHEMA reftrutta;
ALTER SCHEMA reftrutta OWNER TO diaspara_admin;
-- edit pg_hba.conf on the server


DROP TABLE IF EXISTS "ref".tr_species_spe;
CREATE TABLE "ref".tr_species_spe (
     spe_code CHARACTER VARYING(3) PRIMARY KEY,
     spe_codeices CHARACTER VARYING(6) NOT NULL, -- TODO CHANGE WHEN ICES VOCAB
     
     spe_description TEXT);
INSERT INTO "ref".tr_species_spe VALUES ('eel','ele','mieux que le saumon');


-- TODO search countries for Salmon US
CREATE TABLE ref.tr_country_cou (
    cou_code character varying(2) NOT NULL,
    cou_country text NOT NULL,
    cou_order integer NOT NULL,
    geom public.geometry,
    cou_iso3code character varying(3)
);
-- how to inegrate with hierarchical level in salmodb ? Same for eel ?

ALTER TABLE ref.tr_country_cou OWNER TO diaspara_admin;


SELECT * FROM SELECT * FROM "public"."ref-countries-2024-01m — CNTR_RG_01M_2024_4326" LIMIT 10


SELECT "CNTR_ID", "CNTR_NAME", "NAME_ENGL","NAME_GERM", "NAME_FREN", "ISO3_CODE"
FROM  "public"."ref-countries-2024-01m — CNTR_RG_01M_2024_4326" 
WHERE "CNTR_ID" IN ('GL', 'CA', 'US')
-- anguilla rostrata would need much more


DELETE FROM ref.tr_country_cou WHERE cou_code IN ('GL', 'CA', 'US');

INSERT INTO ref.tr_country_cou ( cou_code,
    cou_country,    
    cou_iso3code,
    geom, 
    cou_order)
SELECT "CNTR_ID" AS cou_code, "NAME_ENGL" AS cou_country,  "ISO3_CODE" AS cou_isocode, geom,
CASE WHEN "CNTR_ID" = 'GL' THEN 47
     WHEN "CNTR_ID" = 'CA' THEN 48
     ELSE 49 END AS cou_order
FROM  "public"."ref-countries-2024-01m — CNTR_RG_01M_2024_4326" 
WHERE "CNTR_ID" IN ('GL', 'CA', 'US');


UPDATE ref.tr_country_cou SET geom = nuts.geom FROM 
"public"."ref-countries-2024-01m — CNTR_RG_01M_2024_4326" nuts 
WHERE nuts."CNTR_ID" = tr_country_cou.cou_code; # 40


SELECT cou_code,cou_country,cou_order, cou_iso3code
('BM', 'BS', 'TC', 'DO', 'HT', 'CU', 'PR', 'VG', 
'VI', 'AI','BL', 'SX','BQ', 'KN', 'AG', 'DM', 'LC', 'VC', 'GD')

SELECT "CNTR_ID", "CNTR_NAME", "NAME_ENGL","NAME_GERM", "NAME_FREN", "ISO3_CODE"
FROM  "public"."ref-countries-2024-01m — CNTR_RG_01M_2024_4326" 
WHERE "CNTR_ID" ILIKE 'AN'


-- Habitat types

-- TODO search ICES for this
CREATE TABLE ref.tr_habitattype_hty (
    hty_code character varying(2) NOT NULL,
    hty_description text
);

ALTER TABLE ref.tr_habitattype_hty OWNER TO diaspara_admin;

-- 

DROP TABLE IF EXISTS ref.tr_lifestage_lfs CASCADE;
CREATE TABLE ref.tr_lifestage_lfs (
    lfs_code character varying(5) PRIMARY KEY, 
    lfs_name character varying(30) NOT NULL,
    lfs_definition TEXT,
    lfs_spe_code CHARACTER VARYING(3) NOT NULL, -- TODO CHANGE WHEN ICES FOUND
    CONSTRAINT c_fk_lfs_spe_code FOREIGN KEY (lfs_spe_code) REFERENCES "ref".tr_species_spe(spe_code) 
    ON UPDATE CASCADE ON DELETE NO ACTION,
    CONSTRAINT c_uk_lfs_name UNIQUE (lfs_name)
);

ALTER TABLE ref.tr_lifestage_lfs OWNER TO diaspara_admin;



-- referential per species



DROP TABLE IF EXISTS refeel.tr_lifestageeel_lfe;
CREATE TABLE refeel.tr_lifestageeel_lfe()INHERITS("ref".tr_lifestage_lfs);
INSERT INTO refeel.tr_lifestageeel_lfe SELECT *, 'eel' FROM refwgeel.tr_lifestage_lfs;

SELECT * FROM  refeel.tr_lifestageeel_lfe;
SELECT * FROM  ref.tr_lifestage_lfs;




CREATE TABLE "ref".tr_parameter_parm (
  parm_id serial4 NOT NULL,
  parm_name TEXT NOT NULL UNIQUE,
  parm_species TEXT
  parm_description text NULL,
  parm_uni_code varchar(20) NULL,
  CONSTRAINT parm_pkey PRIMARY KEY (typ_id),
  CONSTRAINT c_fk_parm_uni_code FOREIGN KEY (typ_uni_code) REFERENCES "ref".tr_units_uni(uni_code) ON UPDATE CASCADE
);







--DROP TABLE IF EXISTS ref.tr_units_uni CASCADE;

CREATE TABLE ref.tr_units_uni (
  uni_code varchar(20) NOT NULL,
  uni_description text NOT NULL,
  uni_icesvalue character varying(4),  
  uni_icesguid uuid,
  uni_icestablesource text,
  CONSTRAINT t_units_uni_pkey PRIMARY KEY (uni_code),
  CONSTRAINT uk_uni_description UNIQUE (uni_description),
  CONSTRAINT uk_uni_icesguid UNIQUE (uni_icesguid),
  CONSTRAINT uk_uni_icesvalue UNIQUE (uni_icesvalue)
);
GRANT ALL ON ref.tr_units_uni TO diaspara_admin;
GRANT SELECT ON ref.tr_units_uni TO diaspara_read; 
-- I don't add definitions this is an ICES vocab


-- 24/03/2026 this is the same as gd (gear day) and is not used
SELECT * FROM "ref".tr_units_uni WHERE uni_code = 'nr fyke.day';
SELECT * FROM datbast.t_series_ser WHERE ser_uni_code = 'nr fyke.day';
SELECT * FROM datnas.t_series_ser WHERE ser_uni_code = 'nr fyke.day';
SELECT * FROM dateel.t_series_ser WHERE ser_uni_code = 'nr fyke.day';
SELECT * FROM refeel.tr_traitnumeric_trn  WHERE trn_uni_code = 'nr fyke.day';
DELETE FROM "ref".tr_units_uni WHERE uni_code = 'nr fyke.day';

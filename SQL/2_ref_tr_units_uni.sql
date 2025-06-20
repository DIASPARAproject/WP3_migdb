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
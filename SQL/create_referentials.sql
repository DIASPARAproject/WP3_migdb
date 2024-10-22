-- CREATE REFERENTIAL TABLES

/*
This is a comment
*/
DROP schema if exists "ref" CASCADE;
CREATE schema "ref";
GRANT ALL PRIVILEGES ON SCHEMA "ref" TO diaspara_admin ;
GRANT ALL PRIVILEGES ON SCHEMA public TO diaspara_read ;
GRANT CONNECT ON DATABASE "dbmig" TO diaspara_read;
ALTER DATABASE "dbmig" OWNER TO diaspara_admin;

-- edit pg_hba.conf on the server


-- TODO search countries for Salmon US
CREATE TABLE ref.tr_country_cou (
    cou_code character varying(2) NOT NULL,
    cou_country text NOT NULL,
    cou_order integer NOT NULL,
    geom public.geometry,
    cou_iso3code character varying(3)
);
-- how to inegrate with hierarchical level in salmodb ? Same for eel ?

ALTER TABLE ref.tr_country_cou OWNER TO postgres;
GRANT ALL ON SCHEMA ref diaspara_admin;
CREATE ROLE diaspara_read

CREATE TABLE "ref".tr_pararmeter_parm (
  parm_id serial4 NOT NULL,
  parm_name TEXT NOT NULL UNIQUE,
  parm_species TEXT
  parm_description text NULL,
  parm_uni_code varchar(20) NULL,
  CONSTRAINT parm_pkey PRIMARY KEY (typ_id),
  CONSTRAINT c_fk_parm_uni_code FOREIGN KEY (typ_uni_code) REFERENCES "ref".tr_units_uni(uni_code) ON UPDATE CASCADE
);
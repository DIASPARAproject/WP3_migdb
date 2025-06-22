DROP TABLE IF EXISTS ref.tr_country_cou;
CREATE TABLE ref.tr_country_cou (
    cou_code character varying(2) NOT NULL,
    cou_country text NOT NULL,
    cou_order integer NOT NULL,
    geom public.geometry,
    cou_iso3code character varying(3)
);
COMMENT ON TABLE ref.tr_country_cou IS
          'Table of country codes source EuroGeographics and UN-FAO.';
ALTER TABLE ref.tr_country_cou 
          OWNER TO diaspara_admin;
GRANT SELECT ON TABLE ref.tr_country_cou TO diaspara_read;

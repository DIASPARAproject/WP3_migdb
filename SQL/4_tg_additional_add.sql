DROP TABLE IF EXISTS refnas.tg_additional_add;
CREATE TABLE refnas.tg_additional_add AS
SELECT are_code AS add_code, 'Area' AS add_type FROM refnas.tr_area_are
UNION
SELECT age_code AS add_code, 'Age' AS add_type FROM "ref".tr_age_age; --80
ALTER TABLE refnas.tg_additional_add ADD CONSTRAINT 
uk_add_code UNIQUE (add_code);


ALTER TABLE refnas.tg_additional_add OWNER TO diaspara_admin;
GRANT ALL ON TABLE refnas.tg_additional_add TO diaspara_read;




COMMENT ON TABLE refnas.tg_additional_add IS 
'Table including the stock data in schema datnas.... This table feeds the dat.t_stock_sto table by inheritance. It corresponds
to the database table in the original WGNAS database.';
COMMENT ON COLUMN refnas.tg_additional_add.add_code IS 'Code coming from are_code in
table refnas.tr_area_are or age_code in table ref.tr_age_age';
COMMENT ON COLUMN refnas.tg_additional_add.add_type IS 'One of Area or Age';
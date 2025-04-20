DROP TABLE IF EXISTS refnas.tg_additional_add;
CREATE TABLE refnas.tg_additional_add AS
SELECT are_code AS add_code, 'Area' AS add_type FROM refnas.tr_area_are
UNION
SELECT age_code AS add_code, 'Age' AS add_type FROM "ref".tr_age_age; --80

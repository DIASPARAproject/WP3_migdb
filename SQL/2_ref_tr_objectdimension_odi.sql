DROP TABLE IF EXISTS ref.tr_objectdimension_odi CASCADE;
CREATE TABLE ref.tr_objectdimension_odi (
odi_code TEXT PRIMARY KEY,
odi_description TEXT
);

INSERT INTO ref.tr_objectdimension_odi VALUES ('Single_value', 'Single value');
INSERT INTO ref.tr_objectdimension_odi VALUES ('Vector', 'One dimension vector');
INSERT INTO ref.tr_objectdimension_odi VALUES ('Matrix', 'Two dimensions matrix');
INSERT INTO ref.tr_objectdimension_odi VALUES ('Array', 'Three dimensions array');

COMMENT ON TABLE ref.tr_objectdimension_odi IS 
'Table indicating the dimensions of the object stored in the model, 
single value, vector, matrix, array';

COMMENT ON COLUMN ref.tr_objectdimension_odi.odi_code IS 
'code of the object dimension, single_value, vector, ...';

COMMENT ON COLUMN ref.tr_objectdimension_odi.odi_code IS 'description of the object type';
GRANT ALL ON ref.tr_objectdimension_odi TO diaspara_admin;
GRANT SELECT ON ref.tr_objectdimension_odi TO diaspara_read;

/* fix from Hilaire's review


ALTER TABLE "ref".tr_objecttype_oty RENAME TO tr_objectdimension_odi;
ALTER TABLE "ref".tr_objectdimension_odi RENAME COLUMN oty_code TO odi_code;
ALTER TABLE "ref".tr_objectdimension_odi RENAME COLUMN oty_description TO odi_description;
ALTER TABLE "ref".tr_objectdimension_odi RENAME CONSTRAINT tr_objecttype_oty_pkey TO tr_objectdimension_odi_pkey;
ALTER TABLE dat.t_metadata_met RENAME COLUMN met_oty_code TO met_odi_code;
ALTER TABLE dat.t_metadata_met RENAME CONSTRAINT fk_met_oty_code TO fk_met_odi_code;
 */


-- Table of estimation methods when databasis is Estimated

DROP TABLE IF EXISTS refbast.tr_estimationmethod_esm CASCADE;
CREATE  TABLE refbast.tr_estimationmethod_esm () inherits (ref.tr_estimationmethod_esm);
ALTER TABLE refbast.tr_estimationmethod_esm ALTER COLUMN esm_wkg_code SET DEFAULT 'WGBAST';
ALTER TABLE refbast.tr_estimationmethod_esm ADD CONSTRAINT uk_esm_code UNIQUE (esm_code);
COMMENT ON TABLE refbast.tr_estimationmethod_esm IS 'Table of table estimation method, provided when databasis (dtb_code) correspond to Estimated';
COMMENT ON COLUMN refbast.tr_estimationmethod_esm.esm_code IS 'Estimation method code';
COMMENT ON COLUMN refbast.tr_estimationmethod_esm.esm_description IS 'Estimation method  description';
COMMENT ON COLUMN refbast.tr_estimationmethod_esm.esm_icesvalue IS 'Code (Key) of the Estimation method in ICES';
COMMENT ON COLUMN refbast.tr_estimationmethod_esm.esm_icesguid IS 'UUID (guid) of ICES ';
COMMENT ON COLUMN refbast.tr_estimationmethod_esm.esm_icestablesource IS 'Source table in ICES';

GRANT ALL ON refbast.tr_estimationmethod_esm TO diaspara_admin;
GRANT SELECT ON refbast.tr_estimationmethod_esm TO diaspara_read;



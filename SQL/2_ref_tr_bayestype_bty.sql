--nimble

DROP TABLE IF EXISTS ref.tr_bayestype_bty CASCADE;
CREATE TABLE ref.tr_bayestype_bty (
nim_code TEXT PRIMARY KEY,
nim_description TEXT
);

COMMENT ON TABLE ref.tr_bayestype_bty IS 
'Indicate the type of data, parameter constant, parameter estimate, output, other ...';
-- Note this is a mix of nimble and status, which mean the same....

INSERT INTO ref.tr_bayestype_bty VALUES ('Data', 'Data entry to the model');
INSERT INTO ref.tr_bayestype_bty 
VALUES ('Parameter constant', 'Parameter input to the model');
INSERT INTO ref.tr_bayestype_bty 
VALUES ('Parameter estimate', 'Parameter input to the model');
INSERT INTO ref.tr_bayestype_bty 
VALUES ('Output', 'Output from the model, derived quantity');
-- Do we want another type here ?
--INSERT INTO ref.tr_bayestype_bty VALUES ('observation', 'Observation not used in the model');
INSERT INTO ref.tr_bayestype_bty 
VALUES ('Other', 'Applies currently to conservation limits');
GRANT ALL ON ref.tr_bayestype_bty TO diaspara_admin;
GRANT SELECT ON ref.tr_bayestype_bty TO diaspara_read;


/*
Hilaire review : remove "nimble" ...
ALTER TABLE "ref".tr_nimble_nim RENAME COLUMN nim_code TO bty_code;
ALTER TABLE "ref".tr_nimble_nim RENAME COLUMN nim_description TO bty_description;
ALTER TABLE "ref".tr_nimble_nim RENAME CONSTRAINT tr_nimble_nim_pkey TO tr_bayestype_bty_pkey;
ALTER INDEX "ref".tr_nimble_nim_pkey RENAME TO tr_bayestype_bty_pkey;
ALTER TABLE dat.t_metadata_met RENAME COLUMN met_nim_code TO met_bty_code;
ALTER TABLE dat.t_metadata_met RENAME CONSTRAINT fk_met_nim_code TO fk_met_bty_code;
ALTER TABLE dateel.t_metadata_met RENAME CONSTRAINT fk_met_nim_code TO fk_met_bty_code;
ALTER TABLE datnas.t_metadata_met RENAME CONSTRAINT fk_met_nim_code TO fk_met_bty_code;
ALTER TABLE datbast.t_metadata_met RENAME CONSTRAINT fk_met_nim_code TO fk_met_bty_code;
*/


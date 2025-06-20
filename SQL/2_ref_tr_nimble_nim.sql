--nimble

DROP TABLE IF EXISTS ref.tr_nimble_nim CASCADE;
CREATE TABLE ref.tr_nimble_nim (
nim_code TEXT PRIMARY KEY,
nim_description TEXT
);

COMMENT ON TABLE ref.tr_nimble_nim IS 
'Indicate the type of data, parameter constant, parameter estimate, output, other ...';
-- Note this is a mix of nimble and status, which mean the same....

INSERT INTO ref.tr_nimble_nim VALUES ('Data', 'Data entry to the model');
INSERT INTO ref.tr_nimble_nim 
VALUES ('Parameter constant', 'Parameter input to the model');
INSERT INTO ref.tr_nimble_nim 
VALUES ('Parameter estimate', 'Parameter input to the model');
INSERT INTO ref.tr_nimble_nim 
VALUES ('Output', 'Output from the model, derived quantity');
-- Do we want another type here ?
--INSERT INTO ref.tr_nimble_nim VALUES ('observation', 'Observation not used in the model');
INSERT INTO ref.tr_nimble_nim 
VALUES ('Other', 'Applies currently to conservation limits');
GRANT ALL ON ref.tr_nimble_nim TO diaspara_admin;
GRANT SELECT ON ref.tr_nimble_nim TO diaspara_read;

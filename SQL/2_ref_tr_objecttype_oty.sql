DROP TABLE IF EXISTS ref.tr_objecttype_oty CASCADE;
CREATE TABLE ref.tr_objecttype_oty (
oty_code TEXT PRIMARY KEY,
oty_description TEXT
);

INSERT INTO ref.tr_objecttype_oty VALUES ('Single_value', 'Single value');
INSERT INTO ref.tr_objecttype_oty VALUES ('Vector', 'One dimension vector');
INSERT INTO ref.tr_objecttype_oty VALUES ('Matrix', 'Two dimensions matrix');
INSERT INTO ref.tr_objecttype_oty VALUES ('Array', 'Three dimensions array');

COMMENT ON TABLE ref.tr_objecttype_oty IS 
'Table indicating the dimensions of the object stored in the model, 
single value, vector, matrix, array';

COMMENT ON COLUMN ref.tr_objecttype_oty.oty_code IS 
'code of the object type, single_value, vector, ...';

COMMENT ON COLUMN ref.tr_objecttype_oty.oty_code IS 'description of the object type';
GRANT ALL ON ref.tr_objecttype_oty TO diaspara_admin;
GRANT SELECT ON ref.tr_objecttype_oty TO diaspara_read;
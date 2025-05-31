-- maturity table code


DROP TABLE IF EXISTS ref.tr_maturity_mat CASCADE;
CREATE TABLE ref.tr_maturity_mat (
  mat_id SERIAL PRIMARY KEY,
  mat_code TEXT NOT NULL CONSTRAINT uk_mat_code UNIQUE, 
  mat_description TEXT,
  mat_icesvalue character varying(4),  
  mat_icesguid uuid,
  mat_icestablesource text
);

COMMENT ON TABLE ref.tr_maturity_mat IS 'Table of maturity corresponding to the 6 stage scale of the ICES vocabulary';
COMMENT ON COLUMN ref.tr_maturity_mat.mat_id IS 'Integer, primary key of the table';
COMMENT ON COLUMN ref.tr_maturity_mat.mat_code IS 'The code of maturity stage';
COMMENT ON COLUMN ref.tr_maturity_mat.mat_description IS 'Definition of the maturity stage';
COMMENT ON COLUMN ref.tr_maturity_mat.mat_icesvalue IS 'Code (Key) of the maturity in ICES db';
COMMENT ON COLUMN ref.tr_maturity_mat.mat_icesguid IS 'UUID (guid) of ICES, you can access by pasting ';
COMMENT ON COLUMN ref.tr_maturity_mat.mat_icestablesource IS 'Source table in ICES';
GRANT ALL ON ref.tr_maturity_mat TO diaspara_admin;
GRANT SELECT ON ref.tr_maturity_mat TO diaspara_read;


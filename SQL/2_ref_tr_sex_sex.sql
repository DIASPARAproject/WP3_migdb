DROP TABLE IF EXISTS ref.tr_sex_sex CASCADE;
CREATE TABLE ref.tr_sex_sex (
  sex_id SERIAL PRIMARY KEY,
  sex_code TEXT NOT NULL CONSTRAINT uk_sex_code UNIQUE, 
  sex_description TEXT,
  sex_icesvalue character varying(4),  
  sex_icesguid uuid,
  sex_icestablesource text
);

COMMENT ON TABLE ref.tr_sex_sex IS 'Table of possible sex values corresponding to the 7 scale of the ICES vocabulary';
COMMENT ON COLUMN ref.tr_sex_sex.sex_id IS 'Integer, primary key of the table';
COMMENT ON COLUMN ref.tr_sex_sex.sex_code IS 'The code of sex';
COMMENT ON COLUMN ref.tr_sex_sex.sex_description IS 'Definition of the sex nature';
COMMENT ON COLUMN ref.tr_sex_sex.sex_icesvalue IS 'Code (Key) of the sex in ICES db';
COMMENT ON COLUMN ref.tr_sex_sex.sex_icesguid IS 'UUID (guid) of ICES, you can access by pasting ';

GRANT ALL ON ref.tr_sex_sex TO diaspara_admin;
GRANT SELECT ON ref.tr_sex_sex TO diaspara_read;
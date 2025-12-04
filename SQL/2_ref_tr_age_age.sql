-- Table for age
-- there is one table for all working groups 
-- so this table is not inherited (otherwise two wkg could create referential for the same species)

DROP TABLE IF EXISTS ref.tr_age_age;
CREATE TABLE ref.tr_age_age (
age_value INTEGER,
age_envir TEXT NOT NULL,
CONSTRAINT ck_age_envir CHECK (age_envir='Seawater' OR age_envir='Freshwater'),
age_code varchar(3) PRIMARY KEY,
age_description TEXT,
age_definition TEXT,
age_icesvalue character varying(4),  
age_icesguid uuid,
age_icestablesource text);

ALTER TABLE ref.tr_age_age OWNER TO diaspara_admin;
GRANT SELECT ON ref.tr_age_age  TO diaspara_read;


INSERT INTO ref.tr_age_age VALUES (0, 'Freshwater', '0FW', '0 year in freshwater','Age of juvenile fish in their first year in Freshwater');
INSERT INTO ref.tr_age_age VALUES (1, 'Freshwater', '1FW', '1 year in freshwater',NULL);
INSERT INTO ref.tr_age_age VALUES (2, 'Freshwater', '2FW', '2 years in freshwater',NULL);
INSERT INTO ref.tr_age_age VALUES (3, 'Freshwater', '3FW', '3 years in freshwater',NULL);
INSERT INTO ref.tr_age_age VALUES (4, 'Freshwater', '4FW', '4 years in freshwater',NULL);
INSERT INTO ref.tr_age_age VALUES (5, 'Freshwater', '5FW', '5 years in freshwater',NULL);
INSERT INTO ref.tr_age_age VALUES (6, 'Freshwater', '6FW', '6 years in freshwater',NULL);
INSERT INTO ref.tr_age_age VALUES (1, 'Seawater', '1SW', '1 year in seawater',NULL);
INSERT INTO ref.tr_age_age VALUES (2, 'Seawater', '2SW', '2 years in seawater',NULL);
INSERT INTO ref.tr_age_age VALUES (NULL, 'Seawater', 'MSW', 'Two years or more in seawater',NULL);
INSERT INTO ref.tr_age_age VALUES (NULL, 'Seawater', 'MSW', 'Two years or more in seawater',NULL);
INSERT INTO "ref".tr_age_age (age_envir,age_code,age_description,age_definition)
  VALUES ('Freshwater','1+','Older than one year in freshwater','Groups all fishes older than one year in freshwater');


COMMENT ON TABLE ref.tr_age_age IS 'Table of ages for salmonids';
COMMENT ON COLUMN ref.tr_age_age.age_value IS 'Integer, value of the age as integer';
COMMENT ON COLUMN ref.tr_age_age.age_envir IS 'Freshwater or Seawater';
COMMENT ON COLUMN ref.tr_age_age.age_code IS '1FW to 6FW and 1SW to 2SW';
COMMENT ON COLUMN ref.tr_age_age.age_description IS 'Description of the age';
COMMENT ON COLUMN ref.tr_age_age.age_definition IS 'Definition of the age';
COMMENT ON COLUMN ref.tr_age_age.age_icesvalue IS 'Code for the age in the ICES database';
COMMENT ON COLUMN ref.tr_age_age.age_icesguid IS 'GUID in the ICES database';
COMMENT ON COLUMN ref.tr_age_age.age_icestablesource IS 'Source table in ICES vocab';
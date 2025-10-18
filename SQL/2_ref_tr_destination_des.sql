-- table ref.tr_destination_des

DROP TABLE IF EXISTS ref.tr_destination_des CASCADE;
CREATE TABLE ref.tr_destination_des (
des_code TEXT PRIMARY KEY,
des_description TEXT
);

COMMENT ON TABLE ref.tr_destination_des IS 
'Table of fish destination. When dealing with fish, e.g. in landings,what is the future of the fish, e.g. Released (alive), Seal damage, 
Removed (from the environment)'; 
INSERT INTO ref.tr_destination_des VALUES 
('Removed', 'Removed from the environment, e.g. caught and kept');
INSERT INTO ref.tr_destination_des VALUES (
'Seal damaged', 'Seal damage');
INSERT INTO ref.tr_destination_des VALUES (
'Discarded', 'Discards');
INSERT INTO ref.tr_destination_des VALUES (
'Released', 'Released alive');
INSERT INTO ref.tr_destination_des VALUES (
'Released ', 'Released alive');

GRANT ALL ON ref.tr_destination_des TO diaspara_admin;
GRANT SELECT ON ref.tr_destination_des TO diaspara_read;
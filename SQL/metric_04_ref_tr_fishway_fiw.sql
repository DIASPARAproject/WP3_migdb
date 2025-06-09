-- this is a new referential

DROP TABLE IF EXISTS ref.tr_fishway_fiw;
CREATE TABLE ref.tr_fishway_fiw (
fiw_code TEXT PRIMARY KEY,
fiw_description TEXT,
fiw_definition TEXT,
fiw_icesvalue character varying(4),  
fiw_icesguid uuid,
fiw_icestablesource text);
DELETE FROM ref.tr_fishway_fiw;
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('VS', 
'Vertical slot fishway', 
'Vertical Slot Fishways have top-to-bottom opening (slot) in the cross-wall by which water flows between pools, they are adapted to wide variations in water level.');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('PO', 
'Pool', 
'TODO');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('FL', 
'Fish lock', 
'TODO');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('D', 
'Denil pass', 
'TODO');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('RR', 
'Rock ramp', 
'TODO');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('ER', 
'Eel ramp', 
'TODO');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('LA', 
'Lateral canal', 
'TODO');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('AR', 
'Artificial river', 
'TODO');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('UN', 
'Unknown', 
'TODO');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('S', 
'Sluice', 
'TODO');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('L', 
'Fish lift', 
'TODO');


ALTER TABLE ref.tr_fishway_fiw OWNER TO diaspara_admin;
GRANT SELECT ON ref.tr_fishway_fiw  TO diaspara_read;


COMMENT ON TABLE ref.tr_fishway_fiw IS 'Table of fishway type';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_code IS 'Code for fishway type';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_description IS 'Description of the fishway';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_definition IS 'Definition of the fishway';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_icesvalue IS 'Code for the fishwat in the ICES database';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_icesguid IS 'GUID in the ICES database';

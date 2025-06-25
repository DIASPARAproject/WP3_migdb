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
'A pool pass consists of a stepped channel divided by cross-walls that form a series of pools, where water flows through submerged or surface openings, allowing fish to rest between short bursts through higher-velocity zones. The rough bottom and calm pools make it especially suitable for both swimming and bottom-dwelling species.');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('FL', 
'Fish lock', 
'A fish lock, similar in structure to a ship lock, uses a lock chamber with inlet and outlet gates to help fish ascend past barriers; unlike ship locks, it is specifically designed to support fish migration by addressing issues like turbulence, timing, and the need for a guiding current. While ship locks generally cannot replace fish passes, they can sometimes be adapted during peak migration seasons to aid species like salmon or glass eels.');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('D', 
'Denil pass', 
'compact, steeply sloped fish pass featuring angled baffles that create backflows to reduce water velocity, enabling fish to ascend over moderate height differences. Its prefabricated design and efficient energy dissipation make it ideal for retrofitting existing dams with limited space, with the standard U-shaped baffle version now widely used.');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('RR', 
'Rock ramp', 
'Close-to_nature type, gently sloped rough-surfaced sill spanning the river width with a gentle slope, designed to overcome riverbed level differences; it may include stabilizing structures like weirs if they share similar sloped, loose construction.');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('ER', 
'Eel ramp', 
'Eel ladders/ramps, e.g., pipe-based systems laid through weirs and filled with baffles or brushwood to slow flow, shallow channels fitted with brush or gravel structures that help eels ascend while offering better visibility, maintenance, and protection from predators.');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('LA', 
'Lateral canal', 
'Bybass channel that uses lateral canals');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('AR', 
'Artificial river', 
'Human-made channel designed to mimic the characteristics of a natural stream, allowing fish to bypass barriers like dams. These fishways typically feature a gentle slope, varied flow conditions, resting areas, and natural substrates (like gravel and rocks, trees, bushes, etc.)');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('UN', 
'Unknown', 
'Unknown type fish passage');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('S', 
'Sluice', 
'Periodically opening sluice gates that creates a strong, directed flow that attracts and allows fish to pass. ');
INSERT INTO ref.tr_fishway_fiw (fiw_code, fiw_description, fiw_definition)
VALUES('HL', 
'Hydraulic lift', 
'A type of fish elevator that uses hydraulic mechanisms—such as pumps, valves, and water pressure—to move fish over high barriers like dams.');


ALTER TABLE ref.tr_fishway_fiw OWNER TO diaspara_admin;
GRANT SELECT ON ref.tr_fishway_fiw  TO diaspara_read;


COMMENT ON TABLE ref.tr_fishway_fiw IS 'Table of fishway type';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_code IS 'Code for fishway type';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_description IS 'Description of the fishway';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_definition IS 'Definition of the fishway';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_icesvalue IS 'Code for the fishwat in the ICES database';
COMMENT ON COLUMN ref.tr_fishway_fiw.fiw_icesguid IS 'GUID in the ICES database';

-- this is a new referential

DROP TABLE IF EXISTS ref.tr_monitoring_mon;
CREATE TABLE ref.tr_monitoring_mon (
mon_code TEXT PRIMARY KEY,
mon_description TEXT,
mon_definition TEXT,
mon_icesvalue character varying(4),  
mon_icesguid uuid,
mon_icestablesource text);
DELETE FROM ref.tr_monitoring_mon;
INSERT INTO ref.tr_monitoring_mon (mon_code, mon_description, mon_definition)
VALUES('SO', 
'Sonar HF', 
'High frequency sonar used to monitor fish migration, e.g. Didson, Aris, Blueview, Occulus ....');
INSERT INTO ref.tr_monitoring_mon (mon_code, mon_description, mon_definition)
VALUES('TR', 
'Trap', 
'Trap used to catch a part or the whole run. Fish can be directed towards the trap with a system of grids,
or within a fishway. The fishes are counted and measured and then released, most often to continue their migration,
upstream or downstream from the trap.');
INSERT INTO ref.tr_monitoring_mon (mon_code, mon_description, mon_definition)
VALUES('VR', 
'Video recording', 
'Video recording of the fish used to make specific identification, and measure the length and direction of passage.
The video is often located in a narrow passage within a fishway, often also with light set in the background.');
INSERT INTO ref.tr_monitoring_mon (mon_code, mon_description, mon_definition)
VALUES('RC', 
'Resistivity counter', 
'Resistivity counters monitor the resistance between electrodes to detect the passage of a fish.
The lower resistance of the fish compared to the water is used to detect the passage. 
A series of submerged electrodes are used to detect the direction. Automatic
adjustment of the sensitivity of the counter ensures that the sizes into which fish are
classified remains consistent.');
INSERT INTO ref.tr_monitoring_mon (mon_code, mon_description, mon_definition)
VALUES('AC', 
'Acoustic receiver', 
'Acoustic receivers are use in fish tracking to detect and decode transmissions from acoustic fish tags');
INSERT INTO ref.tr_monitoring_mon (mon_code, mon_description, mon_definition)
VALUES('IR', 
'Infrared counter', 
'Counter that uses infrared, e.g., Vaki Riverwatcher');



ALTER TABLE ref.tr_monitoring_mon OWNER TO diaspara_admin;
GRANT SELECT ON ref.tr_monitoring_mon  TO diaspara_read;


COMMENT ON TABLE ref.tr_monitoring_mon IS 'Table of monitoring devices. 
A monitoring device is used to monitor fish passage. It can be attached to a fishway. 
A fishway can have several monitoring devices, e.g. a trap and a video recording. 
A monitoring device can also be placed without fishway , e.g. a sonar, an accoustic receiver.';
COMMENT ON COLUMN ref.tr_monitoring_mon.mon_code IS 'Code for monitoring type';
COMMENT ON COLUMN ref.tr_monitoring_mon.mon_description IS 'Description of the monitoring device';
COMMENT ON COLUMN ref.tr_monitoring_mon.mon_definition IS 'Definition of the monitoring device';
COMMENT ON COLUMN ref.tr_monitoring_mon.mon_icesvalue IS 'Code for the fishwat in the ICES database';
COMMENT ON COLUMN ref.tr_monitoring_mon.mon_icesguid IS 'GUID in the ICES database';

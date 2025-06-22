--DROP TABLE IF EXISTS ref.tr_icworkinggroup_wkg CASCADE;

CREATE TABLE ref.tr_icworkinggroup_wkg (
wkg_code TEXT PRIMARY KEY,
wkg_description TEXT,
wkg_icesguid uuid,
wkg_stockkeylabel TEXT
);

COMMENT ON TABLE ref.tr_icworkinggroup_wkg 
IS 'Table corresponding to the IC_WorkingGroup referential;';
COMMENT ON COLUMN ref.tr_icworkinggroup_wkg.wkg_code IS 
'Working group code uppercase, WGEEL, WGNAS, WGBAST, WGTRUTTA';


GRANT ALL ON ref.tr_icworkinggroup_wkg TO diaspara_admin;
GRANT SELECT ON ref.tr_icworkinggroup_wkg TO diaspara_read;
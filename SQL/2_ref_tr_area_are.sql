--DROP TABLE IF EXISTS ref.tr_area_are CASCADE;
CREATE TABLE ref.tr_area_are (
   are_id INTEGER PRIMARY KEY,
   are_are_id INTEGER,
   are_code  TEXT,
   are_lev_code TEXT,
   are_wkg_code TEXT,
   are_ismarine BOOLEAN,
   are_rivername TEXT,
   geom_polygon geometry(MULTIPOLYGON, 4326),
   geom_line geometry(MULTILINESTRING, 4326),
  CONSTRAINT fk_are_are_id FOREIGN KEY (are_are_id) 
  REFERENCES ref.tr_area_are (are_id) ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT uk_are_code UNIQUE (are_code),
  CONSTRAINT fk_area_lev_code FOREIGN KEY (are_lev_code) REFERENCES
  ref.tr_habitatlevel_lev(lev_code) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_area_wkg_code FOREIGN KEY (are_wkg_code) REFERENCES
  ref.tr_icworkinggroup_wkg(wkg_code) ON UPDATE CASCADE ON DELETE CASCADE
);

GRANT ALL ON ref.tr_area_are TO diaspara_admin;
GRANT SELECT ON ref.tr_area_are TO diaspara_read;

COMMENT ON TABLE ref.tr_area_are IS 'Table corresponding to different geographic levels, from stock 
to river section.');





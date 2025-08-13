--DROP TABLE IF EXISTS ref.tr_rivernames_riv CASCADE;

CREATE TABLE ref.tr_rivernames_riv(
   riv_id INTEGER PRIMARY KEY,
   riv_wkg_code TEXT,
   riv_are_code TEXT,
   riv_rivername TEXT,
   CONSTRAINT fk_riv_wkg_code FOREIGN KEY (riv_wkg_code) REFERENCES
   ref.tr_icworkinggroup_wkg(wkg_code) ON UPDATE CASCADE ON DELETE CASCADE,
   CONSTRAINT fk_riv_are_code FOREIGN KEY (riv_are_code) REFERENCES
   ref.tr_area_are(are_code) ON UPDATE CASCADE ON DELETE CASCADE
);



COMMENT ON TABLE ref.tr_rivernames_riv
IS 'Table matching basins to their corresponding rivers.';

GRANT ALL ON ref.tr_rivernames_riv TO diaspara_admin;
GRANT SELECT ON ref.tr_rivernames_riv TO diaspara_read; 
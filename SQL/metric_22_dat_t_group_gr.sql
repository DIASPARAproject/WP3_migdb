
-- DROP TABLE dat.t_group_gr CASCADE;

CREATE TABLE dat.t_group_gr (
  gr_id serial4 NOT NULL,
  gr_ser_id UUID,
  CONSTRAINT fk_gr_ser_id FOREIGN KEY (gr_ser_id)
  REFERENCES dat.t_series_ser (ser_id) 
  ON UPDATE CASCADE ON DELETE CASCADE, 
  gr_gr_id INTEGER,
  CONSTRAINT fk_gr_gr_id  FOREIGN KEY (gr_gr_id, gr_wkg_code)
  REFERENCES dat.t_group_gr(gr_id, gr_wkg_code)
  ON UPDATE CASCADE ON DELETE CASCADE,
  gr_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_gr_wkg_code  FOREIGN KEY (gr_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT t_group_gr_pkey PRIMARY KEY (gr_id, gr_wkg_code),
  gr_year int4 NULL,
  gr_number int4 NULL,
  gr_comment text NULL,
  gr_lastupdate date DEFAULT CURRENT_DATE NOT NULL,
  gr_ver_code TEXT NOT NULL,
  CONSTRAINT fk_gr_ver_code FOREIGN KEY (gr_ver_code)
  REFERENCES ref.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT
);

COMMENT ON TABLE dat.t_group_gr IS 'Table identifying the group metrics, a group metric corresponds to a
number of fish sampled for a given year, mostly to describe the annual series. Comments can be made
on the sampling with gr_comments. There can be several group metrics for the same year, for instance
with sampling designs for different stages';

COMMENT ON COLUMN dat.t_group_gr.gr_id IS 'Group ID, serial primary key on gr_id and gr_wkg_code';
COMMENT ON COLUMN dat.t_group_gr.gr_gr_id IS 'Parent group ID, used when giving separate metrics for male and females';
COMMENT ON COLUMN dat.t_group_gr.gr_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';
COMMENT ON COLUMN dat.t_group_gr.gr_year IS 'The year';
COMMENT ON COLUMN dat.t_group_gr.gr_number IS 'Number of fish in the group';
COMMENT ON COLUMN dat.t_group_gr.gr_comment IS 'Comment on the group metric, including on the sampling design applied to that particular year, if different from that applied for the whole series.';
COMMENT ON COLUMN dat.t_group_gr.gr_lastupdate IS 'Last update, inserted automatically';
COMMENT ON COLUMN dat.t_group_gr.gr_ver_code IS 'Version code as in tr_version_ver, corresponds to the working group code WGNAS-2024-1 WGEEL-2016-1, the -1 indicate the first data call in the year, -2 would be second etc....';


GRANT ALL ON dat.t_group_gr TO diaspara_admin;
GRANT SELECT ON dat.t_group_gr TO diaspara_read; 

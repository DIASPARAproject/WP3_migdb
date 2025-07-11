-- DROP TABLE IF EXISTS dat.t_fish_fi CASCADE;

CREATE TABLE dat.t_fish_fi (
  fi_id serial4 NOT NULL,
  fi_ser_id UUID NOT NULL,
  CONSTRAINT fk_fi_ser_id FOREIGN KEY (fi_ser_id)
  REFERENCES dat.t_series_ser (ser_id) 
  ON UPDATE CASCADE ON DELETE CASCADE, 
  fi_wkg_code TEXT NOT NULL,  
  CONSTRAINT fk_fi_wkg_code  FOREIGN KEY (fi_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT t_fish_fi_pkey PRIMARY KEY (fi_id, fi_wkg_code),
  fi_spe_code TEXT,
  CONSTRAINT fk_fi_spe_code FOREIGN KEY (fi_spe_code) 
  REFERENCES ref.tr_species_spe(spe_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,
  fi_lfs_code TEXT,
  CONSTRAINT fk_fi_lfs_code_fi_spe_code FOREIGN KEY (fi_lfs_code, fi_spe_code)
  REFERENCES ref.tr_lifestage_lfs (lfs_code, lfs_spe_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT, 
  fi_date date NULL,
  fi_year int4 NULL,
  CONSTRAINT ck_fi_date_fi_year CHECK (((fi_date IS NOT NULL) OR (fi_year IS NOT NULL))),
  fi_comment text NULL,
  fi_lastupdate date DEFAULT CURRENT_DATE NOT NULL,
  fi_idsource TEXT NULL UNIQUE,
  fi_ver_code TEXT NOT NULL,
  CONSTRAINT fk_gr_ver_code FOREIGN KEY (fi_ver_code)
  REFERENCES ref.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  fi_x_4326 NUMERIC,
  fi_y_4326 NUMERIC,
  fi_geom  GEOMETRY(Point, 4326) 
);




COMMENT ON TABLE dat.t_fish_fi IS 'Table identifying the fish metrics, a fish metric corresponds to a
 fish sampled at a given date or year.';

COMMENT ON COLUMN dat.t_fish_fi.fi_id IS 'Fi ID, serial primary key on fi_id and fi_wkg_code';
COMMENT ON COLUMN dat.t_fish_fi.fi_wkg_code IS 'Code of the working group, one of
WGBAST, WGEEL, WGNAS, WKTRUTTA';
COMMENT ON COLUMN dat.t_fish_fi.fi_lfs_code IS 'Life stage code';
COMMENT ON COLUMN dat.t_fish_fi.fi_spe_code IS 'Species code';
COMMENT ON COLUMN dat.t_fish_fi.fi_year IS 'The year';
COMMENT ON COLUMN dat.t_fish_fi.fi_comment IS 'Comment on the fish';
COMMENT ON COLUMN dat.t_fish_fi.fi_lastupdate IS 'Last update, inserted automatically';
COMMENT ON COLUMN dat.t_fish_fi.fi_ver_code IS 'Version code as in tr_version_ver, corresponds to the working group code WGNAS-2024-1 WGEEL-2016-1, the -1 indicate the first data call in the year, -2 would be second etc....';
COMMENT ON COLUMN dat.t_fish_fi.fi_idsource IS 'Identifier of the fish in the source (country) database';

GRANT ALL ON dat.t_fish_fi TO diaspara_admin;
GRANT SELECT ON dat.t_fish_fi TO diaspara_read; 

DROP TABLE IF EXISTS dateel.t_fish_fi;
CREATE TABLE dateel.t_fish_fi (
  CONSTRAINT fk_fi_ser_id FOREIGN KEY (fi_ser_id)
  REFERENCES dateel.t_series_ser (ser_id) 
  ON UPDATE CASCADE ON DELETE CASCADE, 
  CONSTRAINT fk_fi_wkg_code  FOREIGN KEY (fi_wkg_code)
  REFERENCES ref.tr_icworkinggroup_wkg(wkg_code)
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT t_fish_fi_pkey PRIMARY KEY (fi_id, fi_wkg_code),
  CONSTRAINT fk_fi_spe_code FOREIGN KEY (fi_spe_code) 
  REFERENCES ref.tr_species_spe(spe_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_fi_lfs_code_fi_spe_code FOREIGN KEY (fi_lfs_code, fi_spe_code)
  REFERENCES ref.tr_lifestage_lfs (lfs_code, lfs_spe_code) 
  ON UPDATE CASCADE ON DELETE RESTRICT, 
  CONSTRAINT ck_fi_date_fi_year CHECK (((fi_date IS NOT NULL) OR (fi_year IS NOT NULL))),
  CONSTRAINT fk_gr_ver_code FOREIGN KEY (fi_ver_code)
  REFERENCES refeel.tr_version_ver(ver_code)
  ON UPDATE CASCADE ON DELETE RESTRICT  
) INHERITS (dat.t_fish_fi);
 

GRANT ALL ON dateel.t_fish_fi TO diaspara_admin;
GRANT SELECT ON dateel.t_fish_fi TO diaspara_read;  
    
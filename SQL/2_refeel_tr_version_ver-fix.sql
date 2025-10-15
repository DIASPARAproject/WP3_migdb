-- fix inversion of column
-- add 2025 data call

INSERT INTO refeel.tr_version_ver (ver_code,ver_year,ver_spe_code,ver_stockkeylabel,ver_datacalldoi,ver_version,ver_description)
  VALUES ('WGEEL-2025-2',2025,'ANG','ele','https://doi.org/10.17895/ices.pub.29254589',2,'WGEEL Data call 2025: Joint ICES/GFCM/EIFAAC eel data call');
UPDATE refeel.tr_version_ver
  SET ver_description='Joint EIFAAC/GFCM/ICES Eel Data Call 2016',ver_stockkeylabel='ele',ver_datacalldoi=''
  WHERE ver_code='WGEEL-2016-1';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2017-2';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2017-1';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2018-1';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2019-1';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2020-1';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2021-1';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2022-1';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2023-1';
UPDATE refeel.tr_version_ver
  SET ver_datacalldoi='https://doi.org/10.17895/ices.pub.25816738.v2'
  WHERE ver_code='WGEEL-2024-1';
UPDATE refeel.tr_version_ver
  SET ver_datacalldoi='https://doi.org/10.17895/ices.pub.25816738.v2'
  WHERE ver_code='WGEEL-2025-1';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2024-1';
UPDATE refeel.tr_version_ver
  SET ver_stockkeylabel='ele'
  WHERE ver_code='WGEEL-2025-1';


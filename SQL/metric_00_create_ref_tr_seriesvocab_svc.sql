-- create dictionary table for series.
-- this serie_id might be related to a sampling station.
-- Here it identifies the upper level of a multitannual data collection
-- procedure. One svc_id might be common to several working group.


CREATE TABLE ref.tr_seriesvocab_svc (
  svc_id uuid,
  CONSTRAINT tr_seriesvocab_svc_pkey PRIMARY KEY (svc_id),
  svc_code text NOT NULL,
  CONSTRAINT uk_svc_code UNIQUE,
  svc_description NULL) 




COMMENT ON TABLE ref.tr_seriesvocab_svc IS 'Table of time series vocabulary, or sampling data identifier. This corresponds to a multi-annual data collection design.
It can correspond to time series data or individual metrics collection or both.';
COMMENT ON COLUMN ref.tr_seriesvocab_svc.svc_id IS 'UUID, identifier of the series';
COMMENT ON COLUMN ref.tr_seriesvocab_svc.svc_code IS 'Code of the series unique';


GRANT ALL ON ref.tr_seriesvocab_svc TO diaspara_admin;
GRANT SELECT ON ref.tr_seriesvocab_svc TO diaspara_read; 



SELECT * FROM datnas.t_metadata_met;

SELECT * FROM datnas.t_stock_sto;

SELECT * FROM dateel.t_metadata_met;

SELECT * FROM dateel.t_stock_sto;

SELECT * FROM datbast.t_metadata_met;

SELECT * FROM datbast.t_stock_sto;

SELECT tss.* FROM datbast.t_stock_sto AS tss
WHERE sto_are_code='2120027320'

SELECT * FROM ref.get_parent_area(310, 'WGBAST');

SELECT * FROM ref.get_parent_area(7025, 'WGBAST');



-- sample of the series (sampling info)
SELECT * FROM datbast.t_series_ser;

-- sample for annual data
SELECT * FROM datbast.t_serannual_san;

-- metric 

DROP TABLE IF EXISTS  ref.tr_statistic_sta CASCADE;
CREATE TABLE ref.tr_statistic_sta(
sta_code TEXT PRIMARY KEY,
sta_description TEXT
);


INSERT INTO ref.tr_statistic_sta VALUES
('Estimate' , 'Estimate');
INSERT INTO ref.tr_statistic_sta VALUES
('Index', 'Index');
INSERT INTO ref.tr_statistic_sta VALUES
('Bound', 'Either min or max');
INSERT INTO ref.tr_statistic_sta VALUES
('Hyperparameter', 'Hyperparameter (prior)');
INSERT INTO ref.tr_statistic_sta VALUES
('SD', 'Standard deviation');
INSERT INTO ref.tr_statistic_sta VALUES
('CV', 'Coefficient of variation');
INSERT INTO ref.tr_statistic_sta VALUES
('Precision', 'Inverse of variance');
INSERT INTO ref.tr_statistic_sta VALUES
('Mean', 'Mean');
INSERT INTO ref.tr_statistic_sta VALUES 
('Min','Minimum');
INSERT INTO ref.tr_statistic_sta VALUES 
('Max','Maximum');

GRANT ALL ON ref.tr_statistic_sta TO diaspara_admin;
GRANT SELECT ON ref.tr_statistic_sta TO diaspara_read;
COMMENT ON TABLE ref.tr_statistic_sta IS 
'Table metric describe the type of statistic described by the parameter,  Index, Bound ...';

/*
ALTER TABLE "ref".tr_metric_mtr RENAME TO tr_statistic_sta;
ALTER TABLE "ref".tr_statistic_sta RENAME COLUMN mtr_code TO sta_code;
ALTER TABLE "ref".tr_statistic_sta RENAME COLUMN mtr_description TO sta_description;
ALTER TABLE "ref".tr_statistic_sta RENAME CONSTRAINT tr_metric_mtr_pkey TO tr_statistic_sta_pkey;

-- metric 

DROP TABLE IF EXISTS  ref.tr_metric_mtr CASCADE;
CREATE TABLE ref.tr_metric_mtr(
mtr_code TEXT PRIMARY KEY,
mtr_description TEXT
);


INSERT INTO ref.tr_metric_mtr VALUES
('Estimate' , 'Estimate');
INSERT INTO ref.tr_metric_mtr VALUES
('Index', 'Index');
INSERT INTO ref.tr_metric_mtr VALUES
('Bound', 'Either min or max');
INSERT INTO ref.tr_metric_mtr VALUES
('Hyperparameter', 'Hyperparameter (prior)');
INSERT INTO ref.tr_metric_mtr VALUES
('SD', 'Standard deviation');
INSERT INTO ref.tr_metric_mtr VALUES
('CV', 'Coefficient of variation');
INSERT INTO ref.tr_metric_mtr VALUES
('Precision', 'Inverse of variance');
INSERT INTO ref.tr_metric_mtr VALUES
('Mean', 'Mean');
INSERT INTO ref.tr_metric_mtr VALUES 
('Min','Minimum');
INSERT INTO ref.tr_metric_mtr VALUES 
('Max','Maximum');

GRANT ALL ON ref.tr_metric_mtr TO diaspara_admin;
GRANT SELECT ON ref.tr_metric_mtr TO diaspara_read;
COMMENT ON TABLE ref.tr_metric_mtr IS 
'Table metric describe the type of parm used, Index, Bound ...';
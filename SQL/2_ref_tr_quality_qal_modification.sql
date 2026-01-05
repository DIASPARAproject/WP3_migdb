-- See report following Maria's comment there is a referential, here is the script to adapt the table

ALTER TABLE ref.tr_quality_qal  ADD COLUMN qal_icesvalue CHARACTER VARYING (4);
ALTER TABLE ref.tr_quality_qal  ADD COLUMN qal_icesguid uuid ;
ALTER TABLE ref.tr_quality_qal  ADD COLUMN qal_icestablesource TEXT ;

-- table public.temp_sdn_flags has been inserted in R
-- see report https://diaspara.bordeaux-aquitaine.inrae.fr/deliverables/wp3/p7stock/stockdb.html#quality-tr_quality_qal


/*
 * 0 has been removed from the table
 */

SELECT * FROM public.temp_sdn_flags WHERE "Key" = '9';
DELETE FROM  ref.tr_quality_qal WHERE qal_code = 9;
INSERT INTO ref.tr_quality_qal (qal_code, qal_description, qal_definition,
qal_kept, qal_icesvalue, qal_icesguid, qal_icestablesource)
 SELECT "Key"::integer AS qal_code,
  'Missing' AS qal_description,
 "Description" AS qal_definition,
 FALSE AS qal_kept,
 "Key" AS qal_icesvalue,
 "Guid"::UUID AS qal_icesguid, 
 'SDN_FLAGS' AS qal_icestablesource 
 FROM public.temp_sdn_flags WHERE "Key" = '9'; --1
 
 
 /*
  * 1 is OK
  */
 
SELECT * FROM public.temp_sdn_flags WHERE "Key" = '1';
UPDATE ref.tr_quality_qal SET (qal_description, qal_definition, qal_kept,
qal_icesvalue, qal_icesguid, qal_icestablesource) =
(s.qal_description, s.qal_definition, s.qal_kept, s.qal_icesvalue, 
s.qal_icesguid, s.qal_icestablesource)
FROM (
 SELECT
  'Good quality' AS qal_description,
 "Description" AS qal_definition,
 TRUE AS qal_kept,
 "Key" AS qal_icesvalue,
 "Guid"::UUID AS qal_icesguid, 
 'SDN_FLAGS' AS qal_icestablesource 
 FROM public.temp_sdn_flags WHERE "Key" = '1') AS s
 WHERE qal_code = 1;
 
  /*
  * 2 becomes 5
  */
DELETE FROM  ref.tr_quality_qal WHERE qal_code = 5;
UPDATE ref.tr_quality_qal SET (qal_code, qal_description, qal_definition, 
qal_kept, qal_icesvalue, qal_icesguid, qal_icestablesource) =
(s.qal_code, s.qal_description, s.qal_definition, s.qal_kept, 
s.qal_icesvalue, s.qal_icesguid, s.qal_icestablesource)
 FROM (
 SELECT
  "Key"::integer AS qal_code,
  'Modified' AS qal_description,
 "Description"|| '. Warning this was 2 previously in the WGEEL database.' AS qal_definition,
 TRUE AS qal_kept,
 "Key" AS qal_icesvalue,
 "Guid"::UUID AS qal_icesguid, 
 'SDN_FLAGS' AS qal_icestablesource 
 FROM public.temp_sdn_flags WHERE "Key" = '5') AS s
 WHERE tr_quality_qal.qal_code = 2; --1
 
   /*
  * 3 becomes 100
  * 4 becomes 3
  * 100 becomes 4
  */
 

 
 UPDATE ref.tr_quality_qal SET (qal_code, qal_description, qal_definition, 
qal_kept, qal_icesvalue, qal_icesguid, qal_icestablesource) =
(s.qal_code, s.qal_description, s.qal_definition, s.qal_kept, 
s.qal_icesvalue, s.qal_icesguid, s.qal_icestablesource)
FROM
(SELECT 
100 AS qal_code,
 qal_description, 
 "Description"||'. Previously 3 in WGEEL with definition:  '||qal_definition AS qal_definition, 
 qal_kept, 
 "Key" AS qal_icesvalue,
 "Guid"::UUID AS qal_icesguid, 
 'SDN_FLAGS' AS qal_icestablesource 
 FROM ref.tr_quality_qal, temp_sdn_flags 
 WHERE qal_code = 3 AND  "Key" = '4')s
 WHERE tr_quality_qal.qal_code = 3;
 
 
 UPDATE ref.tr_quality_qal SET (qal_code, qal_description, qal_definition, 
qal_kept, qal_icesvalue, qal_icesguid, qal_icestablesource) =
(s.qal_code, s.qal_description, s.qal_definition, s.qal_kept, 
s.qal_icesvalue, s.qal_icesguid, s.qal_icestablesource)
FROM
(SELECT 
 3 AS qal_code,
 qal_description, 
 "Description"||'. Previously 4 in WGEEL with definition: '||qal_definition AS qal_definition, 
 qal_kept, "Key" AS qal_icesvalue,
 "Guid"::UUID AS qal_icesguid, 
 'SDN_FLAGS' AS qal_icestablesource 
 FROM ref.tr_quality_qal, temp_sdn_flags 
 WHERE qal_code = 4 AND  "Key" = '3')s
 WHERE tr_quality_qal.qal_code = 4;

 
 UPDATE ref.tr_quality_qal SET qal_code = 4 WHERE qal_code =100;
 
 
 
 
  /*
  * Insert values 2, 6, 7, 8 (I'm not using letters) as qal_code is an integer
  */

 
 INSERT INTO ref.tr_quality_qal (qal_code, qal_description, qal_definition,
qal_kept, qal_icesvalue, qal_icesguid, qal_icestablesource)
 SELECT "Key"::integer AS qal_code,
  'Missing' AS qal_description,
 "Description" AS qal_definition,
 TRUE AS qal_kept,
 "Key" AS qal_icesvalue,
 "Guid"::UUID AS qal_icesguid, 
 'SDN_FLAGS' AS qal_icestablesource 
 FROM public.temp_sdn_flags WHERE "Key" in ('2', '6', '7', '8'); --4
 
UPDATE "ref".tr_quality_qal
  SET qal_description='probably good'
  WHERE qal_code=2;
UPDATE "ref".tr_quality_qal
  SET qal_description='below detection'
  WHERE qal_code=6;
UPDATE "ref".tr_quality_qal
  SET qal_description='above detection'
  WHERE qal_code=7;
UPDATE "ref".tr_quality_qal
  SET qal_description='interpolated'
  WHERE qal_code=8;

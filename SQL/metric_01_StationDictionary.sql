
/*
 * 
 * Note since the api retrieves a one to many relationship
 * in the foreign tables I need to drop foreign keys
 */

DROP TABLE IF EXISTS "ref"."StationDictionary" CASCADE;
CREATE TABLE "ref"."StationDictionary"(
"Definition" TEXT NOT NULL DEFAULT 'Station',
"HeaderRecord" TEXT NOT NULL DEFAULT 'Record',
"Station_Code" INTEGER PRIMARY KEY,
"Station_Country" TEXT NOT NULL,
--CONSTRAINT  fk_station_country 
--FOREIGN KEY ("Station_Country")
--REFERENCES ref.tr_country_cou(cou_code)
--ON UPDATE CASCADE ON DELETE CASCADE, -- possible problem here AS I don't have ALL the countries...
"Station_Name" TEXT NOT NULL,
"Station_LongName" TEXT NULL,
"Station_ActiveFromDate" CHARACTER VARYING (10) NULL, -- CHANGE I don't have that FROM the API
"Station_ActiveUntilDate" CHARACTER VARYING (10) NULL,
"Station_ProgramGovernance" TEXT  NULL,
--CONSTRAINT fk_station_programgovernance
--FOREIGN KEY ("Station_ProgramGovernance") 
--REFERENCES "ref"."PRGOV"("Key") 
--ON UPDATE CASCADE ON DELETE CASCADE,
"Station_StationGovernance" TEXT  NULL,
--CONSTRAINT fk_station_stationgovernance 
--FOREIGN KEY ("Station_StationGovernance") 
--REFERENCES "ref"."EDMO"("Key") 
--ON UPDATE CASCADE ON DELETE CASCADE,
"Station_PURPM" TEXT NULL, -- FAILS WITH NOT NULL
--CONSTRAINT fk_station
--FOREIGN KEY ("Station_PURPM") 
--REFERENCES "ref"."PURPM"("Key")
--ON UPDATE CASCADE ON DELETE CASCADE,
"Station_Latitude" NUMERIC NULL,
"Station_LatitudeRange" NUMERIC NULL,
"Station_Longitude" NUMERIC NULL,
"Station_LongitudeRange" NUMERIC NULL,
"Station_Geometry" geometry,
--CONSTRAINT ck_geom_or_latlon 
--CHECK ("Station_Geometry" IS NOT NULL 
--OR "Station_Latitude" IS NOT NULL
--OR "Station_LatitudeRange" IS NOT NULL),
"Station_DataType" TEXT NULL,
--CONSTRAINT fk_station_datatype 
--FOREIGN KEY ("Station_DataType") REFERENCES
--"ref"."Station_DTYPE"("Key")
--ON UPDATE CASCADE ON DELETE CASCADE,
"Station_WLTYP" TEXT,
--CONSTRAINT fk_station_wltype 
--FOREIGN KEY ("Station_WLTYP") 
--REFERENCES "ref"."WLTYP"("Key")
--ON UPDATE CASCADE ON DELETE CASCADE,
"Station_MSTAT" TEXT,
-- CONSTRAINT fk_station_msat
--FOREIGN KEY ("Station_MSTAT") 
--REFERENCES "ref"."MSTAT"("Key")
--ON UPDATE CASCADE ON DELETE CASCADE,
"Station_Notes" TEXT,
"Station_Deprecated" TEXT,
FOREIGN KEY ("Station_Deprecated") 
REFERENCES "ref"."Deprecated"("Key")
ON UPDATE CASCADE ON DELETE CASCADE
);

-- Not sure I'll ever need that one .....
DROP TABLE IF EXISTS "ref"."Relation";
CREATE TABLE "ref"."Relation"(
"Definiton" TEXT NOT NULL DEFAULT 'Relation',
"HeaderRecord" TEXT  NOT NULL DEFAULT 'Record',
"Relation_Code" INTEGER NOT NULL,
CONSTRAINT fk_relation_code FOREIGN KEY ("Relation_Code")
REFERENCES "ref"."StationDictionary"("Station_Code") 
ON UPDATE CASCADE ON DELETE CASCADE,
"Relation_Country" TEXT NOT NULL,
CONSTRAINT fk_relation_country 
 FOREIGN KEY ("Relation_Country")
REFERENCES ref.tr_country_cou(cou_code)
ON UPDATE CASCADE ON DELETE CASCADE,
"Relation_Name" CHARACTER VARYING(50) NOT NULL,
"Relation_ActiveFromDate" CHARACTER VARYING(10) NOT NULL,
"Relation_RelatedCode" INTEGER NOT NULL,
CONSTRAINT fk_relation_relatedCode 
FOREIGN KEY ("Relation_RelatedCode")
REFERENCES "ref"."StationDictionary"("Station_Code") 
ON UPDATE CASCADE ON DELETE CASCADE,
"Relation_RelatedCountry" TEXT NOT NULL,
CONSTRAINT fk_relation_related_country
FOREIGN KEY  ("Relation_RelatedCountry")
REFERENCES ref.tr_country_cou(cou_code)
ON UPDATE CASCADE ON DELETE CASCADE,
"Relation_RelatedName" CHARACTER VARYING(50) NOT NULL,
"Relation_RelatedActiveFromDate" CHARACTER VARYING (10) NOT NULL,
"Relation_RelationType" TEXT NOT NULL);



COMMENT ON TABLE ref."WLTYP" IS 'Water and land station type';
COMMENT ON TABLE ref."PRGOV" IS 'Program Governance referential';
COMMENT ON TABLE ref."PURPM" IS 'Purpose of monitoring';
COMMENT ON TABLE ref."MSTAT" IS 'Purpose of monitoring';
COMMENT ON TABLE ref."EDMO" IS 'European Directory of Marine Organisations (EDMO)';



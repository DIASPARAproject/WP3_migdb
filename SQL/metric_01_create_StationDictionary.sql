/*
 * 
 *  NOTE BELOW I'M NOT SPENDING TOO MUCH TIME ON THE CONSTRAINT
 *  AS THIS TABLE IS COMING FROM ICES.
 */


CREATE TABLE "ref"."StationDictionary"(
"StationDefinition" TEXT NOT NULL,
"HeaderRecord" TEXT NOT NULL,
"Station_Code" INTEGER PRIMARY KEY ,
"Station_Country" TEXT NOT NULL,
"Station_Name" CHARACTER VARYING (50) NOT NULL,
"Station_LongName" CHARACTER VARYING (50) NULL,
"Station_ActiveFromDate" CHARACTER VARYING (10) NOT NULL,
"Station_ActiveUntilDate" CHARACTER VARYING (10) NULL,
"Station_ProgramGovernance" TEXT NOT NULL,
CONSTRAINT fk_station_programgovernance
FOREIGN KEY ("Station_ProgramGovernance") 
REFERENCES "ref"."PRGGOV"("Key") 
ON UPDATE CASCADE ON DELETE CASCADE,
"Station_StationGovernance" INTEGER NOT NULL,
CONSTRAINT fk_station_stationgovernance 
FOREIGN KEY ("Station_StationGovernance") 
REFERENCES "ref"."EDMO"("Key") 
ON UPDATE CASCADE ON DELETE CASCADE,
"Station_PURPM" TEXT NOT NULL,
CONSTRAINT fk_station
FOREIGN KEY ("Station_PURPM") 
REFERENCES "ref"."PURM"("Key")
ON UPDATE CASCADE ON DELETE CASCADE,
"Station_Latitude" NUMERIC NULL
"Station_LatitudeRange" NUMERIC NULL
"Station_Longitude" NUMERIC NULL
"Station_LongitudeRange" NUMERIC NULL
"Station_Geometry" geometry,
CONSTRAINT ck_geom_or_latlon 
CHECK ("Station_Geometry" IS NOT NULL 
OR "Station_Latitude" IS NOT NULL
OR "Station_LatitudeRange" IS NOT NULL)
"Station_DataType" TEXT NULL,
CONSTRAINT fk_station_datatype 
FOREIGN KEY "Station_DataType" REFERENCES
"ref"."Station_DTYPE"("Key")
ON UPDATE CASCADE ON DELETE CASCADE,
"Station_WLTYP" TEXT,

"Station_MSTAT" TEXT,
"Station_Notes" TEXT,
"Station_Deprecated" TEXT
);


CREATE TABLE "ref"."Relation"(
"Relation",
"Header/Record",
"Relation_Code",
"Relation_Country",
"Relation_Name",
"Relation_ActiveFromDate",
"Relation_RelatedCode",
"Relation_RelatedCountry",
"Relation_RelatedName",
"Relation_RelatedActiveFromDate",
"Relation_RelationType")



)
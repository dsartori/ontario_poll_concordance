-- init variables
DECLARE @election_year int = 2020
DECLARE @path varchar(max) 

-- load ontario polling divisions
SET @path = 'c:\wkt\POLLING_DIVISION.csv'

DROP TABLE IF EXISTS #raw_pd

CREATE TABLE #raw_pd (
	ED_ID VARCHAR(MAX),
	OBJECTID VARCHAR(MAX),
	PD_NUMBER VARCHAR(MAX),
	PD_LABEL VARCHAR(MAX),
	ED_NAME_EN VARCHAR(MAX),
	ED_NAME_FR VARCHAR(MAX),
	SHAPE_AREA VARCHAR(MAX),
	SHAPE_LEN VARCHAR(MAX),
	WKB VARCHAR(MAX))


DECLARE @SQL VARCHAR(MAX) = 'BULK INSERT #raw_pd
	FROM  ''' + @path + '''
	WITH
	(
	FIRSTROW = 2,
	CODEPAGE = ''65001'',
	FIELDTERMINATOR = '','',
	ROWTERMINATOR = ''\n'',
	FORMAT = ''CSV''
	)'

EXEC(@SQL)

DELETE FROM polling_division

INSERT INTO polling_division (
								Election_Year,
								ED_ID,
								PD,
								ED_Name_En,
								ED_Name_Fr,
								Geo
							)
SELECT 
	@election_year AS Election_Year,
	ED_ID AS ED_ID,
	PD_LABEL AS PD,
	ED_NAME_EN AS ED_Name_En,
	ED_NAME_FR AS ED_Name_Fr,
	GEOMETRY::STGeomFromWKB(CONVERT(VARBINARY(MAX),'0x' + WKB,1),4326) AS Geo
FROM #raw_pd
		
-- load census geography

DROP TABLE IF EXISTS #raw_da

CREATE TABLE #raw_da (
	DAUID VARCHAR(MAX),
	PRUID VARCHAR(MAX),
	PRNAME VARCHAR(MAX),
	CDUID VARCHAR(MAX),
	CDNAME VARCHAR(MAX),
	CDTYPE VARCHAR(MAX),
	CCSUID VARCHAR(MAX),
	CCSNAME VARCHAR(MAX),
	CSDUID VARCHAR(MAX),
	CSDNAME VARCHAR(MAX),
	CSDTYPE VARCHAR(MAX),
	ERUID VARCHAR(MAX),
	ERNAME VARCHAR(MAX),
	SACCODE VARCHAR(MAX),
	SACTYPE VARCHAR(MAX),
	CMAUID VARCHAR(MAX),
	CMAPUID VARCHAR(MAX),
	CMANAME VARCHAR(MAX),
	CMATYPE VARCHAR(MAX),
	CTUID VARCHAR(MAX),
	CTNAME VARCHAR(MAX),
	ADAUID VARCHAR(MAX),
	WKB VARCHAR(MAX)
	)

set @path = 'C:\WKT\lda_000b16a_e.csv'
SET @SQL = 'BULK INSERT #raw_da
	FROM  ''' + @path + '''
	WITH
	(
	FIRSTROW = 2,
	CODEPAGE = ''65001'',
	FIELDTERMINATOR = '','',
	ROWTERMINATOR = ''\n'',
	FORMAT = ''CSV''
	)'

EXEC(@SQL)

DELETE FROM DA

INSERT INTO DA (
				DAUID,
				Census_Division,
				Geo
				)
SELECT 
	DAUID,
	CDNAME,
	GEOMETRY::STGeomFromWKB(CONVERT(VARBINARY(MAX),'0x' + WKB,1),4326) AS Geo
FROM #raw_da
WHERE PRUID = 35 -- Ontario


-- Perform geo analysis

DELETE FROM Concordance

insert into Concordance
select 
	d.da_ID,
	p.polling_division_ID,
	round(d.Geo.STIntersection(p.Geo).STArea() / d.Geo.STArea(),4) 
FROM da d
INNER JOIN polling_division p ON p.Geo.STIntersects(d.Geo) = 1
WHERE d.Geo.STIntersection(p.Geo).STArea() / d.Geo.STArea() > 0.01

-- Load Census Data
TRUNCATE TABLE Census_Data
	
SET @path = 'C:\Census\98-401-X2016044_ONTARIO_English_CSV_data.csv'
SET @SQL = 'BULK INSERT Census_Data
    FROM ''' + @path + '''
    WITH
    (
    FORMAT = ''CSV'', 
    FIELDQUOTE = ''"'',
    FIRSTROW = 2,
    FIELDTERMINATOR = '','',  
    ROWTERMINATOR = ''\n'',   
    TABLOCK
    );'

EXEC(@SQL)
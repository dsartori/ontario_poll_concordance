
CREATE TABLE polling_division(
	polling_division_ID INT IDENTITY(1,1),
	Election_Year INT,
	ED_ID INT,
	PD VARCHAR(10),
	ED_Name_En VARCHAR(255),
	ED_Name_Fr VARCHAR(255),
	Geo GEOMETRY
)

CREATE TABLE DA(
	da_ID INT IDENTITY(1,1),
	DAUID INT,
	Census_Division VARCHAR(255),
	Geo GEOMETRY
)

CREATE TABLE Concordance(
	polling_division_ID INT,
	da_ID INT,
	percent_in_PD decimal(5,4)
)

CREATE TABLE Census_Data(
	[CENSUS_YEAR] VARCHAR(50),
	[GEO_CODE_POR] VARCHAR(50),
	[GEO_LEVEL] VARCHAR(50),
	[GEO_NAME] VARCHAR(50),
	[GNR] VARCHAR(50),
	[GNR_LF] VARCHAR(50),
	[DATA_QUALITY_FLAG] VARCHAR(50),
	[ALT_GEO_CODE] VARCHAR(50),
	[DIM_PROFILE_OF_DISSEMINATION_AREAS] VARCHAR(255),
	[MEMBER_ID_PROFILE_OF_DISSEMINATION_AREAS] VARCHAR(50),
	[NOTES_PROFILE_OF_DISSEMINATION_AREAS] VARCHAR(50),
	[DIM_SEX_MEMBER_ID_TOTAL_SEX] VARCHAR(50),
	[DIM_SEX_MEMBER_ID_MALE] VARCHAR(50),
	[DIM_SEX_MEMBER_ID_FEMALE] VARCHAR(50) 
)


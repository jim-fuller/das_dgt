USE [FSC_DASVALORGOV]
GO

ALTER TABLE [dw].[DimDataQualityRule] DROP CONSTRAINT [FK_DimDataQualityRule_DimDataQualitySubjectArea]
GO

DROP TABLE [dw].[DimDataQualitySubjectArea]
DROP TABLE [dw].[DimDataQualityRule]
GO

CREATE TABLE dw.DimDataQualityRule (
	DimDataQualityRuleId BIGINT NOT NULL CONSTRAINT [PK_DimDataQualityRule] PRIMARY KEY CLUSTERED IDENTITY(1,1) 
	,DimDataQualitySubjectAreaId BIGINT NULL

	,BusinessRuleName VARCHAR(100)
	,TechnicalRuleName VARCHAR(100)
	,RuleDescription VARCHAR(1000)
	,PassFailLogic VARCHAR(1000)
	,Criteria VARCHAR(1000)
	,Element VARCHAR(100)
	,PrimaryDataSteward VARCHAR(100)
	,Dimension VARCHAR(10)
	,BusinessImpact VARCHAR(1000)
	,ImpactedSystems VARCHAR(1000)
	,RemediationGuidance VARCHAR(1000)
	,Comments VARCHAR(1000)
	,CreatedBy VARCHAR(30) NOT NULL
	,CreationDate DATE NOT NULL
	,UpdatedBy VARCHAR(30) NOT NULL
	,LastUpdatedDate DATE NOT NULL
	,ActiveFlag BIT
	,BeginDate DATE NULL
	,EndDate DATE NULL
	,VersionNumber Timestamp NOT NULL
)

CREATE TABLE dw.DimDataQualitySubjectArea (
	DimDataQualitySubjectAreaId BIGINT NOT NULL CONSTRAINT [PK_DimDataQualitySubjectArea] PRIMARY KEY CLUSTERED IDENTITY(1,1) 
	,FunctionalCommunityName VARCHAR(75)
	,FunctionalCommunityDescription VARCHAR(150)
	,SubjectAreaName VARCHAR(75)
	,SubjectAreaDescription VARCHAR(150)
	,SourceName VARCHAR(75)
	,SourceDescription VARCHAR(150)
	,DatasetName VARCHAR(75)
	,DatasetDescription VARCHAR(150)
)
GO

ALTER TABLE [dw].[DimDataQualityRule] WITH CHECK ADD CONSTRAINT [FK_DimDataQualityRule_DimDataQualitySubjectArea] FOREIGN KEY([DimDataQualitySubjectAreaId])
REFERENCES [dw].[DimDataQualitySubjectArea] ([DimDataQualitySubjectAreaId])
GO
ALTER TABLE [dw].[DimDataQualityRule] CHECK CONSTRAINT [FK_DimDataQualityRule_DimDataQualitySubjectArea]
GO

CREATE NONCLUSTERED INDEX [IDX_DimDataQualityRule_DimDataQualitySubjectAreaId] ON [dw].[DimDataQualityRule] ([DimDataQualitySubjectAreaId] ASC)
GO


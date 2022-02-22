USE [DGT]
GO

--START - Changes for FSCDAS-12397
	UPDATE s
	SET SubjectAreaNM= 'Building Service Equipment'
	FROM [dw].[FactDGTRuleSummary] AS s
	WHERE SubjectAreaNM = 'AEMS/MERS'


	UPDATE f
	SET SubjectAreaNM= 'Building Service Equipment'
	FROM [dw].[FactDGTequipinv6914ErrorDetails] AS f
	WHERE SubjectAreaNM = 'AEMS/MERS'
--END - Changes for FSCDAS-12397
GO

--START - Changes for FSCDAS-12460 and FSCDAS-12462
	--START - Create new schema
		IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'ref') BEGIN
			EXEC sys.sp_executesql N'CREATE SCHEMA [ref]'
		END
	--END - Create new schema


	--START - Create the Table [ref].[DGTRuleLookup]
		IF NOT EXISTS (
			SELECT *
			FROM sys.objects
			WHERE object_id = OBJECT_ID(N'[ref].[DGTRuleLookup]')
			AND type in (N'U')
		) BEGIN
			CREATE TABLE [ref].[DGTRuleLookup](
				[RuleID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
				[SubjectAreaNM] [varchar](200) NULL,
				[RuleNM] [varchar](200) NULL,
				[UserID] [varchar](100) NULL,
				[InsertDT] [datetime] NULL,
				[UpdateDT] [datetime] NULL,
				[Source] [varchar](1) NULL,
				[DataQualityDimension] [varchar](50) NULL,
				[FunctionalCommunityNM] [varchar](50) NULL,
				[RuleDescription] [varchar](10) NULL,
				[RuleStatus] [varchar](10) NULL,
				[StartDate] [date] NULL,
				[EndDate] [date] NULL,
				[CurrentRecordFlag] [char](1) NULL
			)
		END
		ELSE BEGIN
			PRINT 'Table [ref].[DGTRuleLookup] already exists'
		END
	--END - Create the Table [ref].[DGTRuleLookup]
	GO

	--START - Create Primary Key on table [dw].[FactDGTRuleSummary]
		IF NOT EXISTS (
			SELECT 1
			FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
			WHERE CONSTRAINT_TYPE='PRIMARY KEY'
			AND TABLE_SCHEMA = 'dw'
			AND TABLE_NAME = 'FactDGTRuleSummary'
			AND CONSTRAINT_NAME = 'PK_FactDGTRuleSummary'
		) BEGIN
			ALTER TABLE [dw].[FactDGTRuleSummary]
			ADD CONSTRAINT PK_FactDGTRuleSummary PRIMARY KEY CLUSTERED (ValidationID)
		END
		ELSE BEGIN
			PRINT 'Primary Key PK_FactDGTRuleSummary already exists on [dw].[FactDGTRuleSummary]'
		END
	--END - Create Primary Key on table [dw].[FactDGTRuleSummary]
	GO

	--START - Add field RuleID on table [dw].[FactDGTRuleSummary]
		IF NOT EXISTS(
			SELECT 1
			FROM SYS.COLUMNS
			WHERE [Name] = N'RuleID'
			AND [Object_ID] = Object_ID(N'dw.FactDGTRuleSummary')
		) BEGIN
			ALTER TABLE [dw].[FactDGTRuleSummary]
			ADD RuleID INT NULL
		END
		ELSE BEGIN
			PRINT 'Field RuleID already exists in table [dw].[FactDGTRuleSummary]'
		END
	--END - Add field RuleID on table [dw].[FactDGTRuleSummary]
	GO

	--START - Add field RuleID on table [dw].[FactDGTequipinv6914ErrorDetails]
		IF NOT EXISTS(
			SELECT 1
			FROM SYS.COLUMNS
			WHERE [Name] = N'RuleID'
			AND [Object_ID] = Object_ID(N'dw.FactDGTequipinv6914ErrorDetails')
		) BEGIN
			ALTER TABLE [dw].[FactDGTequipinv6914ErrorDetails]
			ADD RuleID INT NULL
		END
		ELSE BEGIN
			PRINT 'Field RuleID already exists in table [dw].[FactDGTequipinv6914ErrorDetails]'
		END
	--END - Add field RuleID on table [dw].[FactDGTequipinv6914ErrorDetails]
	GO

	--START - Create a foreign key between [dw].[FactDGTRuleSummary] and [ref].[DGTRuleLookup]
		IF NOT EXISTS (
			SELECT 1
			FROM sys.objects AS o
			WHERE o.object_id = object_id(N'dw.FK_FactDGTRuleSummary_RuleID')
			AND OBJECTPROPERTY(o.object_id, N'IsForeignKey') = 1
		)
		BEGIN
			ALTER TABLE [dw].[FactDGTRuleSummary]  WITH CHECK ADD CONSTRAINT [FK_FactDGTRuleSummary_RuleID] FOREIGN KEY([RuleID])
			REFERENCES [ref].[DGTRuleLookup] ([RuleID])

			ALTER TABLE [dw].[FactDGTRuleSummary] CHECK CONSTRAINT [FK_FactDGTRuleSummary_RuleID]
		END
		ELSE BEGIN
			PRINT 'The foreign key dw.FK_FactDGTRuleSummary_RuleID already exists'
		END
	--END - Create a foreign key between [dw].[FactDGTRuleSummary] and [ref].[DGTRuleLookup]
	GO

	--START - Create a foreign key between [dw].[FactDGTequipinv6914ErrorDetails] and [ref].[DGTRuleLookup]
		IF NOT EXISTS (
			SELECT 1
			FROM sys.objects AS o
			WHERE o.object_id = object_id(N'dw.FK_FactDGTequipinv6914ErrorDetails_RuleID')
			AND OBJECTPROPERTY(o.object_id, N'IsForeignKey') = 1
		)
		BEGIN
			ALTER TABLE [dw].[FactDGTequipinv6914ErrorDetails]  WITH CHECK ADD CONSTRAINT [FK_FactDGTequipinv6914ErrorDetails_RuleID] FOREIGN KEY([RuleID])
			REFERENCES [ref].[DGTRuleLookup] ([RuleID])

			ALTER TABLE [dw].[FactDGTequipinv6914ErrorDetails] CHECK CONSTRAINT [FK_FactDGTequipinv6914ErrorDetails_RuleID]
		END
		ELSE BEGIN
			PRINT 'The foreign key dw.FK_FactDGTequipinv6914ErrorDetails_RuleID already exists'
		END
	--END - Create a foreign key between [dw].[FactDGTequipinv6914ErrorDetails] and [ref].[DGTRuleLookup]
	GO

	--START - Create an index on [dw].[FactDGTRuleSummary].[RuleID]
		IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'IX_FactDGTRuleSummary_RuleID') BEGIN
			CREATE INDEX [IX_FactDGTRuleSummary_RuleID] ON [dw].[FactDGTRuleSummary] ([RuleID])
		END
		ELSE BEGIN
			PRINT 'The index IX_FactDGTRuleSummary_RuleID already exists'
		END
	--END - Create an index on [dw].[FactDGTRuleSummary].[RuleID]
	GO

	--START - Create an index on [dw].[FactDGTequipinv6914ErrorDetails].[RuleID]
		IF NOT EXISTS (SELECT name FROM sysindexes WHERE name = 'IX_FactDGTequipinv6914ErrorDetails_RuleID') BEGIN
			CREATE INDEX [IX_FactDGTequipinv6914ErrorDetails_RuleID] ON [dw].[FactDGTequipinv6914ErrorDetails] ([RuleID])
		END
		ELSE BEGIN
			PRINT 'The index IX_FactDGTequipinv6914ErrorDetails_RuleID already exists'
		END
	--END - Create an index on [dw].[FactDGTequipinv6914ErrorDetails].[RuleID]
	GO

	--START - Load new data
		IF NOT EXISTS (SELECT * FROM [ref].[DGTRuleLookup]) BEGIN
			SET IDENTITY_INSERT [ref].[DGTRuleLookup] ON 
				INSERT [ref].[DGTRuleLookup] ([RuleID], [SubjectAreaNM], [RuleNM], [UserID], [InsertDT], [UpdateDT], [Source], [DataQualityDimension], [FunctionalCommunityNM], [RuleDescription], [RuleStatus], [StartDate], [EndDate], [CurrentRecordFlag])
				VALUES (1, N'CEQUIPBSE', N'BSE non-dispositioned items assigned a location beginning with ZZ', N'SR', CAST(N'2021-12-28T11:23:33.623' AS DateTime), NULL, N'V', N'Validity', NULL, NULL, N'Active', CAST(N'2021-09-01' AS Date), NULL, N'Y')

				INSERT [ref].[DGTRuleLookup] ([RuleID], [SubjectAreaNM], [RuleNM], [UserID], [InsertDT], [UpdateDT], [Source], [DataQualityDimension], [FunctionalCommunityNM], [RuleDescription], [RuleStatus], [StartDate], [EndDate], [CurrentRecordFlag])
				VALUES (2, N'CEQUIPBSE', N'Database Corruption', N'SR', CAST(N'2021-12-28T11:23:45.967' AS DateTime), NULL, N'V', N'Validity', NULL, NULL, N'Active', CAST(N'2021-09-01' AS Date), NULL, N'Y')
			SET IDENTITY_INSERT [ref].[DGTRuleLookup] OFF
		END
		ELSE BEGIN
			PRINT 'The two rules already exist in [ref].[DGTRuleLookup]'
		END
	--END - Load new data
	GO

	--START - Fix historical data

		--START - Change the Rule Name "Location Mal Formatted" to "Database Corruption"
			UPDATE [ref].[DGTRuleLookup]
			SET RuleNM = 'Database Corruption'
			WHERE RuleNM = 'Location Mal Formatted'
		--END - Change the Rule Name "Location Mal Formatted" to "Database Corruption"
		GO

		--START - Populate the historical data in table [dw].[FactDGTRuleSummary] with a RuleID value
			UPDATE s
			SET s.RuleID = r.RuleID
			FROM [dw].[FactDGTRuleSummary] AS s
			INNER JOIN [ref].[DGTRuleLookup] AS r
				ON s.MetricNM = r.RuleNM
		--END - Populate the historical data in table [dw].[FactDGTRuleSummary] with a RuleID value
		GO

		--START - Populate the historical data in table [dw].[FactDGTequipinv6914ErrorDetails] with a RuleID value
			UPDATE e
			SET e.RuleID = r.RuleID
			FROM [dw].[FactDGTequipinv6914ErrorDetails] AS e
			INNER JOIN [ref].[DGTRuleLookup] AS r
				ON e.[ErrorMessage] = r.RuleNM
		--END - Populate the historical data in table [dw].[FactDGTequipinv6914ErrorDetails] with a RuleID value
		GO
	--END - Fix historical data
	

	--START - Update Views
GO
ALTER VIEW [rpt].[vw_DGTRuleSummary]
AS

WITH Result AS (
	SELECT DISTINCT
		drs.[ValidationID]
		,drs.[ProcessID]
		,drs.[SubjectAreaNM]
		,'FM' as FunctionalCommunity
		,drs.[StationNbr]
		,sn.[StationName]
		,drs.[Visn]
		,drs.[MetricNM]
		,drs.[MetricCNT]
		,CAST(drs.[MetricCNT] AS FLOAT) / CAST(drs.[TotalLoadCNT] AS FLOAT) AS MetricPCT
		,drs.[TotalLoadCNT]
		,drs.[UserID]
		,drs.[InsertDT] as ReportDate
		,drs.[UpdateDT]
		,CASE
			WHEN [Source] = 'V' THEN 'AEMS/MERS - VistA'
			WHEN [Source] = 'M' THEN 'Maximo'
			WHEN [Source] = 'X' THEN 'External'
		END AS [Source]
	FROM [dw].[FactDGTRuleSummary] AS drs
	LEFT JOIN (
		SELECT DISTINCT
			s.[station__no] AS StationNumber
			,CASE
				WHEN s.[sta6aname] IS NOT NULL THEN s.[sta6aname]
				WHEN s.[sta5aname] is not null then s.[sta5aname]
				ELSE s.[sta3nname]
			END AS StationName
		FROM [stg].[VHACDWA06CdwWorkInventoryequipmentinv6914engspace6928DSSDimDimLocationVha] AS s
	) AS sn
		ON drs.StationNbr = sn.StationNumber
	WHERE MetricNM in ('Information','Non-Compliant','Warning','Compliant','Fail')
)


SELECT
	r.[ValidationID]
	,r.[ProcessID]
	,r.[SubjectAreaNM]
	,r.FunctionalCommunity
	,r.[StationNbr]
	,r.[StationName]
	,r.[Visn]
	,r.[MetricNM]
	,r.[MetricCNT]
	,r.MetricPCT
	,r.[TotalLoadCNT]
	,r.[UserID]
	,r.[ReportDate]
	,r.[UpdateDT]
	,r.[Source]
	,'N' as 'ReportDateWithinLast10WeeksFlag'
FROM Result AS r
UNION ALL
SELECT
	r.[ValidationID]
	,r.[ProcessID]
	,r.[SubjectAreaNM]
	,r.FunctionalCommunity
	,r.[StationNbr]
	,r.[StationName]
	,r.[Visn]
	,r.[MetricNM]
	,r.[MetricCNT]
	,r.MetricPCT
	,r.[TotalLoadCNT]
	,r.[UserID]
	,r.[ReportDate]
	,r.[UpdateDT]
	,r.[Source]
	,'Y' as 'ReportDateWithinLast10WeeksFlag'
FROM Result AS r
WHERE CAST(r.[ReportDate] AS DATE) >= DATEADD(week,-9,CAST(getdate() AS DATE))

GO



ALTER VIEW [rpt].[vw_DGTRuleDetails]
AS 

WITH latest AS (
	SELECT MAX(processid) AS latprocessid
	FROM [dw].[FactDGTRuleSummary]
)

SELECT DISTINCT
	s.[ValidationID]
	,s.[ProcessID]
	,s.[SubjectAreaNM]
	,'FM' as FunctionalCommunity
	,s.StationNbr
	,s.[Visn]
	,s.[MetricNM]
	,s.[MetricCNT]
	,CAST(s.MetricCNT AS FLOAT) / CAST(s.TotalLoadCNT AS FLOAT) AS MetricPCT
	,s.[TotalLoadCNT]
	,s.[UserID]
	,s.[InsertDT] as ReportDate
	,s.[UpdateDT]
	,CASE
		WHEN s.[Source] = 'V' THEN 'AEMS/MERS - VistA'
		WHEN s.[Source] = 'M' THEN 'Maximo'
		WHEN s.[Source] = 'X' THEN 'External'
	END AS [Source]
	,r.DataQualityDimension
FROM [dw].[FactDGTRuleSummary] AS s
INNER JOIN latest AS l
	ON l.latprocessid = s.ProcessID
INNER JOIN [ref].[DGTRuleLookup] AS r
	ON s.RuleID = r.RuleID
WHERE s.MetricNM NOT IN ('Information','Non-Compliant','Warning','Compliant','Fail')

GO



ALTER VIEW [rpt].[vw_DGTErrorDetailCequip_BSE]
AS

WITH latest AS (
	SELECT
		MAX(processid) AS latprocessid
	FROM [dw].[FactDGTequipinv6914ErrorDetails]
)

SELECT
	e.[visn]
	,CASE
		WHEN e.sta6aname IS NOT NULL THEN e.sta6aname
		WHEN e.sta5aname IS NOT NULL THEN e.sta5aname
		ELSE e.sta3nname
	END AS StationNM
	,e.[sta3nname]
	,e.[sta6aname]
	,e.[station__no]
	,e.[station_number]
	,e.[SubjectAreaNM]
	,'FM' AS FunctionalCommunity 
	,e.[entry_number]
	,e.[ErrorMessage]
	,e.[location]
	,e.[locationx]
	,e.[room_number]
	,e.[building_number]
	,e.[functionx]
	,e.[servicex]
	,e.[ProcessID]
	,e.[UserID]
	,e.[InsertDT] AS ReportDate
	,e.[sta5aname]
	,CASE
		WHEN e.[Source] = 'V' THEN 'AEMS/MERS - VistA'
		WHEN e.[Source] = 'M' THEN 'Maximo'
		WHEN e.[Source] = 'X' THEN 'External'
	END AS [Source]
	,CASE
		WHEN stg.type_of_entry = 'BUILDING SERVICE EQPT' THEN 'EQUIPMENT (BSE)'
		ELSE stg.type_of_entry
	END AS EquipmentType
	,r.DataQualityDimension
FROM [dw].[FactDGTequipinv6914ErrorDetails] AS e
INNER JOIN latest AS l
	ON l.latprocessid = e.ProcessID
INNER JOIN [stg].[VHACDWA06CdwWorkInventoryequipmentinv6914engspace6928DSSDimDimLocationVha] AS stg
	ON stg.[station__no] = e.[station__no]
	AND stg.[entry_number] = e.[entry_number]
INNER JOIN [ref].[DGTRuleLookup] AS r
	ON e.RuleID = r.RuleID
GO

	--END - Update Views

--END - Changes for FSCDAS-12460 and FSCDAS-12462
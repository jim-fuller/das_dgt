USE [DGT]
GO

/****** Object:  View [rpt].[vw_DGTErrorDetailCequip_BSE]    Script Date: 1/27/2022 4:57:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [rpt].[vw_DGTErrorDetailCequip_BSE]
AS

WITH latest AS (
	SELECT
		MAX(processid) AS latprocessid
	FROM [dw].[FactDGTequipinv6914ErrorDetails]
)

SELECT
	ed.[visn]
	,CASE
		WHEN ed.sta6aname IS NOT NULL THEN ed.sta6aname
		WHEN ed.sta5aname IS NOT NULL THEN ed.sta5aname
		ELSE ed.sta3nname
	END AS StationNM
	,ed.[sta3nname]
	,ed.[sta6aname]
	,ed.[station__no]
	,ed.[station_number]
	,ed.[SubjectAreaNM]
	,'FM' AS FunctionalCommunity 
	,ed.[entry_number]
	,ed.[ErrorMessage]
	,ed.[location]
	,ed.[locationx]
	,ed.[room_number]
	,ed.[building_number]
	,ed.[functionx]
	,ed.[servicex]
	,ed.[ProcessID]
	,ed.[UserID]
	,ed.[InsertDT] AS ReportDate
	,ed.[sta5aname]
	,CASE
		WHEN ed.[Source] = 'V' THEN 'AEMS/MERS - VistA'
		WHEN ed.[Source] = 'M' THEN 'Maximo'
		WHEN ed.[Source] = 'X' THEN 'External'
	END AS [Source]
	,CASE
		WHEN s.type_of_entry = 'BUILDING SERVICE EQPT' THEN 'EQUIPMENT (BSE)'
		ELSE s.type_of_entry
	END AS EquipmentType
FROM [dw].[FactDGTequipinv6914ErrorDetails] AS ed 
INNER JOIN latest AS lat
	ON lat.latprocessid = ed.ProcessID
INNER JOIN [stg].[VHACDWA06CdwWorkInventoryequipmentinv6914engspace6928DSSDimDimLocationVha] AS s
	ON s.[station__no] = ed.[station__no]
	AND s.[entry_number] = ed.[entry_number]
GO

/****** Object:  View [rpt].[vw_DGTRuleDetails]    Script Date: 1/27/2022 4:57:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [rpt].[vw_DGTRuleDetails]
AS 

WITH latest AS (
	SELECT MAX(processid) AS latprocessid
	FROM [dw].[FactDGTRuleSummary]
)

SELECT DISTINCT
	[ValidationID]
	,[ProcessID]
	,[SubjectAreaNM]
	,'FM' as FunctionalCommunity
	,StationNbr
	,[Visn]
	,[MetricNM]
	,[MetricCNT]
	,CAST(MetricCNT AS FLOAT) / CAST(TotalLoadCNT AS FLOAT) AS MetricPCT
	,[TotalLoadCNT]
	,[UserID]
	,[InsertDT] as ReportDate
	,[UpdateDT]
	,CASE
		WHEN [Source] = 'V' THEN 'AEMS/MERS - VistA'
		WHEN [Source] = 'M' THEN 'Maximo'
		WHEN [Source] = 'X' THEN 'External'
	END AS [Source]
FROM [dw].[FactDGTRuleSummary] AS drs
INNER JOIN latest AS lat
	ON lat.latprocessid = drs.ProcessID
WHERE MetricNM NOT IN ('Information','Non-Compliant','Warning','Compliant','Fail')

GO

/****** Object:  View [rpt].[vw_DGTRuleSummary]    Script Date: 1/27/2022 4:57:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [rpt].[vw_DGTRuleSummary]
AS
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
	,CASE WHEN drs.[InsertDT] >= DATEADD(week,-10,CAST(getdate() AS DATE)) THEN 'Y'
		ELSE 'N'
	END AS 'ReportDateWithinLast10WeeksFlag'
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
GO

USE [DGT]
GO

/****** Object:  View [rpt].[vw_DGTRuleSummary]    Script Date: 12/27/2021 12:23:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO















CREATE view [rpt].[vw_DGTRuleSummary] as 


Select distinct [ValidationID]
      ,[ProcessID]
      ,[SubjectAreaNM]
	  ,'FM' as FunctionalCommunity
	  ,StationNbr
      ,[Visn]
      ,[MetricNM]
      ,[MetricCNT]
	  ,cast(MetricCNT as float)/cast(TotalLoadCNT as float)  as MetricPCT
      ,[TotalLoadCNT]
      ,[UserID]
      ,[InsertDT] as ReportDate
      ,[UpdateDT]
	  ,case when [Source] = 'V'
			then 'VistA'
		   when [Source] = 'M'
		   then 'Maximo'
		   when [Source] = 'X'
		   then 'External'
	   end as Source
from [dw].[FactDGTRuleSummary] drs
where MetricNM in ('Information','Non-Compliant','Warning','Compliant','Fail') 
GO



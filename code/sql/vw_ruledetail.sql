USE [DGT]
GO

/****** Object:  View [rpt].[vw_DGTRuleDetails]    Script Date: 12/27/2021 12:23:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

















CREATE view [rpt].[vw_DGTRuleDetails] as 

with latest as ( select max(processid) as latprocessid from [dw].[FactDGTRuleSummary] ) 

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
join latest lat on lat.latprocessid = drs.ProcessID
where MetricNM not in ('Information','Non-Compliant','Warning','Compliant','Fail') 
GO



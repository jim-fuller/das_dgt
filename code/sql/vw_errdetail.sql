USE [DGT]
GO

/****** Object:  View [rpt].[vw_DGTErrorDetailCequip_BSE]    Script Date: 12/27/2021 12:21:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
















CREATE view [rpt].[vw_DGTErrorDetailCequip_BSE] as 


with latest as ( select max(processid) as latprocessid from [dw].[FactDGTequipinv6914ErrorDetails])


Select[visn]
, case when sta6aname is not null then sta6aname
       when sta5aname is not null then sta5aname
	   else sta3nname
	   End as StationNM
      ,[sta3nname]
      ,[sta6aname]
      ,[station__no]
      ,[station_number]
      ,[SubjectAreaNM]
	  ,'FM' as FunctionalCommunity 
      ,[entry_number]
      ,[ErrorMessage]
      ,[location]
      ,[locationx]
      ,[room_number]
      ,[building_number]
      ,[functionx]
      ,[servicex]
      ,[ProcessID]
      ,[UserID]
      ,[InsertDT] as ReportDate
       ,[sta5aname]
	  ,case when [Source] = 'V'
			then 'VistA'
		   when [Source] = 'M'
		   then 'Maximo'
		   when [Source] = 'X'
		   then 'External'
	   end as Source
from [dw].[FactDGTequipinv6914ErrorDetails] ed 
join latest lat on lat.latprocessid = ed.ProcessID
GO



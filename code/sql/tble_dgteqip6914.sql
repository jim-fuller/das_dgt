USE [DGT]
GO

/****** Object:  Table [dw].[FactDGTequipinv6914ErrorDetails]    Script Date: 12/27/2021 11:14:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dw].[FactDGTequipinv6914ErrorDetails](
	[visn] [int] NULL,
	[sta3nname] [varchar](250) NULL,
	[sta6aname] [varchar](250) NULL,
	[station__no] [varchar](30) NULL,
	[station_number] [varchar](8000) NULL,
	[SubjectAreaNM] [varchar](50) NULL,
	[entry_number] [varchar](8000) NULL,
	[ErrorMessage] [varchar](8000) NULL,
	[location] [varchar](8000) NULL,
	[locationx] [varchar](8000) NULL,
	[room_number] [varchar](8000) NULL,
	[building_number] [varchar](8000) NULL,
	[functionx] [varchar](8000) NULL,
	[servicex] [varchar](8000) NULL,
	[ProcessID] [int] NULL,
	[UserID] [varchar](100) NULL,
	[InsertDT] [datetime] NULL,
	[Source] [varchar](1) NULL,
	[sta5aname] [varchar](250) NULL
) ON [PRIMARY]
GO



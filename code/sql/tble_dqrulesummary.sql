USE [DGT]
GO

/****** Object:  Table [dw].[FactDGTRuleSummary]    Script Date: 12/27/2021 11:13:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dw].[FactDGTRuleSummary](
	[ValidationID] [int] IDENTITY(1,1) NOT NULL,
	[SubjectAreaNM] [varchar](200) NULL,
	[MetricNM] [varchar](200) NULL,
	[MetricCNT] [int] NULL,
	[TotalLoadCNT] [int] NULL,
	[UserID] [varchar](100) NULL,
	[InsertDT] [datetime] NULL,
	[UpdateDT] [datetime] NULL,
	[Source] [varchar](1) NULL,
	[StationNbr] [varchar](6) NULL,
	[processid] [int] NULL,
	[visn] [int] NULL
) ON [PRIMARY]
GO



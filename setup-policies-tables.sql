/*
Description: T-SQL SCRIPT TO BUILD POLICIES TABLES
Author: d@wonder.tax
Date: 20241114
*/

USE msbuxley;
GO

ALTER TABLE [dbo].[policies] DROP CONSTRAINT [FK_policies_createdby]
GO

/****** Object:  Table [dbo].[policies]    Script Date: 11/20/2024 10:13:26 AM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[policies]') AND type in (N'U'))
DROP TABLE [dbo].[policies]
GO

/****** Object:  Table [dbo].[policies]    Script Date: 11/20/2024 10:13:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[policies](
	[id] [uniqueidentifier] NOT NULL,
	[name] [nvarchar](256) NOT NULL,
	[abbreviation] [nvarchar](64) NOT NULL,
	[created] [int] NOT NULL,
	[createdby] [uniqueidentifier] NOT NULL,
	[modified] [int] NULL,
	[modifiedby] [uniqueidentifier] NULL,
	[lastrun] [int] NULL,
	[retired] [int] NULL,
 CONSTRAINT [PK_policies] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [AK_abbreviation] UNIQUE NONCLUSTERED 
(
	[abbreviation] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[policies] ADD  DEFAULT (newsequentialid()) FOR [id]
GO

ALTER TABLE [dbo].[policies]  WITH CHECK ADD  CONSTRAINT [FK_policies_createdby] FOREIGN KEY([createdby])
REFERENCES [dbo].[user] ([id])
GO

ALTER TABLE [dbo].[policies] CHECK CONSTRAINT [FK_policies_createdby]
GO

/**

-- Inspect:

SELECT * from [dbo].[policies]

SELECT * FROM [dbo].[policy_details]

**/


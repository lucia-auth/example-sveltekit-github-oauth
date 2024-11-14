/*
Description: T-SQL SCRIPT TO BUILD POLICIES TABLES
Author: d@wonder.tax
Date: 20241114
*/

USE msbuxley;
GO

-- create our policies table

/*
DECLARE @today DATETIME = GETUTCDATE();
--get YYYYMMDD as INT
SELECT CAST(FORMAT(@today,'yyyyMMdd') as INT); 
*/

CREATE TABLE [dbo].[policies]
(
	id UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
	CONSTRAINT PK_policies PRIMARY KEY NONCLUSTERED (id),
	name NVARCHAR(256) NOT NULL,
	abbr NVARCHAR(64) NOT NULL,
	CONSTRAINT AK_abbreviation UNIQUE(abbr),
	created INT NOT NULL,
	createdby UNIQUEIDENTIFIER NOT NULL
	CONSTRAINT FK_policies_createdby FOREIGN KEY (createdby)
		REFERENCES [dbo].[user](id),
	modified INT NULL,
	modifiedby UNIQUEIDENTIFIER NULL,
	lastrun INT NULL,
	retired INT NULL
);

CREATE CLUSTERED INDEX abbr_index ON [dbo].[policies](abbr)

/*
-- create our policy_details table

CREATE TABLE [dbo].[policy_details] (
	id nvarchar(64) NOT NULL,
	CONSTRAINT PK_policy_details PRIMARY KEY CLUSTERED (id),
);
*/

/**

-- Inspect:

SELECT * from [dbo].[policies]

SELECT * FROM [dbo].[policy_details]

**/

/**

-- Tear down and restart:

DROP INDEX IF EXISTS github_id_index ON [dbo].[user];

--drop session first to remove foreign key contraint on user table

DROP TABLE IF EXISTS [dbo].[session];

DROP TABLE IF EXISTS [dbo].[user];


**/


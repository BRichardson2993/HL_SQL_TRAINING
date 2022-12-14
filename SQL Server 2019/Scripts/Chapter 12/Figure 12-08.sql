/*
   Thursday, February 261, 2020 1:13:05 PM
   User: 
   Server: localhost\SQLEXPRESS
   Database: New_AP
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Invoices
	DROP CONSTRAINT FK_Invoices_Vendors
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Invoices
	DROP CONSTRAINT DF_Invoices_InvoiceTotal
GO
CREATE TABLE dbo.Tmp_Invoices
	(
	InvoiceID int NOT NULL IDENTITY (1, 1),
	VendorID int NOT NULL,
	InvoiceDate date NOT NULL,
	InvoiceTotal money NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Invoices ADD CONSTRAINT
	DF_Invoices_InvoiceTotal DEFAULT ((0)) FOR InvoiceTotal
GO
SET IDENTITY_INSERT dbo.Tmp_Invoices ON
GO
IF EXISTS(SELECT * FROM dbo.Invoices)
	 EXEC('INSERT INTO dbo.Tmp_Invoices (InvoiceID, VendorID, InvoiceDate, InvoiceTotal)
		SELECT InvoiceID, VendorID, InvoiceDate, InvoiceTotal FROM dbo.Invoices WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Invoices OFF
GO
DROP TABLE dbo.Invoices
GO
EXECUTE sp_rename N'dbo.Tmp_Invoices', N'Invoices', 'OBJECT' 
GO
ALTER TABLE dbo.Invoices ADD CONSTRAINT
	PK_Invoices_1 PRIMARY KEY CLUSTERED 
	(
	InvoiceID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Invoices ADD CONSTRAINT
	CK_InvoiceTotal CHECK (([InvoiceTotal]>(0)))
GO
ALTER TABLE dbo.Invoices ADD CONSTRAINT
	FK_Invoices_Vendors FOREIGN KEY
	(
	VendorID
	) REFERENCES dbo.Vendors
	(
	VendorID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT

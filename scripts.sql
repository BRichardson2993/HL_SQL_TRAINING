-- HOW TO WORK WITH SCRIPTS

-- ALWAYS notate this file

/*
Creates 3 tables in a db named ClubRoster.
Author: Brian L. Richardson
Created: <Date>
Modified: <Date>
Last Modified By: 
*/

--CREATE DATABASE ClubRoster;
--GO							-- <-- we HAVE to add the 'GO' statement here to create the db before we can USE the db...
									-- the other batches below do not require it since the dependent table is added LAST

--USE ClubRoster;

--CREATE TABLE Members (MemberID int NOT NULL IDENTITY PRIMARY KEY,
--						LastName varchar(75) NOT NULL,
--						FirstName varchar(50) NOT NULL,
--						MiddleName varchar(50) NULL);

--CREATE TABLE Committees (CommitteeID int NOT NULL IDENTITY PRIMARY KEY,
--							CommitteeName varchar(50) NOT NULL);

--CREATE TABLE CommitteeAssignments (MemberID int NOT NULL REFERENCES Members(MemberID),
--									CommitteeID int NOT NULL REFERENCES Committees(CommitteeID));



------------------------------------------------------------------------------------------------
-- Transact-SQL statements for script processing

--USE AP;
--DECLARE @TotalDue money;
--SET @TotalDue = (SELECT SUM(InvoiceTotal - PaymentTotal - CreditTotal)
--				FROM Invoices);
--IF @TotalDue > 0
--	PRINT 'Total invoices due = $' + CONVERT(varchar, @TotalDue, 1);
--ELSE
--	PRINT 'Invoices paid in full';


------------------------------------------------------------------------------------------------
-- Variables and Temporary Tables

-- Scalar variables

--USE AP;
--DECLARE @MaxInvoice money, @MinInvoice money;
--DECLARE @PercentDifference decimal(8,2);
--DECLARE @InvoiceCount int, @VendorIDVar int;

--SET @VendorIDVar = 95;
--SET @MaxInvoice = (SELECT Max(InvoiceTotal) 
--					FROM Invoices
--					WHERE VendorID = @VendorIDVar);

--SELECT @MinInvoice = MIN(InvoiceTotal), @InvoiceCount = COUNT(*)
--FROM Invoices
--WHERE VendorID = @VendorIDVar;
--SET @PercentDifference = (@MaxInvoice - @MinInvoice) / @MinInvoice * 100;

--PRINT 'Maximum invoice is $' + CONVERT(varchar, @MaxInvoice, 1) + '.';
--PRINT 'Minimum invoice is $' + CONVERT(varchar, @MinInvoice, 1) + '.';
--PRINT 'Maximum is ' + CONVERT(varchar, @PercentDifference) + '% more than minimum.';
--PRINT 'Number of invoices: ' + CONVERT(varchar, @InvoiceCount) + '.';



------------------------------------------------------------------------------------------------
-- Table Variables
	-- a table variable can store the contents of an entire table

--USE AP;

--DECLARE @BigVendors table (VendorID int, VendorName varchar(50));
 
--INSERT @BigVendors
--SELECT VendorID, VendorName
--FROM Vendors
--WHERE VendorID IN
--(SELECT VendorID FROM Invoices WHERE InvoiceTotal > 5000);

--SELECT * FROM @BigVendors;



------------------------------------------------------------------------------------------------
-- Temporary Tables 
	-- only exist during the current session

-- A script that uses a local temporary table instead of a derived table

--SELECT TOP 1 VendorID, AVG(InvoiceTotal) as AvgInvoice
--INTO #TopVendors
--FROM Invoices
--GROUP BY VendorID
--ORDER BY AvgInvoice DESC;

--SELECT i.VendorID, MAX(InvoiceDate) AS LatestInv
--FROM Invoices i	
--	JOIN #TopVendors tv
--	ON i.VendorID = tv.VendorID
--GROUP BY i.VendorID;

---- A script that creates a global temporary table of random numbers

--CREATE TABLE ##RandomSSNs
--(
--	SSN_ID	int		IDENTITY,
--	SSN		char(9)	DEFAULT
--		LEFT(CAST(CAST(CEILING(RAND() * 10000000000) AS bigint) AS varchar), 9)
--);

--INSERT ##RandomSSNs VALUES (DEFAULT);
--INSERT ##RandomSSNs VALUES (DEFAULT);

--SELECT * FROM ##RandomSSNs;


------------------------------------------------------------------------------------------------
-- The 5 types of Transact-SQL table objects

-- Standard Table - until explicitly deleted
-- Temporary Table - while the current session is open
-- Table Variable - while the current batch is executing
-- Derived Table - while the current statement is executing
-- View - until explicitly deleted


------------------------------------------------------------------------------------------------
-- How to control the execution of a script

-- using IF

--USE AP;
--DECLARE @EarliestInvoiceDueDate date;

--SELECT @EarliestInvoiceDueDate = MIN(InvoiceDueDate)
--FROM INVOICES
--WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;

--IF @EarliestInvoiceDueDate < GETDATE()
--PRINT 'Outstanding invoices overdue!';


-- and enhanced version using IF...ELSE
--USE AP;
--DECLARE @MinInvoiceDue money, @MaxInvoiceDue money;
--DECLARE @EarliestInvoiceDue date, @LatestInvoiceDue date;

--SELECT @MinInvoiceDue = MIN(InvoiceTotal - PaymentTotal - CreditTotal),
--		@MaxInvoiceDue = MAX(InvoiceTotal - PaymentTotal - CreditTotal),
--		@EarliestInvoiceDue = MIN(InvoiceDueDate),
--		@LatestInvoiceDue = MAX(InvoiceDueDate)
--FROM Invoices
--WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;

--IF @EarliestInvoiceDue < GETDATE()
--	BEGIN
--		PRINT 'Outstanding invoices overdue!';
--		PRINT 'Dated ' + CONVERT(varchar, @EarliestInvoiceDue, 1) +
--				' through ' + CONVERT(varchar, @LatestInvoiceDue, 1) + '.';
--		PRINT 'Amounting from $' + CONVERT(varchar, @MinInvoiceDue, 1) +
--				' to $' + CONVERT(varchar, @MaxInvoiceDue, 1) + '.';
--	END;
--ELSE -- @EarliestInvoiceDue >= GETDATE()
--	PRINT 'No overdue invoices.';



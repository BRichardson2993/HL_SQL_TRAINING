-- AGGREGATE FUNCTIONS (aka 'Column Functions') 

-- summary query that counts unpaid invoices and calculates total due, basically summarizing one total for all outstanding invoices

--SELECT COUNT(*) as NumberOfInvoices, SUM(InvoiceTotal - PaymentTotal - CreditTotal) as TotalDue
--FROM Invoices
--WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0;


-- Using COUNT(*), AVG, and SUM functions
--Use AP;
--SELECT 'After 1/1/2012' as [Selection Date], 
--		COUNT(*) as [Number Of Invoices], 
--		AVG(InvoiceTotal) as [Average Invoice Amount], 
--		SUM(InvoiceTotal) as [Total Invoice Amount]
--FROM Invoices
--WHERE InvoiceDate > '2012-01-01';

-- Using MIN and MAX
--Use AP;
--SELECT 'After 1/1/2012' as "Selection Date", 
--		COUNT(*) as "Number Of Invoices", 
--		MAX(InvoiceTotal) as "Highest Invoice Total",
--		MIN(InvoiceTotal) as "Lowest Invoice Total"
--FROM Invoices
--WHERE InvoiceDate > '2012-01-01';

-- Using non-numeric columns
--SELECT Min(VendorName) as 'First Vendor', 
--		MAX(VendorName) as 'Last Vendor', 
--		COUNT(VendorName) as 'Number Of Vendors'
--FROM Vendors;

-- Using DISTINCT
--SELECT COUNT(DISTINCT VendorID) As NumberOfVendors, 
--		COUNT(VendorID) as NumberOfInvoices, 
--		AVG(InvoiceTotal) as [Average Invoice Amount], 
--		SUM(InvoiceTotal) as TotalInvoiceAmount
--FROM Invoices
--WHERE InvoiceDate > '2012-01-01';



-- Using GROUP BY and HAVING

--SELECT VendorID, AVG(InvoiceTotal) as AverageInvoiceAmount
--FROM Invoices
--GROUP BY VendorID
--HAVING AVG(InvoiceTotal) > 2000
--ORDER BY AverageInvoiceAmount DESC;

-- counting the number of invoices by vendor
--SELECT VendorID, COUNT(*) as InvoiceQty
--FROM Invoices
--GROUP BY VendorID;

-- calculating the number of invoices and average amount for the vendors in each state/city
--SELECT VendorState, 
--		VendorCity, 
--		COUNT(*) as InvoiceQty,
--		AVG(InvoiceTotal) as InvoiceAvg
--FROM Invoices
--	JOIN Vendors
--	ON Invoices.VendorID = Vendors.VendorID
--GROUP BY VendorState, VendorCity
--ORDER BY VendorState, VendorCity

-- limiting the groups to those with 2 or more invoices
--SELECT VendorState, 
--		VendorCity, 
--		COUNT(*) as InvoiceQty,
--		AVG(InvoiceTotal) as InvoiceAvg
--FROM Invoices
--	JOIN Vendors
--	ON Invoices.VendorID = Vendors.VendorID
--GROUP BY VendorState, VendorCity
--HAVING Count(*) > 2
--ORDER BY VendorState, VendorCity



-- COMPLEX Search Conditions

-- a compound condition in the HAVING clause
--USE AP;
--SELECT InvoiceDate, COUNT(*) as InvoiceQty, SUM(InvoiceTotal) as InvoiceSum
--FROM Invoices
--GROUP BY InvoiceDate
--HAVING InvoiceDate BETWEEN '2012-01-01' AND '2012-01-31'
--AND Count(*) > 1
--AND SUM(InvoiceTotal) > 100
--ORDER BY InvoiceDate DESC;

-- same as above but moving the NON-AGGREGATE function to the WHERE clause
--USE AP;
--SELECT InvoiceDate, COUNT(*) as InvoiceQty, SUM(InvoiceTotal) as InvoiceSum
--FROM Invoices
--WHERE InvoiceDate BETWEEN '2012-01-01' AND '2012-01-31'
--GROUP BY InvoiceDate
--HAVING Count(*) > 1
--AND SUM(InvoiceTotal) > 100
--ORDER BY InvoiceDate DESC;


-- ROLLUP clause

-- including a final summary row (based off a single column)
--SELECT VendorID, COUNT(*) as InvoiceCount, SUM(InvoiceTotal) AS InvoiceTotal
--FROM Invoices
----GROUP BY ROLLUP(VendorID) 
---- OR you can do this (But I like the above better, as this method is from before 2008) 
---- GROUP BY VendorID WITH ROLLUP

--SELECT VendorState, VendorCity, COUNT(*) as QtyVendors
--FROM Vendors
--WHERE VendorState IN ('IA', 'NJ')
--GROUP BY ROLLUP(VendorState, VendorCity)
---- or (OLDER WAY)
---- GROUP BY VendorState, VendorCity WITH ROLLUP
--ORDER BY VendorState DESC, VendorCity DESC;


-- CUBE clause

-- like ROLLUP but returns summary rows for every combo of groups

--SELECT VendorID, COUNT(*) as InvoiceCount, SUM(InvoiceTotal) as InvoiceTotal
--FROM Invoices
--GROUP BY CUBE(VendorID);
----or (old way)
----GROUP BY VendorID WITH CUBE;

-- includes a summary row for each set of groups
--SELECT VendorState, VendorCity, COUNT(*) as QtyVendors
--FROM Vendors
--WHERE VendorState IN ('IA', 'NJ')
--GROUP BY CUBE(VendorState, VendorCity)
--ORDER BY VendorState DESC, VendorCity DESC;

-- GROUPING SETS operator (Only shows summary rows)
--SELECT VendorState, VendorCity, COUNT(*) as QtyVendors
--FROM Vendors
--WHERE VendorState IN ('IA', 'NJ')
--GROUP BY GROUPING SETS(VendorState, VendorCity)
--ORDER BY VendorState DESC, VendorCity DESC;

-- a composite grouping
--SELECT VendorState, VendorCity, VendorZipCode, COUNT(*) as QtyVendors
--FROM Vendors
--WHERE VendorState IN ('IA', 'NJ')
--GROUP BY GROUPING SETS((VendorState, VendorCity), VendorZipCode, ())
--ORDER BY VendorState DESC, VendorCity DESC;

-- summary query using the ROLLUP operator
--SELECT VendorState, VendorCity, VendorZipCode, COUNT(*) as QtyVendors
--FROM Vendors
--WHERE VendorState IN ('IA', 'NJ')
--GROUP BY GROUPING SETS(ROLLUP(VendorState, VendorCity), VendorZipCode)
--ORDER BY VendorState DESC, VendorCity DESC;


-- OVER 

-- groups summary data by date
Use AP;
--SELECT InvoiceNumber, InvoiceDate, InvoiceTotal,
--    SUM(InvoiceTotal) OVER (PARTITION BY InvoiceDate) AS DateTotal,
--    COUNT(InvoiceTotal) OVER (PARTITION BY InvoiceDate) AS Count,
--    AVG(InvoiceTotal) OVER (PARTITION BY InvoiceDate) AS DateAvg
--FROM Invoices;

-- calculates a 'cumulative total' and 'moving average'
--SELECT InvoiceNumber, InvoiceDate, InvoiceTotal,
--    SUM(InvoiceTotal) OVER (ORDER BY InvoiceDate) AS CumulativeTotal,
--    COUNT(InvoiceTotal) OVER (ORDER BY InvoiceDate) AS Count,
--    AVG(InvoiceTotal) OVER (ORDER BY InvoiceDate) AS MovingAvg
--FROM Invoices;

-- same as above but grouped by TermsID
SELECT InvoiceNumber, InvoiceDate, InvoiceTotal,
    SUM(InvoiceTotal) OVER (PARTITION BY TermsID ORDER BY InvoiceDate) AS CumulativeTotal,
    COUNT(InvoiceTotal) OVER (PARTITION BY TermsID ORDER BY InvoiceDate) AS Count,
    AVG(InvoiceTotal) OVER (PARTITION BY TermsID ORDER BY InvoiceDate) AS MovingAvg
FROM Invoices;

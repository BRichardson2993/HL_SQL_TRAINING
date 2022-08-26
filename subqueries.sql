USE AP;
set statistics io, time on

-- INTRO EXAMPLE:
--SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
--FROM Invoices
--WHERE InvoiceTotal >
--	(SELECT AVG(InvoiceTotal)
--		FROM Invoices)
--ORDER BY InvoiceTotal DESC;

------------------------------------------------------------------------------------------------
-- SUBQUERIES COMPARED to JOINS

--SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, VendorName
--FROM Invoices i
--	JOIN Vendors v
--	ON i.VendorID = v.VendorID
--WHERE VendorState = 'CA'
--ORDER BY InvoiceDate;

---- the above is the same as the below restated as a subquery

--SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, VendorName -- <-- VendorName here errors out bc it isn't in the original query from Invoices
--FROM Invoices
--WHERE VendorID IN
--	(SELECT VendorID
--	FROM Vendors
--	WHERE VendorState = 'CA')
--ORDER BY InvoiceDate;

------------------------------------------------------------------------------------------------
-- SUBQUERIES IN SEARCH CONDITIONS

--SELECT DISTINCT VendorID -- <-- this will become our subquery below
--		FROM Invoices; 

--SELECT VendorID, VendorName, VendorState
--FROM Vendors
--WHERE VendorID NOT IN
--	(SELECT DISTINCT VendorID
--		FROM Invoices);

---- is the same as (restated without the subquery):

--SELECT v.VendorID, VendorName, VendorState
--FROM Vendors v
--	LEFT JOIN Invoices i
--	on v.VendorID = i.VendorID
--WHERE i.VendorID IS NULL;

------------------------------------------------------------------------------------------------
-- COMPARING RESULTS OF SUBQUERY WITH AN EXPRESSION

--SELECT InvoiceNumber, InvoiceDate, InvoiceTotal,
--		InvoiceTotal - PaymentTotal - CreditTotal as BalanceDue
--FROM Invoices
--WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
--AND InvoiceTotal - PaymentTotal - CreditTotal <
--	(SELECT AVG(InvoiceTotal - PaymentTotal - CreditTotal)
--	FROM Invoices
--	WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0)
--ORDER BY InvoiceTotal DESC;

------------------------------------------------------------------------------------------------
-- USING THE 'ALL' KEYWORD

-- our subquery:
--SELECT InvoiceTotal
--	FROM Invoices
--	WHERE VendorID = 34; -- <-- returns only 2 rows


--SELECT v.VendorID, VendorName, InvoiceNumber, InvoiceTotal
--FROM Invoices i
--	JOIN Vendors v
--	ON i.VendorID = v.VendorID
--WHERE InvoiceTotal > ALL
--	(SELECT InvoiceTotal
--	FROM Invoices			-- <-- so in this case a range is put together 
--	WHERE VendorID = 34)		--	from all of the invoice totals from invoices that 
--ORDER BY VendorName;			--	match vendor #34, so all vendor totals greater than that


------------------------------------------------------------------------------------------------
-- USING 'ANY' and 'SOME'

-- our subquery:
--SELECT InvoiceTotal
--FROM Invoices
--WHERE VendorID = 115;

--SELECT VendorName, InvoiceNumber, InvoiceTotal
--FROM Vendors v
--	JOIN Invoices i
--	on v.VendorID = i.VendorID -- <-- this query returns all values that are less than ANY of the values 
--WHERE InvoiceTotal < ANY			-- in the subquery's returned set
--	(SELECT InvoiceTotal
--	FROM Invoices
--	WHERE VendorID = 115);


------------------------------------------------------------------------------------------------
-- CORRELATED SUBQUERIES

-- the subquery:
--SELECT AVG(InvoiceTotal)
--FROM Invoices as Inv_Sub
--WHERE Inv_Sub.VendorID = 95;

--SELECT VendorID, InvoiceNumber, InvoiceTotal
--FROM Invoices as Inv_Main
--WHERE InvoiceTotal >
--	(SELECT AVG(InvoiceTotal)  -- <-- in this case, the subquery is executed once for EACH row
--	FROM Invoices as Inv_Sub		-- processed by the outer query
--	WHERE Inv_Sub.VendorID = Inv_Main.VendorID)
--ORDER BY VendorID ASC, InvoiceTotal DESC;

-- self challenge! Could this be written as a JOIN instead?

--SELECT DISTINCT Inv_Main.VendorID, Inv_Main.InvoiceNumber, Inv_Main.InvoiceTotal
--FROM Invoices Inv_Main
--	JOIN Invoices Inv_Sub
--	on Inv_Main.VendorID = Inv_Sub.VendorID
--WHERE Inv_Main.InvoiceTotal > 
--(SELECT AVG(InvoiceTotal)  
--	FROM Invoices as Inv_Sub		
--	WHERE Inv_Sub.VendorID = Inv_Main.VendorID)
--ORDER BY VendorID ASC, InvoiceTotal DESC;

-- answer: yes, but with duplicates because it's pulling values from each table...until I added "DISTINCT"
-- NOW they are the same


------------------------------------------------------------------------------------------------
-- EXISTS operator

--SELECT VendorID, VendorName, VendorState
--FROM Vendors
--WHERE NOT EXISTS
--	(SELECT *
--	FROM Invoices
--	WHERE Invoices.VendorID = Vendors.VendorID);


------------------------------------------------------------------------------------------------
-- OTHER WAYS TO USE SUBQUERIES

-- In the FROM clause

-- our subquery:
--SELECT TOP 5 VendorID, AVG(InvoiceTotal) as AvgInvoice
--FROM Invoices
--GROUP BY VendorID 
--ORDER BY AvgInvoice DESC

--SELECT Invoices.VendorID, MAX(InvoiceDate) as LatestInv, AVG(InvoiceTotal) as AvgInvoice
--FROM Invoices JOIN
--	(SELECT TOP 5 VendorID, AVG(InvoiceTotal) as AvgInvoice
--	FROM Invoices
--	GROUP BY VendorID 
--	ORDER BY AvgInvoice DESC) AS TopVendor
--	ON Invoices.VendorID = TopVendor.VendorID
--GROUP BY Invoices.VendorID
--ORDER BY LatestInv DESC;

-- In the SELECT clause

-- our subquery:
--SELECT MAX(InvoiceDate)
--FROM Invoices
--WHERE Invoices.VendorID = 123;

--SELECT VendorName, 
--				(SELECT MAX(InvoiceDate)
--				FROM Invoices
--				WHERE Invoices.VendorID = 123) AS LatestInv
--FROM Vendors
--ORDER BY LatestInv DESC;

---- and the above as a JOIN
--SELECT DISTINCT VendorName, MAX(InvoiceDate) as LatestInv
--FROM Vendors v
--	LEFT JOIN Invoices i
--	on v.VendorID = i.VendorID
--GROUP BY VendorName
--ORDER BY LatestInv DESC;



------------------------------------------------------------------------------------------------
-- GO TO complex_query_procedure.sql
-- This file will break down how to create a complex query

-- 1. State the problem to be solved by the query
	-- "Which vendor in each state has the largest invoice total?"

-- 2. Use pseudocode to outline the query
	-- This should:
	-- 1. identify the subqueries used by the query and the data they return
	-- 2. includ aliases used for any derived tables

-- 3. If needed, pseudocode to outline each subquery

-- 4. Code all subqueries and test them 

-- 5. Construct the final query

--------------------------------------------------------------------------------------------------

-- Begin

-- "Which vendor in each state has the largest invoice total?"


USE AP;	

-- pseudocode for outer query
SELECT Summary1.VendorState, Summary1.VendorName, TopInState.SumOfInvoices
FROM (Derived table returning VendorState, VendorName, SumOfInvoices) AS Summary1
	JOIN (Derived table returning VendorState, MAX(SumOfInvoices)) as TopInState
	ON Summary1.VendorState = TopInState.VendorState
	AND Summary1.SumOfInvoices = TopInState.SumOfInvoices
ORDER BY Summary1.VendorState;

-- so now we know we need: Summary1 and TopInState

-- let's work on Summary1
--SELECT V_Sub.VendorState, V_Sub.VendorName, SUM(I_Sub.InvoiceTotal) as SumOfInvoices
--FROM Invoices as I_Sub
--	JOIN Vendors as V_Sub
--	ON I_Sub.VendorID = V_Sub.VendorID
--GROUP BY V_Sub.VendorState, V_Sub.VendorName;

-- Summary 1 works, so let's now work on TopInState, which will actually need a second summary for comparison
--SELECT Summary2.VendorState, MAX(Summary2.SumOfInvoices)
--FROM (
--		-- Derived table returning vendorState, VendorName, SumOfInvoices
--		SELECT V_Sub.VendorState, V_Sub.VendorName, SUM(I_Sub.InvoiceTotal) as SumOfInvoices
--	    FROM Invoices as I_Sub
--	        JOIN Vendors as V_Sub
--	        ON I_Sub.VendorID = V_Sub.VendorID
--	    GROUP BY V_Sub.VendorState, V_Sub.VendorName) as Summary2
--GROUP BY Summary2.VendorState;


-- now that we have a working subquery (Summary1), let's start filling in the gaps:


-- going back to the original pseudocode for the outer query:

SELECT Summary1.VendorState, Summary1.VendorName, TopInState.SumOfInvoices
FROM (SELECT V_Sub.VendorState, V_Sub.VendorName, SUM(I_Sub.InvoiceTotal) as SumOfInvoices
		FROM Invoices as I_Sub
			JOIN Vendors as V_Sub
			ON I_Sub.VendorID = V_Sub.VendorID
		GROUP BY V_Sub.VendorState, V_Sub.VendorName) AS Summary1

	JOIN (SELECT Summary2.VendorState, MAX(Summary2.SumOfInvoices) as SumOfInvoices
			FROM (-- Derived table returning vendorState, VendorName, SumOfInvoices
				  SELECT V_Sub.VendorState, V_Sub.VendorName, SUM(I_Sub.InvoiceTotal) as SumOfInvoices
				  FROM Invoices as I_Sub
					  JOIN Vendors as V_Sub
					  ON I_Sub.VendorID = V_Sub.VendorID
				  GROUP BY V_Sub.VendorState, V_Sub.VendorName) as Summary2
			GROUP BY Summary2.VendorState) as TopInState
	ON Summary1.VendorState = TopInState.VendorState
	AND Summary1.SumOfInvoices = TopInState.SumOfInvoices
ORDER BY Summary1.VendorState;

-- WOO HOOO!!!!! IT WORKS!
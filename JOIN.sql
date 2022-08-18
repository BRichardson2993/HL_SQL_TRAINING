-- An Inner Join (notice 'INNER' is optional)
--SELECT InvoiceNumber, VendorName
--FROM Vendors v JOIN InvoicesCopy i
--ON v.VendorID = i.VendorID;

-- USING CORRELATION NAMES

-- Inner Join with Correlation Names that's a little hard to read - DON'T DO THIS
--SELECT InvoiceNumber, VendorName, InvoiceDueDate, 
--		InvoiceTotal - PaymentTotal - CreditTotal as BalanceDue
--FROM Vendors AS v JOIN Invoices as i
--	ON v.VendorID = i.VendorID
--WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
--ORDER BY InvoiceDueDate DESC;

-- Inner Join with a correlation name that simplifies the query
--SELECT InvoiceNumber, InvoiceLineItemAmount, InvoiceLineItemDescription
--FROM Invoices JOIN InvoiceLineItems as LineItems -- <-- LineItems is the correlation name
--	ON Invoices.InvoiceID = LineItems.InvoiceID
--WHERE AccountNo =540
--ORDER BY InvoiceDate;


-- JOIN TABLES FROM DIFFERENT DATABASE(S)
--SELECT VendorName, CustLastName, CustFirstName, VendorState AS State, VendorCity as City
--FROM DBSServer.AP.dbo.Vendors as Vendors
--	JOIN DBServer.ProductOrders.dbo.Customers as Customers
--	ON Vendors.VendorZipCode = Customers.CustZip
--ORDER BY State, City;

-- The same join with partially-qualified table names
--SELECT VendorName, CustLastName, CustFirstName, VendorState as State, VendorCity as City
--FROM Vendors
--	JOIN ProductOrders..Customers as Customers
--	ON Vendors.VendorZipCode = Customers.CustZip
--ORDER BY State, City;


--USE master;
--EXEC sp_addlinkedserver
--	@server='DBServer',
--	@srvproduct = '',
--	@provider = 'SQLNCLI',
--	@datasrc = 'localhost\SqlExpress';


-- COMPOUND JOINS

-- Inner Join with 2 conditions
--SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, InvoiceLineItemAmount
--FROM Invoices JOIN InvoiceLineItems as LineItems
--ON (Invoices.InvoiceID = LineItems.InvoiceID) -- I believe the parens are optional here
--	AND (Invoices.InvoiceTotal > LineItems.InvoiceLineItemAmount) -- <-- notice the 'and' clause here...
--ORDER BY InvoiceNumber;

-- Same Join as above with the second condition coded in a WHERE clause
--SELECT InvoiceNumber, InvoiceDate, InvoiceTotal, InvoiceLineItemAmount
--FROM Invoices JOIN InvoiceLineItems as LineItems
--	ON Invoices.InvoiceID = LineItems.InvoiceID
--WHERE Invoices.InvoiceTotal > LineItems.InvoiceLineItemAmount -- <-- 'and' clause from above becomes a 'where' clause instead
--ORDER BY InvoiceNumber;


-- SELF JOIN

--SELECT DISTINCT Vendors1.VendorName, Vendors1.VendorCity, Vendors1.VendorState
--FROM Vendors as Vendors1 JOIN Vendors as Vendors2
--ON Vendors1.VendorCity = Vendors2.VendorCity
--	AND Vendors1.VendorState = Vendors2.VendorState
--	AND Vendors1.VendorID = Vendors2.VendorID
--ORDER BY Vendors1.VendorState, Vendors1.VendorCity;


-- JOINING MULTIPLE TABLES

--SELECT VendorName, InvoiceNumber, InvoiceDate, InvoiceLineItemAmount as LineItemAmount, AccountDescription
--FROM Vendors v
--	JOIN Invoices i ON v.VendorID = i.VendorID
--	JOIN InvoiceLineItems l ON i.InvoiceID = l.InvoiceID
--	JOIN GLAccounts g ON l.AccountNo = g.AccountNo
--WHERE InvoiceTotal - PaymentTotal - CreditTotal > 0
--ORDER BY VendorName, LineItemAmount DESC;


-- *** THE BOOK COVERED IMPLICIT SYNTAX FOR JOINS, BUT I'M SKIPPING AS WE SHOULD ALWAYS BE EXPLICIT!!! ***


-- OUTER JOIN

-- a left outer join - remember 'OUTER' keyword is optional (LEFT JOIN is the same as LEFT OUTER JOIN)
--SELECT VendorName, InvoiceNumber, InvoiceTotal
--FROM Vendors LEFT JOIN Invoices
--	ON Vendors.VendorID = Invoices.VendorID
--ORDER BY VendorName;

-- another left outer join
--SELECT DeptName, d.DeptNo, LastName
--FROM Departments d LEFT JOIN Employees e -- <-- This join returns all departments and their employees, even if an employee field is 'null'
--ON d.DeptNo = e.DeptNo;

-- a right outer join
--SELECT DeptName, e.DeptNo, LastName
--FROM Departments d RIGHT JOIN Employees e -- <-- This join returns all Employees and their departments, even if a department field is 'null'
--ON d.DeptNo = e.DeptNo;

-- a full outer join
--SELECT DeptName, d.DeptNo, e.DeptNo, LastName
--FROM Departments d FULL JOIN Employees e -- <-- This join retuns all of the departments and employees and shows 'null' where matchups don't occur
--on d.DeptNo = e.DeptNo; 


-- OUTER JOINS THAT JOIN MORE THAN 2 TABLES

-- joining 3 tables using left outer joins
--SELECT DeptName, LastName, ProjectNo
--FROM Departments d
--	LEFT JOIN Employees e
--		ON d.DeptNo = e.DeptNo
--	LEFT JOIN Projects p
--		ON e.EmployeeID = p.EmployeeID
--ORDER BY DeptName, LastName, ProjectNo;


-- joining 3 tables using full outer joins
--SELECT DeptName, LastName, ProjectNo
--FROM Departments d
--	FULL JOIN Employees e
--		ON d.DeptNo = e.DeptNo
--	FULL JOIN Projects p
--		ON e.EmployeeID = p.EmployeeID
--ORDER BY DeptName;


-- COMBINING INNER AND OUTER JOINS

--SELECT DeptName, LastName, ProjectNo
--FROM Departments d
--	JOIN Employees e 
--		ON d.DeptNo = e.DeptNo
--	LEFT JOIN Projects p
--		ON e.EmployeeID = p.EmployeeID
--ORDER BY DeptName;


-- CROSS JOIN

--SELECT d.DeptNo, DeptName, EmployeeID, LastName
--FROM Departments d
--	CROSS JOIN Employees e
--ORDER BY d.DeptNo;

--Just for comparison to below union 
--SELECT * FROM ActiveInvoices;
--SELECT * FROM PaidInvoices;

-- UNIONS

--Use Examples; <-- Use this statement to actually use the Examples database
--SELECT 'Active' as Source, InvoiceNumber, InvoiceDate, InvoiceTotal
--FROM ActiveInvoices
--WHERE InvoiceDate >= '01/01/2020'
--UNION
--SELECT 'Paid' as Source, InvoiceNumber, InvoiceDate, InvoiceTotal
--FROM PaidInvoices
--WHERE InvoiceDate >= '01/01/2020'
--ORDER BY InvoiceTotal DESC;

-- a union combining data from the same table

--use AP;
--SELECT InvoiceNumber, VendorName, '33% Payment' AS PaymentType, InvoiceTotal as Total, (InvoiceTotal * 0.333) as Payment
--FROM Invoices i 
--	JOIN Vendors v
--	ON i.VendorID = v.VendorID
--WHERE InvoiceTotal > 10000
--UNION
--SELECT InvoiceNumber, VendorName, '50% Payment' AS PaymentType, InvoiceTotal as Total, (InvoiceTotal * 0.5) as Payment
--FROM Invoices i 
--	JOIN Vendors v
--	ON i.VendorID = v.VendorID
--WHERE InvoiceTotal BETWEEN 500 AND 10000
--UNION
--SELECT InvoiceNumber, VendorName, 'Full Amount' AS PaymentType, InvoiceTotal as Total, InvoiceTotal as Payment
--FROM Invoices i 
--	JOIN Vendors v
--	ON i.VendorID = v.VendorID
--WHERE InvoiceTotal < 500
--ORDER BY PaymentType, VendorName, InvoiceNumber;


-- EXCEPT and INTERSECT

-- using EXCEPT to show all those listed in Customers UNLESS they appear also in Employees
--Use Examples;
--SELECT CustomerFirst, CustomerLast
--FROM Customers
--EXCEPT
--SELECT FirstName, LastName
--FROM EMPLOYEES
--ORDER BY CustomerLast;

-- using INTERSECT to show all listed in BOTH Employees and Customers
--Use Examples;
--SELECT CustomerFirst, CustomerLast
--FROM Customers
--INTERSECT
--SELECT FirstName, LastName
--FROM EMPLOYEES 
--ORDER BY CustomerLast;



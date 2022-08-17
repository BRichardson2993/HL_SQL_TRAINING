--SELECT *
--FROM Vendors;

--SELECT *
--FROM Invoices;

-- EXPANDED SYNTAX ---------------------------------------------------

--SELECT VendorName, VendorCity, VendorState
--FROM Vendors;

--SELECT InvoiceNumber, InvoiceTotal - PaymentTotal - CreditTotal As BalanceDue
--FROM InvoicesCopy;

--SELECT VendorContactFName + ' ' + VendorContactLName As FullName
--FROM Vendors;

--SELECT InvoiceNumber, InvoiceDate, 
--		GETDATE() As CurrentDate
--FROM InvoicesCopy;

-- NAMING COLUMNS IN THE RESULT SET ---------------------------------------------------

--SELECT InvoiceNumber as [Invoice Number], InvoiceDate as Date, InvoiceTotal as Total
--FROM InvoicesCopy;

--SELECT [Invoice Number] = InvoiceNumber, Date = InvoiceDate, Total = InvoiceTotal
--FROM InvoicesCopy;

-- USING CONCATENATION ---------------------------------------------------

SELECT VendorName, 
	   VendorCity,
	   VendorState,
	   VendorCity + VendorState
FROM Vendors;

SELECT VendorName,
	   VendorCity + ', ' + VendorState + ' ' + VendorZipCode as Address
FROM Vendors;

-- Include Apostrophes

SELECT VendorName + '''s Address: ',
	   VendorCity + ', ' + VendorState + ' ' + VendorZipCode as Address
FROM Vendors;

-- LEFT function

SELECT VendorContactFName, 
		VendorContactLName,
		LEFT(VendorContactFName, 1) + LEFT(VendorContactLName, 1) as Initials
FROM Vendors;

SELECT 'Invoice: #' + InvoiceNumber
	+	', dated ' + CONVERT(char(8), PaymentDate, 1)
	+	', for $' + CONVERT(varchar(9), PaymentTotal, 1)
FROM InvoicesCopy;

SELECT InvoiceDate,
		GETDATE() as 'Today''s Date',
		DATEDIFF(day, InvoiceDate, GETDATE()) as AGE
FROM Invoices;
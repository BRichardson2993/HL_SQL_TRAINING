SELECT *
FROM InvoicesCopy;

SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
FROM InvoicesCopy
ORDER BY InvoiceTotal;

SELECT InvoiceID, InvoiceTotal, CreditTotal + PaymentTotal as TotalCredits
FROM InvoicesCopy
WHERE InvoiceID = 17;

SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
FROM InvoicesCopy
WHERE InvoiceDate BETWEEN '2012-01-01' AND '2012-03-31'
ORDER BY InvoiceDate;

SELECT InvoiceNumber, InvoiceDate, InvoiceTotal
FROM InvoicesCopy
WHERE InvoiceTotal > 50000;


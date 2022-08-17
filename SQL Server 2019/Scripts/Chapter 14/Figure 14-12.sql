USE AP;
IF OBJECT_ID('tempdb..#InvoiceCopy') IS NOT NULL
    DROP TABLE #InvoiceCopy;

SELECT * INTO #InvoiceCopy FROM Invoices 
WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0;

    UPDATE #InvoiceCopy
    SET CreditTotal = CreditTotal + .05
    WHERE InvoiceTotal - CreditTotal - PaymentTotal > 0;

    IF (SELECT MAX(CreditTotal) FROM #InvoiceCopy) > 3000
        BREAK;
    ELSE --(SELECT MAX(CreditTotal) FROM #InvoiceCopy) <= 3000
        CONTINUE;
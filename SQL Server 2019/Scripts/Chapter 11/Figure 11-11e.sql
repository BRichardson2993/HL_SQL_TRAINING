USE New_AP;

ALTER TABLE InvoiceLineItems WITH CHECK
ADD FOREIGN KEY (AccountNo) REFERENCES GLAccounts(AccountNo);

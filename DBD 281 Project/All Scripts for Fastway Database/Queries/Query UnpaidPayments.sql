SELECT
    p.PaymentID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    p.Amount,
    p.PaymentStatus
FROM Payment p
JOIN Customer c ON p.CustomerID = c.CustomerID
WHERE p.PaymentStatus IN ('Pending', 'Failed');
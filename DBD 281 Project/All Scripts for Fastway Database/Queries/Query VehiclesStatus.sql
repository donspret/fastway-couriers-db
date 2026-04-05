SELECT
    Status,
    COUNT(*) AS TotalVehicles
FROM Vehicle
GROUP BY Status;

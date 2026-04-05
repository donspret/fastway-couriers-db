CREATE VIEW vw_CustomerPaymentSummary AS
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    COUNT(p.PaymentID) AS PaymentCount,
    SUM(p.Amount) AS TotalPaid,
    MAX(p.PaymentDate) AS LastPaymentDate
FROM Customer c
LEFT JOIN Payment p ON c.CustomerID = p.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;

GO

CREATE VIEW vw_SpecialHandlingPackages AS
SELECT
    PackageID,
    CustomerID,
    PackageType,
    Weight,
    Fragile,
    Hazardous,
    SpecialInstructions
FROM Package
WHERE Fragile = 1 OR Hazardous = 1;

GO


CREATE VIEW vw_ActiveShipments AS
SELECT
    s.ShipmentID,
    s.CustomerID, 
    c.FirstName + ' ' + c.LastName AS CustomerName,
    s.RecipientName,
    s.RecipientsCity,
    s.ShipmentDate,
    s.EstimatedDeliveryDate,
    p.PackageID,
    p.PackageType,
    p.Weight,
    st.Name AS ServiceType,
    v.Status AS VehicleStatus
FROM Shipment s
JOIN Customer c ON s.CustomerID = c.CustomerID
JOIN ShipmentPackage sp ON s.ShipmentID = sp.ShipmentID
JOIN Package p ON sp.PackageID = p.PackageID
JOIN ServiceType st ON s.ServiceTypeID = st.ServiceTypeID
JOIN Vehicle v ON s.VehicleID = v.VehicleID;

GO

CREATE VIEW vw_EmployeeAssignments AS
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Position,
    r.RoleName,
    w.Name AS WarehouseName,
    w.City
FROM Employee e
JOIN Roles r ON e.RoleID = r.RolesID
JOIN Warehouse w ON e.WarehouseID = w.WarehouseID;

GO

CREATE VIEW vw_RouteEfficiency AS
SELECT
    r.RouteID,
    w.Name AS WarehouseName,
    r.Distance,
    r.EstimatedTravelTime,
    COUNT(sr.ShipmentID) AS ShipmentsAssigned
FROM Route r
JOIN Warehouse w ON r.WarehouseID = w.WarehouseID
LEFT JOIN ShipmentRoute sr ON r.RouteID = sr.RouteID
GROUP BY r.RouteID, w.Name, r.Distance, r.EstimatedTravelTime;
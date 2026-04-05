-- Ensure correct database context
USE FastwayCouriers;
GO

-- Stored Procedure 1: Get all active shipments for a customer
DROP PROCEDURE IF EXISTS usp_GetActiveShipmentsByCustomer;
GO
CREATE PROCEDURE usp_GetActiveShipmentsByCustomer
    @CustomerID INT
AS
BEGIN
    SELECT *
    FROM vw_ActiveShipments
    WHERE CustomerID = @CustomerID AND EstimatedDeliveryDate >= GETDATE();
END;
GO

-- Stored Procedure 2: Insert a new customer with basic validation
DROP PROCEDURE IF EXISTS usp_AddCustomer;
GO
CREATE PROCEDURE usp_AddCustomer
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Phone VARCHAR(10),
    @Address VARCHAR(50),
    @City VARCHAR(50),
    @PostalCode VARCHAR(4)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Customer WHERE Email = @Email)
    BEGIN
        RAISERROR('Email already exists.', 16, 1);
        RETURN;
    END
    INSERT INTO Customer (FirstName, LastName, Email, Phone, Address, City, PostalCode)
    VALUES (@FirstName, @LastName, @Email, @Phone, @Address, @City, @PostalCode);
END;
GO

-- Stored Procedure 3: Update vehicle status
DROP PROCEDURE IF EXISTS usp_UpdateVehicleStatus;
GO
CREATE PROCEDURE usp_UpdateVehicleStatus
    @VehicleID INT,
    @NewStatus VARCHAR(50)
AS
BEGIN
    UPDATE Vehicle
    SET Status = @NewStatus
    WHERE VehicleID = @VehicleID;
END;
GO

-- Stored Procedure 4: Record a new shipment event
DROP PROCEDURE IF EXISTS usp_AddShipmentEvent;
GO
CREATE PROCEDURE usp_AddShipmentEvent
    @EventType VARCHAR(50),
    @Location VARCHAR(100),
    @Notes VARCHAR(255),
    @Status VARCHAR(20),
    @ShipmentPackageID INT,
    @EmployeeID INT
AS
BEGIN
    INSERT INTO EventTracker (EventType, EventTimeStamp, Location, Notes, Status, ShipmentPackageID, EmployeeID)
    VALUES (@EventType, GETDATE(), @Location, @Notes, @Status, @ShipmentPackageID, @EmployeeID);
END;
GO

-- Stored Procedure 5: Get all failed or pending payments
DROP PROCEDURE IF EXISTS usp_GetUnpaidPayments;
GO
CREATE PROCEDURE usp_GetUnpaidPayments
AS
BEGIN
    SELECT * FROM Payment
    WHERE PaymentStatus IN ('Pending', 'Failed');
END;
GO

-- Stored Procedure 6: Assign package to shipment
DROP PROCEDURE IF EXISTS usp_AssignPackageToShipment;
GO
CREATE PROCEDURE usp_AssignPackageToShipment
    @ShipmentID INT,
    @PackageID INT
AS
BEGIN
    INSERT INTO ShipmentPackage (ShipmentID, PackageID)
    VALUES (@ShipmentID, @PackageID);
END;
GO

-- Stored Procedure 7: Get customer payment history
DROP PROCEDURE IF EXISTS usp_GetCustomerPaymentHistory;
GO
CREATE PROCEDURE usp_GetCustomerPaymentHistory
    @CustomerID INT
AS
BEGIN
    SELECT *
    FROM Payment
    WHERE CustomerID = @CustomerID
    ORDER BY PaymentDate DESC;
END;
GO

-- Stored Procedure 8: Get route efficiency report
DROP PROCEDURE IF EXISTS usp_GetRouteEfficiency;
GO
CREATE PROCEDURE usp_GetRouteEfficiency
AS
BEGIN
    SELECT * FROM vw_RouteEfficiency
    ORDER BY ShipmentsAssigned DESC;
END;
GO

-- Trigger 1: Audit package insert
DROP TRIGGER IF EXISTS trg_AuditPackageInsert;
GO
CREATE TRIGGER trg_AuditPackageInsert
ON Package
AFTER INSERT
AS
BEGIN
    PRINT 'New package has been added to the system.';
END;
GO

-- Trigger 2: Enforce salary > 0 on update (adjusted to exclude RoleID reference)
DROP TRIGGER IF EXISTS trg_ValidateSalary;
GO
CREATE TRIGGER trg_ValidateSalary
ON Employee
INSTEAD OF UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE Salary <= 0)
    BEGIN
        RAISERROR('Salary must be greater than zero.', 16, 1);
        ROLLBACK;
    END
    ELSE
    BEGIN
        UPDATE e
        SET e.FirstName = i.FirstName,
            e.LastName = i.LastName,
            e.Email = i.Email,
            e.Phone = i.Phone,
            e.Address = i.Address,
            e.Position = i.Position,
            e.HireDate = i.HireDate,
            e.Salary = i.Salary,
            e.WarehouseID = i.WarehouseID
        FROM Employee e
        JOIN inserted i ON e.EmployeeID = i.EmployeeID;
    END
END;
GO

-- Create SQL Login and User (only if they don't exist)
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'FastwayUser')
    CREATE LOGIN FastwayUser WITH PASSWORD = 'StrongP@ssword123';
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'FastwayUser')
BEGIN
    CREATE USER FastwayUser FOR LOGIN FastwayUser;
    EXEC sp_addrolemember 'db_datareader', 'FastwayUser';
    EXEC sp_addrolemember 'db_datawriter', 'FastwayUser';
END;
GO

-- Optional: Restrict user from seeing sensitive views directly
DENY SELECT ON vw_CustomerPaymentSummary TO FastwayUser;
GO

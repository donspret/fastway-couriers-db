Use FastwayCouriers	
-- Sample data for Customer
INSERT INTO Customer (FirstName, LastName, Email, Phone, Address, City, PostalCode)
VALUES
('John', 'Doe', 'john.doe@example.com', '0123456789', '123 Main St', 'Cape Town', '8000'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321', '456 Oak Ave', 'Johannesburg', '2000');

-- Sample data for Roles
INSERT INTO Roles (RoleName, RoleDescription)
VALUES
('Driver', 'Responsible for deliveries and pickups'),
('Manager', 'Oversees depot operations');

-- Sample data for Warehouse
INSERT INTO Warehouse (Name, Address, City, PostalCode, Capacity)
VALUES
('Cape Town Warehouse', '789 Industrial Rd', 'Cape Town', '8000', 5000),
('Johannesburg Warehouse', '321 Commercial St', 'Johannesburg', '2000', 7000);

-- Sample data for Employee
INSERT INTO Employee (FirstName, LastName, Email, Phone, Address, Position, Salary, RoleID, WarehouseID)
VALUES
('Alan', 'Walker', 'alan.walker@fastway.co.za', '0821234567', '12 Hill Rd', 'Driver', 18000.00, 1, 1),
('Maria', 'Lopez', 'maria.lopez@fastway.co.za', '0839876543', '34 Beach Rd', 'Manager', 28000.00, 2, 2);

-- Sample data for Vehicle
INSERT INTO Vehicle (RegistrationNumber, Make, Model, Year, Capacity, CurrentWarehouseID, Status)
VALUES
('CA123456', 'Toyota', 'Hiace', 2023, 1200.00, 1, 'Available'),
('GP987654', 'Ford', 'Transit', 2022, 1400.00, 2, 'In Use');

-- Sample data for ServiceType
INSERT INTO ServiceType (Name, Description, BasePrice, PricePerKg, EstimatedDeliveryTime)
VALUES
('Express', 'Fast delivery within 1 day', 100.00, 10.00, '04:00:00'),
('Standard', 'Delivery within 3–5 days', 50.00, 5.00, '08:00:00');

-- Sample data for Payment
INSERT INTO Payment (CustomerID, Amount, PaymentMethod, PaymentStatus, InvoiceNumber)
VALUES
(1, 150.00, 'Card', 'Paid', 'INV1001'),
(2, 300.00, 'EFT', 'Pending', 'INV1002');

-- Sample data for Package
INSERT INTO Package (CustomerID, Weight, Length, Width, Height, PackageType, ContentsDescription, DeclaredValue, Fragile, Hazardous, SpecialInstructions)
VALUES
(1, 5.50, '30cm', '20cm', '15cm', 'Box', 'Electronics', 1200.00, 1, 0, 'Handle with care'),
(2, 2.00, '25cm', '15cm', '10cm', 'Envelope', 'Documents', NULL, 0, 0, NULL);

-- Sample data for Shipment
INSERT INTO Shipment (RecipientName, RecipientAddress, RecipientsCity, RecipientPostalCode, RecipientPhone, ShipmentDate, EstimatedDeliveryDate, VehicleID, CustomerID, EmployeeID, ServiceTypeID, PaymentID)
VALUES
('Michael Brown', '101 Cedar St', 'Durban', '4000', '0741112233', GETDATE(), DATEADD(DAY, 2, GETDATE()), 1, 1, 1, 1, 1),
('Sarah Green', '202 Pine St', 'Pretoria', '0002', '0719988776', GETDATE(), DATEADD(DAY, 4, GETDATE()), 2, 2, 2, 2, 2);


-- Sample data for ShipmentPackage
INSERT INTO ShipmentPackage (ShipmentID, PackageID)
VALUES
(1, 1),
(2, 2);

-- Sample data for Route
INSERT INTO Route (WarehouseID, Distance, EstimatedTravelTime, RouteDescription)
VALUES
(1, 800.00, '10:00:00', 'Cape Town to Durban route'),
(2, 500.00, '08:00:00', 'Johannesburg to Pretoria route');

-- Sample data for ShipmentRoute
INSERT INTO ShipmentRoute (ShipmentID, RouteID)
VALUES
(1, 1),
(2, 2);

-- Sample data for EventTracker
INSERT INTO EventTracker (EventType, EventTimeStamp, Location, Notes, Status, ShipmentPackageID, EmployeeID)
VALUES
('Pickup', GETDATE(), 'Cape Town Warehouse', 'Package picked up for delivery', 'Completed', 1, 1),
('Delivery', GETDATE(), 'Durban Central', 'Package delivered successfully', 'Completed', 1, 1);

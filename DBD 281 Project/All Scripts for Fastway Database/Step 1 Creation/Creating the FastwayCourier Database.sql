CREATE DATABASE FastwayCouriers;
GO

USE FastwayCouriers;
GO
--Customer Table 
CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(10) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(4) NOT NULL,
    AccountCreatedDate DATETIME NOT NULL DEFAULT GETDATE()
);
-- Payment Table
CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    PaymentMethod VARCHAR(10) NOT NULL,
    PaymentStatus VARCHAR(10) NOT NULL,
    InvoiceNumber VARCHAR(30) NOT NULL UNIQUE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
--Package Table 
CREATE TABLE Package (
    PackageID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    Weight DECIMAL(4,2) NOT NULL CHECK (Weight > 0),
    Length VARCHAR(10) NOT NULL,
    Width VARCHAR(10) NOT NULL,
    Height VARCHAR(10) NOT NULL,
    PackageType VARCHAR(20) NOT NULL,
    ContentsDescription VARCHAR(100),
    DeclaredValue DECIMAL(6,2) CHECK (DeclaredValue >= 0),
    Fragile BIT NOT NULL DEFAULT 0,
    Hazardous BIT NOT NULL DEFAULT 0,
    SpecialInstructions VARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
-- Warehouse Table
CREATE TABLE Warehouse (
    WarehouseID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    City VARCHAR(100) NOT NULL,
    PostalCode VARCHAR(4) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity >= 0)
);
-- Roles Table
CREATE TABLE Roles (
    RolesID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName VARCHAR(50) NOT NULL UNIQUE,
    RoleDescription VARCHAR(255)
);
-- Employee Table
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(10) NOT NULL,
    Address VARCHAR(100),
    Position VARCHAR(50) NOT NULL,
    HireDate DATETIME NOT NULL DEFAULT GETDATE(),
    Salary DECIMAL(10,2) NOT NULL CHECK (Salary > 0),
    RoleID INT NOT NULL,
    WarehouseID INT NOT NULL,
    FOREIGN KEY (RoleID) REFERENCES Roles(RolesID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID)
);
-- Vehicle Table
CREATE TABLE Vehicle (
    VehicleID INT IDENTITY(1,1) PRIMARY KEY,
    RegistrationNumber VARCHAR(20) NOT NULL UNIQUE,
    Make VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    Year INT NOT NULL,
    Capacity DECIMAL(6,2) NOT NULL CHECK (Capacity >= 0),
    CurrentWarehouseID INT NOT NULL,
    Status VARCHAR(50) NOT NULL,
    FOREIGN KEY (CurrentWarehouseID) REFERENCES Warehouse(WarehouseID)
);
--Service Type Table
CREATE TABLE ServiceType (
    ServiceTypeID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(20) NOT NULL UNIQUE,
    Description VARCHAR(255),
    BasePrice DECIMAL(10,2) NOT NULL CHECK (BasePrice > 0),
    PricePerKg DECIMAL(10,2) NOT NULL CHECK (PricePerKg > 0),
    EstimatedDeliveryTime TIME
);
-- Shipment Table
CREATE TABLE Shipment (
    ShipmentID INT IDENTITY(1,1) PRIMARY KEY,
    RecipientName VARCHAR(20) NOT NULL,
    RecipientAddress VARCHAR(100) NOT NULL,
    RecipientsCity VARCHAR(100) NOT NULL,
    RecipientPostalCode VARCHAR(4) NOT NULL,
    RecipientPhone VARCHAR(10) NOT NULL,
    ShipmentDate DATETIME NOT NULL,
    EstimatedDeliveryDate DATETIME NOT NULL,
    VehicleID INT NOT NULL,
    CustomerID INT NOT NULL,
    EmployeeID INT NOT NULL,
    ServiceTypeID INT NOT NULL,
    PaymentID INT NOT NULL,
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ServiceTypeID) REFERENCES ServiceType(ServiceTypeID),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
);
-- ShipmentPackage Table
CREATE TABLE ShipmentPackage (
    ShipmentPackageID INT IDENTITY(1,1) PRIMARY KEY,
    ShipmentID INT NOT NULL,
    PackageID INT NOT NULL,
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID),
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID)
);
-- Route Table
CREATE TABLE Route (
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT NOT NULL,
    Distance DECIMAL(10,2) NOT NULL CHECK (Distance > 0),
    EstimatedTravelTime TIME,
    RouteDescription VARCHAR(255),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID)
);
-- ShipmentRoute Table
CREATE TABLE ShipmentRoute (
    ShipmentRouteID INT IDENTITY(1,1) PRIMARY KEY,
    ShipmentID INT NOT NULL,
    RouteID INT NOT NULL,
    FOREIGN KEY (ShipmentID) REFERENCES Shipment(ShipmentID),
    FOREIGN KEY (RouteID) REFERENCES Route(RouteID)
);
-- Event Tracker Table
CREATE TABLE EventTracker (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    EventType VARCHAR(50) NOT NULL,
    EventTimeStamp DATETIME NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Notes VARCHAR(255),
    Status VARCHAR(20) NOT NULL,
    ShipmentPackageID INT NOT NULL,
    EmployeeID INT NOT NULL,
    FOREIGN KEY (ShipmentPackageID) REFERENCES ShipmentPackage(ShipmentPackageID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

--INEDEXES
CREATE UNIQUE INDEX IDX_Customer_Email ON Customer(Email);
CREATE NONCLUSTERED INDEX IDX_Payment_Status ON Payment(PaymentStatus);
CREATE NONCLUSTERED INDEX IDX_Package_Type ON Package(PackageType);
CREATE NONCLUSTERED INDEX IDX_Vehicle_Status ON Vehicle(Status);
CREATE NONCLUSTERED INDEX IDX_Shipment_Date ON Shipment(ShipmentDate);
CREATE NONCLUSTERED INDEX IDX_Shipment_EstimatedDeliveryDate ON Shipment(EstimatedDeliveryDate);
CREATE UNIQUE INDEX IDX_Employee_Email ON Employee(Email);
CREATE NONCLUSTERED INDEX IDX_EventTracker_Status ON EventTracker(Status);
CREATE NONCLUSTERED INDEX IDX_Route_Distance ON Route(Distance);
CREATE NONCLUSTERED INDEX IDX_Customer_CityPostal ON Customer(City, PostalCode);
CREATE NONCLUSTERED INDEX IDX_EventTracker_StatusDate ON EventTracker(Status, EventTimeStamp);

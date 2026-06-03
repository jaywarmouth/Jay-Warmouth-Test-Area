-- =============================================
-- Table: dbo.Customers
-- Description: Stores customer account records
-- =============================================

CREATE TABLE dbo.Customers (
    CustomerID    INT            NOT NULL IDENTITY(1,1),
    FirstName     NVARCHAR(100)  NOT NULL,
    LastName      NVARCHAR(100)  NOT NULL,
    Email         NVARCHAR(255)  NOT NULL,
    PhoneNumber   NVARCHAR(20)       NULL,
    CreatedAt     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),

    CONSTRAINT PK_Customers PRIMARY KEY CLUSTERED (CustomerID),
    CONSTRAINT UQ_Customers_Email UNIQUE (Email)
);
GO

-- =============================================
-- Table: dbo.Orders
-- Description: Stores customer order records
-- =============================================

CREATE TABLE dbo.Orders (
    OrderID       INT            NOT NULL IDENTITY(1,1),
    CustomerID    INT            NOT NULL,
    OrderDate     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    TotalAmount   DECIMAL(18,2)  NOT NULL,
    Status        NVARCHAR(50)   NOT NULL DEFAULT 'Pending',
    CreatedAt     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),
    UpdatedAt     DATETIME2      NOT NULL DEFAULT GETUTCDATE(),

    CONSTRAINT PK_Orders PRIMARY KEY CLUSTERED (OrderID),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers (CustomerID)
);
GO

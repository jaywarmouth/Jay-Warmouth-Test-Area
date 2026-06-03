-- =============================================
-- Table: public.orders
-- Description: Stores customer order records
-- Distribution: DISTKEY on customer_id (co-located with customers)
-- =============================================

CREATE TABLE public.orders (
    order_id      BIGINT          NOT NULL,
    customer_id   BIGINT          NOT NULL,
    order_date    TIMESTAMP       NOT NULL DEFAULT GETDATE(),
    total_amount  DECIMAL(18,2)   NOT NULL,
    status        VARCHAR(50)     NOT NULL DEFAULT 'Pending',
    created_at    TIMESTAMP       NOT NULL DEFAULT GETDATE(),
    updated_at    TIMESTAMP       NOT NULL DEFAULT GETDATE()
)
DISTKEY(customer_id)
SORTKEY(order_date);

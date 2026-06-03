-- =============================================
-- Table: public.customers
-- Description: Stores customer account records
-- Distribution: DISTKEY on customer_id
-- =============================================

CREATE TABLE public.customers (
    customer_id   BIGINT        NOT NULL,
    first_name    VARCHAR(100)  NOT NULL,
    last_name     VARCHAR(100)  NOT NULL,
    email         VARCHAR(255)  NOT NULL,
    phone_number  VARCHAR(20)       NULL,
    created_at    TIMESTAMP     NOT NULL DEFAULT GETDATE(),
    updated_at    TIMESTAMP     NOT NULL DEFAULT GETDATE()
)
DISTKEY(customer_id)
SORTKEY(created_at);

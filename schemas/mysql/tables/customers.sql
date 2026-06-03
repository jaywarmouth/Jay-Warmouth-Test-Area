-- =============================================
-- Table: `customers`
-- Description: Stores customer account records
-- =============================================

CREATE TABLE `customers` (
    `customer_id`  BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    `first_name`   VARCHAR(100)     NOT NULL,
    `last_name`    VARCHAR(100)     NOT NULL,
    `email`        VARCHAR(255)     NOT NULL,
    `phone_number` VARCHAR(20)          NULL,
    `created_at`   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`customer_id`),
    UNIQUE KEY `uq_customers_email` (`email`)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

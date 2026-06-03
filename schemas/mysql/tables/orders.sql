-- =============================================
-- Table: `orders`
-- Description: Stores customer order records
-- =============================================

CREATE TABLE `orders` (
    `order_id`     BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT,
    `customer_id`  BIGINT UNSIGNED  NOT NULL,
    `order_date`   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `total_amount` DECIMAL(18,2)    NOT NULL,
    `status`       VARCHAR(50)      NOT NULL DEFAULT 'Pending',
    `created_at`   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`   DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (`order_id`),
    KEY `idx_orders_customer_id` (`customer_id`),
    CONSTRAINT `fk_orders_customer_id`
        FOREIGN KEY (`customer_id`)
        REFERENCES `customers` (`customer_id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;

-- Lodge V | lv_dev | Datenbankschema v0.2.0
-- Vor dem Import eine Sicherung der Datenbank erstellen.
-- Dieses Schema legt ausschliesslich lv_dev-Tabellen an.

CREATE TABLE IF NOT EXISTS `lv_dev_audit` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `actor_identifier` VARCHAR(100) NOT NULL,
    `actor_name` VARCHAR(100) NOT NULL,
    `module` VARCHAR(50) NOT NULL,
    `action` VARCHAR(80) NOT NULL,
    `target` VARCHAR(150) DEFAULT NULL,
    `details` LONGTEXT DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_lv_dev_audit_actor` (`actor_identifier`),
    KEY `idx_lv_dev_audit_module` (`module`),
    KEY `idx_lv_dev_audit_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lv_dev_blips` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `sprite` INT UNSIGNED NOT NULL DEFAULT 1,
    `color` INT UNSIGNED NOT NULL DEFAULT 0,
    `scale` DECIMAL(4,2) NOT NULL DEFAULT 1.00,
    `x` DECIMAL(10,4) NOT NULL,
    `y` DECIMAL(10,4) NOT NULL,
    `z` DECIMAL(10,4) NOT NULL,
    `short_range` TINYINT(1) NOT NULL DEFAULT 1,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_by` VARCHAR(100) DEFAULT NULL,
    `updated_by` VARCHAR(100) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_lv_dev_blips_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lv_dev_elevators` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `job_name` VARCHAR(50) DEFAULT NULL,
    `required_grade` INT NOT NULL DEFAULT 0,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_by` VARCHAR(100) DEFAULT NULL,
    `updated_by` VARCHAR(100) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_lv_dev_elevators_enabled` (`enabled`),
    KEY `idx_lv_dev_elevators_job` (`job_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lv_dev_elevator_floors` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `elevator_id` INT UNSIGNED NOT NULL,
    `label` VARCHAR(100) NOT NULL,
    `floor_order` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    `x` DECIMAL(10,4) NOT NULL,
    `y` DECIMAL(10,4) NOT NULL,
    `z` DECIMAL(10,4) NOT NULL,
    `heading` DECIMAL(7,3) NOT NULL DEFAULT 0,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    KEY `idx_lv_dev_floors_elevator` (`elevator_id`),
    CONSTRAINT `fk_lv_dev_floors_elevator`
        FOREIGN KEY (`elevator_id`) REFERENCES `lv_dev_elevators` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lv_dev_logging` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `event_key` VARCHAR(100) NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_by` VARCHAR(100) DEFAULT NULL,
    `updated_by` VARCHAR(100) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_lv_dev_logging_event` (`event_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lv_dev_logging_webhooks` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `logging_id` INT UNSIGNED NOT NULL,
    `webhook_url` VARCHAR(512) NOT NULL,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_lv_dev_webhooks_logging` (`logging_id`),
    CONSTRAINT `fk_lv_dev_webhooks_logging`
        FOREIGN KEY (`logging_id`) REFERENCES `lv_dev_logging` (`id`)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lv_dev_teleports` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `x` DECIMAL(10,4) NOT NULL,
    `y` DECIMAL(10,4) NOT NULL,
    `z` DECIMAL(10,4) NOT NULL,
    `heading` DECIMAL(7,3) NOT NULL DEFAULT 0,
    `job_name` VARCHAR(50) DEFAULT NULL,
    `required_grade` INT NOT NULL DEFAULT 0,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_by` VARCHAR(100) DEFAULT NULL,
    `updated_by` VARCHAR(100) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_lv_dev_teleports_enabled` (`enabled`),
    KEY `idx_lv_dev_teleports_job` (`job_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lv_dev_bells` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `x` DECIMAL(10,4) NOT NULL,
    `y` DECIMAL(10,4) NOT NULL,
    `z` DECIMAL(10,4) NOT NULL,
    `radius` DECIMAL(5,2) NOT NULL DEFAULT 2.00,
    `cooldown_seconds` SMALLINT UNSIGNED NOT NULL DEFAULT 30,
    `job_name` VARCHAR(50) DEFAULT NULL,
    `enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_by` VARCHAR(100) DEFAULT NULL,
    `updated_by` VARCHAR(100) DEFAULT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_lv_dev_bells_enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

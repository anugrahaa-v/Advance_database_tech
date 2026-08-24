-- Lab 5: Demonstrate the ACID (Atomicity, Consistency, Isolation, and Durability)
-- properties of transactions using SQL commands

-- ============================
-- Initial tables (users, subscription_plans, user_subscriptions, payment)
-- ============================
SELECT * FROM users;
SELECT * FROM subscription_plans;
SELECT * FROM user_subscriptions;
SELECT * FROM payment;

-- ============================
-- 1. ATOMICITY
-- ============================
START TRANSACTION;
#Insert a new subscription.
#Use a new Subscription ID.
INSERT INTO user_subscriptions
VALUES
(306,105,201,'Active');
#insert payment
INSERT INTO payment
VALUES
(406,105,306,199.00,'2026-07-11');
COMMIT;

SELECT * FROM user_subscriptions;
SELECT * FROM payment;

-- Atomicity (Failure using Rollback)
#Atomicity (Failure using Rollback)
START TRANSACTION;
INSERT INTO user_subscriptions
VALUES
(307,104,202,'Active');

#insert payment using wrong Subscription ID.
INSERT INTO payment
VALUES
(407,104,999,399.00,'2026-07-11');
-- Error Code: 1452. Cannot add or update a child row: a foreign key constraint fails ('ott_platform'.'payment'.'CO...')
-- Since 999 does not exist in user_subscriptions Foreign Key Error will occur.

-- ROLLBACK OPERATION
ROLLBACK;

SELECT * FROM user_subscriptions;
-- 307 does NOT exist. Rollback cancelled everything.
SELECT * FROM payment;
-- 307 does NOT exist. Rollback cancelled everything.

-- ============================
-- 2. CONSISTENCY
-- ============================
-- valid insert.
INSERT INTO user_subscriptions
VALUES
(308,102,203,'Active');

-- Invalid Insert
INSERT INTO user_subscriptions
VALUES
(309,999,201,'Active');
-- User 999 doesn't exist.
-- Foreign Key Error.
-- Database remains consistent.

-- ============================
-- 3. ISOLATION
-- ============================

-- Window 1 Before Commit
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

UPDATE subscription_plans
SET Price=249
WHERE Plan_ID=201;

-- Window 2
SELECT *
FROM subscription_plans
WHERE Plan_ID=201;
-- You will still see 199 because Transaction 1 hasn't committed.

-- Window 1 After Commit
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

START TRANSACTION;

UPDATE subscription_plans
SET Price=249
WHERE Plan_ID=201;
COMMIT;

-- Window 2
SELECT *
FROM subscription_plans
WHERE Plan_ID=201;
-- Now 249 appears.

-- ============================
-- 4. DURABILITY
-- ============================
#Durability
START TRANSACTION;
#Insert payment
INSERT INTO payment
VALUES
(408,101,301,199.00,'2026-07-11');
COMMIT;

-- Disconnected MySQL.
-- Then Reconnect.
#after reconnecting
SELECT *
FROM payment
WHERE Payment_ID=408;
-- Record still exists. This proves durability.

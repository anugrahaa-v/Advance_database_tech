-- Lab 4: Normalization

-- ============================
-- CREATING AN UNNORMALIZED TABLE
-- ============================
CREATE DATABASE ott_normalization;
USE ott_normalization;

CREATE TABLE OTT_DETAILS (
    User_ID INT,
    Name VARCHAR(50),
    Email VARCHAR(50),
    Phone VARCHAR(15),
    Plan_ID INT,
    Plan_Name VARCHAR(30),
    Price DECIMAL(10,2),
    Status VARCHAR(20),
    Payment_ID INT,
    Amount DECIMAL(10,2),
    Paid_On DATE,
    Content_ID INT,
    Title VARCHAR(50),
    Genre VARCHAR(30),
    Type VARCHAR(20),
    Watched_On DATE
);

INSERT INTO OTT_DETAILS
(User_ID, Name, Email, Phone, Plan_ID, Plan_Name, Price, Status,
Payment_ID, Amount, Paid_On, Content_ID, Title, Genre, Type, Watched_On)
VALUES
(101,'Anugrahaa','anugrahaa@gmail.com','9876543210',201,'Basic',199,'Active',
401,199,'2026-06-01',501,'Stranger Things','Sci-Fi','Series','2026-06-20'),

(101,'Anugrahaa','anugrahaa@gmail.com','9876543210',201,'Basic',199,'Active',
401,199,'2026-06-01',502,'Inception','Thriller','Movie','2026-06-22'),

(102,'Priya','priya@gmail.com','9876543211',202,'Standard',399,'Active',
402,399,'2026-06-05',503,'Friends','Comedy','Series','2026-06-24'),

(103,'Rahul','rahul@gmail.com','9876543212',203,'Premium',599,'Active',
403,599,'2026-06-10',504,'Interstellar','Sci-Fi','Movie','2026-06-26'),

(104,'Sneha','sneha@gmail.com','9876543213',201,'Basic',199,'Expired',
404,199,'2026-06-15',505,'Wednesday','Mystery','Series','2026-06-28'),

(105,'Arjun','arjun@gmail.com','9876543214',202,'Standard',399,'Active',
405,399,'2026-06-20',501,'Stranger Things','Sci-Fi','Series','2026-06-30');

-- Unnormalized Form
SELECT * FROM OTT_DETAILS;

-- ============================
-- FIRST NORMAL FORM (1NF)
-- ============================
-- The OTT_DETAILS table satisfies First Normal Form because every attribute
-- contains atomic (single) values. Primary Key: (User_ID, Content_ID)

-- ============================
-- (2NF) SECOND NORMAL FORM
-- ============================
#2NF
#REMOVING PARTIAL DEPENDENCY
CREATE TABLE USERS_2NF (User_ID INT PRIMARY KEY,Name VARCHAR(50),Email VARCHAR(50),Phone VARCHAR(15));
CREATE TABLE CONTENT_2NF (Content_ID INT PRIMARY KEY,Title VARCHAR(50),Genre VARCHAR(30),Type VARCHAR(20));
CREATE TABLE OTT_DETAILS_2NF (User_ID INT,Content_ID INT,Plan_ID INT,Plan_Name VARCHAR(30),Price DECIMAL(10,2),Status VARCHAR(20),
Payment_ID INT,Amount DECIMAL(10,2),Paid_On DATE,Watched_On DATE,PRIMARY KEY (User_ID, Content_ID));
INSERT INTO USERS_2NF SELECT DISTINCT User_ID, Name, Email, Phone FROM OTT_DETAILS;
INSERT INTO CONTENT_2NF SELECT DISTINCT Content_ID, Title, Genre, Type FROM OTT_DETAILS;
INSERT INTO OTT_DETAILS_2NF SELECT User_ID, Content_ID,Plan_ID, Plan_Name, Price,Status,Payment_ID, Amount, Paid_On,Watched_On
FROM OTT_DETAILS;

SELECT * FROM USERS_2NF;
SELECT * FROM CONTENT_2NF;
SELECT * FROM OTT_DETAILS_2NF;

-- ============================
-- THIRD NORMAL FORM (3NF)
-- ============================
#3NF
CREATE TABLE PLAN_3NF (Plan_ID INT PRIMARY KEY,Plan_Name VARCHAR(30),Price DECIMAL(10,2));
CREATE TABLE PAYMENT_3NF (Payment_ID INT PRIMARY KEY,Amount DECIMAL(10,2),Paid_On DATE);
CREATE TABLE OTT_DETAILS_3NF (User_ID INT,Content_ID INT,Plan_ID INT,Payment_ID INT,Status VARCHAR(20),
Watched_On DATE,PRIMARY KEY (User_ID, Content_ID));
INSERT INTO PLAN_3NF SELECT DISTINCT Plan_ID, Plan_Name, Price FROM OTT_DETAILS;
INSERT INTO PAYMENT_3NF SELECT DISTINCT Payment_ID, Amount, Paid_On FROM OTT_DETAILS;
INSERT INTO OTT_DETAILS_3NF SELECT User_ID,Content_ID,Plan_ID,Payment_ID,Status,Watched_On
FROM OTT_DETAILS;

SELECT * FROM PLAN_3NF;
SELECT * FROM PAYMENT_3NF;
SELECT * FROM OTT_DETAILS_3NF;

-- ============================
-- UNNORMALIZED DATABASE TABLE
-- ============================
#UNNORMALIZED TABLE
SELECT * FROM OTT_DETAILS;

-- ============================
-- NORMALIZED DATABASE TABLE
-- ============================
#NORALIZED TABLE
SELECT * FROM USERS_2NF;
SELECT * FROM CONTENT_2NF;
SELECT * FROM PLAN_3NF;
SELECT * FROM PAYMENT_3NF;
SELECT * FROM OTT_DETAILS_3NF;

-- ============================
-- COMPARE SQL OPERATIONS
-- ============================

-- 1. INSERT Operation
-- Before Normalization
#INSERT Operation
#Before Normalization
INSERT INTO OTT_DETAILS
VALUES
(106,'Kiran','kiran@gmail.com','9876543215',
203,'Premium',599,'Active',
406,599,'2026-07-01',
502,'Inception','Thriller','Movie',
'2026-07-02');
SELECT * FROM OTT_DETAILS;

-- After normalization
#After Normalization
INSERT INTO USERS_2NF
VALUES
(106,'Kiran','kiran@gmail.com','9876543215');
INSERT INTO PAYMENT_3NF
VALUES
(406,599,'2026-07-01');
INSERT INTO OTT_DETAILS_3NF
VALUES
(106,502,203,406,'Active','2026-07-02');

-- 2. UPDATE OPERATION
-- Before Normalization
#UPDATE Operation
#Before Normalization
UPDATE OTT_DETAILS
SET Phone='9999999999'
WHERE User_ID=101;
SELECT * FROM OTT_DETAILS
WHERE User_ID=101;

-- After Normalization
#After Normalization
UPDATE USERS_2NF
SET Phone='9999999999'
WHERE User_ID=101;
SELECT * FROM USERS_2NF;

-- 3. DELETE Operation
-- Before Normalization
#DELETE Operation
#Before Normalization
DELETE FROM OTT_DETAILS
WHERE User_ID=105;

-- After Normalization
#After Normalization
DELETE FROM OTT_DETAILS_3NF
WHERE User_ID=105;

-- 4. Retrieval using JOIN
-- Because data is split into different tables after normalization, use a JOIN to reconstruct the information.
#4. Retrieval using JOIN
SELECT u.Name,p.Plan_Name,c.Title FROM OTT_DETAILS_3NF od
JOIN USERS_2NF u ON od.User_ID=u.User_ID
JOIN PLAN_3NF p
ON od.Plan_ID=p.Plan_ID
JOIN CONTENT_2NF c
ON od.Content_ID=c.Content_ID;

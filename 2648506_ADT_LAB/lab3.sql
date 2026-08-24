-- Lab 3: Data Retrieval using JOINS, Subqueries and Correlated Queries

-- ============================
-- QUESTION 1 - JOINS
-- ============================

-- INNER JOIN
-- Display users along with their subscription details.
#INNER JOIN
#Display users along with their subscription details.
SELECT u.User_ID,
       u.Name,
       us.Sub_ID,
       us.Status
FROM users u
INNER JOIN user_subscriptions us
ON u.User_ID = us.User_ID;

-- LEFT JOIN
-- Displays all users even if they don't have a subscription.
# LEFT JOIN
#Displays all users even if they don't have a subscription.
SELECT u.User_ID,
       u.Name,
       us.Sub_ID,
       us.Status
FROM users u
LEFT JOIN user_subscriptions us
ON u.User_ID = us.User_ID;

-- RIGHT JOIN
-- Displays all subscriptions even if a matching user doesn't exist.
#RIGHT JOIN
#Displays all subscriptions even if a matching user doesn't exist.
SELECT u.User_ID,
       u.Name,
       us.Sub_ID,
       us.Status
FROM users u
RIGHT JOIN user_subscriptions us
ON u.User_ID = us.User_ID;

-- FULL OUTER JOIN
-- Displays all users and all subscriptions, whether matching or not.
#FULL OUTER JOIN
#Displays all users and all subscriptions, whether matching or not.
SELECT u.User_ID,u.Name,us.Sub_ID,us.Status FROM users u LEFT JOIN user_subscriptions us ON u.User_ID = us.User_ID UNION
SELECT u.User_ID,u.Name,us.Sub_ID,us.Status
FROM users u RIGHT JOIN user_subscriptions us
ON u.User_ID = us.User_ID;

-- ============================
-- QUESTION 2 - SUBQUERIES
-- ============================

-- Subquery 1: Users having the highest payment.
-- Finds the user who paid the maximum amount.
#Users having the highest payment.
#Finds the user who paid the maximum amount.
SELECT Name
FROM users
WHERE User_ID IN
(SELECT User_ID FROM payment WHERE Amount = (SELECT MAX(Amount) FROM payment));

-- Subquery 2: Users subscribed to the Premium plan.
#Subquery 2
#Users subscribed to the Premium plan.
SELECT Name FROM users WHERE User_ID IN
(SELECT User_ID FROM user_subscriptions WHERE Plan_ID = ( SELECT Plan_ID FROM subscription_plans
WHERE Plan_Name='Premium'
)
);

-- Subquery 3: Plans costing more than the average price.
#Subquery 3
#Plans costing more than the average price.
SELECT Plan_Name, Price
FROM subscription_plans
WHERE Price >
(
SELECT AVG(Price)
FROM subscription_plans
);

-- Subquery 4: Users who made a payment greater than ₹300.
#Subquery 4
#Users who made a payment greater than ₹300.
SELECT Name FROM users WHERE User_ID IN
(SELECT User_ID
FROM payment
WHERE Amount > 300
);

-- Subquery 5: Plans that are currently subscribed by users.
#Subquery 5
#Plans that are currently subscribed by users.
SELECT Plan_Name
FROM subscription_plans
WHERE Plan_ID IN
(
SELECT Plan_ID
FROM user_subscriptions
);

-- ============================
-- Compound SQL Query (Uses ALL Existing Tables)
-- ============================
#Compound SQL Query
#Combines all six tables to display complete user, subscription, payment, and watch history information.
SELECT
    u.User_ID,u.Name,u.Email,sp.Plan_Name,sp.Price,p.Amount,p.Paid_on,c.Title,c.Genre,c.Type,wh.Watched_on
    FROM Users u INNER JOIN User_Subscriptions us ON u.User_ID = us.User_ID
    INNER JOIN Subscription_Plans sp ON us.Plan_ID = sp.Plan_ID INNER JOIN Payment p ON u.User_ID = p.User_ID INNER JOIN Watch_History wh
ON u.User_ID = wh.User_ID INNER JOIN Content c ON wh.Content_ID = c.Content_ID;

-- ============================
-- Correlated Query
-- ============================
-- Compares each payment against the average payment made by the same user.
#Correlated Query
#Compares each payment against the average payment made by the same user.
SELECT u.Name, p.Amount
FROM users u JOIN payment p ON u.User_ID = p.User_ID WHERE p.Amount >
(SELECT AVG(p2.Amount)
FROM payment p2 WHERE p2.User_ID = p.User_ID);

USE bank;

-- Activity 1

-- How many accounts do we have?
SELECT 
    COUNT(*) AS accounts_no
FROM
    account a;

-- How many of the accounts are defaulted?
SELECT 
    COUNT(*) AS accounts_no
FROM
    loan
WHERE
    status = 'B';

-- What is the percentage of defaulted people in the dataset?
SELECT 
    (SELECT 
            COUNT(*) AS accounts_no
        FROM
            loan
        WHERE
            status = 'B') * 100 / COUNT(*) AS percentage
FROM
    account; 

-- What can we conclude from here?
-- There are very few clients that default on loans.

-- Activity 2

-- Find the account_id, amount and date of the first transaction of the defaulted people if its amount 
-- is at least twice the average of non-default people transactions.

-- Steps:
-- find the average of non-default people transactions
-- find the transactions which are at least twice the average found earlier
-- find the first transaction by date of the ones mentioned before
-- find the account_id, amount and date of the transaction

WITH defaulted_transactions AS
(SELECT 
    trans.account_id, trans.amount, MIN(date(trans.`date`))
FROM
    trans
        JOIN
    loan ON loan.account_id = trans.account_id
WHERE
    trans.amount > 2 * (SELECT 
            AVG(trans.amount)
        FROM
            trans
                JOIN
            loan ON trans.account_id = loan.account_id
        WHERE
            status != 'B')
        AND status = 'B')
SELECT 
    account_id, MIN(date(trans.`date`)) AS first_transaction
FROM
    defaulted_transactions
GROUP BY account_id
ORDER BY trans.`date`
LIMIT 1;

-- Activity 3

-- Create a pivot table showing the average amount of transactions using frequency for each district.
SELECT 
    district_name,
    AVG(CASE
        WHEN frequency = 'POPLATEK MESICNE' THEN amount
    END) AS Poplatek_Mesicne,
    AVG(CASE
        WHEN frequency = 'POPLATEK TYDNE' THEN amount
    END) AS Poplatek_Tydne,
    AVG(CASE
        WHEN frequency = 'POPLATEK PO OBRATU' THEN amount
    END) AS Poplatek_Po_Obratu
FROM
    district
        JOIN
    `account` ON `account`.district_id = district.district_id
        JOIN
    trans ON `account`.account_id = trans.account_id
GROUP BY
	district_name;

-- Activity 4

-- For this problem we will use the sakila dataset.
USE sakila;

SELECT * FROM film;

-- Write a simple stored procedure to find the number of movies released in the year 2006.

-- Change delimiter
DELIMITER //

CREATE PROCEDURE movies_2006()
BEGIN 
	SELECT COUNT(*) AS number_of_movies FROM sakila.film WHERE release_year = "2006";
END //

DELIMITER ;

-- Use stored procedure
CALL movies_2006()




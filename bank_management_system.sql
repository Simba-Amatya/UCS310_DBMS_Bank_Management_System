DROP DATABASE IF EXISTS BankDB;
CREATE DATABASE BankDB;
USE BankDB;
CREATE TABLE BRANCH (
    Branch_ID     INT            PRIMARY KEY AUTO_INCREMENT,
    Branch_Name   VARCHAR(100)   NOT NULL,
    Location      VARCHAR(150)   NOT NULL,
    City          VARCHAR(80)    NOT NULL,
    IFSC_Code     VARCHAR(20)    UNIQUE NOT NULL
);
CREATE TABLE CUSTOMER (
    Customer_ID   INT            PRIMARY KEY AUTO_INCREMENT,
    Name          VARCHAR(100)   NOT NULL,
    Address       VARCHAR(200),
    Phone_No      VARCHAR(15)    UNIQUE NOT NULL,
    Email         VARCHAR(100)   UNIQUE,
    DOB           DATE,
    City          VARCHAR(80),
    State         VARCHAR(80)
);
CREATE TABLE ACCOUNT (
    Account_No    INT            PRIMARY KEY AUTO_INCREMENT,
    Customer_ID   INT            NOT NULL,
    Branch_ID     INT            NOT NULL,
    Account_Type  ENUM('Savings','Current','Fixed Deposit','Recurring') NOT NULL,
    Balance       DECIMAL(15,2)  NOT NULL DEFAULT 0.00,
    Open_Date     DATE           NOT NULL DEFAULT (CURDATE()),
    Status        ENUM('Active','Inactive','Closed')                    NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_acc_cust   FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID) ON DELETE RESTRICT,
    CONSTRAINT fk_acc_branch FOREIGN KEY (Branch_ID)   REFERENCES BRANCH(Branch_ID)    ON DELETE RESTRICT,
    CONSTRAINT chk_balance   CHECK (Balance >= 0)
);
CREATE TABLE TRANSACTION_LOG (
    Transaction_ID  INT            PRIMARY KEY AUTO_INCREMENT,
    Account_No      INT            NOT NULL,
    Txn_Date        DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Amount          DECIMAL(15,2)  NOT NULL,
    Txn_Type        ENUM('Deposit','Withdrawal','Transfer In','Transfer Out') NOT NULL,
    Description     VARCHAR(255),
    Balance_After   DECIMAL(15,2)  NOT NULL,
    CONSTRAINT fk_txn_acc FOREIGN KEY (Account_No) REFERENCES ACCOUNT(Account_No) ON DELETE RESTRICT,
    CONSTRAINT chk_amount CHECK (Amount > 0)
);
CREATE TABLE LOAN (
    Loan_ID         INT            PRIMARY KEY AUTO_INCREMENT,
    Customer_ID     INT            NOT NULL,
    Branch_ID       INT            NOT NULL,
    Loan_Amount     DECIMAL(15,2)  NOT NULL,
    Loan_Type       ENUM('Home','Car','Personal','Education','Business') NOT NULL,
    Interest_Rate   DECIMAL(5,2)   NOT NULL,
    Tenure_Months   INT            NOT NULL,
    Status          ENUM('Pending','Approved','Rejected','Closed')       NOT NULL DEFAULT 'Pending',
    Issue_Date      DATE,
    CONSTRAINT fk_loan_cust   FOREIGN KEY (Customer_ID) REFERENCES CUSTOMER(Customer_ID) ON DELETE RESTRICT,
    CONSTRAINT fk_loan_branch FOREIGN KEY (Branch_ID)   REFERENCES BRANCH(Branch_ID)    ON DELETE RESTRICT,
    CONSTRAINT chk_loan_amt   CHECK (Loan_Amount > 0),
    CONSTRAINT chk_tenure     CHECK (Tenure_Months > 0)
);
CREATE TABLE EMPLOYEE (
    Employee_ID   INT            PRIMARY KEY AUTO_INCREMENT,
    Branch_ID     INT            NOT NULL,
    Name          VARCHAR(100)   NOT NULL,
    Designation   VARCHAR(80)    NOT NULL,
    Salary        DECIMAL(10,2)  NOT NULL,
    Join_Date     DATE           NOT NULL DEFAULT (CURDATE()),
    CONSTRAINT fk_emp_branch FOREIGN KEY (Branch_ID) REFERENCES BRANCH(Branch_ID) ON DELETE RESTRICT,
    CONSTRAINT chk_salary    CHECK (Salary > 0)
);
ALTER TABLE CUSTOMER ADD COLUMN PAN_No VARCHAR(15) UNIQUE;

-- Add a manager column to BRANCH (self-referencing the employee table)
ALTER TABLE BRANCH ADD COLUMN Manager_Employee_ID INT;

-- Add an index on TRANSACTION_LOG for faster date-range queries
CREATE INDEX idx_txn_date ON TRANSACTION_LOG(Txn_Date);

-- Add an index for account lookups by customer
CREATE INDEX idx_acc_cust ON ACCOUNT(Customer_ID);
INSERT INTO BRANCH (Branch_Name, Location, City, IFSC_Code) VALUES
('Main Branch',      'MG Road, Sector 12',     'Patiala',  'BANK0001001'),
('Civil Lines',      'Civil Lines, Block A',    'Patiala',  'BANK0001002'),
('Chandigarh North', 'Sector 17, SCO 44',       'Chandigarh','BANK0002001'),
('Delhi Connaught',  'Connaught Place, Block C','New Delhi', 'BANK0003001'),
('Mumbai Fort',      'Fort Area, Horniman Circle','Mumbai', 'BANK0004001');
INSERT INTO CUSTOMER (Name, Address, Phone_No, Email, DOB, City, State) VALUES
('Akshat Prakash Singh', '12 Rose Garden, Patiala',    '9876543210', 'akshat@email.com',   '2003-04-15', 'Patiala',    'Punjab'),
('Amatya Simba',         '34 Green Park, Patiala',     '9876543211', 'amatya@email.com',   '2003-07-22', 'Patiala',    'Punjab'),
('Nityan Bhakri',        '56 Blue Heights, Patiala',   '9876543212', 'nityan@email.com',   '2003-11-08', 'Patiala',    'Punjab'),
('Priya Sharma',         '78 Ashoka Road, Chandigarh', '9876543213', 'priya@email.com',    '1990-03-12', 'Chandigarh', 'Chandigarh'),
('Rahul Verma',          '23 DLF Colony, New Delhi',   '9876543214', 'rahul@email.com',    '1985-08-19', 'New Delhi',  'Delhi'),
('Sneha Gupta',          '9 Powai Lake Road, Mumbai',  '9876543215', 'sneha@email.com',    '1992-01-30', 'Mumbai',     'Maharashtra'),
('Vikram Nair',          '45 Koramangala, Bengaluru',  '9876543216', 'vikram@email.com',   '1988-06-05', 'Bengaluru',  'Karnataka'),
('Ananya Reddy',         '67 Banjara Hills, Hyderabad','9876543217', 'ananya@email.com',   '1995-09-25', 'Hyderabad',  'Telangana');
INSERT INTO ACCOUNT (Customer_ID, Branch_ID, Account_Type, Balance, Open_Date, Status) VALUES
(1, 1, 'Savings',        50000.00,  '2022-06-01', 'Active'),
(2, 1, 'Savings',        35000.00,  '2022-06-01', 'Active'),
(3, 1, 'Current',        120000.00, '2022-06-01', 'Active'),
(4, 3, 'Savings',        75000.00,  '2021-03-15', 'Active'),
(5, 4, 'Current',        250000.00, '2020-08-20', 'Active'),
(6, 5, 'Savings',        45000.00,  '2023-01-10', 'Active'),
(7, 5, 'Fixed Deposit',  500000.00, '2022-11-01', 'Active'),
(8, 3, 'Recurring',      20000.00,  '2023-05-05', 'Active'),
(1, 2, 'Current',        150000.00, '2023-07-01', 'Active'),  -- Customer 1 has 2 accounts
(5, 4, 'Savings',        30000.00,  '2023-09-15', 'Active');  -- Customer 5 has 2 accounts
INSERT INTO TRANSACTION_LOG (Account_No, Txn_Date, Amount, Txn_Type, Description, Balance_After) VALUES
(1, '2024-01-05 10:30:00', 10000.00, 'Deposit',    'Cash deposit',         60000.00),
(1, '2024-01-12 14:00:00',  5000.00, 'Withdrawal', 'ATM withdrawal',       55000.00),
(1, '2024-02-01 09:15:00', 20000.00, 'Deposit',    'Salary credit',        75000.00),
(2, '2024-01-10 11:00:00',  8000.00, 'Deposit',    'Cash deposit',         43000.00),
(2, '2024-01-20 16:30:00',  3000.00, 'Withdrawal', 'Online purchase',      40000.00),
(3, '2024-01-07 09:00:00', 50000.00, 'Deposit',    'Business deposit',    170000.00),
(3, '2024-02-10 13:45:00', 30000.00, 'Withdrawal', 'Vendor payment',      140000.00),
(4, '2024-01-15 10:00:00', 15000.00, 'Deposit',    'Fund transfer',        90000.00),
(5, '2024-01-18 11:30:00', 100000.00,'Deposit',    'Business revenue',    350000.00),
(5, '2024-02-05 10:00:00', 50000.00, 'Withdrawal', 'Office rent',         300000.00),
(6, '2024-01-25 14:00:00', 10000.00, 'Deposit',    'Personal savings',     55000.00),
(7, '2024-02-01 09:00:00', 50000.00, 'Deposit',    'FD top-up',           550000.00),
(1, '2024-02-15 10:00:00', 25000.00, 'Transfer Out','Transfer to Acc 2',   50000.00),
(2, '2024-02-15 10:01:00', 25000.00, 'Transfer In', 'Transfer from Acc 1', 65000.00);
INSERT INTO LOAN (Customer_ID, Branch_ID, Loan_Amount, Loan_Type, Interest_Rate, Tenure_Months, Status, Issue_Date) VALUES
(4, 3, 2000000.00, 'Home',      8.50, 240, 'Approved', '2021-05-01'),
(5, 4, 800000.00,  'Car',       9.00,  60, 'Approved', '2022-01-15'),
(1, 1, 100000.00,  'Personal',  12.00, 24, 'Approved', '2023-03-01'),
(6, 5, 500000.00,  'Education', 7.50,  48, 'Approved', '2023-06-01'),
(7, 5, 5000000.00, 'Business',  11.00, 120,'Pending',   NULL),
(8, 3, 300000.00,  'Personal',  13.00, 36, 'Rejected',  NULL),
(2, 1, 150000.00,  'Car',       9.50,  36, 'Pending',   NULL);
INSERT INTO EMPLOYEE (Branch_ID, Name, Designation, Salary, Join_Date) VALUES
(1, 'Rajinder Singh',  'Branch Manager',    85000.00, '2015-04-01'),
(1, 'Kavita Arora',    'Senior Cashier',    45000.00, '2017-08-15'),
(1, 'Deepak Kumar',    'Loan Officer',      55000.00, '2018-06-01'),
(2, 'Meena Patel',     'Branch Manager',    80000.00, '2016-01-10'),
(2, 'Arjun Tiwari',    'Cashier',           38000.00, '2019-03-20'),
(3, 'Sunita Bhatia',   'Branch Manager',    90000.00, '2014-07-05'),
(3, 'Rohit Malhotra',  'Loan Officer',      58000.00, '2019-11-01'),
(4, 'Amit Chauhan',    'Senior Cashier',    47000.00, '2018-02-14'),
(5, 'Nisha Joshi',     'Branch Manager',    95000.00, '2013-09-30'),
(5, 'Suresh Pillai',   'Customer Service',  35000.00, '2021-06-15');
UPDATE BRANCH SET Manager_Employee_ID = 1 WHERE Branch_ID = 1;
UPDATE BRANCH SET Manager_Employee_ID = 4 WHERE Branch_ID = 2;
UPDATE BRANCH SET Manager_Employee_ID = 6 WHERE Branch_ID = 3;
UPDATE BRANCH SET Manager_Employee_ID = 8 WHERE Branch_ID = 4;
UPDATE BRANCH SET Manager_Employee_ID = 9 WHERE Branch_ID = 5;
SELECT
    C.Customer_ID,
    C.Name          AS Customer_Name,
    C.Phone_No,
    A.Account_No,
    A.Account_Type,
    A.Balance,
    B.Branch_Name
FROM CUSTOMER C
INNER JOIN ACCOUNT  A ON C.Customer_ID = A.Customer_ID
INNER JOIN BRANCH   B ON A.Branch_ID   = B.Branch_ID
ORDER BY C.Customer_ID;
SELECT
    T.Transaction_ID,
    T.Txn_Date,
    T.Txn_Type,
    T.Amount,
    T.Description,
    T.Balance_After
FROM TRANSACTION_LOG T
WHERE T.Account_No = 1
ORDER BY T.Txn_Date;
SELECT
    Account_No,
    SUM(CASE WHEN Txn_Type IN ('Deposit','Transfer In')   THEN Amount ELSE 0 END) AS Total_Credits,
    SUM(CASE WHEN Txn_Type IN ('Withdrawal','Transfer Out') THEN Amount ELSE 0 END) AS Total_Debits,
    COUNT(*) AS Total_Transactions
FROM TRANSACTION_LOG
GROUP BY Account_No
ORDER BY Account_No;
SELECT
    A.Account_No,
    C.Name,
    A.Account_Type,
    A.Balance
FROM ACCOUNT A
INNER JOIN CUSTOMER C ON A.Customer_ID = C.Customer_ID
WHERE A.Balance > (SELECT AVG(Balance) FROM ACCOUNT)
ORDER BY A.Balance DESC;
SELECT
    C.Customer_ID,
    C.Name,
    C.Phone_No,
    C.City
FROM CUSTOMER C
WHERE EXISTS (SELECT 1 FROM ACCOUNT A WHERE A.Customer_ID = C.Customer_ID)
  AND EXISTS (SELECT 1 FROM LOAN    L WHERE L.Customer_ID = C.Customer_ID);
SELECT
    B.Branch_Name,
    COUNT(A.Account_No) AS Num_Accounts,
    SUM(A.Balance)      AS Total_Balance,
    AVG(A.Balance)      AS Avg_Balance
FROM BRANCH B
LEFT JOIN ACCOUNT A ON B.Branch_ID = A.Branch_ID
GROUP BY B.Branch_ID, B.Branch_Name
HAVING SUM(A.Balance) > 100000
ORDER BY Total_Balance DESC;
SELECT
    C.Name            AS Customer_Name,
    L.Loan_ID,
    L.Loan_Type,
    L.Loan_Amount,
    L.Interest_Rate,
    L.Tenure_Months,
    B.Branch_Name
FROM LOAN L
INNER JOIN CUSTOMER C ON L.Customer_ID = C.Customer_ID
INNER JOIN BRANCH   B ON L.Branch_ID   = B.Branch_ID
WHERE L.Status = 'Approved'
ORDER BY L.Loan_Amount DESC;
CREATE OR REPLACE VIEW vw_Transaction_Summary AS
SELECT
    A.Account_No,
    C.Name              AS Customer_Name,
    A.Account_Type,
    A.Balance           AS Current_Balance,
    COUNT(T.Transaction_ID)                                           AS Total_Txns,
    SUM(CASE WHEN T.Txn_Type IN ('Deposit','Transfer In')   THEN T.Amount ELSE 0 END) AS Total_Credits,
    SUM(CASE WHEN T.Txn_Type IN ('Withdrawal','Transfer Out') THEN T.Amount ELSE 0 END) AS Total_Debits,
    MAX(T.Txn_Date)     AS Last_Transaction
FROM ACCOUNT A
INNER JOIN CUSTOMER        C ON A.Customer_ID  = C.Customer_ID
LEFT  JOIN TRANSACTION_LOG T ON A.Account_No   = T.Account_No
GROUP BY A.Account_No, C.Name, A.Account_Type, A.Balance;
SELECT * FROM vw_Transaction_Summary;
SELECT
    B.Branch_Name,
    COUNT(E.Employee_ID) AS Num_Employees,
    MIN(E.Salary)        AS Min_Salary,
    MAX(E.Salary)        AS Max_Salary,
    SUM(E.Salary)        AS Total_Payroll
FROM BRANCH B
LEFT JOIN EMPLOYEE E ON B.Branch_ID = E.Branch_ID
GROUP BY B.Branch_ID, B.Branch_Name
ORDER BY Total_Payroll DESC;
SELECT
    C.Customer_ID,
    C.Name,
    C.Phone_No
FROM CUSTOMER C
LEFT JOIN LOAN L ON C.Customer_ID = L.Customer_ID
WHERE L.Loan_ID IS NULL;
SELECT
    A.Account_No,
    C.Name,
    A.Account_Type,
    A.Balance
FROM ACCOUNT A
INNER JOIN CUSTOMER C ON A.Customer_ID = C.Customer_ID
ORDER BY A.Balance DESC
LIMIT 3;
SELECT
    MONTH(Txn_Date)   AS Month_Num,
    MONTHNAME(Txn_Date) AS Month_Name,
    COUNT(*)          AS Num_Transactions,
    SUM(Amount)       AS Total_Amount
FROM TRANSACTION_LOG
WHERE YEAR(Txn_Date) = 2024
GROUP BY MONTH(Txn_Date), MONTHNAME(Txn_Date)
ORDER BY Month_Num;
SELECT
    C.Customer_ID,
    C.Name,
    COUNT(A.Account_No) AS Num_Accounts
FROM CUSTOMER C
INNER JOIN ACCOUNT A ON C.Customer_ID = A.Customer_ID
GROUP BY C.Customer_ID, C.Name
HAVING COUNT(A.Account_No) > 1;
DELIMITER //
CREATE PROCEDURE sp_Create_Account(
    IN  p_Customer_ID  INT,
    IN  p_Branch_ID    INT,
    IN  p_Acc_Type     VARCHAR(30),
    IN  p_Init_Balance DECIMAL(15,2),
    OUT p_Account_No   INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        INSERT INTO ACCOUNT (Customer_ID, Branch_ID, Account_Type, Balance, Open_Date, Status)
        VALUES (p_Customer_ID, p_Branch_ID, p_Acc_Type, p_Init_Balance, CURDATE(), 'Active');

        SET p_Account_No = LAST_INSERT_ID();

        -- Record the opening deposit
        IF p_Init_Balance > 0 THEN
            INSERT INTO TRANSACTION_LOG (Account_No, Txn_Date, Amount, Txn_Type, Description, Balance_After)
            VALUES (p_Account_No, NOW(), p_Init_Balance, 'Deposit', 'Account opening deposit', p_Init_Balance);
        END IF;
    COMMIT;
END //
CREATE PROCEDURE sp_Fund_Transfer(
    IN p_From_Account  INT,
    IN p_To_Account    INT,
    IN p_Amount        DECIMAL(15,2),
    IN p_Description   VARCHAR(255)
)
BEGIN
    DECLARE v_From_Balance DECIMAL(15,2);
    DECLARE v_To_Balance   DECIMAL(15,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Lock rows for update
        SELECT Balance INTO v_From_Balance FROM ACCOUNT WHERE Account_No = p_From_Account FOR UPDATE;
        SELECT Balance INTO v_To_Balance   FROM ACCOUNT WHERE Account_No = p_To_Account   FOR UPDATE;

        IF v_From_Balance < p_Amount THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Insufficient balance for transfer.';
        END IF;

        -- Debit
        UPDATE ACCOUNT SET Balance = Balance - p_Amount WHERE Account_No = p_From_Account;
        INSERT INTO TRANSACTION_LOG (Account_No, Amount, Txn_Type, Description, Balance_After)
        VALUES (p_From_Account, p_Amount, 'Transfer Out', p_Description, v_From_Balance - p_Amount);

        -- Credit
        UPDATE ACCOUNT SET Balance = Balance + p_Amount WHERE Account_No = p_To_Account;
        INSERT INTO TRANSACTION_LOG (Account_No, Amount, Txn_Type, Description, Balance_After)
        VALUES (p_To_Account, p_Amount, 'Transfer In', p_Description, v_To_Balance + p_Amount);

    COMMIT;
END //

-- 6.3  Deposit or Withdraw from an account
CREATE PROCEDURE sp_Deposit_Withdraw(
    IN p_Account_No  INT,
    IN p_Amount      DECIMAL(15,2),
    IN p_Txn_Type    ENUM('Deposit','Withdrawal'),
    IN p_Description VARCHAR(255)
)
BEGIN
    DECLARE v_Balance DECIMAL(15,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
        SELECT Balance INTO v_Balance FROM ACCOUNT WHERE Account_No = p_Account_No FOR UPDATE;

        IF p_Txn_Type = 'Withdrawal' AND v_Balance < p_Amount THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Insufficient balance.';
        END IF;

        IF p_Txn_Type = 'Deposit' THEN
            UPDATE ACCOUNT SET Balance = Balance + p_Amount WHERE Account_No = p_Account_No;
            SET v_Balance = v_Balance + p_Amount;
        ELSE
            UPDATE ACCOUNT SET Balance = Balance - p_Amount WHERE Account_No = p_Account_No;
            SET v_Balance = v_Balance - p_Amount;
        END IF;

        INSERT INTO TRANSACTION_LOG (Account_No, Amount, Txn_Type, Description, Balance_After)
        VALUES (p_Account_No, p_Amount, p_Txn_Type, p_Description, v_Balance);

    COMMIT;
END //
CREATE FUNCTION fn_Simple_Interest(
    p_Principal   DECIMAL(15,2),
    p_Rate        DECIMAL(5,2),
    p_Months      INT
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    RETURN ROUND((p_Principal * p_Rate * (p_Months / 12)) / 100, 2);
END //

CREATE FUNCTION fn_EMI(
    p_Principal   DECIMAL(15,2),
    p_Rate        DECIMAL(5,2),
    p_Months      INT
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE v_monthly_rate DECIMAL(10,6);
    DECLARE v_emi          DECIMAL(15,2);
    SET v_monthly_rate = p_Rate / (12 * 100);
    SET v_emi = ROUND(
        (p_Principal * v_monthly_rate * POW(1 + v_monthly_rate, p_Months))
        / (POW(1 + v_monthly_rate, p_Months) - 1)
    , 2);
    RETURN v_emi;
END //
CREATE FUNCTION fn_Customer_Total_Balance(p_Customer_ID INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(15,2);
    SELECT COALESCE(SUM(Balance), 0.00)
    INTO   v_total
    FROM   ACCOUNT
    WHERE  Customer_ID = p_Customer_ID AND Status = 'Active';
    RETURN v_total;
END //
CREATE TRIGGER trg_Prevent_Overdraft
BEFORE INSERT ON TRANSACTION_LOG
FOR EACH ROW
BEGIN
    DECLARE v_balance DECIMAL(15,2);

    IF NEW.Txn_Type IN ('Withdrawal', 'Transfer Out') THEN
        SELECT Balance INTO v_balance
        FROM ACCOUNT WHERE Account_No = NEW.Account_No;

        IF v_balance < NEW.Amount THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Overdraft prevented: Insufficient balance.';
        END IF;
    END IF;
END //
CREATE TRIGGER trg_Update_Balance_After_Txn
AFTER INSERT ON TRANSACTION_LOG
FOR EACH ROW
BEGIN
    IF NEW.Txn_Type IN ('Deposit', 'Transfer In') THEN
        UPDATE ACCOUNT SET Balance = Balance + NEW.Amount WHERE Account_No = NEW.Account_No;
    ELSEIF NEW.Txn_Type IN ('Withdrawal', 'Transfer Out') THEN
        UPDATE ACCOUNT SET Balance = Balance - NEW.Amount WHERE Account_No = NEW.Account_No;
    END IF;
END //

CREATE TABLE IF NOT EXISTS LOAN_AUDIT (
    Audit_ID    INT       PRIMARY KEY AUTO_INCREMENT,
    Loan_ID     INT,
    Old_Status  VARCHAR(20),
    New_Status  VARCHAR(20),
    Changed_At  DATETIME  DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER trg_Loan_Status_Audit
AFTER UPDATE ON LOAN
FOR EACH ROW
BEGIN
    IF OLD.Status <> NEW.Status THEN
        INSERT INTO LOAN_AUDIT (Loan_ID, Old_Status, New_Status)
        VALUES (NEW.Loan_ID, OLD.Status, NEW.Status);
    END IF;
END //
CREATE PROCEDURE sp_Branch_Account_Report(IN p_Branch_ID INT)
BEGIN
    DECLARE done         INT DEFAULT FALSE;
    DECLARE v_acc_no     INT;
    DECLARE v_cust_name  VARCHAR(100);
    DECLARE v_acc_type   VARCHAR(50);
    DECLARE v_balance    DECIMAL(15,2);

    DECLARE cur_accounts CURSOR FOR
        SELECT A.Account_No, C.Name, A.Account_Type, A.Balance
        FROM   ACCOUNT A
        INNER JOIN CUSTOMER C ON A.Customer_ID = C.Customer_ID
        WHERE  A.Branch_ID = p_Branch_ID AND A.Status = 'Active';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_Branch_Report (
        Account_No   INT,
        Customer     VARCHAR(100),
        Acc_Type     VARCHAR(50),
        Balance      DECIMAL(15,2)
    );
    TRUNCATE TABLE tmp_Branch_Report;

    OPEN cur_accounts;
    read_loop: LOOP
        FETCH cur_accounts INTO v_acc_no, v_cust_name, v_acc_type, v_balance;
        IF done THEN LEAVE read_loop; END IF;
        INSERT INTO tmp_Branch_Report VALUES (v_acc_no, v_cust_name, v_acc_type, v_balance);
    END LOOP;
    CLOSE cur_accounts;

    SELECT * FROM tmp_Branch_Report ORDER BY Balance DESC;
END //

DELIMITER ;

START TRANSACTION;
    SAVEPOINT sp_before_deposit;

    UPDATE ACCOUNT
    SET    Balance = Balance + 5000
    WHERE  Account_No = 1;

    INSERT INTO TRANSACTION_LOG (Account_No, Amount, Txn_Type, Description, Balance_After)
    SELECT 1, 5000, 'Deposit', 'SAVEPOINT demo deposit', Balance
    FROM ACCOUNT WHERE Account_No = 1;

COMMIT;

-- 10.2  Demonstrate ROLLBACK on error
START TRANSACTION;
    UPDATE ACCOUNT SET Balance = Balance - 999999 WHERE Account_No = 2;
    -- Balance would be negative — roll back
ROLLBACK;
CALL sp_Create_Account(3, 2, 'Savings', 25000.00, @new_acc);
SELECT @new_acc AS New_Account_No;
CALL sp_Fund_Transfer(1, 2, 10000.00, 'Inter-account transfer demo');
SELECT
    L.Loan_ID,
    L.Loan_Amount,
    L.Interest_Rate,
    L.Tenure_Months,
    fn_Simple_Interest(L.Loan_Amount, L.Interest_Rate, L.Tenure_Months) AS Simple_Interest,
    fn_EMI(L.Loan_Amount, L.Interest_Rate, L.Tenure_Months)             AS Monthly_EMI
FROM LOAN L
WHERE L.Status = 'Approved';

SELECT fn_Customer_Total_Balance(1) AS Total_Balance_Customer1;

CALL sp_Branch_Account_Report(1);

UPDATE LOAN SET Status = 'Approved', Issue_Date = CURDATE() WHERE Loan_ID = 5;

SELECT * FROM LOAN_AUDIT;
SELECT C.Name, A.Account_No, A.Account_Type, A.Balance
FROM ACCOUNT A INNER JOIN CUSTOMER C ON A.Customer_ID = C.Customer_ID
WHERE A.Balance > 100000
ORDER BY A.Balance DESC;
SELECT Account_Type, COUNT(*) AS Count, AVG(Balance) AS Avg_Balance, SUM(Balance) AS Total_Balance
FROM ACCOUNT
WHERE Status = 'Active'
GROUP BY Account_Type;

SELECT E.Name, E.Designation, E.Salary, B.Branch_Name
FROM EMPLOYEE E INNER JOIN BRANCH B ON E.Branch_ID = B.Branch_ID
WHERE E.Salary > (SELECT AVG(Salary) FROM EMPLOYEE)
ORDER BY E.Salary DESC;
SELECT
    L.Loan_ID,
    C.Name                                                            AS Borrower,
    L.Loan_Type,
    L.Loan_Amount,
    fn_EMI(L.Loan_Amount, L.Interest_Rate, L.Tenure_Months)          AS EMI,
    fn_EMI(L.Loan_Amount, L.Interest_Rate, L.Tenure_Months) * L.Tenure_Months AS Total_Payable,
    fn_EMI(L.Loan_Amount, L.Interest_Rate, L.Tenure_Months) * L.Tenure_Months - L.Loan_Amount AS Total_Interest
FROM LOAN L
INNER JOIN CUSTOMER C ON L.Customer_ID = C.Customer_ID
WHERE L.Status = 'Approved';
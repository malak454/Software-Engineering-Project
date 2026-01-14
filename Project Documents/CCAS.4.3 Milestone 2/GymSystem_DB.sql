CREATE TABLE Admin (
    Admin_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name  VARCHAR(50),
    Email_Address VARCHAR(100),
    Phone_Number  VARCHAR(20)
);

CREATE TABLE Coach (
    Coach_ID INT PRIMARY KEY,
    F_Name VARCHAR(50),
    L_Name VARCHAR(50),
    Email_Address VARCHAR(100),
    Phone_Number  VARCHAR(20),
    Admin_ID INT,
    FOREIGN KEY (Admin_ID) REFERENCES Admin(Admin_ID)
);

CREATE TABLE Membership (
    Membership_ID INT PRIMARY KEY,
    Membership_Type VARCHAR(50),
    Start_Date DATE,
    Duration INT
);

CREATE TABLE Client (
    Client_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Date_Of_Birth DATE,
    Gender VARCHAR(1),
    Phone_Number VARCHAR(20),
    Email VARCHAR(100),

    Coach_ID INT,
    Membership_ID INT,

    FOREIGN KEY (Coach_ID) REFERENCES Coach(Coach_ID),
    FOREIGN KEY (Membership_ID) REFERENCES Membership(Membership_ID)
);

CREATE TABLE Nutrition_Plan (
    N_Plan_ID INT PRIMARY KEY,
    Client_ID INT,
    Coach_ID INT,
    Diet_Plan VARCHAR(50),
    Calories_Intake INT,
    Protein_Target INT,
    Carbs_Target INT,
    Fats_Target INT,

    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID),
    FOREIGN KEY (Coach_ID) REFERENCES Coach(Coach_ID)
);

CREATE TABLE Workout_Plan (
    W_Plan_ID INT PRIMARY KEY,
    Client_ID INT,
    Coach_ID INT,
    Goal VARCHAR(50),
    Level VARCHAR(50),
    Duration_Weeks INT,

    FOREIGN KEY (Client_ID) REFERENCES Client(Client_ID),
    FOREIGN KEY (Coach_ID) REFERENCES Coach(Coach_ID)
);

/* QUR_001 */
INSERT INTO Admin VALUES
(1,'Maram','Mohamed','maram@example.com','01011111111');

/* QUR_002 */
INSERT INTO Coach VALUES
(1,'Sherif','Ahmed','sherif@example.com','01111111111',1),
(2,'Khaled','Saeed','khaled@example.com','01122222222',1);

/* QUR_003 */
INSERT INTO Membership VALUES
(10,'Monthly','2025-01-01',1),
(20,'Yearly','2025-01-01',12);

/* QUR_004 */
INSERT INTO Client VALUES
(100,'Sara','Kamel','2003-04-10','F','01245678901','sara@example.com',1,10),
(101,'Youssef','Hassan','2000-02-15','M','01223456789','youssefh@example.com',2,20);

/* QUR_005 */
INSERT INTO Nutrition_Plan VALUES
(500,100,1,'Weight Loss',1800,120,200,60),
(501,101,2,'Muscle Gain',2600,180,320,80);

/* QUR_006 */
INSERT INTO Workout_Plan VALUES
(700,100,1,'Fat Loss','Beginner',8),
(701,101,2,'Hypertrophy','Intermediate',12);



/* QUR_007 */
UPDATE Client
SET Coach_ID = 1
WHERE Client_ID = 101;

/* QUR_008 */
UPDATE Nutrition_Plan
SET Calories_Intake = 2000
WHERE N_Plan_ID = 500;



/* QUR_009 */
DELETE FROM Workout_Plan
WHERE W_Plan_ID = 701;



/* QUR_010 */
SELECT
    c.Client_ID,
    c.First_Name,
    c.Last_Name,
    co.F_Name AS Coach_FirstName,
    co.L_Name AS Coach_LastName,
    m.Membership_Type
FROM Client c
JOIN Coach co ON c.Coach_ID = co.Coach_ID
JOIN Membership m ON c.Membership_ID = m.Membership_ID;

/* QUR_011 */
SELECT
    co.Coach_ID,
    co.F_Name,
    co.L_Name,
    COUNT(c.Client_ID) AS Total_Clients
FROM Coach co
LEFT JOIN Client c ON c.Coach_ID = co.Coach_ID
GROUP BY co.Coach_ID, co.F_Name, co.L_Name;

/* QUR_012 */
SELECT
    c.Client_ID,
    c.First_Name,
    c.Last_Name,
    n.Calories_Intake
FROM Client c
JOIN Nutrition_Plan n ON n.Client_ID = c.Client_ID
WHERE n.Calories_Intake >= 2000
ORDER BY c.Client_ID DESC;

/* QUR_013 */
SELECT
    c.Client_ID,
    c.First_Name,
    c.Last_Name,
    n.Calories_Intake
FROM Client c
JOIN Nutrition_Plan n ON n.Client_ID = c.Client_ID
WHERE n.Calories_Intake >
(
    SELECT AVG(Calories_Intake)
    FROM Nutrition_Plan
);


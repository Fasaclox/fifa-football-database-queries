/* 
 * FIFA DATASET 
 * EDA 
 *  
*/

-- 1. What is the total number of Clubs?

SELECT
COUNT(DISTINCT Club) AS Clubs
FROM
Profile;


-- 2. What is the total number of Players?
SELECT
COUNT(DISTINCT ID) AS Total_Players
FROM
Profile;


-- 3. What is the total number of Nationality Represented?

SELECT
COUNT(DISTINCT Nationality) AS Nationalities
FROM
Profile;


--4.What are the Top 10 Nationality with the highest number of players?

SELECT TOP 10 WITH TIES 
  COUNT(DISTINCT p.ID) AS Total_Players, 
  p.Nationality AS Country
FROM 
  Profile p
GROUP BY 
  p.Nationality
ORDER BY 
  Total_Players DESC;


--5 What is the total amount spent on wages?

SELECT FORMAT(SUM([Wage(€)]), '#,##0') as Total_Wages FROM Contract as c;


--6. What is Total Number of Players by Club?

WITH ClubPlayerCounts AS (
  SELECT 
    Club, 
    COUNT(DISTINCT CASE WHEN Club <> 'No Club' THEN ID END) AS Total_Players
  FROM 
    Profile
  GROUP BY 
    Club
  HAVING 
    COUNT(CASE WHEN Club = 'No Club' THEN 1 END) = 0
)
SELECT 
  Club, 
  Total_Players
FROM 
  ClubPlayerCounts
ORDER BY 
  Total_Players DESC;



--7. Whats is the Total Number of Players without Club?

SELECT 
    COUNT(DISTINCT(ID))AS Total_Players, 
    Club
FROM 
    Profile
WHERE Club = 'No Club'
GROUP BY 
    Club;


--8. What is the Total number of players by position?

SELECT 
  DISTINCT(COUNT(ID)) AS Total_Players, 
  [Best Position]
FROM 
  Profile AS p 
GROUP BY 
  p.[Best Position]
ORDER BY 
  Total_Players DESC;


--9. What is the Players age distribution?

SELECT 
    DISTINCT(COUNT(ID)) AS Total_Players,
    Age
FROM
    Profile AS P 
GROUP BY Age
ORDER BY age DESC;


--10. Who is (are) the Youngest Players?

SELECT TOP 1 WITH TIES
    Age,
    Full_Name,
    Club
FROM
    Profile AS P 
GROUP BY Age, Full_Name, Club
ORDER BY Age;


--11. Who is (are) the Oldest Players?

SELECT TOP 1 WITH TIES
    Age,
    Full_Name,
    Club
FROM
    Profile AS P 
GROUP BY Age, Full_Name, Club
ORDER BY Age DESC;


--12. Which Club(s) are the smallest based on the number of players?

SELECT TOP (1) WITH TIES 
  COUNT(DISTINCT(ID)) AS Total_Players,
  Club
FROM 
  Profile as p
GROUP BY 
  p.Club
ORDER BY 
  Total_Players ASC;



--13. Which Club(s) are the biggest based on the number of players?

WITH ClubPlayerCounts AS (
  SELECT 
    Club, 
    COUNT(DISTINCT CASE WHEN Club <> 'No Club' THEN ID END) AS Total_Players
  FROM 
    Profile
  GROUP BY 
    Club
  HAVING 
    COUNT(CASE WHEN Club = 'No Club' THEN 1 END) = 0
)
SELECT TOP 1 WITH TIES 
  Club, 
  Total_Players
FROM 
  ClubPlayerCounts
ORDER BY 
  Total_Players DESC;


--14. Which are the Top 10 clubs in terms of wage structure?


SELECT TOP 10
    CLUB,
    SUM([Wage(€)]) AS Total_Wages
FROM
    Profile AS P
    JOIN Contract AS C ON P.ID = C.ID
GROUP BY
    Club
ORDER BY
    Total_Wages DESC;



--15. Which are the Bottom 10 clubs in terms of wage structure?

SELECT TOP 10
    CLUB,
    SUM([Wage(€)]) AS Total_Wages
FROM
    Profile AS P
    JOIN Contract AS C ON P.ID = C.ID
GROUP BY
    Club
ORDER BY
    Total_Wages;


--16. What is the Total Number of Players by Contract Type?

SELECT
    [Contract_Type],
    COUNT(DISTINCT P.ID) AS Total_Players
FROM
    Profile AS P
    JOIN Contract AS C ON P.ID = C.ID
GROUP BY
    Contract_Type
ORDER BY
    Total_Players DESC;


--17. Who are the Top 10 Players with the Longest Contract?

SELECT TOP 10
    FULL_NAME,
    CLUB,
    Contract_Type,
    (Contract_End_Date - Contract_Start_Date) AS Contract_length
FROM
    Profile AS p
    JOIN Contract AS c ON p.ID = c.ID
GROUP BY
    FULL_NAME,
    CLUB,
    Contract_Start_Date,
    Contract_End_Date,
    Contract_Type
ORDER BY
    Contract_length DESC;


--18. Who are the Top 10 Players Most Valuable Players, Whats their Contract Length and Release Clause?

SELECT TOP 10
    FULL_NAME,
    CLUB,
    Age,
    Contract_Type,
    [Value(€)],
    (Contract_End_Date - Contract_Start_Date) AS Contract_length
FROM
    Profile AS p
    JOIN Contract AS c ON p.ID = c.ID
GROUP BY
    FULL_NAME,
    CLUB,
    Age,
    Contract_Start_Date,
    Contract_End_Date,
    Contract_Type,
    [Value(€)]
ORDER BY
    [Value(€)] DESC;

--19. Who are the Top 10 Players with the Largest Release Clause?

SELECT TOP 10
    FULL_NAME,
    CLUB,
    Age,
    [Release_Clause(€)],
    Contract_Type,
    (Contract_End_Date - Contract_Start_Date) AS Contract_length
FROM
    Profile AS p
    JOIN Contract AS c ON p.ID = c.ID
GROUP BY
    FULL_NAME,
    CLUB,
    Age,
    Contract_Start_Date,
    Contract_End_Date,
    Contract_Type,
    [Release_Clause(€)]
ORDER BY
    [Release_Clause(€)] DESC;


--20. Which Players are both Top 10 Most Valuable and Top 10 with Largest Release Clause?

WITH 
MOSTVALUABLE AS 
(
    SELECT TOP 10
        FULL_NAME,
        CLUB,
        Age,
        Contract_Type,
        [Value(€)],
        (Contract_End_Date - Contract_Start_Date) AS Contract_length
    FROM
        Profile AS p
        JOIN Contract AS c ON p.ID = c.ID
    GROUP BY
        FULL_NAME,
        CLUB,
        Age,
        Contract_Start_Date,
        Contract_End_Date,
        Contract_Type,
        [Value(€)]
    ORDER BY
        [Value(€)] DESC
),
CLAUSE AS 
(
    SELECT TOP 10
        FULL_NAME,
        CLUB,
        Age,
        [Release_Clause(€)],
        Contract_Type,
        (Contract_End_Date - Contract_Start_Date) AS Contract_length
    FROM
        Profile AS p
        JOIN Contract AS c ON p.ID = c.ID
    GROUP BY
        FULL_NAME,
        CLUB,
        Age,
        Contract_Start_Date,
        Contract_End_Date,
        Contract_Type,
        [Release_Clause(€)]
    ORDER BY
        [Release_Clause(€)] DESC
)

SELECT m.FULL_NAME, m.CLUB, m.Age, m.Contract_Type, m.[Value(€)], m.Contract_length, c.[Release_Clause(€)]
FROM MOSTVALUABLE m
INNER JOIN CLAUSE c
ON m.FULL_NAME = c.FULL_NAME;

--21. Which Players are Top 10 Most Valuable but are not Top 10 with Largest Release Clause?
-- ANSWER: Change INNER JOIN on the previous query to LEFT OUTER JOIN.

--22. Which Players are not Top 10 Most Valuable but are Top 10 with Largest Release Clause?
-- ANSWER: Change INNER JOIN on the previous query to RIGHT OUTER JOIN.


--23. Which Players are the Top 10 Best Players

SELECT TOP 10 WITH TIES
    Full_Name,
    Club,
    Nationality,
    (Best_Overall_Rating * 100) AS Percent_Rating
FROM
    Profile AS p
    JOIN Rating AS r ON p.ID = r.ID
ORDER BY 
    Best_Overall_Rating DESC;


--24 Who is the Youngest Top 10 Best Player?

WITH TOP10 AS 
(SELECT TOP 10 WITH TIES
    Full_Name,
    Club,
    Age,
    Nationality,
    (Best_Overall_Rating * 100) AS Percent_Rating
FROM
    Profile AS p
    JOIN Rating AS r ON p.ID = r.ID
ORDER BY 
    Best_Overall_Rating DESC)
SELECT TOP 1 
    Full_Name,
    Club,
    Age,
    Nationality,
    Percent_Rating
FROM
    TOP10
ORDER BY 
    Age ASC;


--25. Which Players are FIFA best players by Position?.

SELECT 
    Full_Name,
    Club,
    [Best Position],
    Nationality,
    (Best_Overall_Rating * 100) AS Percent_Rating
FROM (
    SELECT 
        p.Full_Name,
        p.Club,
        p.[Best Position],
        p.Nationality,
        r.Best_Overall_Rating,
        ROW_NUMBER() OVER (PARTITION BY p.[Best Position] ORDER BY r.Best_Overall_Rating DESC) AS RowNum
    FROM Profile AS p
    JOIN Rating AS r ON p.ID = r.ID
) AS PlayerRanks
WHERE PlayerRanks.RowNum = 1
ORDER BY PlayerRanks.[Best Position], PlayerRanks.Best_Overall_Rating DESC;



--26. What are the top 10 best football clubs based on player ratings.

WITH Player_Rating AS (
    SELECT TOP 100 WITH TIES Full_Name, Club, [Best_Overall_Rating] * 100 AS Rating
    FROM Profile AS p
    JOIN Rating AS r ON p.ID = r.ID
    ORDER BY Rating DESC
)
SELECT TOP 10 Club, COUNT(Player_Rating.Club) AS Total_Players 
FROM Player_Rating 
GROUP BY Club 
ORDER BY Total_Players DESC;



--27. What are the top 10 best football nations based on player ratings.

WITH Player_Rating AS (
    SELECT TOP 100 WITH TIES Full_Name, Nationality, [Best_Overall_Rating] * 100 AS Rating
    FROM Profile AS p
    JOIN Rating AS r ON p.ID = r.ID
    ORDER BY Rating DESC
)
SELECT TOP 10 Nationality, COUNT(Player_Rating.Nationality) AS Total_Players 
FROM Player_Rating 
GROUP BY Nationality 
ORDER BY Total_Players DESC;



--28. Top 10 Club with the highest Number of Players on Loan

SELECT Top 10 with ties
     club, 
    Count(p.ID) as Total_Players
FROM
     profile as p join Contract as c on p.ID=c.ID
WHERE 
    Contract_Type= 'Loan'
GROUP BY Club 
ORDER BY Total_Players DESC;



--29. Top 10 most valuable club based on players value

SELECT TOP 10 WITH TIES 
    Club, 
    SUM([Value(€)]) AS Total_Value
FROM 
    Profile AS p
    INNER JOIN Contract AS c ON p.ID = c.ID
GROUP BY 
    Club
ORDER BY 
    Total_Value DESC;

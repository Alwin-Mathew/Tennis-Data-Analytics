-- Competitions and categories tables

-- 1) List all competitions along with their category name 
SELECT  c.competition_name AS Competition,
	   ct.category_name as Category
FROM competitions c
JOIN categories ct 
ON c.category_id = ct.category_id;

-- 2) Count the number of competitions in each category 
SELECT ct.category_name AS Category,
       COUNT(c.competition_id) AS 'No.of Competitions'
FROM competitions c
JOIN categories ct 
ON c.category_id = ct.category_id
GROUP BY ct.category_name
ORDER BY COUNT(c.competition_id) Desc;

-- 3) Find all competitions of type 'doubles' 
SELECT competition_name AS Competition
FROM competitions
WHERE type = 'doubles';

-- 4) Get competitions that belong to a specific category (e.g., ITF Men) 
SET @category := 'ITF Men'; -- Provide any category name of your choice here

SELECT c.competition_name AS Competition
FROM competitions c
JOIN categories cat 
ON c.category_id = cat.category_id
WHERE cat.category_name = @category;

-- 5) Identify parent competitions and their sub-competitions 
SELECT p.competition_name AS 'Parent Competition',
       c.competition_name AS 'Child Competition'
FROM competitions p
JOIN competitions c 
    ON p.competition_id = c.parent_id
ORDER BY p.competition_name, c.competition_name;

-- 6) Analyze the distribution of competition types by category 
SELECT cat.category_name AS Category,
	   c.type AS 'Type',
       COUNT(c.competition_id) AS 'No.of Competitions' 
FROM competitions c
JOIN categories cat 
ON c.category_id = cat.category_id
GROUP BY cat.category_name,
		 c.type
ORDER BY cat.category_name,
		 COUNT(c.competition_id) DESC;

-- 7) List all competitions with no parent (top-level competitions) 
SELECT competition_name AS 'Top-Level Competitions'
FROM competitions
WHERE parent_id IS NULL
ORDER BY competition_name ;

-- Complexes and Venues tables

-- 1) List all venues along with their associated complex name 
SELECT v.venue_name AS Venue, 
	   c.complex_name AS Complex
FROM Venues v
JOIN Complexes c 
ON v.complex_id = c.complex_id;

-- 2) Count the number of venues in each complex 
SELECT c.complex_name AS Complex,
	   COUNT(DISTINCT v.venue_id) AS 'No.of Venues'
FROM Complexes c
LEFT JOIN Venues v
ON v.complex_id = c.complex_id
GROUP BY c.complex_name
ORDER BY COUNT(DISTINCT v.venue_id) DESC;

-- 3) Get details of venues in a specific country (e.g., Chile) 
SET @Country := 'Chile'; -- Provide any Country name of your choice here (eg: 'Spain')

SELECT v.venue_name AS 'Venue Name',
	   v.city_name AS City,
       v.TimeZone,
	   c.complex_name AS Complex
FROM Venues v
LEFT JOIN Complexes c 
ON v.complex_id = c.complex_id
WHERE v.country_name = @Country;

-- 4) Identify all venues and their timezones 
SELECT Venue_name AS Venue, 
	   TimeZone 
FROM Venues;

-- 5) Find complexes that have more than one venue 
SELECT c.complex_name AS Complex,
	   COUNT(DISTINCT v.venue_id) AS 'No.of Venues'
FROM Complexes c
JOIN Venues v
ON v.complex_id = c.complex_id
GROUP BY c.complex_name
HAVING COUNT(DISTINCT v.venue_id) > 1 ;

-- 6) List venues grouped by country 
-- a> If you want names of Venues based on country
SELECT country_name AS Country, 
	   venue_name AS Venue
FROM Venues
ORDER BY country_name;

-- b> If you want count of Venues based on country
SELECT country_name AS Country, 
	   COUNT(DISTINCT venue_ID) AS 'No.of Venues'
FROM Venues
GROUP BY country_name;

-- 7) Find all venues for a specific complex (e.g., Nacional)
SET @Complex := 'Nacional'; -- Provide any Complex name of your choice here (eg: 'Club Tennis Vic')

SELECT v.Venue_name AS Venue
FROM Complexes c
LEFT JOIN Venues v
ON v.complex_id = c.complex_id
WHERE c.complex_name  =  @Complex ;

-- Competitor_rankings and Competitors tables

-- 1) Get all competitors with their rank and points.
SELECT c.name AS Competitor, 
	   cr.Rank, 
       cr.Points
FROM Competitors c
JOIN Competitor_Rankings cr 
ON c.competitor_id = cr.competitor_id
ORDER BY cr.Points DESC;
 
-- 2) Find competitors ranked in the top 5 
-- a> If you are looking for Competitors within the Top 5 rank
SELECT c.name AS Competitor, 
	   cr.Rank, 
       cr.Points
FROM Competitors c
JOIN Competitor_Rankings cr 
ON c.competitor_id = cr.competitor_id
WHERE cr.rank <= 5
ORDER BY cr.rank ASC,
		 cr.Points DESC;

-- b> If you are looking for Top 5 Competitors 
SELECT c.name AS Competitor, 
	   cr.Rank, 
       cr.Points
FROM Competitors c
JOIN Competitor_Rankings cr 
ON c.competitor_id = cr.competitor_id
ORDER BY cr.Points DESC
LImit 5;

-- 3) List competitors with no rank movement (stable rank) 
SELECT c.name AS Competitor
FROM Competitors c
JOIN Competitor_Rankings cr 
ON c.competitor_id = cr.competitor_id
WHERE cr.movement = 0 ;

-- 4) Get the total points of competitors from a specific country (e.g., Croatia)
SET @Country := 'Croatia'; -- Provide any Country name of your choice here (eg: 'Spain')
 
SELECT c.Country, 
       SUM(cr.Points) AS 'Total Points'
FROM Competitors c
JOIN Competitor_Rankings cr 
ON c.competitor_id = cr.competitor_id
WHERE c.Country = @Country ;

-- 5) Count the number of competitors per country 
SELECT c.Country, 
	   COUNT(c.competitor_id) AS 'No.of Competitors'
FROM Competitors c
GROUP BY c.Country
ORDER BY COUNT(c.competitor_id) DESC;

-- 6) Find competitors with the highest points in the current week 
-- There is no date or week info in any of the tables. So assuming that the Competitor_Rankings table has the latest week's numbers.
 
SELECT c.name AS Competitor, 
	   cr.Rank, 
       cr.Points
FROM Competitors c
JOIN Competitor_Rankings cr 
ON c.competitor_id = cr.competitor_id
ORDER BY cr.Points DESC
LImit 1;

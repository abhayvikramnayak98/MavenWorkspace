-- Category - A
-- Find the number of vehicles stolen each year
SELECT year(date_stolen) as stolen_year, count(*) as vehicles_stolen
FROM stolen_vehicles
GROUP BY stolen_year;

-- Find the number of vehicles stolen each month
SELECT year(date_stolen) as stolen_year, month(date_stolen) as stolen_month, count(*) as vehicles_stolen
FROM stolen_vehicles
GROUP BY stolen_year, stolen_month
ORDER BY stolen_year, stolen_month;

-- Find the number of vehicles stolen each day of the week
SELECT dayofweek(date_stolen) as dow, count(*) as vehicles_stolen
FROM stolen_vehicles
GROUP BY dow
ORDER BY dow;

-- Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)
SELECT 
	dayofweek(date_stolen) as dow, 
    CASE 
	WHEN dayofweek(date_stolen) = 1 THEN 'Sunday'
	WHEN dayofweek(date_stolen) = 2 THEN 'Monday'
	WHEN dayofweek(date_stolen) = 3 THEN 'Tuesday'
	WHEN dayofweek(date_stolen) = 4 THEN 'Wednesday'
	WHEN dayofweek(date_stolen) = 5 THEN 'Thursday'
	WHEN dayofweek(date_stolen) = 6 THEN 'Friday'
	ELSE 'Saturday'
	END AS day_of_week,
    count(*) as vehicles_stolen
FROM stolen_vehicles
GROUP BY dow, day_of_week
ORDER BY dow;

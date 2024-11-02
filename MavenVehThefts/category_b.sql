-- Category - B
-- Find the vehicle types that are most often and least often stolen
SELECT vehicle_type, COUNT(vehicle_id) as num_vehicles FROM stolen_vehicles GROUP BY vehicle_type ORDER BY num_vehicles DESC LIMIT 5;

SELECT vehicle_type, COUNT(vehicle_id) as num_vehicles FROM stolen_vehicles GROUP BY vehicle_type ORDER BY num_vehicles ASC LIMIT 5;

-- For each vehicle type, find the average age of the cars that are stolen
SELECT vehicle_type, round(avg(year(date_stolen) - model_year)) as avg_age FROM stolen_vehicles GROUP BY vehicle_type ORDER BY avg_age DESC;

-- For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
WITH lux_standard AS (
	SELECT vehicle_type, CASE WHEN make_type = 'Luxury' THEN 1 ELSE 0 END AS luxury, 1 AS all_cars
    FROM stolen_vehicles sv JOIN make_details md ON md.make_id = sv.make_id
)
SELECT 
vehicle_type, 
round(SUM(luxury) * 100.0 / SUM(all_cars), 2) AS pct_lux
FROM lux_standard 
GROUP BY vehicle_type 
HAVING vehicle_type IS NOT NULL 
ORDER BY pct_lux DESC;

-- Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen

SELECT color, COUNT(vehicle_id) AS num_veh FROM stolen_vehicles
GROUP BY color ORDER BY num_veh DESC LIMIT 7;

SELECT 
	vehicle_type,
    COUNT(vehicle_id) AS num_veh,
    SUM(CASE WHEN color = 'Silver' THEN 1 ELSE 0 END) as Silver,
    SUM(CASE WHEN color = 'White' THEN 1 ELSE 0 END) as White,
    SUM(CASE WHEN color = 'Black' THEN 1 ELSE 0 END) as Black,
    SUM(CASE WHEN color = 'Blue' THEN 1 ELSE 0 END) as Blue,
    SUM(CASE WHEN color = 'Red' THEN 1 ELSE 0 END) as Red,
    SUM(CASE WHEN color = 'Grey' THEN 1 ELSE 0 END) as Grey,
    SUM(CASE WHEN color = 'Green' THEN 1 ELSE 0 END) as Green,
    SUM(CASE WHEN color NOT IN ('Silver','White','Black','Blue','Red','Grey','Green') THEN 1 ELSE 0 END) as Other
FROM stolen_vehicles
GROUP BY vehicle_type
HAVING vehicle_type IS NOT NULL
ORDER BY num_veh DESC
LIMIT 10;

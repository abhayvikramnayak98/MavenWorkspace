-- Category - C
-- Find the number of vehicles that were stolen in each region
SELECT 
	region, COUNT(vehicle_id) as num_veh
FROM stolen_vehicles sv JOIN locations lc ON sv.location_id = lc.location_id
GROUP BY region;

-- Combine the previous output with the population and density statistics for each region
SELECT 
	region, COUNT(vehicle_id) as num_veh, population, density
FROM stolen_vehicles sv JOIN locations lc ON sv.location_id = lc.location_id
GROUP BY region, population, density
ORDER BY density DESC, num_veh ASC;

-- Do the types of vehicles stolen in the three most dense regions differ from the three least dense regions?

WITH reg_s AS (
    SELECT 
        region, COUNT(vehicle_id) AS num_veh, population, density
    FROM stolen_vehicles sv 
    JOIN locations lc ON sv.location_id = lc.location_id
    GROUP BY region, population, density
    ORDER BY density DESC, num_veh ASC
), 
-- First, get the top 3 high-density regions
top3_regions AS (
    SELECT region 
    FROM reg_s 
    ORDER BY density DESC 
    LIMIT 3
),
-- First, get the top 3 low-density regions
low3_regions AS (
    SELECT region 
    FROM reg_s 
    ORDER BY density 
    LIMIT 3
),
-- Get data for the top 3 high-density regions
top3_dense_reg AS (
    SELECT 
        'High Density' AS status, 
        sv.vehicle_type, 
        COUNT(sv.vehicle_id) AS num_veh 
    FROM stolen_vehicles sv 
    JOIN locations lc ON sv.location_id = lc.location_id 
    JOIN top3_regions tr ON lc.region = tr.region
    GROUP BY sv.vehicle_type 
    HAVING sv.vehicle_type IS NOT NULL
    ORDER BY num_veh DESC
),
-- Get data for the top 3 low-density regions
low3_dense_reg AS (
    SELECT 
        'Low Density' AS status, 
        sv.vehicle_type, 
        COUNT(sv.vehicle_id) AS num_veh 
    FROM stolen_vehicles sv 
    JOIN locations lc ON sv.location_id = lc.location_id 
    JOIN low3_regions lr ON lc.region = lr.region
    GROUP BY sv.vehicle_type 
    HAVING sv.vehicle_type IS NOT NULL
    ORDER BY num_veh DESC
)
-- Combine the results
SELECT * FROM top3_dense_reg 
UNION 
SELECT * FROM low3_dense_reg;

-- Create a scatter plot of population versus density, and change the size of the points based on the number of vehicles stolen in each region

-- Create a map of the regions and color the regions based on the number of stolen vehicles
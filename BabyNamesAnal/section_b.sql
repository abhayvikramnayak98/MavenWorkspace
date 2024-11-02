-- Section - B
-- For each year, return the 3 most popular girl names and 3 most popular boy names.

WITH ranked_names AS (
    SELECT year, name, 
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY SUM(births) DESC) AS rank_pop
    FROM names
    WHERE gender = 'F'
    GROUP BY year, name
)
SELECT year, name, rank_pop
FROM ranked_names
WHERE rank_pop <= 3;

WITH ranked_names AS (
    SELECT year, name, 
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY SUM(births) DESC) AS rank_pop
    FROM names
    WHERE gender = 'M'
    GROUP BY year, name
)
SELECT year, name, rank_pop
FROM ranked_names
WHERE rank_pop <= 3;

-- For each decade, return the 3 most popular girl names and 3 most popular boy names.

WITH ranked_names AS (
    SELECT FLOOR(year / 10) * 10 AS decade, name, 
           ROW_NUMBER() OVER (PARTITION BY FLOOR(year / 10) * 10 ORDER BY SUM(births) DESC) AS rank_pop
    FROM names
    WHERE gender = 'F'
    GROUP BY decade, name
)
SELECT decade, name, rank_pop
FROM ranked_names
WHERE rank_pop <= 3;

WITH ranked_names AS (
    SELECT FLOOR(year / 10) * 10 AS decade, name, 
           ROW_NUMBER() OVER (PARTITION BY FLOOR(year / 10) * 10 ORDER BY SUM(births) DESC) AS rank_pop
    FROM names
    WHERE gender = 'M'
    GROUP BY decade, name
)
SELECT decade, name, rank_pop
FROM ranked_names
WHERE rank_pop <= 3;


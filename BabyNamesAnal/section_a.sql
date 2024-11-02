-- Section-A
-- Find the overall most popular girl and boy names and show how they have changed in popularity rankings over the years

SELECT Name, sum(Births) as num_births 
FROM names WHERE Gender = 'F' 
GROUP BY Name
order by num_births DESC
LIMIT 1;

SELECT Name, sum(Births) as num_births 
FROM names WHERE Gender = 'M' 
GROUP BY Name
order by num_births DESC
LIMIT 1;

WITH girl_names AS (
    SELECT year, name, SUM(births) AS num_births
    FROM names
    WHERE gender = 'F'
    GROUP BY year, name
),
ranked_girl_names AS (
    SELECT year, name,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY num_births DESC) AS rank_pop
    FROM girl_names
),
most_popular_name AS (
    SELECT name
    FROM names
    WHERE gender = 'F'
    GROUP BY name
    ORDER BY SUM(births) DESC
    LIMIT 1
)
SELECT *
FROM ranked_girl_names
WHERE name IN (SELECT name FROM most_popular_name);

WITH boy_names AS (
    SELECT year, name, SUM(births) AS num_births
    FROM names
    WHERE gender = 'M'
    GROUP BY year, name
),
ranked_boy_names AS (
    SELECT year, name,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY num_births DESC) AS rank_pop
    FROM boy_names
),
most_popular_name AS (
    SELECT name
    FROM names
    WHERE gender = 'M'
    GROUP BY name
    ORDER BY SUM(births) DESC
    LIMIT 1
)
SELECT *
FROM ranked_boy_names
WHERE name IN (SELECT name FROM most_popular_name);

-- Find the names with the biggest jumps in popularity from the first year of the data set to the last year.
WITH names_min_year as
(WITH all_names AS (select year, name, sum(births) as num_births from names group by year, name)
SELECT year, name,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY num_births DESC) AS rank_pop
from all_names
WHERE year IN (SELECT min(year) from names)),
names_max_year AS (WITH all_names AS (select year, name, sum(births) as num_births from names group by year, name)
SELECT year, name,
           ROW_NUMBER() OVER (PARTITION BY year ORDER BY num_births DESC) AS rank_pop
from all_names
WHERE year IN (SELECT max(year) from names))
SELECT 
	t1.year, t1.name, t1.rank_pop,
    t2.year, t2.name, t2.rank_pop, 
    CAST(t2.rank_pop AS signed) - CAST(t1.rank_pop AS signed) as diff_pop
from names_min_year t1 INNER JOIN names_max_year t2 ON t1.name = t2.name ORDER BY diff_pop;
-- Section - D
-- Find the 10 most popular androgynous names (names given to both females and males).
SELECT Name, COUNT(DISTINCT Gender) as num_andro, SUM(Births) as num_babies
FROM names 
GROUP BY Name 
HAVING num_andro = 2
ORDER BY num_babies DESC LIMIT 10;

-- Find the length of the shortest and longest names, and identify the most popular short names (those with the fewest characters) and long names (those with the most characters).
WITH name_lenRec AS (
    SELECT Name, LENGTH(Name) AS name_len
    FROM names
    GROUP BY Name
)
SELECT * 
FROM name_lenRec
WHERE name_len IN (
    (SELECT MIN(name_len) FROM name_lenRec),
    (SELECT MAX(name_len) FROM name_lenRec)
);

WITH short_long_names AS (SELECT * FROM names WHERE length(name) IN ((SELECT min(length(name)) FROM names), (SELECT max(length(name)) FROM names)))
SELECT Name, SUM(Births) as num_b FROM short_long_names GROUP BY Name ORDER BY num_b DESC;

-- The founder of Maven Analytics is named Chris. Find the state with the highest percent of babies named "Chris".
with chris_rec as (SELECT state, sum(births) as num_chris FROM names WHERE name = 'Chris' GROUP BY state),
babies_rec as (SELECT state, sum(births) as num_babies FROM names GROUP BY state)
SELECT c.state, c.num_chris/ b.num_babies * 100.0  AS chris_pct FROM chris_rec c INNER JOIN babies_rec b ON c.state = b.state ORDER BY chris_pct DESC;
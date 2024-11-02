-- Section - C
-- Return the number of babies born in each of the six regions (NOTE: The state of MI should be in the Midwest region).
WITH clean_reg as (
SELECT state,
		case when region = 'New England' then 'New_England' else region end as clean_region
FROM regions
UNION
SELECT 'MI' as state, 'Midwest' as clean_region)
select c.clean_region, sum(n.Births) as num_b from names n left join clean_reg c on n.state = c.state group by c.clean_region;

-- Return the 3 most popular girl names and 3 most popular boy names within each region.
WITH clean_reg AS (
    SELECT state, 
           CASE 
               WHEN region = 'New England' THEN 'New_England' 
               ELSE region 
           END AS clean_region 
    FROM regions 
    UNION 
    SELECT 'MI' AS state, 'Midwest' AS clean_region
),
babies_per_reg AS (
    SELECT c.clean_region, 
           n.Gender, 
           n.Name, 
           SUM(n.Births) AS num_b 
    FROM names n 
    LEFT JOIN clean_reg c ON n.state = c.state 
    GROUP BY c.clean_region, n.Gender, n.Name
)
SELECT clean_region, 
       Gender,
       Name, 
       rank_reg_pop 
FROM (
    SELECT clean_region, 
           Gender,
           Name, 
           ROW_NUMBER() OVER (PARTITION BY clean_region, Gender ORDER BY num_b DESC) AS rank_reg_pop 
    FROM babies_per_reg
) AS ranked_babies 
WHERE rank_reg_pop <= 3
ORDER BY clean_region, Gender, rank_reg_pop;
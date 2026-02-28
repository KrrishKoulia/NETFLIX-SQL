-- NETFLIX PROJECT

DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix (
    show_id VARCHAR(10),
    type VARCHAR(10),
    title VARCHAR(150),
    director VARCHAR(250),
    casts VARCHAR(1000),
    country VARCHAR(150),
    date_added VARCHAR(25),
    release_year INT,
    rating VARCHAR(15),
    duration VARCHAR(15),
    listed_in VARCHAR(100),
    description VARCHAR(250)
);

SELECT * FROM netflix;

SELECT COUNT (*) AS total_content
FROM netflix;

SELECT DISTINCT type FROM netflix;

---15 Business Problems

-- 1. Count the number of Movies vs TV Shows..

SELECT 
	type,count(*) as total_count
FROM netflix
GROUP BY type

-- 2. Find the most common rating from movies and TV shows..

SELECT 
    type,
    rating,
    count
FROM 
(
    SELECT 
        type,
        rating,
        COUNT(*) as count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
    FROM netflix
    GROUP BY type, rating
) as t1
WHERE 
    ranking = 1;

--3. List all moveis released in a specific yer (eg. 2020) ..


SELECT *
FROM netflix
WHERE type = 'Movie' 
AND release_year = 2020;

--4. Find the Top 5 countries with the most content on Netflix ..

SELECT 
    TRIM(unnest(string_to_array(country, ','))) as individual_country,
    COUNT(*) as total_content
FROM netflix
WHERE country IS NOT NULL AND country != ''
GROUP BY individual_country
ORDER BY total_content DESC
LIMIT 5;

--5. Identify the longest movie ..

SELECT 
    title,
    duration
FROM netflix
WHERE type = 'Movie' 
  AND duration IS NOT NULL
ORDER BY CAST(REPLACE(duration, ' min', '') AS INTEGER) DESC
LIMIT 10;

--6. Find the content added in the last 5 years ..

SELECT * FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--7. Find all the movies /TV Shows by director 'Rajiv Chilaka'..

SELECT title , DIRECTOR FROM NETFLIX
WHERE director ILIKE  '%Rajiv Chilaka%';

--8. List all TV Shows with more than 5 seasons..

SELECT * 
FROM netflix
WHERE type = 'TV Show'
AND SPLIT_PART(duration, ' ', 1)::numeric > 5;

--9. Count the number of content items in each genre..

SELECT 
    TRIM(unnest(string_to_array(listed_in, ','))) as individual_listed_in,
    COUNT(*) as total_content
FROM netflix
GROUP BY individual_listed_in
ORDER BY total_content DESC;

--10. Find each year and the average numbers of content realeased By India on netflix return top 5 year with highest avg content release..
SELECT 
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
    COUNT(*) as total_count,
    ROUND(COUNT(*)::numeric / (SELECT COUNT(*) FROM netflix WHERE country ILIKE '%India%') * 100, 2) AS avg_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY year
ORDER BY year;

--11. List all movies that are documentaries..

SELECT * FROM NETFLIX
WHERE listed_in ILIKE '%documentaries%';

--12. Find all content wihtout a director

SELECT * FROM NETFLIX
WHERE DIRECTOR IS NULL;

--13.Find how many movies actor 'Salman Khan' appeared in last 10 years..

SELECT 
    title,
    release_year,
    casts
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
  AND type = 'Movie'
  AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10
ORDER BY release_year DESC;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India..

SELECT
	TRIM(UNNEST(STRING_TO_ARRAY(casts,','))) AS individual_actor,
	count(*) as total_count
FROM NETFLIX
WHERE country ILIKE '%India%'
AND type = 'Movie'
GROUP BY individual_actor
ORDER BY total_count DESC
LIMIT 10;

--15. Categorize the content based on the present of th keywords 'kill' and 'violence' the description field , Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many times fall into each catgory.

SELECT 
    CASE 
        WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS category,
    COUNT(*) AS content_count
FROM netflix
GROUP BY category;

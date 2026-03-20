-- Quick Insights - Netflix Data

-- Top 5 genres
SELECT 
    TRIM(unnest(string_to_array(listed_in, ','))) as genre,
    COUNT(*) as count
FROM netflix
GROUP BY genre
ORDER BY count DESC
LIMIT 5;

-- Content by rating
SELECT rating, COUNT(*) as count
FROM netflix
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY count DESC;

-- Movies vs TV shows by year
SELECT 
    release_year,
    COUNT(CASE WHEN type = 'Movie' THEN 1 END) as movies,
    COUNT(CASE WHEN type = 'TV Show' THEN 1 END) as tv_shows
FROM netflix
WHERE release_year >= 2010
GROUP BY release_year
ORDER BY release_year DESC;

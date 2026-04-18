-- ================================================
-- ANIME POPULARITY ANALYSIS
-- Author: Your Name
-- Date: March 2026
-- Database: anime_db
-- Tables: anime, ratings
-- ================================================

USE anime_db;

-- ================================================
-- QUERY 1: Top 10 Highest Rated Anime
-- ================================================
SELECT name, type, rating, members
FROM anime
ORDER BY rating DESC
LIMIT 10;

-- ================================================
-- QUERY 2: Top 10 Most Popular Anime by Members
-- ================================================
SELECT name, type, members, rating
FROM anime
ORDER BY members DESC
LIMIT 10;

-- ================================================
-- QUERY 3: Average Rating by Anime Type
-- ================================================
SELECT type,
       COUNT(*)             AS total,
       ROUND(AVG(rating),2) AS avg_rating,
       ROUND(MIN(rating),2) AS min_rating,
       ROUND(MAX(rating),2) AS max_rating
FROM anime
GROUP BY type
ORDER BY avg_rating DESC;

-- ================================================
-- QUERY 4: Count of Anime per Popularity Tier
-- ================================================
SELECT popularity_tier,
       COUNT(*)             AS total,
       ROUND(AVG(rating),2) AS avg_rating,
       ROUND(AVG(members))  AS avg_members
FROM anime
GROUP BY popularity_tier
ORDER BY total DESC;

-- ================================================
-- QUERY 5: Count of Anime per Episode Bucket
-- ================================================
SELECT episode_bucket,
       COUNT(*)             AS total,
       ROUND(AVG(rating),2) AS avg_rating
FROM anime
GROUP BY episode_bucket
ORDER BY total DESC;

-- ================================================
-- QUERY 6: Anime Above Average Rating
-- ================================================
SELECT name, type, rating, members
FROM anime
WHERE rating > (SELECT AVG(rating) FROM anime)
ORDER BY rating DESC
LIMIT 20;

-- ================================================
-- QUERY 7: JOIN — Anime with Avg User Rating
-- ================================================
SELECT a.name,
       a.type,
       a.rating                AS anime_rating,
       ROUND(AVG(r.rating),2)  AS avg_user_rating,
       COUNT(r.user_id)        AS total_user_ratings
FROM ratings r
JOIN anime a ON r.anime_id = a.anime_id
GROUP BY a.name, a.type, a.rating
ORDER BY avg_user_rating DESC
LIMIT 20;

-- ================================================
-- QUERY 8: JOIN — Rating Difference
-- ================================================
SELECT a.name,
       a.rating                          AS anime_rating,
       ROUND(AVG(r.rating),2)            AS avg_user_rating,
       ROUND(a.rating - AVG(r.rating),2) AS difference
FROM ratings r
JOIN anime a ON r.anime_id = a.anime_id
GROUP BY a.name, a.rating
ORDER BY difference DESC
LIMIT 20;

-- ================================================
-- QUERY 9: Window Function — Top 3 Anime per Type
-- ================================================
SELECT * FROM (
    SELECT name, type, rating, members,
           RANK() OVER (PARTITION BY type ORDER BY rating DESC) AS rnk
    FROM anime
) ranked
WHERE rnk <= 3
ORDER BY type, rnk;

-- ================================================
-- QUERY 10: Window Function — Percentile Rank
-- ================================================
SELECT name, type, rating,
       ROUND(PERCENT_RANK() OVER (ORDER BY rating) * 100, 2) AS percentile
FROM anime
ORDER BY percentile DESC
LIMIT 20;

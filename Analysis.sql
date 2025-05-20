-- Updating the caption for post id = 3
UPDATE posts 
SET caption = 'Delicious pizza and drinks' 
WHERE post_id = 3;

-- Get all the posts and order by created date in descending order
SELECT * FROM posts 
ORDER BY created_at DESC;

-- Which posts had 2 or more likes
SELECT posts.post_id, COUNT(likes.like_id) as post_likes  
FROM posts
JOIN likes ON posts.post_id = likes.post_id
GROUP BY posts.post_id
HAVING COUNT(likes.like_id) >= 2;

-- All users who have commented on Post id 1
SELECT name, email FROM users WHERE user_id IN (
	SELECT user_id from comments WHERE post_id = 1);

-- Rank posts based on number of likes (using sub query)
SELECT post_id, post_likes, DENSE_RANK() OVER(ORDER BY post_likes DESC) as ranking
FROM (
SELECT p.post_id, COUNT(l.like_id) as post_likes  
FROM posts as p
JOIN likes as l ON p.post_id = l.post_id
GROUP BY p.post_id
);

-- Rank posts based on number of likes (using CTE)
WITH cte AS (
SELECT p.post_id, COUNT(l.post_id) as post_likes  
FROM posts as p
JOIN likes as l ON l.post_id = p.post_id
GROUP BY p.post_id
) 
SELECT 
post_id, 
post_likes,
DENSE_RANK() OVER(ORDER BY post_likes) as ranking
FROM cte;

-- All posts and their comments
SELECT p.post_id, p.caption, c.comment_text FROM posts as p
LEFT JOIN comments as c ON c.post_id = p.post_id;

-- Categorizing the posts based on the number of likes
With likes_cte AS (
SELECT p.post_id, COUNT(l.post_id) as like_count
FROM posts as p
JOIN likes as l ON l.post_id = p.post_id
GROUP BY p.post_id
)

SELECT post_id, like_count, 
CASE WHEN like_count <= 2 THEN 'Low Likes'
WHEN like_count > 2 THEN 'High Likes'
ELSE 'no data'
END as like_category
FROM likes_cte;

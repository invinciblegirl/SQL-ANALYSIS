USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 
    'movie' AS table_name, COUNT(*) AS total_rows 
FROM 
    movie
UNION ALL
SELECT 
    'genre' AS table_name, COUNT(*) AS total_rows 
FROM 
    genre
UNION ALL
SELECT 
    'director_mapping' AS table_name, COUNT(*) AS total_rows 
FROM 
    director_mapping
UNION ALL
SELECT 
    'role_mapping' AS table_name, COUNT(*) AS total_rows 
FROM 
    role_mapping
UNION ALL
SELECT 
    'names' AS table_name, COUNT(*) AS total_rows 
FROM 
    names
UNION ALL
SELECT 
    'ratings' AS table_name, COUNT(*) AS total_rows 
FROM 
    ratings;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT 
    SUM(CASE
        WHEN id IS NULL THEN 1
        ELSE 0
    END) AS ID_NULL_COUNT,
    SUM(CASE
        WHEN title IS NULL THEN 1
        ELSE 0
    END) AS title_NULL_COUNT,
    SUM(CASE
        WHEN year IS NULL THEN 1
        ELSE 0
    END) AS year_NULL_COUNT,
    SUM(CASE
        WHEN date_published IS NULL THEN 1
        ELSE 0
    END) AS date_published_NULL_COUNT,
    SUM(CASE
        WHEN duration IS NULL THEN 1
        ELSE 0
    END) AS duration_NULL_COUNT,
    SUM(CASE
        WHEN country IS NULL THEN 1
        ELSE 0
    END) AS country_NULL_COUNT,
    SUM(CASE
        WHEN worlwide_gross_income IS NULL THEN 1
        ELSE 0
    END) AS worlwide_gross_income_NULL_COUNT,
    SUM(CASE
        WHEN languages IS NULL THEN 1
        ELSE 0
    END) AS languages_NULL_COUNT,
    SUM(CASE
        WHEN production_company IS NULL THEN 1
        ELSE 0
    END) AS production_company_NULL_COUNT

from movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT 
    year AS Year, COUNT(*) AS number_of_movies
FROM 
    movie
GROUP BY 
    year
ORDER BY 
    year;
    
   SELECT 
    MONTH(date_published) AS month_num, COUNT(*) AS number_of_movies
FROM 
    movie
WHERE 
    date_published IS NOT NULL
GROUP BY 
    month_num
ORDER BY 
    month_num; 

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(DISTINCT id) AS Number_Of_Movies
FROM movie
WHERE (country LIKE "%india%" OR country LIKE "%usa%")
AND year = 2019;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT 
    DISTINCT genre
FROM 
    genre
ORDER BY 
    genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
    g.genre, COUNT(m.id) AS number_of_movies
FROM 
    genre g
JOIN 
    movie m ON g.movie_id = m.id
GROUP BY 
    g.genre
ORDER BY 
    number_of_movies DESC
LIMIT 1;



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT 
    COUNT(*) AS number_of_movies_with_one_genre
FROM 
    (SELECT 
         movie_id
     FROM 
         genre
     GROUP BY 
         movie_id
     HAVING 
         COUNT(genre) = 1) AS single_genre_movies;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre,Round( AVG(m.duration),2) AS avg_duration
FROM 
    genre g
JOIN 
    movie m ON g.movie_id = m.id
GROUP BY 
    g.genre
ORDER BY 
    avg_duration DESC;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

WITH Ranking_Of_Genre AS(
SELECT genre, COUNT(genre) AS movie_count, 
RANK() OVER(ORDER BY COUNT(genre) DESC) as genre_rank
FROM genre
GROUP BY genre)
SELECT * FROM Ranking_Of_Genre
WHERE genre="thriller";

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating, 
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes, 
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating, 
    MAX(median_rating) AS max_median_rating
FROM 
    ratings;



/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH RankedMovies AS (
    SELECT 
        m.title, 
        r.avg_rating,
        RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
    FROM 
        movie m
    JOIN 
        ratings r ON m.id = r.movie_id
)
SELECT 
    title, 
    avg_rating, 
    movie_rank
FROM 
    RankedMovies
WHERE 
    movie_rank <= 10
ORDER BY 
    movie_rank;

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT 
    median_rating, 
    COUNT(*) AS movie_count
FROM 
    ratings
GROUP BY 
    median_rating
ORDER BY 
    median_rating;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH HitMovies AS (
    SELECT 
        m.production_company,
        COUNT(*) AS movie_count
    FROM 
        movie m
    JOIN 
        ratings r ON m.id = r.movie_id
    WHERE 
        r.avg_rating > 8
        AND m.production_company IS NOT NULL
    GROUP BY 
        m.production_company
),
RankedProductionCompanies AS (
    SELECT 
        production_company,
        movie_count,
        RANK() OVER (ORDER BY movie_count DESC) AS prod_company_rank
    FROM 
        HitMovies
)
SELECT 
    production_company, 
    movie_count, 
    prod_company_rank
FROM 
    RankedProductionCompanies
WHERE 
    prod_company_rank = 1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    g.genre, 
    COUNT(*) AS movie_count
FROM 
    genre g
JOIN 
    movie m ON g.movie_id = m.id
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.country = 'USA'
    AND m.date_published BETWEEN '2017-03-01' AND '2017-03-31'
    AND r.total_votes > 1000
GROUP BY 
    g.genre
ORDER BY 
    movie_count DESC;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title, r.avg_rating, g.genre
FROM
    movie AS m
        INNER JOIN
    genre AS g ON g.movie_id = m.id
        INNER JOIN
    ratings AS r ON r.movie_id = m.id
WHERE
    r.avg_rating > 8 AND m.title LIKE 'THE%'
ORDER BY r.avg_rating DESC;
SELECT 
    title, avg_rating, genre
FROM
    genre AS g
        INNER JOIN
    ratings AS r ON g.movie_id = r.movie_id
        INNER JOIN
    movie AS m ON m.id = g.movie_id
WHERE
    title LIKE 'The%' AND avg_rating > 8
ORDER BY avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
    COUNT(*) AS movie_count
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
    AND r.median_rating = 8;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
SELECT 
    m.country, 
    SUM(r.total_votes) AS total_votes
FROM 
    movie m
JOIN 
    ratings r ON m.id = r.movie_id
WHERE 
    m.country IN ('Germany', 'Italy')
GROUP BY 
    m.country;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM 
    names;
/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH TopGenres AS (
    SELECT genre, COUNT(*) AS movie_count
    FROM movie
    JOIN genre ON movie.id = genre.movie_id
    JOIN ratings ON movie.id = ratings.movie_id
    WHERE ratings.avg_rating > 8
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),
TopDirectors AS (
    SELECT director_mapping.name_id, COUNT(*) AS movie_count
    FROM movie
    JOIN genre ON movie.id = genre.movie_id
    JOIN ratings ON movie.id = ratings.movie_id
    JOIN director_mapping ON movie.id = director_mapping.movie_id
    WHERE ratings.avg_rating > 8 AND genre.genre IN (SELECT genre FROM TopGenres)
    GROUP BY director_mapping.name_id
    ORDER BY movie_count DESC
    LIMIT 3
)
SELECT names.name AS director_name, TopDirectors.movie_count
FROM TopDirectors
JOIN names ON TopDirectors.name_id = names.id
ORDER BY TopDirectors.movie_count DESC;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH actor_movie_ratings AS (
    SELECT
        nm.name AS actor_name,
        m.id AS movie_id,
        r.median_rating
    FROM
        role_mapping rm
        JOIN names nm ON rm.name_id = nm.id
        JOIN movie m ON rm.movie_id = m.id
        JOIN ratings r ON m.id = r.movie_id
),
actor_median_ratings AS (
    SELECT
        actor_name,
        COUNT(DISTINCT movie_id) AS movie_count
    FROM
        actor_movie_ratings
    WHERE
        median_rating >= 8
    GROUP BY
        actor_name
    ORDER BY
        movie_count DESC
    LIMIT 2
)
SELECT
    *
FROM
    actor_median_ratings;

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    production_company, 
    SUM(total_votes) AS vote_count,
    RANK() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM 
    movie
JOIN 
    ratings ON movie.id = ratings.movie_id
GROUP BY 
    production_company
ORDER BY 
    vote_count DESC
LIMIT 3;








/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_movie_ratings AS (
    SELECT 
        n.name AS actor_name,
        COUNT(r.movie_id) AS movie_count,
        SUM(r.total_votes) AS total_votes,
        ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating
    FROM 
        role_mapping rm
    JOIN 
        names n ON rm.name_id = n.id
    JOIN 
        movie m ON rm.movie_id = m.id
    JOIN 
        ratings r ON m.id = r.movie_id
    WHERE 
        m.country = 'India'
    GROUP BY 
        n.name
    HAVING 
        COUNT(r.movie_id) >= 5
),
actor_ranking AS (
    SELECT 
        actor_name,
        total_votes,
        movie_count,
        actor_avg_rating,
        RANK() OVER (ORDER BY actor_avg_rating DESC, total_votes DESC) AS actor_rank
    FROM 
        actor_movie_ratings
)
SELECT 
    actor_name,
    total_votes,
    movie_count,
    actor_avg_rating,
    actor_rank
FROM 
    actor_ranking
ORDER BY 
    actor_rank;




-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

/*type your code here*/
WITH actress_movie_stats AS (
    SELECT 
        n.name AS actress_name,
        COUNT(*) AS movie_count,
        SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) AS weighted_avg_rating,
        SUM(r.total_votes) AS total_votes
    FROM 
        movie m
        JOIN role_mapping rm ON m.id = rm.movie_id
        JOIN names n ON rm.name_id = n.id
        JOIN ratings r ON m.id = r.movie_id
    WHERE 
        rm.category = 'actress' AND
        m.country = 'India' AND
        m.languages LIKE '%Hindi%'
    GROUP BY 
        n.name
    HAVING 
        COUNT(*) >= 3
),
ranked_actresses AS (
    SELECT 
        actress_name,
        total_votes,
        movie_count,
        ROUND(weighted_avg_rating, 2) AS weighted_avg_rating,
        ROW_NUMBER() OVER (ORDER BY weighted_avg_rating DESC, total_votes DESC) AS actress_rank
    FROM 
        actress_movie_stats
)
SELECT
    actress_name,
    total_votes,
    movie_count,
    weighted_avg_rating AS actress_avg_rating,
    actress_rank
FROM 
    ranked_actresses
WHERE 
    actress_rank <= 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
WITH thriller_movies AS (
    SELECT
        m.title AS movie_title,
        AVG(r.avg_rating) AS avg_rating
    FROM
        movie m
        JOIN genre g ON m.id = g.movie_id
        JOIN ratings r ON m.id = r.movie_id
    WHERE
        g.genre = 'Thriller'
    GROUP BY
        m.id
)
SELECT
    movie_title,
    avg_rating,
    CASE
        WHEN avg_rating > 8 THEN 'Superhit'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
        WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
        ELSE 'Flop'
    END AS movie_category
FROM
    thriller_movies
ORDER BY
    avg_rating DESC;








/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
WITH genre_avg_duration AS (
    SELECT
        g.genre,
        AVG(m.duration) AS avg_duration
    FROM
        movie m
        JOIN genre g ON m.id = g.movie_id
    GROUP BY
        g.genre
),
genre_running_total AS (
    SELECT
        genre,
        avg_duration,
        SUM(avg_duration) OVER (ORDER BY genre) AS running_total_duration,
        AVG(avg_duration) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg_duration
    FROM
        genre_avg_duration
)
SELECT
    genre,
    avg_duration,
    running_total_duration,
    moving_avg_duration
FROM
    genre_running_total
ORDER BY
    genre;






-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
-- Step 1: Identify the top 3 genres with the most number of movies
WITH top_genres AS (
    SELECT
        g.genre,
        COUNT(m.id) AS movie_count
    FROM
        movie m
        JOIN genre g ON m.id = g.movie_id
    GROUP BY
        g.genre
    ORDER BY
        movie_count DESC
    LIMIT 3
),
-- Step 2: Retrieve the five highest-grossing movies of each year for these top 3 genres
ranked_movies AS (
    SELECT
        g.genre,
        m.year,
        m.title AS movie_name,
        m.worlwide_gross_income,
        ROW_NUMBER() OVER (PARTITION BY g.genre, m.year ORDER BY m.worlwide_gross_income DESC) AS movie_rank
    FROM
        movie m
        JOIN genre g ON m.id = g.movie_id
        JOIN top_genres tg ON g.genre = tg.genre
)
-- Select the top 5 movies for each year and genre
SELECT
    genre,
    year,
    movie_name,
    worlwide_gross_income,
    movie_rank
FROM
    ranked_movies
WHERE
    movie_rank <= 5
ORDER BY
    genre, year, movie_rank;









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Step 1: Identify multilingual movies
-- Step 1: Identify multilingual movies
-- Step 1: Identify multilingual movies
WITH MultilingualMovies AS (
    SELECT id, production_company
    FROM movie
    WHERE LENGTH(languages) - LENGTH(REPLACE(languages, ',', '')) + 1 > 1
),
Hits AS (
    SELECT movie_id
    FROM ratings
    WHERE median_rating >= 8
),
ProductionHouseHits AS (
    SELECT m.production_company, COUNT(*) AS movie_count
    FROM MultilingualMovies m
    JOIN Hits h ON m.id = h.movie_id
    WHERE m.production_company IS NOT NULL
    GROUP BY m.production_company
),
RankedProductionHouses AS (
    SELECT production_company, movie_count,
           RANK() OVER (ORDER BY movie_count DESC) AS prod_comp_rank
    FROM ProductionHouseHits
)
SELECT production_company, movie_count, prod_comp_rank
FROM RankedProductionHouses
WHERE prod_comp_rank <= 2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actress_summary AS (
  SELECT
    n.NAME AS actress_name,
    SUM(total_votes) AS total_votes,
    Count(r.movie_id) AS movie_count,
    Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
  FROM movie AS m
  INNER JOIN ratings AS r
    ON m.id=r.movie_id
  INNER JOIN role_mapping AS rm
    ON m.id = rm.movie_id
  INNER JOIN names AS n
    ON rm.name_id = n.id
  INNER JOIN GENRE AS g
    ON g.movie_id = m.id
  WHERE 
    category = 'ACTRESS'
    AND avg_rating > 8
    AND genre = "Drama"  -- Add filtering here
  GROUP BY NAME )
SELECT
  *,
  RANK() OVER (ORDER BY movie_count DESC) AS actress_rank
FROM actress_summary
LIMIT 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations 

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_movie_counts AS (
    SELECT
        dm.name_id AS director_id,
        COUNT(DISTINCT dm.movie_id) AS number_of_movies,
        AVG(DATEDIFF(m.date_published, lag_date)) AS avg_inter_movie_days,
        AVG(r.avg_rating) AS avg_rating,
        SUM(r.total_votes) AS total_votes,
        MIN(r.avg_rating) AS min_rating,
        MAX(r.avg_rating) AS max_rating,
        SUM(m.duration) AS total_duration
    FROM
        director_mapping dm
        JOIN movie m ON dm.movie_id = m.id
        JOIN ratings r ON m.id = r.movie_id
        JOIN (
            SELECT
                m1.id,
                m1.date_published,
                COALESCE(
                    LAG(m1.date_published) OVER (PARTITION BY dm.name_id ORDER BY m1.date_published),
                    m1.date_published
                ) AS lag_date
            FROM
                movie m1
            JOIN director_mapping dm ON m1.id = dm.movie_id
        ) AS lag_dates ON m.id = lag_dates.id
    GROUP BY
        dm.name_id
    ORDER BY
        number_of_movies DESC
    LIMIT 9
)
SELECT
    dmc.director_id,
    n.name AS director_name,
    dmc.number_of_movies,
    dmc.avg_inter_movie_days,
    dmc.avg_rating,
    dmc.total_votes,
    dmc.min_rating,
    dmc.max_rating,
    dmc.total_duration
FROM
    director_movie_counts dmc
    JOIN names n ON dmc.director_id = n.id
ORDER BY
    dmc.number_of_movies DESC;

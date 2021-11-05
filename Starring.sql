
/* Adding another column to table movies*/
ALTER TABLE movies ADD lexemesStarring tsvector;


/* Using text search based on Starring in order to fill the Summary column */
UPDATE movies SET lexemesStarring=to_tsvector(Starring);


/* Gives an example of what the code can do */
SELECT url FROM movies WHERE lexemesStarring @@ to_tsquery('Cassel');


/* Updating the table with the rank for each movie, based on the given input */
UPDATE movies SET rank =ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM movies WHERE url='black-swan'))); 


/* Creating a table based on Starring recommendations with a rank from -1 to 50 */                                                                     
CREATE TABLE recommendationsBasedOnStarringField AS SELECT url,rank FROM movies WHERE rank >-1 ORDER BY rank DESC LIMIT 50;

/* Copying the Summary recommendations to a csv file in RSL called top50recommendationsStarring.csv */
\COPY (SELECT * FROM recommendationsBasedOnStarringField) to '/home/pi/RSL/top50recommendationsStarring.csv' WI
TH csv;



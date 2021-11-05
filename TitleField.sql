/* Adding another column to table movies*/
ALTER TABLE movies ADD lexemesTitle tsvector;


/* Using text search based on Starring in order to fill the Title column */
UPDATE movies SET lexemesTitle=to_tsvector(Title);


/* Gives an example of what the code can do */
SELECT url FROM movies WHERE lexemesTitle @@ to_tsquery('black');
       

/* Updating the table with the rank for each movie, based on the given input */
UPDATE movies SET rank=ts_rank(lexemesTitle,plainto_tsquery(( SELECT Title FROM movies WHERE url='black-swan')));


/* Creating a table based on Title recommendations with a rank from -1 to 50 */
CREATE TABLE recommendationsBasedOnTitleField AS SELECT url, rank FROM movies WHERE rank > -1  ORDER BY rank DESC LIMIT 50;


/* Copying the Title recommendations to a csv file in RSL called top50recommendationsTitle.csv */
\COPY (SELECT * FROM recommendationsBasedOnTitleField) to '/home/pi/RSL/top50recommendationsTitle.csv' WITH csv;


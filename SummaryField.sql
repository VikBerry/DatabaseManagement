
/* Creating the table movies containg 13 columns*/
CREATE TABLE movies (
url text,
title text,
ReleaseDate text,
Distributor text,
Starring text,
Summary text,
Director text,
Genre text,
Rating text,
Runtime text,
Userscore text,
Metascore text,
scoreCounts text
);

/* Copying the movies scrapped from Metacritic to my movies table */ 
\COPY movies FROM '/home/pi/RSL/moviesFromMetacritic.csv' DELIMITER ';' CSV HEADER;


/* Selecting my favourite movie */
SELECT * FROM movies WHERE url='black-swan';


/* Adding another column to table movies*/
ALTER TABLE movies ADD lexemesSummary tsvector;


/* Using text search based on Summary in order to fill the Summary column */
UPDATE movies SET lexemesSummary=to_tsvector(Summary);


/* Gives an example of what the code can do */
SELECT url FROM movies WHERE lexemesSummary @@ to_tsquery('black');


/* Adding the column rank indicating what type of data can be entered in that specific column */
ALTER TABLE movies ADD rank float4;


/* Updating the table with the rank for each movie, based on the given input */
UPDATE movies SET rank=ts_rank(lexemesSummary,plainto_tsquery(( SELECT Summary FROM movies WHERE url='black-swan')));


/* Creating a table based on Summary recommendations with a rank from -1 to 50 */
CREATE TABLE recommendationsBasedOnSummaryField AS SELECT url, rank FROM movies WHERE rank > -1  ORDER BY rank DESC LIMIT 50;


/* Copying the Summary recommendations to a csv file in RSL called top50recommendations.csv */
\COPY (SELECT * FROM recommendationsBasedOnSummaryField) to '/home/pi/RSL/top50recommendations.csv' WITH csv;



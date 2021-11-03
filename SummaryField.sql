pi@raspberrypi:~/RSL $ psql test
psql (11.12 (Raspbian 11.12-0+deb10u1))
Type "help" for help.

test=> CREATE TABLE movies (
test(> url text,
test(> title text,
test(> ReleaseDate text,
test(> Distributor text,
test(> Starring text,
test(> Summary text,
test(> Director text,
test(> Genre text,
test(> Rating text,
test(> Runtime text,
test(> Userscore text,
test(> Metascore text,
test(> scoreCounts text
test(>  );
CREATE TABLE
test=> \COPY movies FROM '/home/pi/RSL/moviesFromMetacritic.csv' DELIMITER ';' CSV HEADER;
COPY 5229
test=> SELECT * FROM movies WHERE url='black-swan';
test=> ALTER TABLE movies ADD lexemesSummary tsvector;
ALTER TABLE
test=> UPDATE movies SET lexemesSummary=to_tsvector(Summary);
UPDATE 5229
test=> SELECT url FROM movies WHERE lexemesSummary @@ to_tsquery('black');
test=> ALTER TABLE movies ADD rank float4;
ALTER TABLE
test=> UPDATE movies SET rank=ts_rank(lexemesSummary,plainto_tsquery(( SELECT Summary FROM movies WHERE url='black-swan')));
UPDATE 5229
test=>  CREATE TABLE recommendationsBasedOnSummaryField AS SELECT url, rank FROM movies WHERE rank > -1  ORDER BY rank DESC LIMIT 50;
SELECT 50
test=> \COPY (SELECT * FROM recommendationsBasedOnSummaryField) to '/home/pi/RSL/top50recommendations.csv' WITH csv;
COPY 50
test=> \q

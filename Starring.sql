pi@raspberrypi:~/RSL $ psql test
psql (11.12 (Raspbian 11.12-0+deb10u1))
Type "help" for help.             ^
test=> UPDATE movies SET lexemesStarring=to_tsvector(Starring);
UPDATE 5229
test=> SELECT url FROM movies WHERE lexemesStarring @@ to_tsquery('Cassel');
            url            
---------------------------
 birthday-girl
 black-swan
 jason-bourne
 irreversible
 trance
 mesrine-public-enemy-no-1
 tale-of-tales
(7 rows)

test=> UPDATE movies SET rank =ts_rank(lexemesStarring,plainto_tsquery((SELECT Starring FROM movies WHERE url='black-swan'))); 
UPDATE 5229                                                                     
test=> CREATE TABLE recommendationsBasedOnStarringField AS SELECT url,rank FROM movies WHERE rank >-1 ORDER BY rank DESC LIMIT 50;
SELECT 50
test=> \COPY (SELECT * FROM recommendationsBasedOnStarringField) to '/home/pi/RSL/top50recommendationsStarring.csv' WITH csv;
COPY 50
test=> \q
pi@raspberrypi:~/RSL $ 

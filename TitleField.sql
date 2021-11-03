pi@raspberrypi:~/RSL $ psql test
psql (11.12 (Raspbian 11.12-0+deb10u1))
Type "help" for help.

test=> ALTER TABLE movies ADD lexemesTitle tsvector;
ALTER TABLE
test=> UPDATE movies SET lexemesTitle=to_tsvector(Title)
test-> ;
UPDATE 5229
test=> SELECT url FROM movies WHERE lexemesTitle @@ to_tsquery('black');
                                   url                                   
-------------------------------------------------------------------------
 the-black-stallion
 the-black-stallion-returns
 fade-to-black
 white-king-red-rubber-black-death
 black-swan
 black-book
 black-christmas
 the-black-dahlia
 black-rain-1989
 black-dynamite
 black-hawk-down
 black-knight
 black-nativity
 black-out
 the-black-power-mixtape-1967-1975
 black-sea
 the-black-waters-of-echos-pond
 code-black
 diary-of-a-mad-black-woman
 the-woman-in-black-2-angel-of-death
 fifty-shades-of-black
 pitch-black
 little-black-book
 meet-joe-black
 men-in-black
 men-in-black-ii
 pirates-of-the-caribbean-the-curse-of-the-black-pearl
 tears-of-the-black-tiger
 through-a-lens-darkly-black-photographers-and-the-emergence-of-a-people
 black-mass
 the-woman-in-black
(31 rows)
test=> UPDATE movies SET rank=ts_rank(lexemesTitle,plainto_tsquery(( SELECT Title FROM movies WHERE url='black-swan')));
UPDATE 5229
test=> CREATE TABLE recommendationsBasedOnTitleField AS SELECT url, rank FROM movies WHERE rank > -1  ORDER BY rank DESC LIMIT 50;
SELECT 50
test=> \COPY (SELECT * FROM recommendationsBasedOnTitleField) to '/home/pi/RSL/top50recommendationsTitle.csv' WITH csv;
COPY 50
test=> \q
pi@raspberrypi:~/RSL $ 


-- Количество исполнителей в каждом жанре.
WITH t_art_genr AS
  (SELECT genr_id
     FROM artists       AS a,
          genr_2_artist AS ga
    WHERE a.id = ga.artist_id)
SELECT
  genr_name,
  COUNT(*) AS art_cnt
FROM genres AS g
     LEFT JOIN t_art_genr AS tar
     ON g.id = tar.genr_id
GROUP BY genr_name;
-- Количество треков, вошедших в альбомы 2019–2020 годов.
WITH t_albums AS (SELECT id FROM albums
                   WHERE TO_NUMBER(album_year, '9999') BETWEEN 2019 AND 2020
                  )
SELECT COUNT(*) AS trcks_cnt
  FROM t_albums AS a,
       tracks   AS t
 WHERE a.id = t.album_id;
-- Средняя продолжительность треков по каждому альбому.
WITH t_alb_rtcks AS
  (SELECT album_name,
          track_length
     FROM albums AS a,
          tracks AS t
    WHERE a.id = t.album_id
   )
SELECT
  album_name,
  AVG(track_length) AS avg_tl
FROM t_alb_rtcks
GROUP BY album_name;
-- Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT artist_name 
FROM artists AS a
WHERE
  NOT EXISTS(SELECT 1 FROM artist_2_album AS a2a,
                           albums         AS alb
              WHERE a2a.artist_id = a.id
                AND a2a.album_id = alb.id
                AND alb.album_year = '2020');
-- Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
WITH t_param AS (SELECT '5' || chr(180) || 'nizza' AS pn)
SELECT comp_name 
  FROM compilation_albums ca
 WHERE
   EXISTS(SELECT 1 FROM compilation_tracks AS ct,
                        tracks             AS t,
                        albums             AS alb,
                        artist_2_album     AS a2a,
                        artists            AS art,
                        t_param
          WHERE ct.comp_alb_id = ca.id 
            AND ct.track_id = t.id
            AND t.album_id = alb.id
            AND alb.id = a2a.album_id 
            AND a2a.artist_id = art.id
            AND art.artist_name = pn
   );
-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT
  album_name
FROM albums a
WHERE
  (SELECT COUNT(*)
     FROM artist_2_album a2a,
          genr_2_artist g2a
    WHERE a2a.album_id = a.id
      AND g2a.artist_id = a2a.artist_id 
   ) > 1; 
-- Наименования треков, которые не входят в сборники.
SELECT track_name
  FROM tracks AS t
 WHERE
   NOT EXISTS(SELECT 1 FROM compilation_tracks AS ct
               WHERE ct.track_id = t.id);
-- Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
WITH t_shortest AS
  (SELECT track_length AS tl FROM tracks
 ORDER BY track_length
    LIMIT 1
   )
SELECT artist_name, id FROM artists AS art
 WHERE
   EXISTS(SELECT * FROM artist_2_album     AS alb,
                        tracks             AS t,
                        t_shortest
           WHERE alb.artist_id = art.id
             AND t.album_id = alb.album_id
             AND track_length = tl
          );
-- Названия альбомов, содержащих наименьшее количество треков.
WITH t_cnt AS
  (SELECT album_id,
          COUNT(*) AS tc
     FROM tracks
 GROUP BY album_id
   ),
     t_min AS (SELECT MIN(tc) AS mtc from t_cnt)
SELECT album_name FROM albums AS a,
                       t_cnt  AS c,
                       t_min  AS m
 WHERE a.id = c.album_id
   AND c.tc = m.mtc;
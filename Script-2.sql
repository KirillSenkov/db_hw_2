-- Задание 2
-- Написать SELECT-запросы, которые выведут информацию согласно инструкциям ниже.
    -- Название и год выхода альбомов, вышедших в 2018 году.
select album_name, album_year  from albums where album_year = '2018';
    -- Название и продолжительность самого длительного трека.
select track_name, track_length from tracks order by track_length desc limit 1;
    -- Название треков, продолжительность которых не менее 3,5 минут.
select track_name, track_length from tracks where track_length >= '3.5 minutes';
    -- Названия сборников, вышедших в период с 2018 по 2020 год включительно.
select comp_name from compilation_albums where to_number(comp_year, '9999') between 2018 and 2020;
    -- Исполнители, чьё имя состоит из одного слова.
select * from artists where artist_name similar to '([a-z]|[A-Z]|[0-9]|' || chr(180) || ')+';
    -- Название треков, которые содержат слово «мой» или «my».
select * from tracks where track_name like '%my%' or track_name like '%мой%';
 
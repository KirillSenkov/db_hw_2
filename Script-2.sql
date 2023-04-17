-- Дополняет созданные в прошлом домашнем задании структуры
-- необходимыми данными для соответствия условиям Задания 1 текущего домашнего задания
insert into artists select gs + 3 as id,
                           case when gs = 1 then 'Psoy Korolenko'
                                when gs = 2 then 'Yanka Dyagileva'
                                when gs = 3 then 'Сramped leg'
                                when gs = 4 then '5' || chr(180) || 'nizza'
                                when gs = 5 then 'Astor Piazzolla'
                           end as artist_name 
                    from generate_series(1, 5) as gs;
insert into genres select gs + 3 as id,
                          case when gs = 1 then 'Punk'
                               when gs = 2 then 'Reggae'
                               when gs = 3 then 'Tango'
                          end as genr_name
                   from generate_series(1, 3) as gs;
insert into genr_2_artist select case when gs in (5,6) then 1 when gs = 4 then 4 when gs = 7 then 5 else 6 end as genr_id,
                                 gs as artist_id 
                          from generate_series(4, 8) as gs;
insert into artist_2_album select a.id as artist_id,
                                  round(random() * (9 - 1) + 1) as album_id
                           from artists as a where id between 4 and 8;
update albums set album_year = case when random() < 0.3 then '2018' else album_year end;
insert into compilation_albums select gs as id,
                                      'Compilation album №' || gs as comp_name,
                                      case when random() < 0.5 then '2018'
                                           when random() < 0.5 then '2020'
                                           else to_char(current_date, 'yyyy')
                                      end as comp_year 
                               from generate_series(4, 8) as gs;
                              commit;
insert into compilation_tracks select round(random() * (8 - 4) + 4) as comp_alb_id,
                                      id as track_id 
                               from tracks where random() < 0.3;
update tracks
set track_length = interval '10 minutes' * random(),
    track_name = case when random() < 0.5 then 'Blah мой ' || track_name
                      when random() < 0.3 then 'Blah my ' || track_name
                      else track_name
                 end
where not exists(select 1 from tracks as ex
                 where ex.track_length >= '3.5 minutes'
                       or ex.track_name like '%мой%'
                       or ex.track_name like '%my%'
                 )
      and random() < 0.5;

     
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
 
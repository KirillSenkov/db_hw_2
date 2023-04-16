create table departments (id serial primary key,
                          boss_id integer not null,
                          department_name varchar(128) not null
                          );
create table employees (id serial primary key,
                        dept_id integer not null references departments(id),
                        emp_name varchar(50)
                        );
insert into departments select * from (select generate_series as id,
                                       0 as boss_id,
                                       'Department №' || generate_series as department_name
                                       from generate_series(1, 3)) as sq_departments;
insert into employees select * from (select generate_series as id,
                                            floor(random() * (4 - 1) + 1) as dept_id,
                                            'Employee name №' || generate_series as emp_name
                                     from generate_series(1, 9)) as sq_employees;
update departments d set boss_id = (select id from (select row_number() OVER (ORDER BY e.id) as rownum,
                                                           e.id
                                                    from employees e where e.dept_id = d.id
                                    ) as sq_employees where rownum < 2);
alter table departments add foreign key (boss_id) references employees;
create or replace view vw_employees as select e1.emp_name,
                                              department_name,
                                              e2.emp_name as boss_name
                                       from employees e1,
                                            employees e2,
                                            departments d
                                       where e1.dept_id = d.id
                                             and e2.id = d.boss_id;
select * from vw_employees;
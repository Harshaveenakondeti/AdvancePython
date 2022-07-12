-- Olympic Data Analysis by sql

-- We have imported given csv file data into one single table called olympic in pyconnect schema
-- from olympic table, i created multiple tables while satisfying 3NF norms
-- all data will imported from olympic table which is source to new table.
-- only primary keys & forign key data was added by auto increment 
-- we have one table olympic contains 8618 rows 10 rows, which are divided into 5 tables.
select count(*) from olympic;
-- 8618
select * from olympic limit 5;
-- columns (name, age, country, year, Date_Given, sports,gold_medal, silver_medal, brone_medal, total_medal)
-- data successfully imported
-- lets apply 3NF , divide table to multiple tables
-- to satisfy 3 NF, first it should satisfy 1NF & 2NF
-- 1NF means, every cell should contain atomic value, no duplicates
-- 2NF means, it should not contain partial dependency. 
-- after satisfying above 2
-- in which no non-primary-key attribute is transitively dependent on the primary key, 
-- then it is in Third Normal Form (3NF).


----------------------------------
-- Dividing Tables & create relational database to acess data

-- create table called person for name & age with new column for id as primary key and auto increment value.alter
-- it dont have atomic values, so it satisfy 1NF.
-- here name and age column can have duplicates, so we have to acces through id only , so completely dependent on id pk. satisfy 2NF
-- Here we dont have partial dependency on each other, here candiadate keys can be id with name or  to  age,
-- primary key is id, all derived from id only, so  it satisfy 3NF
CREATE TABLE personal AS
    SELECT name, age
    FROM olympic;
 Alter table personal add (id  smallint key auto_increment primary key);   
select count(*)  from personal;
select * from personal limit 5;
----------------------------------
-- we create table called region which has person id as fk, with country
-- with id we can access country
-- it satisfy 3nf
CREATE TABLE region AS
    SELECT country
    FROM olympic;
Alter table region add (r_id  smallint key auto_increment);
select * from region;
---------------------------------
-- create table name summary for sports and total medals with s_id as foreign key 
-- it has atomic values, so 1NF satisfy
-- it depend on s_id only, so 2nF satisfy
-- it dont depend on each oyher, so it satisfy 3NF also
CREATE TABLE summary AS
    SELECT sports, Date_Given, total_medal
    FROM olympic;
 Alter table summary add (s_id  smallint key auto_increment);
select * from summary;   
--------------------------
-- create table called tenure for year column & id column to access.
-- it has only 2 rows, year depend on id only , so it satisfy 2 & 3NF.
CREATE TABLE tenure AS
    SELECT year
    FROM olympic;
    Alter table tenure add (t_id  smallint key auto_increment);
select * from tenure;
--------------------------------
-- created table medal for gold,silver,bronze medalas along with  id as foreign key from person 
-- it has atomic values, so 1NF satisfy
-- it depend on  id only , so 2nF satisfy
-- it dont depend on each other like partially, so 3NF satisfied
CREATE TABLE medal AS
    SELECT gold_medal, brone_medal, silver_medal
    FROM olympic;
    Alter table medal add (m_id  smallint key auto_increment);
select * from medal;
  -- table with all rows created, now add foreign keys to maintain relations  


SET FOREIGN_KEY_CHECKS=0;
--  foreign key checks to 0 means, while creating tables,it will not check fks
-- adding foreign keys
-- here only 5 tables we take, one primary key and 4 foreign keys we used
ALTER TABLE region
ADD CONSTRAINT FK_PersonRegion
 foreign key (r_id) references personal(id) ,ENGINE=innodb;

ALTER TABLE tenure
ADD CONSTRAINT FK_PesonalTenure
 foreign key (t_id) references personal(id);
 
 ALTER TABLE summary
ADD CONSTRAINT FK_PersonSummary
 foreign key (s_id) references personal(id);
 
 ALTER TABLE medal
ADD CONSTRAINT FK_PersonMedal
 foreign key (m_id) references personal(id);



SET FOREIGN_KEY_CHECKS=1;
-- after creating relation , we can check now
 -- Database created successfully.
 -- verify tables
 select * from region;
  select * from personal;
   select * from tenure;
    select * from medal;
     select * from summary;
-- Data Analysis 
-- we will get insights of data by answering following questions
 ----------------------------------------------------------------------------------------------
 -- 1. Find the average number of medals won by each counry?
select avg(total_medal),country
 from region 
 inner join summary 
 on r_id=s_id 
group by country;
-- United States won 1.1641 medals on average
-- Russia won 1.1105 medals on average
-- Australia won 1.1718 medals on average
----------------------------------------------------------------------------
-- 2. Display the countries and the number of gold medals they have won in decreasing order?
select sum(gold_medal),country
 from region inner join medal 
on r_id=m_id 
group by country 
order by sum(gold_medal) desc;
-- United States won total 467 gold medals which is highest
-- Russia won 238 gold medals
-- Australia won 202 gold medals
------------------------------------------------------------------------------------
-- 3. Display the list of people and the medals they have won in descending order, grouped by their country.
select country, name,count(total_medal) from
 personal inner join region 
 on id = r_id inner join summary 
 on r_id = s_id
 group by country
 order by count(total_medal) desc;

 -- From United States won 1109 times, in which is Michael Philips won more
 -- From Russia won 706 times, in which Wang Hao won more
 
 
------------------------------------------------------------------------------
-- 4. Display the list of people and the medals they have won according to their age?
select name, age,total_medal from personal inner join summary
on id = s_id order by age  desc ;
-- Ian Milar at age 61 with highest age won 1 medal
-- Mark Todd at 56 age won 1 medal
-- Mac Cone at 55 won 1 medal
select name, age,total_medal from personal inner join summary
on id = s_id order by age ;
-- Leisel Jones with 15 years won 3 medal
-- Go Gi-Hyeon a 15 won 3 medals
-- 
------------------------------------------------------------------------------------
-- 5.Which country has won the most number of medals(cumulative)?
 select sum(total_medal),country from region inner join summary 
 on r_id = s_id group by country order by sum(total_medal) desc;
 
 -- United states won most number of medals of 1291. 
 -------------------------------------------------------------------------------------
 -- Please go through EER Diagram to check relations of tables
 -- Please go through capstone_sql.ipynb file for source code of importing csv data from python using pymysql & sqlalchemy
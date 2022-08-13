--Creating the table
DROP TABLE space;
CREATE TABLE space (
  Company VARCHAR(50),
	Location VARCHAR(255),
  Date DATE,
  Time TIME,
  Rocket VARCHAR(200),
  Mission VARCHAR(255),
  RocketStatus VARCHAR (255),
	Price VARCHAR (20),
	MissionStatus VARCHAR (255)
);



select * from space
---Importing data

COPY SPACE FROM 'C:\Users\LENOVO\Desktop\space_missions.csv' WITH CSV HEADER encoding 'windows-1251'


---Most Active country on space
with temptable as (
			SELECT *,split_part(location,', ',-1) as country,
					to_char(date,'Month')as month FROM space)

SELECT Distinct country , COUNT(country)as rocket_launched
from temptable
group by country
order by rocket_launched desc

--- Ranking the countries
with temptable as (
			SELECT *,split_part(location,', ',-1) as country,
					to_char(date,'Month')as month FROM space)
					
SELECT Distinct country , COUNT(country)as rocket_launched,
	rank() over(order by count(country) desc)as rank
from temptable
group by country
order by rocket_launched desc


---ROCKET PLANT LOCATION IN USA
SELECT split_part(location,', ',-1) as country,
		split_part(location,', ',-2) as city,
		
		count(split_part(location,', ',-2)) as lol

from space 
where split_part(location,', ',-1) in ('USA')

group by country,city
order by lol desc

------ROCKET PLANT LOCATION IN RUSSIA
SELECT split_part(location,', ',-1) as country,
		split_part(location,', ',-2) as city,
		
		count(split_part(location,', ',-2)) as lol

from space 
where split_part(location,', ',-1) in ('Russia')

group by country,city
order by lol desc

---ROCKET PLANT LOCATION IN KAZAHKSTAN
SELECT split_part(location,', ',-1) as country,
		split_part(location,', ',-2) as city,
		
		count(split_part(location,', ',-2)) as lol

from space 
where split_part(location,', ',-1) in ('Kazakhstan')

group by country,city
order by lol desc

---Percentage of Mission Status from 1957 to august 2022
WITH temptable as ( select *, split_part(location,', ',-1) as country,
		split_part(location,', ',-2) as city
				  from space)
SELECT MissionStatus,
ROUND(count(MissionStatus)*100.0/ sum(COUNT(missionStatus)) over(),2) as percentage_succcess_failure_rate
from temptable
group by 1
ORDER BY 2 DESC

---OVER THE YEARS, HOW MANY ROCKETS HAVE BEEN LAUNCHED GROUPED BY COUNTRY
---Number of missions per year
WITH temptable as (
	select *, split_part(location,', ',-1) as country,
	extract(year from date) as year from space
)
SELECT country,  year, count( year)
from temptable
group by 1,2
order by 1,2

---AVERAGE AMOUNT EACH COUNTRY HAS SPENT ON SPACE MISSIONS in Millions
WITH temptable as (
	select *, split_part(location,', ',-1) as country,
			cast(REPLACE(Price,',','') as decimal) as amount
FROM space
)
SELECT country, round(avg(amount),2)
from temptable
where amount is not NULL
group by 1
order by 2 desc


---Top 5 most successful mission
SELECT Mission, count(MissionStatus)
from space
where MissionStatus = 'Success'
group by 1
order by 2 desc
limit 5

---Top 5 most successful Rocket
SELECT Rocket, count(MissionStatus) as missions
from space
where MissionStatus = 'Success'
group by 1
order by 2 desc
limit 5

---TOP 5 Countries having active rockets
select split_part(location,', ',-1) as country, count(Rocket)
from space
where RocketStatus = 'Active'
group by 1
order by 2 desc
limit 5




	




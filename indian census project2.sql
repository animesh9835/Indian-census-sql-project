select * from [ project].dbo.data1;

select * from  [ project].dbo.Sheet1$;

-- Number of rows into our dataset

select count(*) as no_of_rows from [ project]..data1;
select count(*) as no_of_rows from [ project]..Sheet1$;

--Dataset for Jharkhand and Bihar

select * from [ project]..data1 where state in ('Jharkhand','Bihar') 

--Population of India

select sum(Population) as Population from [ project]..Sheet1$

--Average growth

select AVG(Growth)* 100 as avg_growth_of_total_population  from [ project]..data1

--Average growth by state

select  State ,AVG(Growth)* 100 as avg_growth_population  from [ project]..data1 group by State;

--Average sex ratio by state

select  State ,round(AVG(Sex_Ratio),0) as avg_growth_sex_ratio from [ project]..data1 group by State order by 
avg_growth_sex_ratio desc;

-- Average literacy rate

select state, round(AVG(Literacy),0) as avg_literacy_rate from [ project]..data1 group by State  having round(AVG(Literacy),0)>90 order by avg_literacy_rate desc ;

--Top 3 states showing highest growth ratio

select  top 3.state, AVG(Growth)*100 as avg_growth from [ project]..data1 group by State order by avg_growth desc;

--Bottom 3 state showing lowest sex ratio

select top 3.state, round(AVG(Sex_Ratio),0) as avg_sex_ratio from [ project]..data1 group by State order by round(AVG(Sex_Ratio),0) 

--Top and bottom 3 states in literacy

drop table if exists #topstates;

create table #topstates
(State nvarchar(225),
topstate float

)
insert into #topstates
Select  state, round(AVG(Literacy),0) as avg_literacy_ratio from [ project]..data1 group by State order by avg_literacy_ratio desc;

select top 3 * from #topstates order by #topstates.topstate desc;

drop table if exists #bottomstates;
create table #bottomstates
(state nvarchar(225),
bottomstate float
)
insert into #bottomstates
select state, round(avg(Literacy),0) as avg_literacy_ratio from [ project]..data1 group by State order by avg_literacy_ratio;

select top 3* from #bottomstates order by #bottomstates.bottomstate

-- Union operator

select *  from (select top 3 * from #topstates order by #topstates.topstate desc) a

union

select * from (select top 3* from #bottomstates order by #bottomstates.bottomstate) b

--State starting with letter a 

select  distinct state  from [ project]..data1 where lower (state) like 'a%'

-- State starting with letter a or b

select distinct state from [ project]..data1 where  lower(state) like  'a%' or lower (state) like 'b%'

select distinct state from [ project]..data1 where  lower(state) like  'a%' and lower(state) like '%m'

--Joining both table

select k.District, k.State, Sex_Ratio, Population 
from [ project]..data1 k
join [ project]..Sheet1$ l on l.District = k.District;

--Total Male and Female

 select d.State,sum(d.male) total_male,sum(d.females) total_females from (select c.District, c.State,round((c.Population)/(c.sex_ratio+1),0) male,round((c.Population * c.sex_ratio)/(c.sex_ratio+1),0) females from (select m.District , m.State, m.Sex_Ratio/1000 sex_ratio, f.Population
 from [ project]..data1 m  inner join [ project]..Sheet1$ f on f.District = m.District)c)d  group by d.State order by total_male, total_females;

 --Total literacy rate 

 
select z.State, sum(total_literate_people) total_literate_people, sum(total_illterate_people) total_illterate_people from 
(select v.District ,v.State, round((v.literacy_ratio* v.Population),0) total_literate_people , round((1-v.literacy_ratio)* v.Population,0) total_illterate_people from(select  p.District,j.State,  P.Population, J.Literacy/100 literacy_ratio,J.Sex_Ratio from  [ project]..data1 j
 inner join [ project]..Sheet1$ p on p.District = j.District)v)z group by z.State;

 -- Population in previous census

 select e.state, sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
 (select o.district, o.state, round(o.population/(1-o.growth),0) previous_census_population, o.population current_census_population from
 (select a.district, a.state, a.growth , b.population  from [ project]..data1 a  inner join   [ project]..Sheet1$ b on  b.District=a.District)o)e 
 group by e.state

 select sum(f.previous_census_population) previous_census_population, sum(f.current_census_population) current_census_population from
 (select e.state, sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
 (select o.district, o.state, round(o.population/(1-o.growth),0) previous_census_population, o.population current_census_population from
 (select a.district, a.state, a.growth , b.population  from [ project]..data1 a  inner join   [ project]..Sheet1$ b on  b.District=a.District)o)e 
 group by e.state)f

 --Population vs area

  
 select (g.total_area/g.previous_census_population) as previous_census_population_vs_area, (g.total_area/g.current_census_population) as current_census_population_vs_area from
 (select q.*, r.total_area from (
 select '1' as keyy, n.* from
 (select sum(f.previous_census_population) previous_census_population, sum(f.current_census_population) current_census_population from
 (select e.state, sum(e.previous_census_population) previous_census_population,sum(e.current_census_population) current_census_population from
 (select o.district, o.state, round(o.population/(1-o.growth),0) previous_census_population, o.population current_census_population from
 (select a.district, a.state, a.growth , b.population  from [ project]..data1 a  inner join   [ project]..Sheet1$ b on  b.District=a.District)o)e 
 group by e.state)f)n)q inner join (

select '1' as keyy, z.* from (
select sum(area_km2) total_area from [ project]..Sheet1$)z)r on q.keyy= r.keyy)g 

--Window

output top 3 districts from each state with highest literacy rate 

select a.* from
(select district,state, literacy, rank() over (partition by state order by literacy desc) rnk from [ project]..data1) a 
where a.rnk in (1,2,3) order by state





  











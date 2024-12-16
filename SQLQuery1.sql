select location, date, total_cases, new_cases,total_deaths,population
from PortfolioProject_1.dbo.CovidDeaths
where continent is not null
order by 3,4;

select location, date, total_cases, total_deaths,( total_deaths/ total_cases )*100 death_percentage
from PortfolioProject_1.dbo.CovidDeaths
where location like '%states%'
order by 1,2

--total_cases vs Population
select location, date, population,total_cases,  ( total_cases/ population )*100 percentage_population_infected
from PortfolioProject_1.dbo.CovidDeaths
where location like '%states%'
order by 1,2

--highest_population_infected_countries

select location, population, max(total_cases) highest_infected_countries, Max (( total_cases/ population ))*100 percentage_population_infected
from PortfolioProject_1.dbo.CovidDeaths
--where location like '%states%'
where continent is not null
group by location, population
order by percentage_population_infected desc

--death percentage with the highest countries affected

select location, MAX(cast(total_deaths as int)) totalDeathCount
from PortfolioProject_1.dbo.CovidDeaths
--where location like '%states%'
where continent is null
group by location
order by totalDeathCount desc

--death percentage as per continent
select continent, MAX(cast(total_deaths as int)) totalDeathCount
from PortfolioProject_1.dbo.CovidDeaths
where location like '%states%'
where continent is not null
group by continent
order by totalDeathCount desc

--global numbers
select date, sum(new_cases) totalCases  , sum(cast(new_deaths as int)) TotalDeaths , sum(cast(new_deaths as int))/sum(new_cases)*100 as  deathPercentage
from PortfolioProject_1.dbo.CovidDeaths
where continent is not null
group by date
order by 1,2 

--looking total Population vs vaccinations Using CTE

with PopvsVac ( continent, Location,date, Population, New_vaccinations, RolllingPeopleVaccinated ) as (select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(convert(int, v.new_vaccinations )) over (partition by d.location, d.date) as RolllingPeopleVaccinated
from PortfolioProject_1..CovidDeaths d  join PortfolioProject_1..CovidVaccinations v on d.location = v.location and d.date = v.date 
where d.continent is not null
--order by 2,3 
)
select * , (RolllingPeopleVaccinated/ Population)*100 from PopvsVac

--above data using TEMP Table
drop table if exists #percentagePopulationvaccinated
create table #percentagePopulationvaccinated
(continent nvarchar(255), Location nvarchar(255), date datetime, population numeric, New_vaccinations numeric, RolllingPeopleVaccinated numeric)
insert into #percentagePopulationvaccinated 
select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(convert(int, v.new_vaccinations )) over (partition by d.location, d.date) as RolllingPeopleVaccinated
from PortfolioProject_1..CovidDeaths d  join PortfolioProject_1..CovidVaccinations v on d.location = v.location and d.date = v.date 
where d.continent is not null
--order by 2,3 
select * , (RolllingPeopleVaccinated/ Population)*100 from #percentagePopulationvaccinated

--lets create view for visualization

create view percentagePopulationvaccinated 
 as select d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(convert(int, v.new_vaccinations )) over (partition by d.location, d.date) as RolllingPeopleVaccinated
from PortfolioProject_1..CovidDeaths d  join PortfolioProject_1..CovidVaccinations v on d.location = v.location and d.date = v.date 
where d.continent is not null
--order by 2,3 




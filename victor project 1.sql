

					-------LOOKING AT TOTAL CASES VS TOTAL DEATHS-----------


SELECT location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as deathpercentage
FROM victorprojectdata.dbo.CovidDeaths
where location like '%states%'
order by 1,2


				----------LOOKING AT TOTAL CASES VS POPULATION----------

select location, date, total_cases, population,
(total_cases/population)*100 as percentpopulationinfested
FROM victorprojectdata.dbo.CovidDeaths
order by 1,2


				---------LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION-------


SELECT location, population, max(total_cases) as highestinfectioncount,
max((total_cases/population))*100 as percentpopulationinfected
FROM victorprojectdata.dbo.CovidDeaths
group by location, population
order by percentpopulationinfected desc



				--------------SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION----------


select location, max(cast(total_deaths as int)) as totaldeathcount
FROM victorprojectdata.dbo.CovidDeaths
where continent is not null
group by location
order by totaldeathcount desc



				--------------BREAKING THINGS DOWN TO CONTINENT-----------


select continent, max(cast(total_deaths as int)) as totaldeathcount
FROM victorprojectdata.dbo.CovidDeaths
where continent is not null
group by continent
order by totaldeathcount desc


					--OR--


select location, max(cast(total_deaths as int)) as totaldeathcount
FROM victorprojectdata.dbo.CovidDeaths
where continent is null
group by location
order by totaldeathcount desc




					---------------GLOBAL NUMBERS---------------



select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
FROM victorprojectdata.dbo.CovidDeaths
where continent is not null
order by 1,2



					---------------LOOKING AT TOTAL POPULATION VS VACCINATIONS---------------


select ab.continent, ab.location, ab.date, ab.population,
cd.new_vaccinations, sum(convert(int, cd.new_vaccinations))
over (partition by ab.location ORDER BY ab.location, ab.date)
as rollingpeoplevaccinated
FROM victorprojectdata.dbo.CovidDeaths AB
JOIN victorprojectdata.dbo.CovidVaccinations CD
ON AB.location = CD.location
AND AB.date = CD.date
WHERE AB.continent is not null
order by 2,3

		USE CTE popvsvac

with popvsvac(continent, location, date, population, new_vaccinations,
rollingpeoplevaccinated) as
(
select ab.continent, ab.location, ab.date, ab.population,
cd.new_vaccinations, sum(convert(int, cd.new_vaccinations))
over (partition by ab.location ORDER BY ab.location, ab.date)
as rollingpeoplevaccinated
FROM victorprojectdata.dbo.CovidDeaths AB
JOIN victorprojectdata.dbo.CovidVaccinations CD
ON AB.location = CD.location
AND AB.date = CD.date
WHERE AB.continent is not null
--order by 2,3
)

select *, (rollingpeoplevaccinated/population)*100
from popvsvac


					--TEMP TABLE--

DROP TABLE IF EXISTS #PERCENTPOPULATIONVACCINATED
CREATE TABLE #PERCENTPOPULATIONVACCINATED
(
CONTINENT NVARCHAR (255),
LOCATION NVARCHAR (255),
DATE DATETIME,
POPULATION NUMERIC,
NEW_VACCINATIONS NUMERIC,
ROLLINGPEOPLEVACCINATED NUMERIC
)

INSERT INTO #PERCENTPOPULATIONVACCINATED
select ab.continent, ab.location, ab.date, ab.population,
cd.new_vaccinations, sum(convert(int, cd.new_vaccinations))
over (partition by ab.location ORDER BY ab.location, ab.date)
as rollingpeoplevaccinated
FROM victorprojectdata.dbo.CovidDeaths AB
JOIN victorprojectdata.dbo.CovidVaccinations CD
ON AB.location = CD.location
AND AB.date = CD.date
WHERE AB.continent is not null
--order by 2,3

SELECT *, (rollingpeoplevaccinated/population)*100
from #PERCENTPOPULATIONVACCINATED


						--------CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION-----------

create view PERCENTPOPULATIONVACCINATED as
select ab.continent, ab.location, ab.date, ab.population,
cd.new_vaccinations, sum(convert(int, cd.new_vaccinations))
over (partition by ab.location ORDER BY ab.location, ab.date)
as rollingpeoplevaccinated
FROM victorprojectdata.dbo.CovidDeaths AB
JOIN victorprojectdata.dbo.CovidVaccinations CD
ON AB.location = CD.location
AND AB.date = CD.date
WHERE AB.continent is not null
--order by 2,3